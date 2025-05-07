Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224622116E9;
	Wed,  7 May 2025 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643776; cv=none; b=cy/1EKf0i//PCUU/XvHlLwWwDw8jdFOgKGS7v6XjQCcXA4GTjW6VcAftd4cdxGROm5ItYbQUDoPjGcidjHbZ8t/cugLVF5QLw86MXkk+7em5GKEBZP+Fc8dg/dNgSV482NA9SGnfpA+Y2QDjQOQM3mWKxw4n7ZYyRRLfdhLyThE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643776; c=relaxed/simple;
	bh=aircaE4orOV9gVGJXTls+8WypVWOjTAbCFmcGjctK58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOOeb3riRxN34Ha6K/BaMCz9PrPkNFj3HMf+GPHqw37hOYyKDaIJhUZhNAQSwX73CQ52Y3NsEktJqnbBfJHQ683gcNDQCigvdzltsPgBtZvzD6XD8toJ7Jxg2n8pHd0ngZvFJSZmye7MG1sE4Rxigx65wJsyDX2bzf72HFBe3PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNAaoyrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNAaoyrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26663C4CEE2;
	Wed,  7 May 2025 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643775;
	bh=aircaE4orOV9gVGJXTls+8WypVWOjTAbCFmcGjctK58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNAaoyrVt21fRSTt3RmtfT1W6Mj81LeisUlRyQu4+K+I638+1p+SndGs9cPXijuPW
	 WOKDBgK0+rNRru0aK2n2OsgWdeXICA6Y/jOLtJnIaK2NUtH/KFBT9rRKs3Fqx4F54C
	 1xSP4FdFqWCIsoHHpJZcwk0eG6vgyOBG3lIXW9wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.14 003/183] ALSA: usb-audio: Add retry on -EPROTO from usb_set_interface()
Date: Wed,  7 May 2025 20:37:28 +0200
Message-ID: <20250507183824.826722017@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -926,6 +926,8 @@ static int endpoint_set_interface(struct
 {
 	int altset = set ? ep->altsetting : 0;
 	int err;
+	int retries = 0;
+	const int max_retries = 5;
 
 	if (ep->iface_ref->altset == altset)
 		return 0;
@@ -935,8 +937,13 @@ static int endpoint_set_interface(struct
 
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


