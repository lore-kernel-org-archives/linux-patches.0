Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A200523CE;
	Tue,  3 Dec 2024 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241881; cv=none; b=so1XBN71aVznaZy6aqL2k8ft5D8H2LuySyfZsNHfEZpJ2gu8v2nxkFvjFMZCYhSgqyau2Q6vltURkNXUUrkQTgxVwqdlztr/tX6fJZvmWpU0VCGKP+d8aSAfG9xA2N/MqcxxhnDn/YKrJLmePuJA0CXtffj4z0M8VmYpbWv43Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241881; c=relaxed/simple;
	bh=ZnUgfzMQB3zHbeElJDHaCd/vKDBok9rXsTL7tTpfX8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUK3Uf+nFZs5pmYbQBZpUuQgjb2EUKQs04joiaLEmHfvKE7ADhwflu6erztIJ6kJfUBzTZGFsuL9XcM8wairkEizQkwntuy39g9Ska9J1r6HH4rejE2fTy5DtoyPZVyruHWdhnsLacHUS0C83qAXuu0n6B8AIAMrsepP1qKjwzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv8rc269; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv8rc269"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C29C4CED8;
	Tue,  3 Dec 2024 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241881;
	bh=ZnUgfzMQB3zHbeElJDHaCd/vKDBok9rXsTL7tTpfX8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv8rc269MQIxkO59B0UZaSWuGAKX5vBmXvH3rShacwgXb9UJrHTBZd0bmfVkucELv
	 srpYTgNCVvUGNCt9KrdrFqme/icjkTt1WlS+FX03MMg51k6OS9LWTh62ZPD/srVBHp
	 YjewSZxPNw0Oobg8X9WGRX7n0JzfUDy+MH/eE7yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 542/826] selftests/mount_setattr: Fix failures on 64K PAGE_SIZE kernels
Date: Tue,  3 Dec 2024 15:44:29 +0100
Message-ID: <20241203144804.895565336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 68801e1a9ec2d..70f65eb320a7a 100644
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



