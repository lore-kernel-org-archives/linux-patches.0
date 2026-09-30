Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80925503BEE;
	Wed, 30 Sep 2026 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785211; cv=none; b=PhP6uaWQZQ8quYbH+RzxoLCZjmFnv0FTtyst0l7fGwA25iXSE/WtIhQSL5pChi3mGQr36VuqesQYYCgae9URWwAQohK0MEU9BLtVzZyyZdxSwu6EfckIqr9FaVZ0ybbY7Jf1xNnHDvRPXeQTnC8UxjasXaYHA2ouisUcXxwGm5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785211; c=relaxed/simple;
	bh=nvdnJEWF1oTNg2F7dYX+SX59dI3tz5O2c8I8wdzA6nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4MvJfFmliTpNTUdCT6Bsb6b8s7Tfo8O3Vzd2cnrIQ3Sjm3tuGXeY98CGFraNQIZI5oPulz8yZCnqzSu+kWOPkp/ojLzTCMtkA6hoHL3FFy8YDubcjFrGLKByYcC9DsSkst9uykVijvW0/ft3gvFjSUpMzc4V8/uKO3lc/g7nZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tyj9nZXU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tyj9nZXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CF91F00898;
	Wed, 30 Sep 2026 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785203;
	bh=MoM3M8GiDnh8ER4UZK98876YfysIesuotbH6HkqXYU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tyj9nZXUP2lRlDFOy16vFpyNJCotanBLpQwLJ1ms/LHP4Od8xr6m7LjVEWNYjcqpW
	 hC2MUut3TaVDrXGmEGBNUWEwysrkzDh73YtKseKiRV/gkon5OHS1Apt85OGpXsNn/g
	 81KZmd2Gub6hJBn05WvfK1jdsXj47Tfb2kcRkXSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 399/982] ALSA: caiaq: Fix potential double-free at error path
Date: Wed, 30 Sep 2026 17:18:55 +0200
Message-ID: <20260930152425.380020071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



