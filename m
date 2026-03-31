Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42361317150;
	Tue, 31 Mar 2026 17:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976973; cv=none; b=rrfOxMauSswoIldNp8VMpSIQg/L0SnSTzBQoTVDRMSjBqmvEsjPxIVHW5pNK7b0wylEgFA2cjVlmZklWAZRwRAwo7kQgLbRxRATu5DoAwT62GnVNW8TAfju4TrY0m2vOD8TIp8LJ1tkVRsMYDtRigq2msSGoGxqprhEhSlMhSSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976973; c=relaxed/simple;
	bh=+4CACyGjrflPhA1mD24dNI0rCKYicAr/GfouIQXXprE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRZf876kaivijFcxzKWprCG2xObk9VSNt3dlQpCME5uE5teOleNjQ7t4t9vJXZBh/6mnIFcub23ULyydLD2J2BcnflMAI/nAq51s1U1cO5r0WX8MBEr/szyC1Ewai9YoTjUFtG88PbHAMaFdaYq4yR7w3HMKAKgibtpC+AEzPVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFM/QEfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFM/QEfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF75C2BCB3;
	Tue, 31 Mar 2026 17:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976973;
	bh=+4CACyGjrflPhA1mD24dNI0rCKYicAr/GfouIQXXprE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFM/QEfjVgN0HS3qI2QP8WkQECGfwyY7fYlv1Lrc0aT9Gl64bAsLKQMQgMVpS+Gc0
	 XC1syWdENVVBDZoSynnPe78nFG6tIeaOSR+QO13ljYGOg0NW9IE7NMd88giMoKJ07/
	 HbtUHp0/bRn6pTLtfo4+9znTWHlwzfh+QFhEfxac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 299/309] selftests/mount_setattr: increase tmpfs size for idmapped mount tests
Date: Tue, 31 Mar 2026 18:23:22 +0200
Message-ID: <20260331161804.573676011@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index a688871a98eba..388bca88ec94f 100644
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



