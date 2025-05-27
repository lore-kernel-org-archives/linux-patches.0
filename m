Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C0027FD63;
	Tue, 27 May 2025 17:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368637; cv=none; b=cHz8TDgdAkW1PuA+qNr+B3kbFDvJVzEu4VWbkQnzBM4ta8V5NkNoL4/WUQ+gQ+ilZY2uAi1xzJpwniw3DsBW2LtHB02TGTg6U2YNzQpgxMBCR4Mnuv19/BUhJag2sLTYVKQpgadFi+qjh/HqzM7iV5Swasb+AoeT2Vb/x5jZd9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368637; c=relaxed/simple;
	bh=XnMuTDltEVVbukuna0e9HNNKrBZ2dZCF6b9SkHpdxyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPx5m6aZJ0ZRKJM3E2f4Y1GaF5ASfIHub+7pTXGoElkK2tV01G4E1MYhmBl8JjCoNmVrIQUR7KeqzjOvbbE1TmH9KQca0KZWKOBOq87KiYeS+3Js88/JpgC/dV3iFk5x46C/gZVlF+M1qc5VILInbtR3NoE9lrtgNUsjWKklkaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UH6bvSJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UH6bvSJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49601C4CEE9;
	Tue, 27 May 2025 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368636;
	bh=XnMuTDltEVVbukuna0e9HNNKrBZ2dZCF6b9SkHpdxyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UH6bvSJfWNwqYUJnWmjLQROqNVQCqsdP79cRnp/Y9M1TKrwWRhOAMFhZZMwZH3SfT
	 pOmuTkxY051daSbq+61JikR7oWrLFbEJy3BQEcXbxtooPJrBDnDrYPV1OLPfoiGmgL
	 fYC3dkaT1y6dMwki5qFFJwQe4LO/6HxaMoDBqJlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 769/783] ksmbd: fix stream write failure
Date: Tue, 27 May 2025 18:29:26 +0200
Message-ID: <20250527162544.453856526@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1f4bbedd4e5a69b01cde2cc21d01151ab2d0884f ]

If there is no stream data in file, v_len is zero.
So, If position(*pos) is zero, stream write will fail
due to stream write position validation check.
This patch reorganize stream write position validation.

Fixes: 0ca6df4f40cf ("ksmbd: prevent out-of-bounds stream writes by validating *pos")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 648efed5ff7de..474dc6e122c84 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -426,10 +426,15 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	ksmbd_debug(VFS, "write stream data pos : %llu, count : %zd\n",
 		    *pos, count);
 
+	if (*pos >= XATTR_SIZE_MAX) {
+		pr_err("stream write position %lld is out of bounds\n",	*pos);
+		return -EINVAL;
+	}
+
 	size = *pos + count;
 	if (size > XATTR_SIZE_MAX) {
 		size = XATTR_SIZE_MAX;
-		count = (*pos + count) - XATTR_SIZE_MAX;
+		count = XATTR_SIZE_MAX - *pos;
 	}
 
 	v_len = ksmbd_vfs_getcasexattr(idmap,
@@ -443,13 +448,6 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 		goto out;
 	}
 
-	if (v_len <= *pos) {
-		pr_err("stream write position %lld is out of bounds (stream length: %zd)\n",
-				*pos, v_len);
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (v_len < size) {
 		wbuf = kvzalloc(size, KSMBD_DEFAULT_GFP);
 		if (!wbuf) {
-- 
2.39.5



