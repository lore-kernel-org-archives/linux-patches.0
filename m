Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165E833D511;
	Fri,  9 Jan 2026 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962770; cv=none; b=o8DPdhDzx66tQv6s029sJ452zOxhbjIhSAulZcyHrqFeR7fqXYHlOuDZsQr9LUMKXJkYH/upV2j44Q5F0v8GQFBUIhv6pFxuuhlR/98uKvD/JeK/WNW/v9ksBirWXzMRw+5diSXnzbQ3w78QB8m7+pnMPYTX05sNvyn0TrqmD/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962770; c=relaxed/simple;
	bh=7ghR4DZK3outQrA0XTzedylPrOEjehalLXmrQF2NwBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV/Jcm7ZoPJeq3LLmKlE74Rcb6HPEnlftAws4BAP/OA+PpTXAeb0c3GWouDYDgWOKckp1s41m6lNhC837r4jwxL5ZMJIH8brKls2VriC0cMALBCoRGSJVGKi/UHozdaB+pPSuOsHt3PgqQuLJKVyf4TRIMAGRY/WTeJXtR005fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGIVxDvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGIVxDvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6EBC4CEF1;
	Fri,  9 Jan 2026 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962770;
	bh=7ghR4DZK3outQrA0XTzedylPrOEjehalLXmrQF2NwBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGIVxDvYryTle49gQzzQyQl9uQGRIH8JyEhXP3Fj3gFq12g95rFvL9lyTI260egra
	 qKPhooHYYKKXJZW6J4yRkBYShJx/w8TM1t4QZPGijYlsACKMzsECWtTw8k4tozVBi7
	 RDaJNYNqF4F+KpHHe0bCSublsJBNYnIuvUyf5URY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 481/634] media: samsung: exynos4-is: fix potential ABBA deadlock on init
Date: Fri,  9 Jan 2026 12:42:39 +0100
Message-ID: <20260109112135.646306043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 17dc8ccd6dd5ffe30aa9b0d36e2af1389344ce2b upstream.

v4l2_device_register_subdev_nodes() must called without taking
media_dev->graph_mutex to avoid potential AB-BA deadlock on further
subdevice driver initialization.

Fixes: fa91f1056f17 ("[media] exynos4-is: Add support for asynchronous subdevices registration")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/samsung/exynos4-is/media-dev.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/samsung/exynos4-is/media-dev.c
+++ b/drivers/media/platform/samsung/exynos4-is/media-dev.c
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
 


