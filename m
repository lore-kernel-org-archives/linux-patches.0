Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E925FEFA;
	Tue, 13 Feb 2024 17:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845076; cv=none; b=ScQ9M8DQ4RIze/ktOaFjw53aBBNXXTDe2GkJ//70j07KvhHybrA7M7r535R7LdiHdHYVFV4ppDkpcTifDce9oxq1FciNjT8o2ySAQxWc8MMk8VeYcCTGm0XK9IPqrvHEA4WOqbV/ueCwIIrQVNvjI8Wmvhr1pJOl9AcnkxCGrec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845076; c=relaxed/simple;
	bh=2Ag7ixUgMEziCumLdmUfoA9QkDFQowJi1x4go9TCZt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dpz81VDvZ6KQ6vz1BJvRh5vKZYpg0Fwoq2DyO44ZdB+e/EoK2Qfgs2XPNqM4A/sUVPX1CEu/4NGY4i4PUi+XYibp4DhQRgQfH1m2xvMU2nv5lqYoPNGqsvJelcmlGGm7jylfnYyW2Q0lc1Sd4kP/752kEZZvjk+K+lUf7+f1NIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J35j9NcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J35j9NcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA20C433F1;
	Tue, 13 Feb 2024 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845075;
	bh=2Ag7ixUgMEziCumLdmUfoA9QkDFQowJi1x4go9TCZt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J35j9NcUDZWnAq4HIxqqizuOLqy5ZJkEsW555nBLmlHENH5M+3kiGmE7JKs35okOh
	 EMo29+HbuGwZItuMThbsad8bUNkja6QevuKD0EYGCebtIuAwZmMHW9H297uCutXPER
	 cgD5jVq5obC4rdKOUpoOfreYEVCOrcvxxKwY/RGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/64] fs/ntfs3: Fix an NULL dereference bug
Date: Tue, 13 Feb 2024 18:21:26 +0100
Message-ID: <20240213171846.008021403@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c9abaf139e6..74482ef569ab 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -467,7 +467,7 @@ bool al_delete_le(struct ntfs_inode *ni, enum ATTR_TYPE type, CLST vcn,
 int al_update(struct ntfs_inode *ni, int sync);
 static inline size_t al_aligned(size_t size)
 {
-	return (size + 1023) & ~(size_t)1023;
+	return size_add(size, 1023) & ~(size_t)1023;
 }
 
 /* Globals from bitfunc.c */
-- 
2.43.0



