Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0CE46D2C2;
	Tue, 21 Jul 2026 18:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659768; cv=none; b=NbCyGZHu59MZPDfpMOIaT/F+U5EDuMhJslxAh7PFmnYhUGLxVMFIoCVGA1/a3L9QU4euDUOqnxUccVJLYAMUL1BX92nhJE6nHKj9ZIZMDEp2NJv6J76a3PU/KqFE6CYvZFomFN9DpZZW3Lx3lhHsGSMnf955kA9OrQb9K9QYjfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659768; c=relaxed/simple;
	bh=9rmPeg0MAapXrsrlUhc2T1ogoboFs3UeDErRSZCWDYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SdVdFGRg6wmDaQveyCoPBQ2I1GhuZ1sJ8caj/hXOfFXxG8tLhcG2KJ8hgrZMvMwjURzkQjbFwrQwxWkeiTwa9DK1x+Je0uAXJLkUXviYIz4cbSjjt0Tkrk6P3KVXxxjykoTRoIMLuh4U3GK01ZCFFy1ZsjI7SWyY6HhvIZjJIKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NI4NzBiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NI4NzBiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F67C1F00A3D;
	Tue, 21 Jul 2026 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659767;
	bh=yhsZXk/gs4EZWXd1Vcu52Khv+/7POf1V7Vk8MrfAOnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NI4NzBiHjAhgqwyFNfRqWHny872RBpxvnhetvkX96hSUs1rwhWF4d8Wav+lSWpWH4
	 FwotRHBJLYgecnyqfaOQJANSwgo241YCNbgZZSBFPyqM7dP3cqIT/dHORY0Ba+LL2V
	 vJinET7y0/mk2DRfy1HSS5/HnmA8wUfGDfoLzt7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0725/2077] ALSA: usb-audio: qcom: Guard sideband endpoint removal
Date: Tue, 21 Jul 2026 17:06:38 +0200
Message-ID: <20260721152609.900694698@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 2773023abb381e36ce02d364022d901f6f7a416d ]

qmi_stop_session() conditionally looks up the cached data and sync
endpoints, but removes each endpoint unconditionally.

The data endpoint is always present for an active offload stream, while
the sync endpoint is optional. When no sync endpoint exists, ep still
refers to the data endpoint and the code attempts to remove that endpoint
a second time. The current sideband implementation rejects the duplicate
removal, but the teardown path should not pass an unrelated endpoint for
an absent sync endpoint.

Only look up and remove an endpoint when its cached pipe exists, check the
lookup result, and clear the cached pipe after handling it. This matches
the normal stream-disable path.

Fixes: 326bbc348298 ("ALSA: usb-audio: qcom: Introduce QC USB SND offloading support")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260611-alsa-usb-qcom-guard-sideband-endpoint-removal-v1-1-00e73787c156@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index a0009503b2c592..649228421e2f69 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -794,15 +794,23 @@ static void qmi_stop_session(void)
 				continue;
 			}
 			/* Release XHCI endpoints */
-			if (info->data_ep_pipe)
+			if (info->data_ep_pipe) {
 				ep = usb_pipe_endpoint(uadev[pcm_card_num].udev,
 						       info->data_ep_pipe);
-			xhci_sideband_remove_endpoint(uadev[pcm_card_num].sb, ep);
+				if (ep)
+					xhci_sideband_remove_endpoint(uadev[pcm_card_num].sb,
+								      ep);
+				info->data_ep_pipe = 0;
+			}
 
-			if (info->sync_ep_pipe)
+			if (info->sync_ep_pipe) {
 				ep = usb_pipe_endpoint(uadev[pcm_card_num].udev,
 						       info->sync_ep_pipe);
-			xhci_sideband_remove_endpoint(uadev[pcm_card_num].sb, ep);
+				if (ep)
+					xhci_sideband_remove_endpoint(uadev[pcm_card_num].sb,
+								      ep);
+				info->sync_ep_pipe = 0;
+			}
 
 			disable_audio_stream(subs);
 		}
-- 
2.53.0



