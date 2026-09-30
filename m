Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62ED4EE877;
	Wed, 30 Sep 2026 18:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791432; cv=none; b=YbxX5TJYEZKQzly0gDGhI0vSXB/2JnLiB0R0VXaKulSVs/Z4gVoZKjfua9Ce0bblA253C6YJ/wAPi24L8UgnpaRhOwMm54qO6tuJWaIiJK+CNmqA6DzW0zbJkTjPIN+uNUausnOELii6trYq29p7GfKU6b13nXGXWSeNX/Gg75M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791432; c=relaxed/simple;
	bh=ANyXOg+uDukqGdWNwFtGbmxJo0KRqFia0v0Q1rMOkPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPs+w++fJR1j9Zk128XWm8LQEZHac5PVvF9KSI/+S0j0c1pMVnC4ZT6V3cs6dditfa89MCaGFiajsCN0yL4K3wAdmqNb1bXti8SbzCPq9ydFtD1XECxZ+Kc6oEGc0q+mheWcILqExaYEXuXcLnng78kpObVkmLR/eiTipMzN6aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm7CcBEO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm7CcBEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2586A1F000FF;
	Wed, 30 Sep 2026 18:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791431;
	bh=ItF9vleld4DOiJ2O4aXL83XaDrk4nU2QrOiPNSmkAyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qm7CcBEOdMUSJr6IwqM5n9EWpVTh17KwhjR/FjKAs0TI51Pkb1GAWEWkTgKu8zTap
	 JuW7oX0M8Dg2OKzZurGPeuSPARM8qMhdFd6Q8LN7I0HGIstxm0LihSYLvO4JbSvPxA
	 gWzFAO/eJ/6IMtcFQt635Aal97vkpKltlvGLHKUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/752] ALSA: caiaq: Fix potential double-free at error path
Date: Wed, 30 Sep 2026 17:22:49 +0200
Message-ID: <20260930152404.760198341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 7a89872aa0cbd..11d959887de56 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -853,16 +853,13 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *cdev)
 
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
 
@@ -883,6 +880,9 @@ void snd_usb_caiaq_audio_free(struct snd_usb_caiaqdev *cdev)
 
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



