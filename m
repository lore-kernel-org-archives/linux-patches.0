Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308E136B048;
	Tue,  6 Jan 2026 17:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722147; cv=none; b=a060+mN9Oy1J+BKawxp3OfY8I2C19z6M6Edbc02R4oH6Ka8bZXr3N5atje+irRt88SBsPlUvJ7VmLaI/tCDKUAIzOIca35lwNjumb/GAak5mf22GBUPd2umc6rKTuFE24dMdOs6cBOsUaV+2Xe7ff0pmcnvCWOk4RyczvIqmYo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722147; c=relaxed/simple;
	bh=KtaKvMJt/WmOPxuEwiChmZpsw3MFLaF15YXm3yA6bdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrsttPf3FF64PPj7me2fb+Te3Rfe0DHCuvA61hqQVnAD9m+pSBH3FTZEhjtuECac30riZ7qBe91ZwqGTTSwhleD9c57OKnDczwH2q40uyKkX3HpB2qgeRZ37j7Xa9DGJJCG6jTw686IohedSLR8zwECNjQlagsVraGGoNYmT4E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8UcF45H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8UcF45H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E68C116C6;
	Tue,  6 Jan 2026 17:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722147;
	bh=KtaKvMJt/WmOPxuEwiChmZpsw3MFLaF15YXm3yA6bdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8UcF45HtPz5FYpJc33EspUkoSf5UtaXVwXYkh6moRbuQBniNuiBnDP/xkL+Vj3SY
	 IF2Z87sE94ZRZ29ayULV2HIHYGy5spwaGsM7bs89hDIha4tySr2/do05MnwgQOqclB
	 60YwmBScwYUDO9pgwYIPlVjjyOYiBAT1c8Ss2iJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 179/312] media: samsung: exynos4-is: fix potential ABBA deadlock on init
Date: Tue,  6 Jan 2026 18:04:13 +0100
Message-ID: <20260106170554.307987556@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1399,12 +1399,14 @@ static int subdev_notifier_complete(stru
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
 


