Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585501;
	b=XTvDrNgXzSNk7XGrv62URAb85jerjbQrT44lD1d8m9HoRqPkKBG7nLEPg0FSJU9/QOu9
	 AeTwJ13L4CQuygmF0uHF60UPRkzCOl1fhhRnB8MAneeIy2W6vMs5V7NrzJLpSXPZKSgqG
	 0KeY+iHnwbI1AzEotvIUL77Ec4ZqwqR74uBA+gjYXeRieu7+CL0or2TqNcWYmpbOS1X1E
	 2CydoG+nxSNePLELbEyMI0qYxCHCrTKArYfj0NByrZzesFExwLx4Xp/ML7N4rGi7wKBEv
	 2H4YkLdoPP5OJRUoJA7TY4TD8uoSW1quX2V33VA/3D/XOpnMm6coCdgvk+Vg84iPvLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iP75UQcVzMBxWYZ4D4zf2EqHzTz0/HguVFi4QiIe9Pc=;
	b=E9ge6SlE3v7RxdbFuUYBnaaRZ8MI9ytdR1U3/E/1irWKAZpeDO8NpadqTPm3lSIZf86a
	 ur5RGcPieT4PWPNFfgp89Gflx7p/CLSySoBv0b4g1/yj4GnBlt5JBzA9BTdW+TM1H4FMc
	 XPG/Hd34tj1Mb8QE7NPhDq3pg6x22tQrcvRStoZ/yV/p12Nz9TmslTpgds9iNjiWOqsXx
	 chP5sN7MmiOl5/p5Z/WtX+CXZ79JSOjAgkkdss/8b2bGBYAY5DZv8HMsSiyFW+NoAexht
	 jGNd8gt3hngF25sLKOvUV/8E07cKcwQRZL+a0QYeErgTxUSGw1S+DRIpxXJqkONeGSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bu0z2HEA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E47B606AE1B;
	Fri, 13 Nov 2026 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bu0z2HEA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EA31F000C4;
	Fri, 13 Nov 2026 15:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585501;
	bh=iP75UQcVzMBxWYZ4D4zf2EqHzTz0/HguVFi4QiIe9Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bu0z2HEAimTVCwKookMY8GLPmEdMXyTcQ3AVRDqojKbbGZRHahh7oB4GfrCXP8tq7
	 YVAoEzWL9q9dk+hVRNZg0BQPVhSYp4Wupw5QkEwcPzcfIyNxWYYfzsu9epmwipXtDa
	 67e9vT/8isr5DeSMN/ccvfMj375PIxE845A/3jDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nhat Pham <nphamcs@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 142/507] mm/shmem: fix truncate loop after boundary swapin failure
Date: Fri, 13 Nov 2026 10:47:26 -0500
Message-ID: <20261113153759.253592709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 5f1ec2cf92a7d655a8eb39711987822f9b1f9d67 ]

If swapping in a large entry at the new EOF fails, shmem_undo_range()
leaves the entry in place. Its final scan skips the entry, then restarts
from the same start index and finds it again. Truncation can loop forever
while holding i_rwsem.

Advance start past the skipped entry so that a restarted scan can finish,
as we already do for folios that cannot be split.

Note that this does not fix the missing zeroing when boundary swapin fails,
it merely prevents the endless loop.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-13-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2b2f347bb8a71..508ada89151d8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1229,14 +1229,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					order = shmem_confirm_swap(mapping, indices[i],
 								   radix_to_swp_entry(folio));
 					/*
-					 * If found a large swap entry cross the end or start
-					 * border, skip it as the truncate_inode_partial_folio
-					 * above should have at least zerod its content once.
+					 * Skip boundary entries when restarting
+					 * the scan to avoid endless loops after
+					 * swapin failure.
 					 */
 					if (order > 0) {
 						base = round_down(base, 1 << order);
-						if (base < start || base + (1 << order) > end)
+						if (base < start || base + (1 << order) > end) {
+							start = max(start, base + (1 << order));
 							continue;
+						}
 					}
 					/* Swap was replaced by page or extended, retry */
 					index = base;
-- 
2.53.0



