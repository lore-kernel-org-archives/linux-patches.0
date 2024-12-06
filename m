Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89631494D9;
	Fri,  6 Dec 2024 14:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496034; cv=none; b=IG0uIRhqLhNaCf+rjSKCw+VbNJXMVw4ya9T3lNpqanrAagRcqMHoZfpqMoazHW0WJ3ef5V/dimklV4oPHq1d/So+aJk1Q5MutQCK4l7npUjA6tkPKR/IkpJzgOgxaqOCzQrZtNCDraSyZ4XOBQfhyR+iY0vtPQ1gMk+HqnKHfmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496034; c=relaxed/simple;
	bh=1D+cGQq5Tp+8T9SHa+soV+WIh0MquZxJ+D0yrE3VXWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJiW2Q0+SijCQft7Z37UlyvdRlw15TCN14n3kCjGpYGPdD+CN4u/Wn0jhohS15GpRXK2bLMCd8RGLidQ3z5ec3HC9bUKz63COz0ZyHOOVOtShrjXfCgm32uTrAjeneyFTEhhdLKg2puzf3JCcRhQoqVag56TKt3EErZBYi9ygfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iai95OtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iai95OtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24674C4CEDC;
	Fri,  6 Dec 2024 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496034;
	bh=1D+cGQq5Tp+8T9SHa+soV+WIh0MquZxJ+D0yrE3VXWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iai95OtAoHpC7LMQ19C6264OMqz/8/bjNaFT4Rki/dT/hz7hxrRv5ksF8xEcJ/g+H
	 mWkvUBfuUj6NhxTK+MDijeQiGhNS8MJbYEESPCvX4x9Je9WZPDMxlOGci0MK+x7T6v
	 1wV4Bb72q3bHWf/XfTR7lBHUjnbcWcEmF6avK7gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 033/146] media: amphion: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Fri,  6 Dec 2024 15:36:04 +0100
Message-ID: <20241206143528.939621658@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 316e74500d1c6589cba28cebe2864a0bceeb2396 upstream.

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Cc: stable@vger.kernel.org
Fixes: b50a64fc54af ("media: amphion: add amphion vpu device driver")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/amphion/vpu_drv.c
+++ b/drivers/media/platform/amphion/vpu_drv.c
@@ -151,8 +151,8 @@ err_add_decoder:
 	media_device_cleanup(&vpu->mdev);
 	v4l2_device_unregister(&vpu->v4l2_dev);
 err_vpu_deinit:
-	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
 
 	return ret;
 }


