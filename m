Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5497637FF60;
	Sat, 12 Sep 2026 11:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213813; cv=none; b=aNcZ41RGpif81jUZp3ax01bqyg/+SBA0lpBCSFVbV9+EkQnOx/GTgv/GWjXJFy/KNBHnHML6S0eWPsICn5d0kkHmGeyV9DHw3sbNBZ6hLFwSY3r01Utx2xD7u+bqV9TFCdV4zRIAprqHi7uDYlBT4OxrJkdQ2P+Y6GQW6TQrPQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213813; c=relaxed/simple;
	bh=lSQ/WL9AMSDJX1ObjWYIC67iPDkOjSN9kwqZkUzAlfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqJovIGZys8/zgQzKR6ZVMkHXtpCdv5lk6QT+9LG7X6Q3OcuKE6Fkcmfaj8MLjgFtHZ2ND69Sgam0l+CvMgnhkY3JtPVYmkh3bErJi8Q6+bv1UXnxTBUGhJ/N1ht9dvHKemVGIzxeTjTrZMAQXt9ysVjrVHlDFGkGbuqwb8Xwfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0s4sjAWm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0s4sjAWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E976D1F000FF;
	Sat, 12 Sep 2026 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213812;
	bh=HHrZIVfRgZO91MYsAv+UQ8uLI9sakkYYcQ3f6Z6juSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0s4sjAWm/2MCxEZMfOFZNMKCwD8UExQcS8bjhrXSaX8rgN02d8gPotpcLUsgdldDd
	 aGS7wIyHjbQnIKvdQtXy9vmmc5GEyjTMZYmIhrxekn88ee1cdRKg4Itwj0V8ME1ZMc
	 Q8WmazUv6hnNJsxePzzJreGb9wWMUK3gFCKuszxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0199/1376] media: platform: mtk-mdp3: Fix SCP device refcounting
Date: Sat, 12 Sep 2026 08:43:45 +0200
Message-ID: <20260912065611.984994140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 55793e4665b7f15151e6f5ab51ca980e73abed5d upstream.

mdp_probe() first tries to get the SCP handle with scp_get(). When that
fails, it falls back to looking up the SCP platform device with
__get_pdev_by_id() and then reads its driver data.

The fallback lookup returns the platform device with a reference, just
like scp_get() does. However, the fallback path currently drops that
reference immediately after platform_get_drvdata(). The driver later
still calls scp_put(mdp->scp) unconditionally from the probe error path
and from mdp_video_device_release(), which drops the SCP device
reference again.

Keep the fallback reference until the existing scp_put() call, so that
the fallback path follows the same ownership rules as the scp_get()
path.

Fixes: 8f6f3aa21517 ("media: platform: mtk-mdp3: fix device leaks at probe")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-core.c
@@ -311,7 +311,6 @@ static int mdp_probe(struct platform_dev
 			goto err_destroy_clock_wq;
 		}
 		mdp->scp = platform_get_drvdata(mm_pdev);
-		put_device(&mm_pdev->dev);
 	}
 
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);


