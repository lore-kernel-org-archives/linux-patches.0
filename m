Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056043;
	b=L/J2nnPW3pphYOW9zMMfF0ohHSx/onTBS5fTrORUkEQGQXSKjt9hCLQg5BiUgSvaAXVr
	 sh1WbzPFIEHU7N/dB2IKXdqLwvnO6QYPRjH3MEitMS6w6NgtG/m7uO3BF4LwqGvPuYxo+
	 S/OXvc18QmImmQSHXHcvbWuHjSRjAtCgl1xzFY5GTrLFnsnwrVGScdgXofWMFWTfW1tu+
	 90y3HZ4q41IxE16XcJZBMOCcMAabILBGhJr73WRWPeVcYK4XQfwKYaWEkov+tsfFhV1sQ
	 Yh6FzbVcvMqvmbtvt9+Z5gBSLec+9vPm8dHUjKzTcCzeuWhdRga//fhLWxpQy4lAnfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=82w1AYqF1ADiQZS5i2QMHyE8ogZRnOfcj7/MMeoS/x4=;
	b=B7z5hNEilSwFFoQKOXjbQ4kkSCHAoW6DFrWTHfrmlKY91gRjyo8gOeWCy3Omzc3d6ltI
	 VTdYKsHvLKgh9MBHIFZJrloGoEm7XR5oKaQxoGxPZfhUPkXtDh+Cr0c87YZOX01xHOhvX
	 UfvEVZ2CuosmCb1r7K2LBOk2AlZYCTMTzM5T8P+TewpGUlYtInrsxOyAzGyXQ9qRfzPew
	 nSgk6JWbqRh0eYu1qHTYAAvU1gr3jRbP0Dera2vgkXMxh4ZURLDT73XSBNaCzi4rKobHM
	 r8R+qw69KLcr1ZTElqoJ2Io/vygtl5Eahbe1wWvxUAo+YuOz0GYtT0VTxB6H0Xg61Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uX3wAejs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67831606A325;
	Thu, 19 Nov 2026 02:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uX3wAejs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98B71F000C4;
	Thu, 19 Nov 2026 02:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056043;
	bh=82w1AYqF1ADiQZS5i2QMHyE8ogZRnOfcj7/MMeoS/x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uX3wAejsx7YuVqG4FkW8jL1vBo0B+ctjx5479v23D90RTQztSlKTOP0DYRwy1b0Gz
	 /polxosD2xFA55RF54Z45UC5BBtrRokdayRLpwfWM+5sybIhh6C52NGVyA9hO2xG63
	 ZxMxYcXS9aENOhbLdbXd80xaEreQcNPB9/vjyyvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1846/2214] btrfs: fix off by one super block end offset calculation when writing super blocks
Date: Wed, 18 Nov 2026 15:58:42 +0100
Message-ID: <20261118150125.250768550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7884a8f3279c28ff990e2eacd5c2479bb1c930d0 ]

We are skipping the write of a super block mirror if its end offset
matches exactly the device's end offset. This happens because we are using
a greater than or equals comparison instead of just a greater than
comparison.

Fixes: 935e5cc935bc ("Btrfs: fix wrong disk size when writing super blocks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c75db0cd02653..52b10edc55c73 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3832,8 +3832,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			errors++;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		btrfs_set_super_bytenr(sb, bytenr_orig);
@@ -3916,8 +3915,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 				primary_failed = true;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		page = find_get_page(device->bdev->bd_inode->i_mapping,
-- 
2.53.0



