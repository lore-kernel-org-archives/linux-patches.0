Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982CD207658;
	Fri,  6 Dec 2024 15:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498582; cv=none; b=i2jCymfiLOVA6yu4b4WUQobZ1wHuAXlNLxAwxBe0VQr9Cd4rXd1NiQkTQPs3YvwVBU37qUi97sYTN1T6GYR7oTwVgqfkhbA0ZH0XN0IWGA12h+slznUxO/3yFTWwU0hyleLZ+iFk1ynJRoJQ25wXU/oVQi6BTz4ZJH0dbNtEG40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498582; c=relaxed/simple;
	bh=eksjMPd+6SRIcX4CLZf3Evl9TOVnIoZXzNMAlR6ZkCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9BRpt4iqv3sJwpBeWPni2ltmkPt2z/lf7H2oUtCqc6YTrqPzAEeA2ydaqh+U3uHiymG0vfJPgaGpfiPvUSy0cLv0hvvEUfCu8kKPoPVtxRL74Ev4WgPpEvtcN/rXUJd9n2XUAO7pH0EEcE77UoVU7xJvx1Vq+aEbCQCPQL7LZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAPz5Qmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAPz5Qmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97BFC4CED1;
	Fri,  6 Dec 2024 15:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498582;
	bh=eksjMPd+6SRIcX4CLZf3Evl9TOVnIoZXzNMAlR6ZkCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAPz5Qmp2Pl0oSw8S2trja6u3NYacVQ2/TDfodwpQIEW44oyZGo+WTvliTBZXGBgp
	 j4qYGog75dtREkLKN+bbfOa+3QKACTZZk0GkFJ/9Vci7kPZOKgS17ddnusnRHIHRVB
	 /q8JAy3vBPSW+qHUUx+qZNTxjPe1aXzLHjT9Ho9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 620/676] media: amphion: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Fri,  6 Dec 2024 15:37:19 +0100
Message-ID: <20241206143717.585571944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


