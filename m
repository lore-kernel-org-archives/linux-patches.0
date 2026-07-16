Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B332FDC53;
	Thu, 16 Jul 2026 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211047; cv=none; b=lkuSvmXdbt3K+dJ9EG/NMEXbQws+HnzcgVhS/svO33XJz4NtF0GMysVkMNyFpwIabMO37JitRinq+LkWspxO4rmAjrmeP7YRtGQU23JNJGnV5F6J2xG/tArUUKgiX/zQZ33Y9vyUi2x1xtu+lYf43jp0PTWJNJjpVERm9zZrYag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211047; c=relaxed/simple;
	bh=khv3Q03x1LIGnwD/oQ6M0Wg0PEBDMghpKeAx1rjxHBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNDDIW0CtuEPNhpFhB5hwUCKQjCf9nykhqibWH/Wuxf/lA+TsVd6eCkiElK5bjLwjcZAUNmX2d0p9FDvPE2oJWBpXWNqhCmFfkSyzP76cmJ8v9UKM8RKLBzx371MM26BPI9CNjuMcBALAtN3k9WWoYplQZ/xQuHmBN5B7ZherPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A557TGqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A557TGqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5971F000E9;
	Thu, 16 Jul 2026 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211046;
	bh=6dAB6OTexlzNEeDu3CyrJ8s24sjrQOGcM2IusNZ52CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A557TGqHdpaaQ7SO2ouRlr9d5IFXkmgbVOVfMQCJ0vbvss1JB0aVY884EENUpZsUi
	 te1H62WGoqGw9PO+8dqUBJHOgQxUv0ZuqqZR1C1vwR9Jo9UlBGyI0+qQ7EmdhqeLIN
	 KxmE+Tn+nsJ2LOL2t4mw+Ga2hOwLFqWd1zWrPiIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 235/480] smb: client: Fix next buffer leak in receive_encrypted_standard()
Date: Thu, 16 Jul 2026 15:29:42 +0200
Message-ID: <20260716133049.904168596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5096,6 +5096,12 @@ receive_encrypted_standard(struct TCP_Se
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
@@ -5119,10 +5125,6 @@ one_more:
 		mid_entry->resp_buf_size = server->pdu_size;
 	}
 
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
 	bufs[*num_mids] = buf;
 	mids[(*num_mids)++] = mid_entry;
 


