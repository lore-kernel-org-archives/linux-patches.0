Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FC84DA14;
	Wed,  3 Jul 2024 11:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004542; cv=none; b=j0pb/gL0phOC+J1TQh23vDDWRg4gLmwnNExu3iX63kjojzgvDVrLavZzJQAaMPagaMz5tYGVMfET0fBmxb9yUKOckX07O5i1pkytCS2j5Fryx2VQjy8uNwrdbfoY6FGuxM5gweEw7MXyqNV/gKV/rlkRnFzCaRxI9L800JooDPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004542; c=relaxed/simple;
	bh=reLPntVk8Q58aXbUtdNuMqxUD9nuGH6aJFRI+dKXSAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwZior4PWsuJAmG3kgcceDczreYHOgpadrDqOoTbI7MrLS017pJRsOOrI5wZwLv4f0HF5kG7L3NII/BS+CGoauTCdA7DrzqGDRBAFp0beoytHplrdY0izOqUTfYuin9LRrNC33Y21mwcovOW0xP65WwnPZWjfEW+b3W1UPORVtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBDOPtBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBDOPtBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482FAC2BD10;
	Wed,  3 Jul 2024 11:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004542;
	bh=reLPntVk8Q58aXbUtdNuMqxUD9nuGH6aJFRI+dKXSAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBDOPtBL7AmtbACzwY10NAnn8gKrCT8+lK/qgaBRb1SbN1SO3tBwX4oHTw5C+yt7w
	 /QzhHDyXXaA9TCs9Yfst0De51C/zQMNWxzP4UsLNArS9e4u4MiSgXa4ElGj/T3QFNw
	 me81IdMXE8UL6mqDEkxatOKTS0q8+HyRH2euTgy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 076/290] iio: imu: inv_icm42600: delete unneeded update watermark call
Date: Wed,  3 Jul 2024 12:37:37 +0200
Message-ID: <20240703102907.068011434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 245f3b149e6cc3ac6ee612cdb7042263bfc9e73c upstream.

Update watermark will be done inside the hwfifo_set_watermark callback
just after the update_scan_mode. It is useless to do it here.

Fixes: 7f85e42a6c54 ("iio: imu: inv_icm42600: add buffer support in iio devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240527210008.612932-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c |    4 ----
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  |    4 ----
 2 files changed, 8 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -128,10 +128,6 @@ static int inv_icm42600_accel_update_sca
 	/* update data FIFO write */
 	inv_icm42600_timestamp_apply_odr(ts, 0, 0, 0);
 	ret = inv_icm42600_buffer_set_fifo_en(st, fifo_en | st->fifo.en);
-	if (ret)
-		goto out_unlock;
-
-	ret = inv_icm42600_buffer_update_watermark(st);
 
 out_unlock:
 	mutex_unlock(&st->lock);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -128,10 +128,6 @@ static int inv_icm42600_gyro_update_scan
 	/* update data FIFO write */
 	inv_icm42600_timestamp_apply_odr(ts, 0, 0, 0);
 	ret = inv_icm42600_buffer_set_fifo_en(st, fifo_en | st->fifo.en);
-	if (ret)
-		goto out_unlock;
-
-	ret = inv_icm42600_buffer_update_watermark(st);
 
 out_unlock:
 	mutex_unlock(&st->lock);


