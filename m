Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B3444AB9F;
	Tue, 21 Jul 2026 22:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674704; cv=none; b=HY3ohlESMkg4IEcYxq1TzMtVhWm5bm6gPU99D4zP5nUdgJdnGHHMTdsOxNFKovochmumDpOS1cjam5Sv8sljamRiqNRFd6oRw6/n/QURxLKFgQYpkL1ABuIo2kOEYpHwQKl2Lrw4zJo8n5LXiOxcdzdTOC9X/qb51aDRw0MzdUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674704; c=relaxed/simple;
	bh=cSvmu33AzhkE9WuAqf/LXh4OH2238ibv/i8mk9d+rxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7F/eT4CLpAAFIThVq7IDQxs/Bcj4TbXblXRBNqEH91+svjnrZQmbwcozqp8Q+saCTTEm/DKB1bLnDrH+9BiqyUz3PXYq/e6A5Z4+n/ygrUtzXG3Ej0lXUNqJwVI0E4N4CbQRU4sjRjAgyPq3L2aUErphrrDgCPQOxoH75drdsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkRlCtFb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkRlCtFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32BF1F000E9;
	Tue, 21 Jul 2026 22:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674703;
	bh=4r46L3Zdd1hXLyBYdkrHZrALdVtzKFsFh2wY4BxAJKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkRlCtFbFS6DQsTOFhW2ELIGyGUYFa4d9FMRRT9jN0GOGbQlgsmNzNGXRNyoXfET1
	 GYnLvzXwdej04tdQDaEUwu5vSnnYzPMXbGT2F+6pjipHe3GjZoOVFTVmt0R48haDZj
	 v4px79i8oEW3e2nxdk4G92ol0kFn+xEyRu4veb78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 642/699] smb: client: Fix next buffer leak in receive_encrypted_standard()
Date: Tue, 21 Jul 2026 17:26:41 +0200
Message-ID: <20260721152410.232972398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 1c6267a1d5cf4c73b656f8181b310cbbb3e4767b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4961,6 +4961,12 @@ receive_encrypted_standard(struct TCP_Se
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
@@ -4984,10 +4990,6 @@ one_more:
 		mid_entry->resp_buf_size = server->pdu_size;
 	}
 
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
 	bufs[*num_mids] = buf;
 	mids[(*num_mids)++] = mid_entry;
 


