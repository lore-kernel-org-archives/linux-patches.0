Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC422561D7;
	Tue, 25 Mar 2025 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905951; cv=none; b=KoM+5VOVDhxBOEo9AaasaNVKf/LltIJZDIGQLSptCQXicwcrk5IdnosSxe9L6oDSdkUdTjstgXYR8a/vUWRdAh/E1ObRlrAtt8myYmFNhaM9iJEqFA9XfGUaB26R6HVOXMbyIFqy0kz2OfPVlIe/UEkx+q/O692+h515twG72T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905951; c=relaxed/simple;
	bh=cmAbjMFFO3seCksdoV/ifutfeMBri8ImotBEoLez4sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9kYm05PqFcciTSsmZaYjTTOM9tpELJFKnc/GC2IwOSzkWLdvv4qLsdkJqisdBgXbzLtwhCsuAbR6x/HEgCDR95YA35JQU/Zue0xms4AkYxG69ve7LyvuMaXwpFr/wGqMofVC7vR45LMpDqLvXiPjoCRQHIC9U9bS60z99NLnng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jNMI8Jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jNMI8Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0CAC4CEE4;
	Tue, 25 Mar 2025 12:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905951;
	bh=cmAbjMFFO3seCksdoV/ifutfeMBri8ImotBEoLez4sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jNMI8Jz0chbVZCwdKVij1kWfpJXyjrFbcXfuQeRyvX8hjRGFNVEs0zDVIzDV3/v/
	 ZfJSSYcaXIOWu14GRJVbRKorSVKIcrsIgXLvxYuKFtXlty3PeraoOR5BKqilyGdH16
	 t+IzqFmCibqzTM5ZETf9TAS8FRNeKO8PD75byVic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Marsh <arthur.marsh@internode.on.net>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 052/119] media: rtl2832_sdr: assign vb2 lock before vb2_queue_init
Date: Tue, 25 Mar 2025 08:21:50 -0400
Message-ID: <20250325122150.385536556@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit d9e7c172a7f247f7ef0b151fa8c8f044b6a2a070 upstream.

Commit c780d01cf1a6 ("media: vb2: vb2_core_queue_init(): sanity check lock
and wait_prepare/finish") added a sanity check to ensure that if there are
no wait_prepare/finish callbacks set by the driver, then the vb2_queue lock
must be set, since otherwise the vb2 core cannot do correct locking.

The rtl2832_sdr.c triggered this warning: it turns out that while the
driver does set this lock, it sets it too late. So move it up to before
the vb2_queue_init() call.

Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Closes: https://lore.kernel.org/linux-media/20241211042355.8479-1-user@am64/
Fixes: 8fcd2795d22a ("media: rtl2832_sdr: drop vb2_ops_wait_prepare/finish")
Cc: stable@vger.kernel.org
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1363,6 +1363,7 @@ static int rtl2832_sdr_probe(struct plat
 	dev->vb_queue.ops = &rtl2832_sdr_vb2_ops;
 	dev->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	dev->vb_queue.lock = &dev->vb_queue_lock;
 	ret = vb2_queue_init(&dev->vb_queue);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not initialize vb2 queue\n");
@@ -1421,7 +1422,6 @@ static int rtl2832_sdr_probe(struct plat
 	/* Init video_device structure */
 	dev->vdev = rtl2832_sdr_template;
 	dev->vdev.queue = &dev->vb_queue;
-	dev->vdev.queue->lock = &dev->vb_queue_lock;
 	video_set_drvdata(&dev->vdev, dev);
 
 	/* Register the v4l2_device structure */


