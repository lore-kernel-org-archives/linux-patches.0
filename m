Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568434D957E;
	Thu, 17 Sep 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665579; cv=none; b=NBihH1KHQZhKB4vbcBtabW2axXC+iudmhB6Bkqwu2W0RAnerw4FRfPCLaOCTG5dxWvor9mLCR/EFrQPiKQ4h6d/9GpRXDwAza02QcTME1HmRAIkZJdCyCZxNe+k67om/cuXOMtBkx94U2LyRBc1cMvnJ599wDroEUN4sDPlRrMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665579; c=relaxed/simple;
	bh=OlzejxeieVxiqK2uflrecYOT0/LJ+84YsoZeDfQFUR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBlq7ZXeP97B9K+ynlfwHtAB0bWeqecpmBxeqbmrEMUBmXML57efk9flG+FB3+DNi/4z21LVpzowAOXEjsxw6d27zkI/zHJw3tk4g9atsLYThf9oDcnAY7+5gX8F80AFs1IiIwKewK5QmFInDCqSwgwCmO4PD6untzwcP0dRv9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRG7Hxd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRG7Hxd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71061F00898;
	Thu, 17 Sep 2026 17:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665578;
	bh=E5ydvOWCGh2SFnLmSHJZYFHoRDmTN3RWl34cUqapG/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRG7Hxd9FKf6fR/7QH+rI5ctp8IJsWUeAzM99u6uzlvIZgNG/KiUXcfvufhqyavmA
	 2h//yyW6iMvw5tMY+Haeildv0zGtZwiGecgoIHbOdVQge6ThYs34lRlWkYJMdxnxBj
	 Zcle0zmNeGizvSQsxnoNU683zvRMuHua5+v/5LAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0751/1250] ALSA: caiaq: Fix potential double-free at error path
Date: Thu, 17 Sep 2026 16:09:06 +0100
Message-ID: <20260917151612.236490068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 95d425dd9d703..29f6cd9ee9415 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -829,16 +829,13 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *cdev)
 
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
 
@@ -859,6 +856,9 @@ void snd_usb_caiaq_audio_free(struct snd_usb_caiaqdev *cdev)
 
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



