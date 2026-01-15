Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0992F3C1974;
	Thu, 15 Jan 2026 17:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499901; cv=none; b=cjL1DVnOUFmCxv9Mq+PhQdK/8ftdQKXcGOgEDRdhx4j7e43CVV38mex/QuglR1AkHNaA0QQHNvEsK6jXjJlyp65qnH/blTAkGHV63FVPdwV3LTXVBOAPgZCNn0jBdI5Xey8e/Usau/WewJlF/J589bzDVJyG39uWn8f4FWeg/ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499901; c=relaxed/simple;
	bh=LcDShfZczrbTfo+q2E50CJjtzSDSdOoBPcm6spfDUFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4hTJqbCffdmMFvv386NZuOHOP/fMDmAU67sMIGKGYEe1ooqCJw/5aAtk0KcyoAkVOvXTBVLpm3/FhqAy3+8dCnNRFcervFumVP0psl7QdZYY9gY4kVoV21DTfEz4X7U+RZ0dPB5tehgOMNxD1H4L16buUK5sYo+ayYR83dSzGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqZcuG7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqZcuG7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC6BC116D0;
	Thu, 15 Jan 2026 17:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499900;
	bh=LcDShfZczrbTfo+q2E50CJjtzSDSdOoBPcm6spfDUFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqZcuG7nULMNq0YVMXskgiCytjMApppA1V3pZIR8EMAgHzu/5cZqkXieaOi9cdToJ
	 ZyklIbgrYfm9DY7LpMgSWt961PcBIG9fppgo8TuKj83fIZa5/ElnBF2cTZ9rMSV9eI
	 wPlcq2Ze6FWcvl7VPKgfEn8yOBGkWaHhd28pjkqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 389/451] media: samsung: exynos4-is: fix potential ABBA deadlock on init
Date: Thu, 15 Jan 2026 17:49:50 +0100
Message-ID: <20260115164245.002920535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1409,12 +1409,14 @@ static int subdev_notifier_complete(stru
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
 


