Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DE04307AD;
	Tue, 21 Jul 2026 20:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665155; cv=none; b=jUqQiEYuX+qpnEhmuuBQZ1x5NS0usY+3/cUJCSWnr0aR56Rt1yYSkjiBUS81HYSNyztjiQDff539AszjbPkrTMpYbNLQrshCwER92/0BYcVo/G++NwRe9RhE92qGB9CppoMAD8w1T0RHn2wOShW5bF8bAhs/UdID1DSiA6R8/ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665155; c=relaxed/simple;
	bh=8dxXzhPT5xtYmGdQ9v6z6pfvGQf6epfsAtVvabC0Yqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYZWg7uz9xVxmcxtwrl0lSepu0WeHraLO1CHvYdfp5ybcx872xT/so+Rf9D5K11BYTSVSk6IadGMIFkPlAh0uUPqvNQ0GsYP9+rdPfaCCsNDiEgoKt9iIxeRgjaYPDZgikAYAGkKrfIgWPbOccr0jsNfTApiHofmbcQVm9qZLQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkFnraPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkFnraPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552721F000E9;
	Tue, 21 Jul 2026 20:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665153;
	bh=VCzX+aESBiwaZSDrKnib0e2Dg6w3yJhzv53FXwuWShc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkFnraPGBgbzgM8iL+1kWpARopO2OlxDkhi+iDzkjE6qVBMVP3GUe3LFfSiom0YOK
	 sWDOZxGCsYKyvu95XQlj48CEvf0BIZJRs/LxZ2CjnR/EJu+KY9FIjmkoAGWw8D+Q0Y
	 DCyt4zkATMHhiRIrla5WY7TRlTovIvtl1GCRkbl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0198/1266] smb: client: Fix next buffer leak in receive_encrypted_standard()
Date: Tue, 21 Jul 2026 17:10:35 +0200
Message-ID: <20260721152446.240417857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4942,6 +4942,12 @@ receive_encrypted_standard(struct TCP_Se
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
@@ -4965,10 +4971,6 @@ one_more:
 		mid_entry->resp_buf_size = server->pdu_size;
 	}
 
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
 	bufs[*num_mids] = buf;
 	mids[(*num_mids)++] = mid_entry;
 


