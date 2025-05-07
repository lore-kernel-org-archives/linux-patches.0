Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EA019AD5C;
	Wed,  7 May 2025 19:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644865; cv=none; b=S05SqWXjTT+sXAPagJZfAPSGS3MGPvlndTMPdWDwL85jHApoy55Xw1Uyj8fLS6fUh+3CABjy5DicVklA4rsnV72LkPySHTritMW6M/uK9SS+l+sG8R58bKeIMP7lAYSWmUktEgy2bVffK+sfefHqMa+5oVHyDgb+xO5HxYmh8PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644865; c=relaxed/simple;
	bh=T6JDUv4MLbhLahFIui9r1gnnnmShhpuYgH36b+ebGHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ng/rMoQOtkQ+7tpAI/GT1uM4V2bkl48Q5oY2+UIMJ8rbzR3mjV1Aev5lkF5Hbw+bAGc2C/duG2/j/KqL8VEQi/aY4fsjA4C/UAauL2uhhJwRhmgccdLD/cYi17oB4iCMlDeENIU77nJrzlQH1cTp8w1evOtIJOd/Q4XFlsgKj6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdJcf1Ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdJcf1Ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A315C4CEE2;
	Wed,  7 May 2025 19:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644865;
	bh=T6JDUv4MLbhLahFIui9r1gnnnmShhpuYgH36b+ebGHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdJcf1LsJESGlhyubRctEiFAumL/85ggqazhogImdd3BdtnZ96WWGxrSyAkdg9IQ4
	 QwPHjnGQqAnB6nP9u5688A/VgHlNubtvo8CKTd5biimHdyq1szg7EJK/IlP7dFtccH
	 iF7Jw3VZfuuu3LLoUlTvgIqPW4D7mUX5ICWye4J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 002/129] ALSA: usb-audio: Add retry on -EPROTO from usb_set_interface()
Date: Wed,  7 May 2025 20:38:58 +0200
Message-ID: <20250507183813.605041824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

commit f406005e162b660dc405b4f18bf7bcb93a515608 upstream.

During initialisation of Focusrite USB audio interfaces, -EPROTO is
sometimes returned from usb_set_interface(), which sometimes prevents
the device from working: subsequent usb_set_interface() and
uac_clock_source_is_valid() calls fail.

This patch adds up to 5 retries in endpoint_set_interface(), with a
delay starting at 5ms and doubling each time. 5 retries was chosen to
allow for longer than expected waits for the interface to start
responding correctly; in testing, a single 5ms delay was sufficient to
fix the issue.

Closes: https://github.com/geoffreybennett/fcp-support/issues/2
Cc: stable@vger.kernel.org
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/Z//7s9dKsmVxHzY2@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -926,14 +926,21 @@ static int endpoint_set_interface(struct
 {
 	int altset = set ? ep->altsetting : 0;
 	int err;
+	int retries = 0;
+	const int max_retries = 5;
 
 	if (ep->iface_ref->altset == altset)
 		return 0;
 
 	usb_audio_dbg(chip, "Setting usb interface %d:%d for EP 0x%x\n",
 		      ep->iface, altset, ep->ep_num);
+retry:
 	err = usb_set_interface(chip->dev, ep->iface, altset);
 	if (err < 0) {
+		if (err == -EPROTO && ++retries <= max_retries) {
+			msleep(5 * (1 << (retries - 1)));
+			goto retry;
+		}
 		usb_audio_err_ratelimited(
 			chip, "%d:%d: usb_set_interface failed (%d)\n",
 			ep->iface, altset, err);


