Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018B755E5E;
	Wed, 21 Feb 2024 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523191; cv=none; b=GNn8wR40PK/ZUmpam5drJt1PPVCTHQ56ap20sSEjPodE5sHMw/kYI37WytoMqqiyQIEUGe4rBzXqDjxClDo3J53MYG5G65YzGWnwt+7zftd+GxpSHx74T7JLkxIPNZPWPfDU1773DTCM2Qrz4skEYRK7HuNjqUesRNfrxvO4Q/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523191; c=relaxed/simple;
	bh=YXrGCMmjNfntABRzSm8Hfd+dKLSBGzXpiGZJA8jjcDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfdbUFuMYaP5xVCICJn0fvDkr3/bKfOn68sjM+TELhhMFfmsC4GwBCfDTwM4tWByAerHKTtdB4j0mFIRAnIdibw9mdiXOF/JEmjBhrKrWLGb/JBY39tjaVPve+qL8nyOt1RsZ4vcCIV44mZtyenXwnvTlGCTEah2OqI2h/u/mOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V42I3rbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V42I3rbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CB9C433C7;
	Wed, 21 Feb 2024 13:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523190;
	bh=YXrGCMmjNfntABRzSm8Hfd+dKLSBGzXpiGZJA8jjcDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V42I3rbLcG2MpTivabllUHlv+Xo7SRIeood/b3bY+GdCjL6NvHfMUCIoW4oKl5XFq
	 Yi287ks+LSh8bA0688F/EXOetuP3S5OKOJmCtWQESyY8qmvjCFoHxEv92R+79Hl+ot
	 G2k42FiWfcJPc2iIxOnOxCXKSzCUg6fKqSL5/6n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/476] fs/ntfs3: Fix an NULL dereference bug
Date: Wed, 21 Feb 2024 14:06:17 +0100
Message-ID: <20240221130020.082898564@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 510ed2ea1c48..981276500043 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -468,7 +468,7 @@ bool al_delete_le(struct ntfs_inode *ni, enum ATTR_TYPE type, CLST vcn,
 int al_update(struct ntfs_inode *ni, int sync);
 static inline size_t al_aligned(size_t size)
 {
-	return (size + 1023) & ~(size_t)1023;
+	return size_add(size, 1023) & ~(size_t)1023;
 }
 
 /* Globals from bitfunc.c */
-- 
2.43.0



