Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FE82397B1;
	Thu, 12 Dec 2024 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019900; cv=none; b=Ib8uBCM274xMC8CvgEC4CNqaZRMhQ5Ke0+n4QcTC2z+Bu+4VjKn+SP6rm15NJvqBuazcVR+6W6oaE5//fAtJmv6x7S+AdtSpcS32usk7eOwy0hC+21DPioGYVnGJquqRir6VJyYqdROn0H7fR/BgE+whltUy8Dme3mXtJaLxuz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019900; c=relaxed/simple;
	bh=jzetHflY4LWjToPRIGH6WQQmxRlpPpOIGNvTTjnI8Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZEttiZYRrrxSOz1ZzJBP+UjbfH9M9NLw7jWwbhGvhdYNVK/bIXt5q6VW/shaOiuyIj1bJFxZu8qsOCrYiRgKrH/pI8a/hZKNkRwv82Ou0NzwwdHfhFJInh1jTYVRNhT8tD1EUvs+h8GqfKkdopfUPqt9lJTPv5NTTGSzrDNCBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnloPcID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnloPcID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D8BC4CECE;
	Thu, 12 Dec 2024 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019900;
	bh=jzetHflY4LWjToPRIGH6WQQmxRlpPpOIGNvTTjnI8Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnloPcIDSHsQBTHIiV713aCE+6EiYmHjPCurOQPuK61RVaYvn5iUD3ocz/h+ukQQP
	 BtRcHhJk7Dm40nQ8kFSkrwYrRH1Hh/pDi6TGdzmUe0+yN0ZqNwT8rFZBifODqLTqMZ
	 5F+ZLHn+J13l4e6eaSZYG3tanQZNc7L1vxYcif2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 297/772] selftests/mount_setattr: Fix failures on 64K PAGE_SIZE kernels
Date: Thu, 12 Dec 2024 15:54:02 +0100
Message-ID: <20241212144402.176319077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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



