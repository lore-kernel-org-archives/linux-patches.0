Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1AE25F78A;
	Tue, 11 Mar 2025 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707514; cv=none; b=Ku8Oete+EFYUfg/CNFl80TZYG5zX3d2iSAOI9+is6K3pUo8J1zaTUTzgcbGLIM6VvDSGwUNv5UcZ3R4jkfB7NX3026LQKX1FUWfvtZV4yiS0jL5J2m9ia1b+s42bFvR5bBYKbhmCd5zvsVJNZsdvssATon/F03GCd2bHybKHY5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707514; c=relaxed/simple;
	bh=qVHgm5LDMoH4ntyK9wGhTJaanxvvrdUwkiCmN2ekzXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o67Ft/KKGvbORrOAytnGcE6iaDERRYG5U7P1yiMMHXjKRNB7z297tifknmRWR+u4hDSYRBObMDKghOwLdIvfOtFxYEWPpc2BZ++ya3ijekkU7DPAftp8gpMRy1fB8UnFTuTywPweUDD/oJMXmhZI570+boci1C8QBorCEhW2LUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gI+hNc8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gI+hNc8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC41C4CEE9;
	Tue, 11 Mar 2025 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707514;
	bh=qVHgm5LDMoH4ntyK9wGhTJaanxvvrdUwkiCmN2ekzXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gI+hNc8KPP0EFMUcz6cgL3hA5oPFFrG1aHHiRHG1CsquK4u453LcWj9lfu3LMLl5H
	 Kz3m94AhwxSM3bCWbMqfo19q+fatvJ5k6qU/Mf++aN8CBnakljHsCl1atR1ezkX6o4
	 32PnCDpIlAdS0Hh/H3eDbP6TDSZbZXPzPxJfq4O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/462] smb: client: Add check for next_buffer in receive_encrypted_standard()
Date: Tue, 11 Mar 2025 16:00:50 +0100
Message-ID: <20250311145813.516784294@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 860ca5e50f73c2a1cef7eefc9d39d04e275417f7 ]

Add check for the return value of cifs_buf_get() and cifs_small_buf_get()
in receive_encrypted_standard() to prevent null pointer dereference.

Fixes: eec04ea11969 ("smb: client: fix OOB in receive_encrypted_standard()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 68f93de2b1527..70a4d101b5428 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4938,6 +4938,10 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
+		if (!next_buffer) {
+			cifs_server_dbg(VFS, "No memory for (large) SMB response\n");
+			return -1;
+		}
 		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 
-- 
2.39.5



