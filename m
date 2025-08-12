Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C171A9F89;
	Tue, 12 Aug 2025 18:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022997; cv=none; b=ARUAHMdatgNJuN1+OJuR6wNeiFCHTWIBtbi1bzrsCekKY3vk64ph2ozY4aGg/CIoMQVaeGTqYqM1F6i4A1Y1uiGOY9OCAWHrbMR5XVuFxD/LxAMUApxvfmC1x0e42UytS5WR9UBRrkBdt4KX/c/m1QnGmmGKomCuWqeE+CPmzNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022997; c=relaxed/simple;
	bh=m3V1AoO07xWdXaOBzUqUXS4rQAkVt5AU292wrQ9PwhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIe/hO542t1js5e0LWZePSUnNNJI/znudpTelxzTV0G3MvnnBWt/dqWNm22JMY7gupuePta9gOui/ysvRdM3LiKnmwvwaLqN/BBNSsGCJQRwBGKS059kvmL12luuc8iMkm8UNrkn5CqFO3iVW62KhgOSnSuGcCRN/31yDXP+SR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=texgv43y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="texgv43y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0DBC4CEF9;
	Tue, 12 Aug 2025 18:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022997;
	bh=m3V1AoO07xWdXaOBzUqUXS4rQAkVt5AU292wrQ9PwhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=texgv43yb2YIeCGHsuv7/80s8uqQWdYeSNDGPspUFMfzbJrjTUttPgipMqBNSQ6WD
	 CDDcB18syikwJFtzdh1hZjDC3uoBT8sI/HzvAhgYzUuvUof8r2KpX4pSmXfa7MyEAH
	 L8YZQ15ydLuao1mvdvaqndLCmp+0ZbC6/GwO3p2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Su Yue <glass.su@suse.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/369] md/md-cluster: handle REMOVE message earlier
Date: Tue, 12 Aug 2025 19:29:43 +0200
Message-ID: <20250812173027.485902149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Heming Zhao <heming.zhao@suse.com>

[ Upstream commit 948b1fe12005d39e2b49087b50e5ee55c9a8f76f ]

Commit a1fd37f97808 ("md: Don't wait for MD_RECOVERY_NEEDED for
HOT_REMOVE_DISK ioctl") introduced a regression in the md_cluster
module. (Failed cases 02r1_Manage_re-add & 02r10_Manage_re-add)

Consider a 2-node cluster:
- node1 set faulty & remove command on a disk.
- node2 must correctly update the array metadata.

Before a1fd37f97808, on node1, the delay between msg:METADATA_UPDATED
(triggered by faulty) and msg:REMOVE was sufficient for node2 to
reload the disk info (written by node1).
After a1fd37f97808, node1 no longer waits between faulty and remove,
causing it to send msg:REMOVE while node2 is still reloading disk info.
This often results in node2 failing to remove the faulty disk.

== how to trigger ==

set up a 2-node cluster (node1 & node2) with disks vdc & vdd.

on node1:
mdadm -CR /dev/md0 -l1 -b clustered -n2 /dev/vdc /dev/vdd --assume-clean
ssh node2-ip mdadm -A /dev/md0 /dev/vdc /dev/vdd
mdadm --manage /dev/md0 --fail /dev/vdc --remove /dev/vdc

check array status on both nodes with "mdadm -D /dev/md0".
node1 output:
    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1     254       48        1      active sync   /dev/vdd
node2 output:
    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1     254       48        1      active sync   /dev/vdd

       0     254       32        -      faulty   /dev/vdc

Fixes: a1fd37f97808 ("md: Don't wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Link: https://lore.kernel.org/linux-raid/20250728042145.9989-1-heming.zhao@suse.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7809b951e09a..4b3291723670 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9702,8 +9702,8 @@ void md_check_recovery(struct mddev *mddev)
 			 * remove disk.
 			 */
 			rdev_for_each_safe(rdev, tmp, mddev) {
-				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
-						rdev->raid_disk < 0)
+				if (rdev->raid_disk < 0 &&
+				    test_and_clear_bit(ClusterRemove, &rdev->flags))
 					md_kick_rdev_from_array(rdev);
 			}
 		}
@@ -10000,8 +10000,11 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 
 	/* Check for change of roles in the active devices */
 	rdev_for_each_safe(rdev2, tmp, mddev) {
-		if (test_bit(Faulty, &rdev2->flags))
+		if (test_bit(Faulty, &rdev2->flags)) {
+			if (test_bit(ClusterRemove, &rdev2->flags))
+				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			continue;
+		}
 
 		/* Check if the roles changed */
 		role = le16_to_cpu(sb->dev_roles[rdev2->desc_nr]);
-- 
2.39.5



