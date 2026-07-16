Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2C03FE351;
	Thu, 16 Jul 2026 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209580; cv=none; b=MnvB++w2LMizpSehMicgUQg5/ZqJCv+3KiInPC1YojTMHb3V1xKXc0Bd3sCtl9eL+Rz6jmDeHhHqHMBobrMY1FJhNroG5MW/DfezIzisofH+85Hcgid+0WvBK3wqJTsxe86o30JnoKfbTqTid+gcwlujZYhwItM3npO04Qs3+pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209580; c=relaxed/simple;
	bh=RWSrMvcibIGM6sLTDaZLrUZ56Y5cdPgJVYS/qHFxBRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txLeGbLfTINaRf0mwLFufhzyIPQsAEZffLKJDfu3Niv3WfmBM71wD8tUvurEiLA1SdkxzqLyqe2+cdnh4+lbMQUrYPH0EnDZg/XbkQNWR2FCS4gEibzCxzr+hw092yYfGVT7b1Jv2gFtbEMUskizfHFOwc3rXdtYsTz7jc6mr7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzJQMhRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzJQMhRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB531F00A3A;
	Thu, 16 Jul 2026 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209576;
	bh=2OBUh67HERDCJbarrAaumLibbXMtGi0/ccBcZP+xxKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzJQMhRUhXpb8WadiZkBaLSPUY8LfObNBj07W9G4oaKSnVXfXM6EmvesynaRYI9YX
	 Rl60AFjutUV4oS9FN5vCQul/Pds/tM/NJROfOl/z6L/Zvq7qd3SRAJ/Gt+JF2RpE8Z
	 0scvG/V+9SzalX/5d6Af5iNekXcEpmiYbY00eZc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 238/518] smb: client: Fix next buffer leak in receive_encrypted_standard()
Date: Thu, 16 Jul 2026 15:28:26 +0200
Message-ID: <20260716133053.028361726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5111,6 +5111,12 @@ receive_encrypted_standard(struct TCP_Se
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
@@ -5134,10 +5140,6 @@ one_more:
 		mid_entry->resp_buf_size = server->pdu_size;
 	}
 
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
 	bufs[*num_mids] = buf;
 	mids[(*num_mids)++] = mid_entry;
 


