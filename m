Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B0C35A943;
	Fri,  9 Jan 2026 12:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960962; cv=none; b=dCyMVtc7cQjoR28ccCA8Q40XUqx86VTbH94HiksTQJLPlMThTllpjzNu84x/zDCNkI3uKDSLAcUJbpQ+Ck89LpelpHBBz8Vt4klQkubP+Wdm4sn78QPi/uGVpO5WSWYuRy+edIQipTuOg2nW2cpkSXgdD4BqfUJPxG4LpM51+mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960962; c=relaxed/simple;
	bh=AUfv/vEzyArlrLNKjsZNe23KkmMbnxEQ/5eca/SLxps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDbKHSwfVW4Vzo4Yfwlcw9JNWN/F5uy3jaIVL4y3uyEqDSXytna35Gq+HwzVRme66QQGM7xsE8CcT5VDkb9ThxvGPqaOOoPRcy5dfDJCVYe/X4sZIxkcrT5Hqz+0+bD1T7eHOlsGU6BYrFOYSD3m3eVw3RwFRc9IXOu898p5JTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTP/2FB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTP/2FB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C27C4CEF1;
	Fri,  9 Jan 2026 12:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960962;
	bh=AUfv/vEzyArlrLNKjsZNe23KkmMbnxEQ/5eca/SLxps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTP/2FB2zFlb7rTudYtPya4BuLz+4PKN80jbNhdz3lcmigjw5hVCUS9evUqNw+n9f
	 8pDbBBz5HF/UQnMDKSiS/hCSMWaF7vM9i9fMa2OUKh3CQe5TsANA2izr4mYoRNbjAq
	 6ThNb5tuDtZUYc/w7/BA4yO3aqmr/yh9cpuWShGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 586/737] media: samsung: exynos4-is: fix potential ABBA deadlock on init
Date: Fri,  9 Jan 2026 12:42:05 +0100
Message-ID: <20260109112156.044544255@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1410,12 +1410,14 @@ static int subdev_notifier_complete(stru
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
 


