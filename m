Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7A43F44DB;
	Fri, 15 May 2026 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861154; cv=none; b=EvLIjoF55h9afZydHnMaPYgFORjCeIP2Y1SwMIg1dhpiQ/qhhv2DH1u862SraQYRCbwYLa8MDB0XdnXSQtSKmMxut0fkWQ/zO1ZVw6/QoAME3WQIS+Ftr4YPCeXwqI4OpqSacBVk8HRCYSfMQd6jbCvLrm5I9a0a1HZ9wd6hiyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861154; c=relaxed/simple;
	bh=8OvPF+tXfSlDR7yqyTgkGh0oXq9UJDzrAYHv0f1UsdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvYqKjTNvX7lliv264k7D7aq/TqlQPUNrdDau+Xk+mKEVYHQg8YaCQ++R2DsbFXHUA3cA69gpkAeIDvbt+XDjaxf4EV2uTkPE67O2HM8vCLbwoEo54UfM1qYHItJeeS46R/s20/xP5b+71b/Ca507xA4Ef+AHDuHN6+BmCPBV3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAUCsGbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAUCsGbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C10C2BCB3;
	Fri, 15 May 2026 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861153;
	bh=8OvPF+tXfSlDR7yqyTgkGh0oXq9UJDzrAYHv0f1UsdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAUCsGbb2k+ol8X6bz1pJdmnymkG96FpP6anRp4sLhOs1vCRDHSO+FmAyZpi7f+TJ
	 uZhooxVudiCSKET1MUysRaM9PhXc/D2y57EJAGUTiX4aalmDRmjokPg3zueHaWg7wz
	 6W/a1XPOIGld1JxDZ8hfkHIBxLCREMqxw+9fAmuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 219/474] sound: ua101: fix division by zero at probe
Date: Fri, 15 May 2026 17:45:28 +0200
Message-ID: <20260515154719.747687912@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeungJu Cheon <suunj1331@gmail.com>

commit d1f73f169c1014463b5060e3f60813e13ddc7b87 upstream.

Add a missing sanity check for bNrChannels in detect_usb_format()
to prevent a division by zero in playback_urb_complete() and
capture_urb_complete().

USB core does not validate class-specific descriptor fields such
as bNrChannels, so drivers must verify them before use. If a
device provides bNrChannels = 0, frame_bytes becomes zero and is
later used as a divisor in the URB completion handlers, leading
to a kernel crash.

Fixes: 63978ab3e3e9 ("sound: add Edirol UA-101 support")
Cc: stable@vger.kernel.org
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Link: https://patch.msgid.link/20260426111239.103296-1-suunj1331@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/misc/ua101.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -994,6 +994,13 @@ static int detect_usb_format(struct ua10
 
 	ua->capture.channels = fmt_capture->bNrChannels;
 	ua->playback.channels = fmt_playback->bNrChannels;
+	if (!ua->capture.channels || !ua->playback.channels) {
+		dev_err(&ua->dev->dev,
+			"invalid channel count: capture %u, playback %u\n",
+			ua->capture.channels, ua->playback.channels);
+		return -EINVAL;
+	}
+
 	ua->capture.frame_bytes =
 		fmt_capture->bSubframeSize * ua->capture.channels;
 	ua->playback.frame_bytes =


