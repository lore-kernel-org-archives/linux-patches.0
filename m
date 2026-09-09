Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D0D563FB0;
	Wed,  9 Sep 2026 14:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962687; cv=none; b=i6gxRO2mhkfX2OPICXSYlC1KEr7jKGQ3UZy7g/NT3yGcWuyDNy5uN6fGSxAfzhWugDWXWQVUGWu8Tm3TfbOIfZ9wY/5J3+czeOhNnqT96Q5h2rWYpn0J2smnumgB2/CVZ9zvDdQpACINny91i5qqeO6A2lOgrCDBHlrXIxdkKw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962687; c=relaxed/simple;
	bh=9jeS6p7S9BEKhS2miu0YUwJcoak/TsY/DxYJYBtzEsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coH++IEQlt5SnezChwZW86ue0pOuon53HcEBBPT3PgfsKvxT6AgOsG/V7Evzge9yzvTW1TSan1rjgtYrd8+utEuiV94xCaluLMenesOrM00cBqJL94ZGBRjtZHZuCPujSaEV8/Q1Csi5BOr1rbFC21bj362fPUN/B3fcJ7h+DbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Moq3zdms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Moq3zdms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B6A1F00AC4;
	Wed,  9 Sep 2026 14:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962685;
	bh=mnk7LRVypewTeDOE0ZElnL5m9zTfBxBeNfO7F+mHuhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Moq3zdmsxeJWdrRHnqInWwhLCKMSFDXWnYEDJckZODMNELE4t2U2M82ppC2JErKfk
	 fkLElPeIZEQq7Ctr6Y/rDMuvKOWEQF6XeDR/OGTlNy9qI7zHPrfSFYGiKb9+CTPvGc
	 nBRcbw48I6HY02Ap3pDsKpOhzJI5t51HiLAWjjs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 375/556] media: platform: mtk-mdp3: Fix SCP device refcounting
Date: Wed,  9 Sep 2026 15:40:55 +0200
Message-ID: <20260909134243.884854697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,7 +294,6 @@ static int mdp_probe(struct platform_dev
 			goto err_destroy_clock_wq;
 		}
 		mdp->scp = platform_get_drvdata(mm_pdev);
-		put_device(&mm_pdev->dev);
 	}
 
 	mdp->rproc_handle = scp_get_rproc(mdp->scp);


