Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A71A46AA7C;
	Tue, 21 Jul 2026 15:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648016; cv=none; b=ezI8LJIYLsdiepYDFa+vguCFsF6BjfUDv/00Gp4ZZWZ6JtuKtfgX03D/oeVUQtwEarSvrEg70v9SAQXDsZDNMI7RL8Ja6qvIHV+mtdXE4r6Smt+7FOogVuKAft439L3zBFv7tcnRtG3OgIo84x8Z2kh7CnvtFWIHyZ3mISHpdcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648016; c=relaxed/simple;
	bh=YZyYvOsXGnktPM9V9zV7ECN+DXshruh/jQvnIVafbiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQsmO71M+3xPHjnFzLgBuOc5UvtG4mqHyp2BcWfUeycF/60jHazXFDhhK0i2Lq1bO/auNRwEtievIlPBHxMBiwV7IVSy1WvLfZLhv5raRctFs1XRuiB86jBKfRNgJRSaLeVZyxSHmnUTA8wbvsYy0musEVo4yKbkDJ7/7CRyjas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cX2XJkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cX2XJkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F821F00A3A;
	Tue, 21 Jul 2026 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648015;
	bh=AUe4NLvRCayVc9ZNZnbE2k3g0CeIOoLDR/kI9Re8b30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1cX2XJkA2ZtHC92Ijo8RCtqc9S8+f9QrbACZnLEnYEFUk+7ZgDD5zEAywMSeJT4ax
	 5wufv+GouxTOs40BzGPxvSIMt+va4/ASDZZIvlHTicLoBuO955Y/aDq11wBDPwEkbG
	 pIZLYdeg+WrTG80Gzx1yq/dnTiePgjlWzrzpb3vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 0012/2077] media: uvcvideo: Fix dev_sof filtering in hw timestamp
Date: Tue, 21 Jul 2026 16:54:45 +0200
Message-ID: <20260721152552.953693298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit edc1917599c5339aedc83135cade66517e0a2972 upstream.

To avoid filling the clock circular buffer with duplicated data we only
add it if the new value sof is different than the last added sof.

The issue is that we compare the unprocess sof with the processed sof.
If there is a sof_offset, or UVC_QUIRK_INVALID_DEVICE_SOF is enabled,
the comparison will not work as expected.

This patch moves the comparison to the right place.

Fixes: 141270bd95d4 ("media: uvcvideo: Refactor clock circular buffer")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Tested-by: Yunke Cao <yunkec@google.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260513-uvc-hwtimestamp-v3-1-7a64838b0b02@chromium.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -583,16 +583,7 @@ uvc_video_clock_decode(struct uvc_stream
 	if (!has_scr)
 		return;
 
-	/*
-	 * To limit the amount of data, drop SCRs with an SOF identical to the
-	 * previous one. This filtering is also needed to support UVC 1.5, where
-	 * all the data packets of the same frame contains the same SOF. In that
-	 * case only the first one will match the host_sof.
-	 */
 	sample.dev_sof = get_unaligned_le16(&data[header_size - 2]);
-	if (sample.dev_sof == stream->clock.last_sof)
-		return;
-
 	sample.dev_stc = get_unaligned_le32(&data[header_size - 6]);
 
 	/*
@@ -664,6 +655,16 @@ uvc_video_clock_decode(struct uvc_stream
 	}
 
 	sample.dev_sof = (sample.dev_sof + stream->clock.sof_offset) & 2047;
+
+	/*
+	 * To limit the amount of data, drop SCRs with an SOF identical to the
+	 * previous one. This filtering is also needed to support UVC 1.5, where
+	 * all the data packets of the same frame contains the same SOF. In that
+	 * case only the first one will match the host_sof.
+	 */
+	if (sample.dev_sof == stream->clock.last_sof)
+		return;
+
 	uvc_video_clock_add_sample(&stream->clock, &sample);
 	stream->clock.last_sof = sample.dev_sof;
 }


