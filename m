Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F08143C6E;
	Wed,  3 Jul 2024 11:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005632; cv=none; b=M+FgadybYryUJqk9mEGLMWuj0ghryVVEhXHTay2URrYd60/t+5GrbK3oecoay6gKTW24dqAhxFpPrqdIMLha5hKvjunb1aTRsRXqT8LOVRoNazZlTcnM9cvkXvkmalCSA5o57VtkqTk6NLbcBila82QnO+5eVkHIRRNB0kW+6XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005632; c=relaxed/simple;
	bh=DV8iUdKTOUS9t2cmkez1nV9y6hhFsaOlyvYfscComl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIytpZNL0m/4gRmtgzhCh7JnoKmYXsG9snVVYDp6Zwiqrud1Iy/Rdzwjelinxz35oBAbmRNXZQ3Ogmszej1fVehPe8FxUXhpiPpcbToL4iS06I+NdArU8H9lkMJbnzpcZDq9O8MuCRQmgjcXZ0JzQ1CakyZ1PJt7lTrQ3JOJycY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pz3VAgld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pz3VAgld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFEDC2BD10;
	Wed,  3 Jul 2024 11:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005632;
	bh=DV8iUdKTOUS9t2cmkez1nV9y6hhFsaOlyvYfscComl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pz3VAgldeXWU9nHRUN24CQZ+tkeDK+H295bDJ+WtqFEz3paf5F9wVP6Itfn/lSsYY
	 Nxn49ltNHdeLeriEpGivlNdYBE7gmx33MyiZlO02fhsiKYQpEIMf+i0hrS5RQjOj9+
	 S7zVjso9DMvhxG9BJUkvdH3WEa8slFB9IFgCudfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 113/356] iio: imu: inv_icm42600: delete unneeded update watermark call
Date: Wed,  3 Jul 2024 12:37:29 +0200
Message-ID: <20240703102917.372933247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


