Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549988F5C;
	Mon,  1 Apr 2024 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987903; cv=none; b=i32Pp4CW01iyVhKDXHtGVVB5RN00TisUGfycT0RaL5IveXYglOs3NSQW7O2yTxGx8WHoLBxI9PZ0smNx6Kb147T0cCfnhRAeS7A3qNCjhtgEBmp0Dv+J+aWn5FSpIqlXRVZbryf0+CIe/CoDjpqCKVWyNL20xv09q2JWJqXAgyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987903; c=relaxed/simple;
	bh=PdZ/jCsEhZ03Q7J+t0TG83awFkSO29URvTQWEO3iRQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1oLpP0LSAZpx6IAQiP+M3LYUHL83RqcPfe3VRTvuA/RkpGWK26zZ+PdAVr5LoLzqgckdJquMquus7kXw4UpwMFcpgkzkabUDqFETkugREwh6I87snGtVlgGwX7VLSZaA2fTRJD2MV3CAEuXK29EoyZw3hxqLB3PHDpq9feRj0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mAIP64T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mAIP64T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAD3C433C7;
	Mon,  1 Apr 2024 16:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987902;
	bh=PdZ/jCsEhZ03Q7J+t0TG83awFkSO29URvTQWEO3iRQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mAIP64ToETT5VIZlvO4vW04vf5Kht8My3HEMBRRCOCugeYXQZEcEvaQez4yinlzA
	 9MWzBgHzphhVcp77nmlXb1QeR3xjM6/EVAbhWOzHnxAwvvOF7iGjWNRxFI4sitGRQn
	 k3I/Az9JZf8lBhCPtT9sjDfSYLJUPXzRr+OuOWvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 026/432] md: use RCU lock to protect traversal in md_spares_need_change()
Date: Mon,  1 Apr 2024 17:40:13 +0200
Message-ID: <20240401152553.913268706@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 570b9147deb6b07b955b55e06c714ca12a5f3e16 ]

Since md_start_sync() will be called without the protect of mddev_lock,
and it can run concurrently with array reconfiguration, traversal of rdev
in it should be protected by RCU lock.
Commit bc08041b32ab ("md: suspend array in md_start_sync() if array need
reconfiguration") added md_spares_need_change() to md_start_sync(),
casusing use of rdev without any protection.
Fix this by adding RCU lock in md_spares_need_change().

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240104133629.1277517-1-lilingfeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 99b60d37114c4..40dea4c06457f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9302,9 +9302,14 @@ static bool md_spares_need_change(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 
-	rdev_for_each(rdev, mddev)
-		if (rdev_removeable(rdev) || rdev_addable(rdev))
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
+		if (rdev_removeable(rdev) || rdev_addable(rdev)) {
+			rcu_read_unlock();
 			return true;
+		}
+	}
+	rcu_read_unlock();
 	return false;
 }
 
-- 
2.43.0



