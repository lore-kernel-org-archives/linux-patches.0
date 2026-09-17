Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AC04CDDC2;
	Thu, 17 Sep 2026 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670491; cv=none; b=Li/KnavdSK8ehnSwLNwbLlVHTp0yB1oZFVealag0BGVR/whgmHfGPIcgOTnJaIxVi68Qr+TpdZYsX87VNaMNAaFfjAXB5qKKMq/EboOAjA5xLmS13aQakTIaOXc6nI0xGyw59BLj9KGVksvrGYrmP2Ae1PwJ0VucnISv8xxsuQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670491; c=relaxed/simple;
	bh=uscAb+Haq2ls352f3NQMTWwtyrMo46lRIIAKb2oQSWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5AEsJHzTPzxas9W4MeI8O0l69zFCX5cfmtl17JsS2+m1Zq486Mma02ks5hZM5U27hZ+O2nl1PDvOTwA4RLTJD5/YqZdFQMeRtwMJf8ZMdhTU4xnXwy/+fIYsZJDLE0yEI3UGPyLMMM8js732RaC3rPnSJ0SpK2HiGLNa3BJD94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GC+mNgm+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GC+mNgm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE441F000FF;
	Thu, 17 Sep 2026 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670490;
	bh=ClNeLQ/XjnGatqL5vCghVIEq0FQExVydKUI2Bd2gnJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GC+mNgm+x/ED5SeppHfLCjwtjYEbNpVQbcgBvU+Q5grg7vT1blJ+G/uGkv5b8nkM9
	 OibqQIXJAqmvM5gEJqiGfJ8QoB893AkSStrNlYRYU8lFx5cMEeSZ6iEVIbVlC+DX4t
	 zVkcDKnxaoolUNWt63wEez6uYTU96qMNjiKD6574=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0640/1102] ALSA: caiaq: Fix potential double-free at error path
Date: Thu, 17 Sep 2026 16:09:43 +0100
Message-ID: <20260917151556.203213288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3b26ceef88c110f4d188387cffa0df78657be904 ]

The fix for caiaq driver's resource management to handle the errors
tries to release the resources in a common destructor call, but as a
sashiko review for another patch suggested, some of the audio
resources such as URBs have been already freed, and this may lead to a
double-free.

For addressing the double-free, call the common destructor function
from each place, and assure that the resource pointers get cleared.

Link: https://sashiko.dev/#/patchset/20260903084747.535367-1-eadavis%40sina.com
Fixes: 28abd224db4a ("ALSA: caiaq: Handle probe errors properly")
Link: https://patch.msgid.link/20260903103855.1807838-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/audio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 05f964347ed6c..25ba563302fde 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -842,16 +842,13 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *cdev)
 
 	cdev->data_urbs_in = alloc_urbs(cdev, SNDRV_PCM_STREAM_CAPTURE, &ret);
 	if (ret < 0) {
-		kfree(cdev->data_cb_info);
-		free_urbs(cdev->data_urbs_in);
+		snd_usb_caiaq_audio_free(cdev);
 		return ret;
 	}
 
 	cdev->data_urbs_out = alloc_urbs(cdev, SNDRV_PCM_STREAM_PLAYBACK, &ret);
 	if (ret < 0) {
-		kfree(cdev->data_cb_info);
-		free_urbs(cdev->data_urbs_in);
-		free_urbs(cdev->data_urbs_out);
+		snd_usb_caiaq_audio_free(cdev);
 		return ret;
 	}
 
@@ -872,6 +869,9 @@ void snd_usb_caiaq_audio_free(struct snd_usb_caiaqdev *cdev)
 
 	dev_dbg(dev, "%s(%p)\n", __func__, cdev);
 	free_urbs(cdev->data_urbs_in);
+	cdev->data_urbs_in = NULL;
 	free_urbs(cdev->data_urbs_out);
+	cdev->data_urbs_out = NULL;
 	kfree(cdev->data_cb_info);
+	cdev->data_cb_info = NULL;
 }
-- 
2.53.0



