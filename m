Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB6E2F619D;
	Thu, 15 Jan 2026 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498611; cv=none; b=k4Dq35Na7S9h2axZwfMNBMuY3lBItfcelH8YnV75daU723BvLV34LWnEin2dkmd+d1pVMUpOsag1cRBAoREvot0GtFX4iuznxpiQXbUSa/fE+4Deq9+K+Aay1/ruZohphZa8qtQR4bzICIa/xy4k0Of9dkjCTXYECW++q6A3vkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498611; c=relaxed/simple;
	bh=jtasV+6Ydw2kkVmBbj1Uo3cIretycN7G1LQTNH0Bj0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjOYeMWYPtXyP9ymlYStErpkJyApRrwT3MTAKjnzEF4m7DmSX6q1vB10El435x5IuCMKuPpXbE30om0kZAGT4azNdWTWo4BWAQS8d/PMYiGD/1D+Fe1DDII9F9gY3KKmmBt02mZpCdPKIdSJHuDEyApJERT/5fl8/6HwH7busW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx5tPAK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx5tPAK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A3FC116D0;
	Thu, 15 Jan 2026 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498611;
	bh=jtasV+6Ydw2kkVmBbj1Uo3cIretycN7G1LQTNH0Bj0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx5tPAK7/BQ/VpK/4DRb4bOHkm/S8HasvWl4kKnSeDjvKkhxCVjVgRhQX8wR5akyx
	 58RfxbEsTwU8R4y2Q6Kn+Ox7ETS/QLtLzd1EFgf6A8+TYRHVtngknq/4mq8rYdWrzt
	 YjdCzq8Myd9Eu1/Qj+NnKLv6CEb4D6dopOAmtkN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 460/554] media: samsung: exynos4-is: fix potential ABBA deadlock on init
Date: Thu, 15 Jan 2026 17:48:46 +0100
Message-ID: <20260115164302.930516093@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 17dc8ccd6dd5ffe30aa9b0d36e2af1389344ce2b ]

v4l2_device_register_subdev_nodes() must called without taking
media_dev->graph_mutex to avoid potential AB-BA deadlock on further
subdevice driver initialization.

Fixes: fa91f1056f17 ("[media] exynos4-is: Add support for asynchronous subdevices registration")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/exynos4-is/media-dev.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1411,12 +1411,14 @@ static int subdev_notifier_complete(stru
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
 	ret = fimc_md_create_links(fmd);
-	if (ret < 0)
-		goto unlock;
+	if (ret < 0) {
+		mutex_unlock(&fmd->media_dev.graph_mutex);
+		return ret;
+	}
 
-	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
-unlock:
 	mutex_unlock(&fmd->media_dev.graph_mutex);
+
+	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 	if (ret < 0)
 		return ret;
 


