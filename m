Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAEF25F780;
	Mon, 22 Sep 2025 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569812; cv=none; b=RRnz812ZzTvDYUvBOh2b/sAOc3K4zwA8HUM7Masyb4+9lrFVPCTT08HAt2erM/eCWdP+SKcU7er5U+h2EiAZUU1LnjMWMh5NEt79/ZqCUdSnhLJhRcld5NAnIt5hdOngAOIQR+bz+uz3Lp/U8/Ie1ZIBrbWe5cbxG30QWu8sCSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569812; c=relaxed/simple;
	bh=p4jryB07k7M5vKBTCrC4ou4exVH6wGIHL20RQE7fL9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ospaCLxTW08EwDXSaAD9WKzgRlahWFH+kLMoswB/cBOEPvf1zxRGB32UsRKs7c8YWd1xuzBl9MFlgBad9yxwAkLzilUZEUvQ7UdUFBAFbbZFhqgdmAOL/GFLWU+h09e/ay2Lekfui3NRqrGAj0h6ZHPTuLHG0u7Tg04iFLI2WaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnXWlzUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnXWlzUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C8FC4CEF0;
	Mon, 22 Sep 2025 19:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569812;
	bh=p4jryB07k7M5vKBTCrC4ou4exVH6wGIHL20RQE7fL9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnXWlzUDNqYb//Og/ulau8DL0SssM6upbAac1qHnO0VgcihD7iLRWTa6T05mb8z94
	 GyDhHveiabFLALcAzWjVf/5NVGQeXJ9ouNpss1RFCrwntwjT2PfMCeTRrOc8yf3vvp
	 CAGRLWwZ2zV4JN6JET1XpQo9bHhC50RGn0PPv3cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, jack@suse.cz, Eric Hagberg" <ehagberg@janestreet.com>,
	Eric Hagberg <ehagberg@janestreet.com>
Subject: [PATCH 6.6 70/70] Revert "loop: Avoid updating block size under exclusive owner"
Date: Mon, 22 Sep 2025 21:30:10 +0200
Message-ID: <20250922192406.492614870@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Hagberg <ehagberg@janestreet.com>

Revert commit ce8da5d13d8c2a7b30b2fb376a22e8eb1a70b8bb which is commit
7e49538288e523427beedd26993d446afef1a6fb upstream.

This reverts commit ce8da5d13d8c ("loop: Avoid updating block size under
exclusive owner") for the 6.6 kernel, because if the LTP ioctl_loop06 test is
run with this patch in place, the test will fail, it leaves the host unable to
kexec into the kernel again (hangs forever) and "losetup -a" will hang on
attempting to access the /dev/loopN device that the test has set up.

The patch doesn't need to be reverted from 6.12, as it works fine there.

Cc: stable@vger.kernel.org # 6.6.x
Signed-off-by: Eric Hagberg <ehagberg@janestreet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |   38 ++++++++------------------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1472,36 +1472,19 @@ static int loop_set_dio(struct loop_devi
 	return error;
 }
 
-static int loop_set_block_size(struct loop_device *lo, blk_mode_t mode,
-			       struct block_device *bdev, unsigned long arg)
+static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 {
 	int err = 0;
 
-	/*
-	 * If we don't hold exclusive handle for the device, upgrade to it
-	 * here to avoid changing device under exclusive owner.
-	 */
-	if (!(mode & BLK_OPEN_EXCL)) {
-		err = bd_prepare_to_claim(bdev, loop_set_block_size, NULL);
-		if (err)
-			return err;
-	}
-
-	err = mutex_lock_killable(&lo->lo_mutex);
-	if (err)
-		goto abort_claim;
-
-	if (lo->lo_state != Lo_bound) {
-		err = -ENXIO;
-		goto unlock;
-	}
+	if (lo->lo_state != Lo_bound)
+		return -ENXIO;
 
 	err = blk_validate_block_size(arg);
 	if (err)
 		return err;
 
 	if (lo->lo_queue->limits.logical_block_size == arg)
-		goto unlock;
+		return 0;
 
 	sync_blockdev(lo->lo_device);
 	invalidate_bdev(lo->lo_device);
@@ -1513,11 +1496,6 @@ static int loop_set_block_size(struct lo
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
-unlock:
-	mutex_unlock(&lo->lo_mutex);
-abort_claim:
-	if (!(mode & BLK_OPEN_EXCL))
-		bd_abort_claiming(bdev, loop_set_block_size);
 	return err;
 }
 
@@ -1536,6 +1514,9 @@ static int lo_simple_ioctl(struct loop_d
 	case LOOP_SET_DIRECT_IO:
 		err = loop_set_dio(lo, arg);
 		break;
+	case LOOP_SET_BLOCK_SIZE:
+		err = loop_set_block_size(lo, arg);
+		break;
 	default:
 		err = -EINVAL;
 	}
@@ -1590,12 +1571,9 @@ static int lo_ioctl(struct block_device
 		break;
 	case LOOP_GET_STATUS64:
 		return loop_get_status64(lo, argp);
-	case LOOP_SET_BLOCK_SIZE:
-		if (!(mode & BLK_OPEN_WRITE) && !capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		return loop_set_block_size(lo, mode, bdev, arg);
 	case LOOP_SET_CAPACITY:
 	case LOOP_SET_DIRECT_IO:
+	case LOOP_SET_BLOCK_SIZE:
 		if (!(mode & BLK_OPEN_WRITE) && !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		fallthrough;


