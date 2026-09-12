Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0312D0C94;
	Sat, 12 Sep 2026 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237721; cv=none; b=Ko2Mv/R4e72HPB/XyRLEV50i3x+X2AO/SFfl9AdARwy/d93RRXedMSMqpL8DDTevoAl3CbDbQXUUpGthjOmuXWqhzgVAOorofKv8OEdqXvV/I+p5D3h/JoiIUC1SNEn/5KC4ccMI8L6cbXCHjox8hJp/F3SNtilIwnrV4WMy2VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237721; c=relaxed/simple;
	bh=Gxic1ZQlsmibqJyH78Onmwy1vBm9fM/r2moeFVaxM+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M18PLXMWHWjxqz9YG/oUm4WT1vyVVZguWV1+gK3mIP08Ty23Af6ZQX1PRlSuccmmjE96iFRj3WFLShMJnQxcisyKMd71d4dycmQa9noWZBYAox3/826PXT77jC2LqgxPcOMi6kkhx8xGa50saHxNtn32OLnPPMs9SGZ8azJOia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q11Hncsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q11Hncsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5594E1F000FF;
	Sat, 12 Sep 2026 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237720;
	bh=sM33+Mp6WQHPIsIMYRy56KB9NbnfHDdMMsBu6eFAO0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q11Hncsmj0U34wEXinKd2jf0rrbwWPSnpXgt7+X355wOnaoj45SMoDv4bv5s7eTvN
	 QVENG32oihtru2KhxVclYQVW45UpM/f4RVTnn97fljdonVWmbr11KZkSnrqz7a5pcu
	 Sj111Ixwr0qECo3D3iPsvrZFmMTpUwYNMyFhkEc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 317/935] media: go7007: defer the ALSA v4l2 put until card release
Date: Sat, 12 Sep 2026 08:55:47 +0200
Message-ID: <20260912065534.077022775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 1bd456afeb8a515137e567967069fce6f8fcd23e upstream.

go7007_snd_init() already takes a v4l2_device reference for the ALSA
side, but go7007_snd_remove() drops it immediately after calling
snd_card_free_when_closed().

That is too early when a userspace process still has the capture PCM open.
The ALSA card and its PCM callbacks remain alive until the last file is
closed, so the release path can still reach struct go7007 through
pcm->private_data and call go7007_snd_hw_free() after the V4L2 release path
has freed the object.

Move the matching v4l2_device_put() to the ALSA card private_free callback
so the existing ALSA reference covers the whole deferred card lifetime.

Closes: https://lore.kernel.org/r/178144969601.60470.6005237146425573205@gmail.com
Fixes: d5d3a7cc127d ("[media] go7007: fix unregister/disconnect handling")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/go7007/snd-go7007.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -195,6 +195,13 @@ static struct snd_device_ops go7007_snd_
 	.dev_free	= go7007_snd_free,
 };
 
+static void go7007_snd_card_free(struct snd_card *card)
+{
+	struct go7007 *go = card->private_data;
+
+	v4l2_device_put(&go->v4l2_dev);
+}
+
 int go7007_snd_init(struct go7007 *go)
 {
 	static int dev;
@@ -245,6 +252,8 @@ int go7007_snd_init(struct go7007 *go)
 	gosnd->substream = NULL;
 	go->snd_context = gosnd;
 	v4l2_device_get(&go->v4l2_dev);
+	gosnd->card->private_data = go;
+	gosnd->card->private_free = go7007_snd_card_free;
 	++dev;
 
 	return 0;
@@ -263,7 +272,6 @@ int go7007_snd_remove(struct go7007 *go)
 
 	snd_card_disconnect(gosnd->card);
 	snd_card_free_when_closed(gosnd->card);
-	v4l2_device_put(&go->v4l2_dev);
 	return 0;
 }
 EXPORT_SYMBOL(go7007_snd_remove);


