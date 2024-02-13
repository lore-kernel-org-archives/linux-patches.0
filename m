Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626F15F54E;
	Tue, 13 Feb 2024 17:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845455; cv=none; b=Kd3pBt/QBaUvHcj3o7psbstDg6dCQcpD/Wsny4LHtoQ3d+L3Wlr46vvgl2NX2OgEdoEnsbSQuBw6S0+WUHqirGl1T6Z1HayZzbUbdXDaEWaHKwdIfklAqfT9FboBp6rCrEccb8G+FcxKzurjDX2Yc7LirUyryFfArBsVt+mhcsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845455; c=relaxed/simple;
	bh=ooeNb6ZtIuvwTPuuqaubY18fiV5/TaoEF3zxZKDWvNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBUQMDPaiN1MasHzkXui4RnGIgBmJKo2ZG0eXVernk4rywvUPjC2FfXO+Pu4xNT5IXwmGVND0IsmNj6R2BeKArJiI2oRFxU1gGX+w6vk+P2D21HmLaiTzoVITVvCVK5Y+GPJiZ1zAgwEXafmW6o4HdxkCqBe1aoP5UqT12ZPQls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyN3PKwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyN3PKwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D745DC433F1;
	Tue, 13 Feb 2024 17:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845455;
	bh=ooeNb6ZtIuvwTPuuqaubY18fiV5/TaoEF3zxZKDWvNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyN3PKwaAFwobyTUdQ3w09F45cT6lx4EAeinYxrrrMkBW9K4hNgmH0z2iF/YpkMTs
	 +SRh4SQ/pUrBLWI8vhgy2QWKYXG6qov9CIUFXmGPqCptDwwv+kmslDfyHxZy6zSGCd
	 Y5JFikZsaZZcGSMF98v8QhfYPo9YMVOLhd4VYOUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/121] fs/ntfs3: Fix an NULL dereference bug
Date: Tue, 13 Feb 2024 18:21:33 +0100
Message-ID: <20240213171855.440396282@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit b2dd7b953c25ffd5912dda17e980e7168bebcf6c ]

The issue here is when this is called from ntfs_load_attr_list().  The
"size" comes from le32_to_cpu(attr->res.data_size) so it can't overflow
on a 64bit systems but on 32bit systems the "+ 1023" can overflow and
the result is zero.  This means that the kmalloc will succeed by
returning the ZERO_SIZE_PTR and then the memcpy() will crash with an
Oops on the next line.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 0e6a2777870c..29a9b0b29e4f 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -473,7 +473,7 @@ bool al_delete_le(struct ntfs_inode *ni, enum ATTR_TYPE type, CLST vcn,
 int al_update(struct ntfs_inode *ni, int sync);
 static inline size_t al_aligned(size_t size)
 {
-	return (size + 1023) & ~(size_t)1023;
+	return size_add(size, 1023) & ~(size_t)1023;
 }
 
 /* Globals from bitfunc.c */
-- 
2.43.0



