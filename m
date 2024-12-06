Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F77018FDAA;
	Fri,  6 Dec 2024 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497877; cv=none; b=sCrzE/VCmJFvJ/mB78avAL7l+yjDh9Cmq/AH/SEqir1icFgUC+faoiYNOIeoFXxAJtd3d6hBiFTWvTszMcuxyxj8RxYmQv/WEEyTVxJ5tphNurIpWNEEjANiZxe4+qWn9imG/RTGrr5414oA4oABjx9Q0XbOTWB49HWVCiuvi70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497877; c=relaxed/simple;
	bh=jT44WHGeDDMGrI2hnIlqnuM5HGTddqzCQBoSbsdZ+Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKnv6kqS3qKLkn0qwltxxSIxuY1KDjdRiEiqxyVimBISyAUxLjJwbjuzm/p0KgOOlgAR0NrU8rFIUjttEk0DlbEU8ssLfEsioJVJUhUID1hcZ2v3HlrTaac9dnWHUY7QG0wrqLrS8jr5+gmmBP8qAGR0e1foZPM571TBJMHOoUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNuhyKjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNuhyKjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D385BC4CEDC;
	Fri,  6 Dec 2024 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497877;
	bh=jT44WHGeDDMGrI2hnIlqnuM5HGTddqzCQBoSbsdZ+Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNuhyKjMWyx2hSUy10ynrvELrMlV7I3kTEDGrLUvD2DmRnSTX/rt0xZCNzAXBeiRi
	 wrZX+FwdxFG+Cz51BvgMu1ag32Rnjpceq1G9goViG042lCh7z/qWAK4txoqm7Sbmji
	 4Mc6SYEwlFY7Meio6aOgEqspTHeeCsQ5+cVVeLd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 388/676] selftests/mount_setattr: Fix failures on 64K PAGE_SIZE kernels
Date: Fri,  6 Dec 2024 15:33:27 +0100
Message-ID: <20241206143708.501307812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit f13242a46438e690067a4bf47068fde4d5719947 ]

Currently the mount_setattr_test fails on machines with a 64K PAGE_SIZE,
with errors such as:

  #  RUN           mount_setattr_idmapped.invalid_fd_negative ...
  mkfs.ext4: No space left on device while writing out and closing file system
  # mount_setattr_test.c:1055:invalid_fd_negative:Expected system("mkfs.ext4 -q /mnt/C/ext4.img") (256) == 0 (0)
  # invalid_fd_negative: Test terminated by assertion
  #          FAIL  mount_setattr_idmapped.invalid_fd_negative
  not ok 12 mount_setattr_idmapped.invalid_fd_negative

The code creates a 100,000 byte tmpfs:

	ASSERT_EQ(mount("testing", "/mnt", "tmpfs", MS_NOATIME | MS_NODEV,
			"size=100000,mode=700"), 0);

And then a little later creates a 2MB ext4 filesystem in that tmpfs:

	ASSERT_EQ(ftruncate(img_fd, 1024 * 2048), 0);
	ASSERT_EQ(system("mkfs.ext4 -q /mnt/C/ext4.img"), 0);

At first glance it seems like that should never work, after all 2MB is
larger than 100,000 bytes. However the filesystem image doesn't actually
occupy 2MB on "disk" (actually RAM, due to tmpfs). On 4K kernels the
ext4.img uses ~84KB of actual space (according to du), which just fits.

However on 64K PAGE_SIZE kernels the ext4.img takes at least 256KB,
which is too large to fit in the tmpfs, hence the errors.

It seems fraught to rely on the ext4.img taking less space on disk than
the allocated size, so instead create the tmpfs with a size of 2MB. With
that all 21 tests pass on 64K PAGE_SIZE kernels.

Fixes: 01eadc8dd96d ("tests: add mount_setattr() selftests")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20241115134114.1219555-1-mpe@ellerman.id.au
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mount_setattr/mount_setattr_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mount_setattr/mount_setattr_test.c b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
index c6a8c732b8021..304e6422a1f1c 100644
--- a/tools/testing/selftests/mount_setattr/mount_setattr_test.c
+++ b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
@@ -1026,7 +1026,7 @@ FIXTURE_SETUP(mount_setattr_idmapped)
 			"size=100000,mode=700"), 0);
 
 	ASSERT_EQ(mount("testing", "/mnt", "tmpfs", MS_NOATIME | MS_NODEV,
-			"size=100000,mode=700"), 0);
+			"size=2m,mode=700"), 0);
 
 	ASSERT_EQ(mkdir("/mnt/A", 0777), 0);
 
-- 
2.43.0



