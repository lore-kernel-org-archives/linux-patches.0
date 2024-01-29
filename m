Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FEC6FE01;
	Mon, 29 Jan 2024 17:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548486; cv=none; b=GHFvIXRpWzMEPnga7oFVQrzL1+uWBAXMpSlZGDt7Ee/uRHFtGgsu6Z/jOcwjNtyUI5Yx8ZJLg1HsSpbdyZ4IWNjxMPaozrqxu4dNJF3M6k/Dkaa9mq83se2fOjpBikEYP8CKp4HgXrekRX/VcN9BmscMI+G7SRSSfEvoJ49JA7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548486; c=relaxed/simple;
	bh=qK8gZYjUjNvg0qSItyJnL9eOmJpQK0cEsgq5wnjiozA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4d3EPIoxDyuFx/sXUPsZVkopXpIK+teThj7J7MsgSbSsGq0qxKQERtRKAen/G+2brh2OkdJjomVsTBE4uwNMnqgqWvQi9VxJ2wtMRdy9QcuGKx1EWtRvRdtsX+dUdis3AB5ylQIG2EhVJd6tJmn/1ITowwZaoHVxzAj23lu4l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXx9FAWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXx9FAWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F288C43390;
	Mon, 29 Jan 2024 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548486;
	bh=qK8gZYjUjNvg0qSItyJnL9eOmJpQK0cEsgq5wnjiozA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXx9FAWsukvOwe6Fy1RWoJ1EFE7jKMp8uA7ZHvayzx7qyn3Of0NwdP0Z4rRE6ELBT
	 qYAwUYUAw1Uuy6Eku96qEyLBTt4i0srh1lc0xGWheRXTCdpwk8vl5fEHZb1SJEUdbN
	 fu3555Z/nhHpCguw463j+Xgf9rvfWAhiR3cBw2Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.6 108/331] media: mtk-jpeg: Fix use after free bug due to error path handling in mtk_jpeg_dec_device_run
Date: Mon, 29 Jan 2024 09:02:52 -0800
Message-ID: <20240129170018.089384719@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Zheng Wang <zyytlz.wz@163.com>

commit 206c857dd17d4d026de85866f1b5f0969f2a109e upstream.

In mtk_jpeg_probe, &jpeg->job_timeout_work is bound with
mtk_jpeg_job_timeout_work.

In mtk_jpeg_dec_device_run, if error happens in
mtk_jpeg_set_dec_dst, it will finally start the worker while
mark the job as finished by invoking v4l2_m2m_job_finish.

There are two methods to trigger the bug. If we remove the
module, it which will call mtk_jpeg_remove to make cleanup.
The possible sequence is as follows, which will cause a
use-after-free bug.

CPU0                  CPU1
mtk_jpeg_dec_...    |
  start worker	    |
                    |mtk_jpeg_job_timeout_work
mtk_jpeg_remove     |
  v4l2_m2m_release  |
    kfree(m2m_dev); |
                    |
                    | v4l2_m2m_get_curr_priv
                    |   m2m_dev->curr_ctx //use

If we close the file descriptor, which will call mtk_jpeg_release,
it will have a similar sequence.

Fix this bug by starting timeout worker only if started jpegdec worker
successfully. Then v4l2_m2m_job_finish will only be called in
either mtk_jpeg_job_timeout_work or mtk_jpeg_dec_device_run.

Fixes: b2f0d2724ba4 ("[media] vcodec: mediatek: Add Mediatek JPEG Decoder Driver")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1021,13 +1021,13 @@ static void mtk_jpeg_dec_device_run(void
 	if (ret < 0)
 		goto dec_end;
 
-	schedule_delayed_work(&jpeg->job_timeout_work,
-			      msecs_to_jiffies(MTK_JPEG_HW_TIMEOUT_MSEC));
-
 	mtk_jpeg_set_dec_src(ctx, &src_buf->vb2_buf, &bs);
 	if (mtk_jpeg_set_dec_dst(ctx, &jpeg_src_buf->dec_param, &dst_buf->vb2_buf, &fb))
 		goto dec_end;
 
+	schedule_delayed_work(&jpeg->job_timeout_work,
+			      msecs_to_jiffies(MTK_JPEG_HW_TIMEOUT_MSEC));
+
 	spin_lock_irqsave(&jpeg->hw_lock, flags);
 	mtk_jpeg_dec_reset(jpeg->reg_base);
 	mtk_jpeg_dec_set_config(jpeg->reg_base,


