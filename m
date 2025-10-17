Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AE13396E8;
	Fri, 17 Oct 2025 15:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714527; cv=none; b=VHrUTSlIr59X1g/1gX+fnnVMiHp9DTrztY48TbQB86WZ4eCah9zKNL+pLx0z05TeSOA0QNBpV4lZ3Yq5cAdVljS+HrzhpjsdnW2i6W3DM55PBl8hiCAs/HsBynQiY9zSFbfcazTb0OK2+hPkS0699qiqqaqL+Ge0A4GXlYp3z+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714527; c=relaxed/simple;
	bh=tZInMRBJBjLyoRGMDVgQM3ty363qysNFysZG+smmZMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2/rjzLrDE+x6G79TMO0DR0829ob+HcB6TPVO43qO4p/Xb9K5/OcAJlnTAMXwLGoL2HjH20JKEOkqUeFwrb8tIeRtpwn83/BIL31WZ55XvIVZ5kSWkdUOStd58fwTZHVCYL3iJYd6ZMUIhiKFvUpN/dZ2KMK5lhW1L5VusRMU2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNX7h3Ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNX7h3Ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543B2C4CEE7;
	Fri, 17 Oct 2025 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714527;
	bh=tZInMRBJBjLyoRGMDVgQM3ty363qysNFysZG+smmZMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNX7h3Ct8GZE95YG0nN2ZTiLFBat/I+Fl3wimsXk4l3vcAewYx0z8jZ1t4xzPbtqe
	 sGDfRUNzJkAwzQyAdunNIeukS/h6TtbTiO3kANTtRhk6s/Bi4Ee2XbnTQ6IJ0NjhL+
	 QyjzRQSdCdXXuYXkAEVG8IY5j9tlm7pCJK4Xm5NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 143/277] iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume
Date: Fri, 17 Oct 2025 16:52:30 +0200
Message-ID: <20251017145152.345542526@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sean Nyekjaer <sean@geanix.com>

commit a95a0b4e471a6d8860f40c6ac8f1cad9dde3189a upstream.

Remove unnecessary calls to pm_runtime_disable(), pm_runtime_set_active(),
and pm_runtime_enable() from the resume path. These operations are not
required here and can interfere with proper pm_runtime state handling,
especially when resuming from a pm_runtime suspended state.

Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250901-icm42pmreg-v3-2-ef1336246960@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -847,10 +847,6 @@ static int inv_icm42600_resume(struct de
 	if (ret)
 		goto out_unlock;
 
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
 	/* restore sensors state */
 	ret = inv_icm42600_set_pwr_mgmt0(st, st->suspended.gyro,
 					 st->suspended.accel,


