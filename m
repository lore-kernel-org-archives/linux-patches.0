Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2BD1E89C;
	Tue, 27 May 2025 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366155; cv=none; b=daHzpIM4QaqGXarfMfdQUBco9mgFGhn8P6w3HId9mIDNr7ENgZxnultMNjI17F3LrDEil2nZRDCKjUTeeXgCX0Sm9EAF7FKZYJu113PtuclHBGB4E16mSWPzwi3ESoi7/kHggGrRRErFNBF0xDc8I1Tw9iLy9sxK+spUHbab+p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366155; c=relaxed/simple;
	bh=/OBIMv/AK3EbwZs6H/WRYUiVNz1WcymJnYVGh0r4Zdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzQ/ip7ETHfpECqGtoAfrTq06Q6nokhAZOLswasPZrY9cNLDjfPH+63gX16vQG7Y7IGTyJseiQWfIhdyG3SwF4RvhkoAzRLQfu6fqsBDo/zcHSCChYBJ+zQ64BC6aiiRPh9F6SHlvkU740ap/Zc+UbzZ/ouW1UdP/mtzxGEYQ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zaj4AVqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zaj4AVqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05F5C4CEE9;
	Tue, 27 May 2025 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366154;
	bh=/OBIMv/AK3EbwZs6H/WRYUiVNz1WcymJnYVGh0r4Zdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zaj4AVqSwOowsiBnOBOV2/IkgGyrn5zJ5JVXi740rTiPueL489rIk71CnZ8FNpfnw
	 qtEJY3g+bCf2hFWMSxUpI7CRiIonjZQBjtjJemicOaRyS6vuv/2H1WGDnx4cKBzMEO
	 PxSsdWxSp8UEAY/0ahZtoO8KhsWKFN94Ry9hakaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 607/626] ksmbd: fix stream write failure
Date: Tue, 27 May 2025 18:28:20 +0200
Message-ID: <20250527162509.657152839@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e059316be36fd..59ae63ab86857 100644
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



