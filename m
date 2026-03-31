Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173652D1F40;
	Tue, 31 Mar 2026 16:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975527; cv=none; b=hv9r3supwBi5wB/2kUzYGC32RAf/OMDRhsXqDqzHYNGLJ49qTuSETxq0KV52E8ly8sVH8kZE4Wk8tsdFuQOPlChdt43n0lBOrJeubnLF6CwsQozi4E/j7S75agGgiI8ebw4Q0NUoYx5qY5BCTbW/PeN6pzbieufsJ80dLvsYh3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975527; c=relaxed/simple;
	bh=s/Cep65FNyVR7/Q6aRLC7zXx+nZsapVla7TcuHuvQ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwY+WwWMI5kmfZLVUS5ZO3t28YQtdrXu09foQUpVS2PGaYO4mfsjjtil4fOkqvI/fV4Whp7vT70EViZkgwiSjIk2XsJpmN7ZhHDycgR333qsstWly5Yb3CM+PZ92OnkPaT3W6+PR95JsBHBywZDJqQgCwLY6b8uJLuz2wrR46F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxOLsbH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxOLsbH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A5FC19423;
	Tue, 31 Mar 2026 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975527;
	bh=s/Cep65FNyVR7/Q6aRLC7zXx+nZsapVla7TcuHuvQ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxOLsbH8dsuF/ZoUHOox7FzZiHpGF5iX+dNc5eumDxMTBKS5dARsaAB8JMhDJlcGT
	 JIr1m+CLSJ0GRYWLyr28K+VxK1pc4Vv41OKcgKh92jD0tCWmiC9iFeiLKlyT3ODMwQ
	 Z5UrVMcANavMQ95EdD2FEjn3QBu2Sa8ikTtzc8Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 329/342] selftests/mount_setattr: increase tmpfs size for idmapped mount tests
Date: Tue, 31 Mar 2026 18:22:42 +0200
Message-ID: <20260331161811.014096556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit c465f5591aa84a6f85d66d152e28b92844a45d4f ]

The mount_setattr_idmapped fixture mounts a 2 MB tmpfs at /mnt and then
creates a 2 GB sparse ext4 image at /mnt/C/ext4.img. While ftruncate()
succeeds (sparse file), mkfs.ext4 needs to write actual metadata blocks
(inode tables, journal, bitmaps) which easily exceeds the 2 MB tmpfs
limit, causing ENOSPC and failing the fixture setup for all
mount_setattr_idmapped tests.

This was introduced by commit d37d4720c3e7 ("selftests/mount_settattr:
ensure that ext4 filesystem can be created") which increased the image
size from 2 MB to 2 GB but didn't adjust the tmpfs size.

Bump the tmpfs size to 256 MB which is sufficient for the ext4 metadata.

Fixes: d37d4720c3e7 ("selftests/mount_settattr: ensure that ext4 filesystem can be created")
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mount_setattr/mount_setattr_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mount_setattr/mount_setattr_test.c b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
index 7aec3ae82a446..c6dafb3cc1163 100644
--- a/tools/testing/selftests/mount_setattr/mount_setattr_test.c
+++ b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
@@ -1020,7 +1020,7 @@ FIXTURE_SETUP(mount_setattr_idmapped)
 			"size=100000,mode=700"), 0);
 
 	ASSERT_EQ(mount("testing", "/mnt", "tmpfs", MS_NOATIME | MS_NODEV,
-			"size=2m,mode=700"), 0);
+			"size=256m,mode=700"), 0);
 
 	ASSERT_EQ(mkdir("/mnt/A", 0777), 0);
 
-- 
2.53.0



