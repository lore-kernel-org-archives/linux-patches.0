Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F0642A164;
	Thu, 16 Jul 2026 14:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212056; cv=none; b=iOguM2pruCIf1CalEQGbWaQ5F+qFSfthbe7A0vMie2yHl6Nefw/3CZdpBsj6t27WC8BLao+8jErkVsUqexXvFunbPwIuQtQC0IpkSleuU2Wu+tSepsa2rH/xq1lbzxazHew8QKAT+mMCHGq9k73vldTcJD7mX/K9UjJsbJ/GL7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212056; c=relaxed/simple;
	bh=LMKSot5pIK60dMPyYOS+Uwwtnlc2Jaqcj0oVaITfK20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9n/8k3nGvFnqCLtvTx2uRzEucEIXAZNvD+XpsZX7LrVU0vdesas7OWVTmmQpkCDBOC4j8w0XyiwiV0a71yqameGjSfAp7u8KJOObSwR8efNtxV3RueLHfKyXf5k47ASnziMfLP0MojJr9YpUkI3rpdbv1FyJMfNTPwPVIh+1B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6FOjjCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6FOjjCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AFB1F000E9;
	Thu, 16 Jul 2026 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212055;
	bh=O6qHucfEd+t0oS8vwa4Grq8iFv44cHI9Xlyjko+cfqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6FOjjCAQJZ4LVPh+/QO2d0YXDHz5MRVdPoCdUpDt1UmiumDz/Q7FCkbcjcLhH3BS
	 V4CWVll5zMIk87xjKgXWwVqzSDooln68l4KYuWJKJcxgLND20fq78PEsTbarVruuqa
	 21WSB/PdXT9SywltIYrlM6ejwPm0P6jW/Jp2bUAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 181/349] smb: client: Fix next buffer leak in receive_encrypted_standard()
Date: Thu, 16 Jul 2026 15:31:55 +0200
Message-ID: <20260716133037.429973041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 1c6267a1d5cf4c73b656f8181b310cbbb3e4767b upstream.

receive_encrypted_standard() allocates next_buffer before checking
whether the number of compound PDUs already reached MAX_COMPOUND. If
the limit check fails, the function returns immediately and the newly
allocated next_buffer is not assigned to server->smallbuf/server->bigbuf,
making it leaked.

Move the MAX_COMPOUND check before allocating next_buffer.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5035,6 +5035,12 @@ receive_encrypted_standard(struct TCP_Se
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+
+	if (*num_mids >= MAX_COMPOUND) {
+		cifs_server_dbg(VFS, "too many PDUs in compound\n");
+		return -1;
+	}
+
 	if (next_cmd) {
 		if (WARN_ON_ONCE(next_cmd > pdu_length))
 			return -1;
@@ -5058,10 +5064,6 @@ one_more:
 		mid_entry->resp_buf_size = server->pdu_size;
 	}
 
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
 	bufs[*num_mids] = buf;
 	mids[(*num_mids)++] = mid_entry;
 


