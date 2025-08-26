Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0546F352FDA;
	Tue, 26 Aug 2025 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216732; cv=none; b=YjF05Bk/4FBnHERgW3C8fHn3E5b38GL/5e/K4IlgeTTSNN6qSjN4RO7+QHNIJ/5Y4QgUT6bwN+jJOwhtjjSiV3z/YiDTfprNyRRmMqdEVZopWHJdWeQ4ypAIEvLOxl3uwA+UABvzlWLz448cBlnJ5BCn7ykHpc1VvXKeQxuTNZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216732; c=relaxed/simple;
	bh=xj+DslBOyUXcb67xey68SjwVSzdIfAK/gye6UvFBfIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMp8dEHJUCoNBFxTJnTBYsQpD/u6OuSZPXPoO18puXJ/TFVXL4AF9fRUgi8rAkY0a3g6k/qv6SyAAiVF0jf9R9XUgQLlnIxn5fLrC3R5LLPDONSFNpH8e+zkoWU+p3CBAlGgSSy2P/UZYAu6ScUd6mucYTtKrIKitAyettz9N60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNmbQFPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNmbQFPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4CEC4CEF1;
	Tue, 26 Aug 2025 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216731;
	bh=xj+DslBOyUXcb67xey68SjwVSzdIfAK/gye6UvFBfIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNmbQFPKt7VJUmV+UXIx56bNE+/DxzFvb2Z5jzo62WlzHo7D10Fsd6OTTkpB3keWu
	 d3g6cbFd9YNcyc3HWHhufYNVH3vM44gVp4qIqN5HgR5jI+wCgTy6ldvSIJfFA8D9E2
	 0YpJSNP+nn9FPQ3w7xq1HvJNUy/6jjxHoNfmba3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 522/644] ALSA: scarlett2: Add retry on -EPROTO from scarlett2_usb_tx()
Date: Tue, 26 Aug 2025 13:10:13 +0200
Message-ID: <20250826110959.444442166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit 8a15ca0ca51399b652b1bbb23b590b220cf03d62 ]

During communication with Focusrite Scarlett Gen 2/3/4 USB audio
interfaces, -EPROTO is sometimes returned from scarlett2_usb_tx(),
snd_usb_ctl_msg() which can cause initialisation and control
operations to fail intermittently.

This patch adds up to 5 retries in scarlett2_usb(), with a delay
starting at 5ms and doubling each time. This follows the same approach
as the fix for usb_set_interface() in endpoint.c (commit f406005e162b
("ALSA: usb-audio: Add retry on -EPROTO from usb_set_interface()")),
which resolved similar -EPROTO issues during device initialisation,
and is the same approach as in fcp.c:fcp_usb().

Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Closes: https://github.com/geoffreybennett/linux-fcp/issues/41
Cc: stable@vger.kernel.org
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/aIdDO6ld50WQwNim@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ Applied patch to the older file name mixer_scarlett_gen2.c instead of mixer_scarlett2.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett_gen2.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -125,6 +125,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/moduleparam.h>
+#include <linux/delay.h>
 
 #include <sound/control.h>
 #include <sound/tlv.h>
@@ -1064,6 +1065,8 @@ static int scarlett2_usb(
 	u16 req_buf_size = sizeof(struct scarlett2_usb_packet) + req_size;
 	u16 resp_buf_size = sizeof(struct scarlett2_usb_packet) + resp_size;
 	struct scarlett2_usb_packet *req, *resp = NULL;
+	int retries = 0;
+	const int max_retries = 5;
 	int err;
 
 	req = kmalloc(req_buf_size, GFP_KERNEL);
@@ -1087,10 +1090,15 @@ static int scarlett2_usb(
 	if (req_size)
 		memcpy(req->data, req_data, req_size);
 
+retry:
 	err = scarlett2_usb_tx(dev, private->bInterfaceNumber,
 			       req, req_buf_size);
 
 	if (err != req_buf_size) {
+		if (err == -EPROTO && ++retries <= max_retries) {
+			msleep(5 * (1 << (retries - 1)));
+			goto retry;
+		}
 		usb_audio_err(
 			mixer->chip,
 			"Scarlett Gen 2/3 USB request result cmd %x was %d\n",


