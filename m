Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3163046E01C;
	Tue, 21 Jul 2026 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656730; cv=none; b=jOcvWuG8FLYiwlWeBpHyW/fQDt0iix6SXrtuqEXABLmck/RVlzVwV4nwLT2ES9b5A8Ir+IUQMlTVGv7i0iaH7Mg5HMDZ41IU+gNL/ovpvJKoymKo0ShuehZ4a6OExmUPgq2RK87uj3tG0M0MK7KE+Ja92I7uJzdE/L4RcSmx2pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656730; c=relaxed/simple;
	bh=XI+FCXB+g6FiKKFWxw8Saev/kX7+nfpxZO4gm/pJaSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IoA3ALrtHAl/NlH10U8YX6QxYrhHjGwCNeX00xSZpRGFsxqpZBlusM9M98o63Wx2zgi1o5PbJo2kCii8/LHaUzxZcYBSUYzluT1OFihoOenMNwnhd61cwnG3jlpv0Uer5yr8I5zd9I54OK4HdW8aG2860H1cycGqs6O6MNbDxyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OV0Zx6l0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OV0Zx6l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B101F00A3A;
	Tue, 21 Jul 2026 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656729;
	bh=Tm5M3qKV/+LEL/rD0FcoeRBGsRKTKIVt4b/b8ZVdqEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OV0Zx6l0jVfU2guPqSHxqwxDGGe+9gUW1hepC9QvkpAQMmHAFKBO5GlWaT2hpaoKj
	 AXNBxn+1KGI4WYtm3QVSSDC1BL8RsNMezGD/62B+9odQfqMMJkjkH5FU1y2wxhDzs9
	 AX7SuScqXCeAraMnfo4IWE2HuwBLhaoZLWAe9G5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0496/1611] ALSA: usb-audio: qcom: Guard sideband endpoint removal
Date: Tue, 21 Jul 2026 17:10:12 +0200
Message-ID: <20260721152526.497822647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e70649c4afcdc6..962b5f27f04478 100644
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



