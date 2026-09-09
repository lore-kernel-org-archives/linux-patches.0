Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F69F56E064;
	Wed,  9 Sep 2026 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963254; cv=none; b=Dkm9Cv7tOA87JFq6mLlb2s/ciGq3C93jhvBuSL3N95VDYCdYrLl1hn5wuhGLVrxnOvpIgBakmV7UK5Nsufl0ScpRmuK0Ujcm0ArIcu5iQipVnSLst+rTCxBdEnP7dvbd+NH8NKp045wP6kKSp7T6O2mLYxTlisLL1XdrugNBVTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963254; c=relaxed/simple;
	bh=xSitbtCnNM9UghVaP/NEbq1eD/mMnu+x78jf2nxuCuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoPdJqt9FcXFIbPWFDKIQ9TLX4p+RdmakUXAoGqqMOIwUyWIwnjd1UOrusZxTZPYN9DM0lh8XqDBbvSaWsLqcrD0ScKqjyHIKdV6ZAvDZuvIsbS76LVkECVvPkDaN3JF8oGHgJBQQwJqEv6ttGS5U/kNwTkhpu8zvIGKP+2S+GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDiKgm7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDiKgm7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A501F00A3A;
	Wed,  9 Sep 2026 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963253;
	bh=oJt7PQeKDWC2rjL5M2dt3vUml1QtLygkwS5BqZsMesw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDiKgm7kC4x+sxuqTOfDXLt+YvCPMsvLiy5BVGXxvlyymz5O+oKYM0HPgwEcfT3zc
	 L2dLr1NadY6fYXKta3CuD/NmaKmPEXfFCiGM45F5rdDVoa87GdF+451dmIsnwkGgV0
	 3s3sciJMdlSQv6GL7l5QL8zPZJD1U76tW+ll4MP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 016/583] media: usbtv: keep device alive while ALSA card exists
Date: Wed,  9 Sep 2026 15:35:01 +0200
Message-ID: <20260909134238.366527375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit fc530fe168bb2b745a93f553ad21fc25fd9cba3d upstream.

The ALSA PCM callbacks store the driver state in pcm->private_data. An
open PCM file can outlive USB disconnect because usbtv_audio_free() uses
snd_card_free_when_closed(). The disconnect path can then drop the V4L2
device reference and free struct usbtv before ALSA releases the substream,
so a later close dereferences freed memory in snd_usbtv_pcm_close().

Take a V4L2 device reference for the ALSA card and drop it from the card
private_free callback. This keeps struct usbtv valid until ALSA has closed
the remaining files and freed the card.

Closes: https://lore.kernel.org/r/178144969601.60470.4852887710381872458@gmail.com
Fixes: 63ddf68de52e ("[media] usbtv: add audio support")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/usbtv/usbtv-audio.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -317,6 +317,13 @@ static const struct snd_pcm_ops snd_usbt
 	.pointer = snd_usbtv_pointer,
 };
 
+static void usbtv_audio_card_free(struct snd_card *card)
+{
+	struct usbtv *usbtv = card->private_data;
+
+	v4l2_device_put(&usbtv->v4l2_dev);
+}
+
 int usbtv_audio_init(struct usbtv *usbtv)
 {
 	int rv;
@@ -331,6 +338,10 @@ int usbtv_audio_init(struct usbtv *usbtv
 	if (rv < 0)
 		return rv;
 
+	v4l2_device_get(&usbtv->v4l2_dev);
+	card->private_data = usbtv;
+	card->private_free = usbtv_audio_card_free;
+
 	strscpy(card->driver, usbtv->dev->driver->name, sizeof(card->driver));
 	strscpy(card->shortname, "usbtv", sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),


