Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F63543D502;
	Tue, 21 Jul 2026 22:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672845; cv=none; b=AdT/UPVk2eh7khuEAzJh1ZW4zTyzI4rtwGHMjXs238hi7LEiRRqpI4DPslzmOqL3aV8BfN2GDaL1e84gExUXyS7jZGNZvl12DORtVCc4/cHc/VTTHcGvXtcA623ctW7kHsBcOotz+tycc4FoYWZw2pN/g/SgDZR0wKUdvbNqRSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672845; c=relaxed/simple;
	bh=RXJ0oFgfNMOXKZB7ZJ9TFRt78k9704Nt6ljYlGVSLOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwozwMXdCCIiCPtbgz7Y1tgee6n9JaKNWkTBAxTxAmcZo0OxrUMGNRml1WusaxHDjt7xJ7vbXQaSrjXBc7gGAEhwER+7vXLUICtvdL+XQUyVAWqi+FGlZ8/t3osfHMe+8w0J5/KBLCEdp93cJ6/UPYxRhPCZiC/D2529xso3u4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6/Negca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6/Negca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494FE1F000E9;
	Tue, 21 Jul 2026 22:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672843;
	bh=ePyK8UG3ha7VwJI12FTSrodw25EhXf3YtVCJ2OZ9mYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6/Negca+T84GJtyb76m7b1FKr1dbKfEQG1CIiLYLeVIZB7T8UCJguNUbE6Pns1H6
	 qabRJNTmahqRBlkOkakOh8SOdjpLz38yLM86d35YBmvjvW0v6/AAwrX4YMW1S2803c
	 fZ1Thm96Avq0mt+sEh58uUYMMPbuXmb37zI/g3SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 779/843] smb: client: Fix next buffer leak in receive_encrypted_standard()
Date: Tue, 21 Jul 2026 17:26:54 +0200
Message-ID: <20260721152423.578591667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5211,6 +5211,12 @@ receive_encrypted_standard(struct TCP_Se
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
@@ -5234,10 +5240,6 @@ one_more:
 		mid_entry->resp_buf_size = server->pdu_size;
 	}
 
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
 	bufs[*num_mids] = buf;
 	mids[(*num_mids)++] = mid_entry;
 


