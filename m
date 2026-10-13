Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6FE3C1D47;
	Tue, 13 Oct 2026 12:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893490; cv=none; b=MzZoH78Hmd+qiSNDuf5Ad+c25bZeP1viZtXkQhfsfV2jEpRdEOjCvZOAk5tGAahaJ8F7Y6/vNjvXEdNIv2uogiHMIgGaB1qO6hCBoZ63FSBguYpl0I9keYlHZrlEQVIEyPs1m3mpXxqucNWNYU3h4SzgpW5oAGjADyOAvLthDdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893490; c=relaxed/simple;
	bh=19/mHPWlDT7dVtlHvp4+JYbLlQ16r3wQePMY4G0on5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdLNjv/bmslnaDWSsRn9rD0gVQBlhpq5u2JE87Dvxd4s8bC7VyItMZl6IVQ0Lq5vOugpksDUTjkLWRxS7chZrIFXDaA4X4mqiJAAK6yEMKdoZB3WhI+C7HNzgOQTmU3+PF5o8aXa37vB332+KuW36RnpTSYUgm/Qq/oYFvpqc04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsyPXidu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsyPXidu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1731F000FF;
	Tue, 13 Oct 2026 12:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893489;
	bh=tRSGa+vGRpwAkaTY1LiNI0CzedQgOxJC0Puh8CW04PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsyPXiduqRThvh8b5r2hzb+vW8saqPVpR2wVm16jfMLWNuHq8lG/CLne38mVSAHNe
	 DvGYLA9DR4Gz21SjN3ZXa22WDU7abowavMb26iPGaI1wKML86qoNjplhd5fGPT7d/0
	 rCuQ9ZH/PYRSzjQjLTpgsO1v4bNqfwxQ2Hrr5EC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 241/621] cachefiles: Fix error return when vfs_mkdir() fails
Date: Tue, 13 Oct 2026 13:33:56 +0200
Message-ID: <20261013112926.577669217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 8a220d1c312c66194f4a33dd52d1fba42bc2b341 ]

When vfs_mkdir() fails, the error code is not extracted from the
returned error pointer. This causes mkdir_error to be reached with
ret=0, which leads to returning ERR_PTR(0) (NULL) instead of a
proper error pointer.

Fix this by extracting the error code from the error pointer when
vfs_mkdir() fails.

Fixes: 406fad7698f5 ("cachefiles: Fix oops in vfs_mkdir from cachefiles_get_directory")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://patch.msgid.link/20260513103406.202320-1-zenghongling@kylinos.cn
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/namei.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index eae5045d50081..e83056d9aee46 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -129,10 +129,13 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 		if (ret < 0)
 			goto mkdir_error;
 		ret = cachefiles_inject_write_error();
-		if (ret == 0)
+		if (ret == 0) {
 			subdir = vfs_mkdir(&nop_mnt_idmap, d_inode(dir), subdir, 0700);
-		else
+			if (IS_ERR(subdir))
+				ret = PTR_ERR(subdir);
+		} else {
 			subdir = ERR_PTR(ret);
+		}
 		if (IS_ERR(subdir)) {
 			trace_cachefiles_vfs_error(NULL, d_inode(dir), ret,
 						   cachefiles_trace_mkdir_error);
-- 
2.53.0



