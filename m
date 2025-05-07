Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546111A00E7;
	Wed,  7 May 2025 18:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644389; cv=none; b=p8WFdLiAiMTU2P/wjQ9Po625SCCaOy9ZHY9w+Y/3D9B90993e+yl60RHYNFUaHjHohRSB/LnXUlHJouqjn0srRrKbQNSwJMIOGEsaslesSFJADSL8/qjK2fjPTHWdjIfPapNrBdPGGVuvjabrB/IzkM4he+Xqb8m5En3bUsx07M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644389; c=relaxed/simple;
	bh=WGJdbqj8uFVDEklW4XYtZER/4kFaUVRAwwDNOsE3hpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwUFwRauty/c3MtSmRYqYg3WTs+n+Nj94DHPOajN4vqK0Pu0LsvvawkkwnOkmQAKahSTO/AC3vqIyd2G2pynpw0BekZDebOBj3fmgTUO2ik66bGezmi/zKWbEjfzpzqzc+0nNtqK5gzbBNzHRHj78/+VxdzRgjYN5zqDx2tDEXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QubkEzbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QubkEzbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6537C4CEE2;
	Wed,  7 May 2025 18:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644389;
	bh=WGJdbqj8uFVDEklW4XYtZER/4kFaUVRAwwDNOsE3hpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QubkEzbwVqzeYt0Um//mCsfA78ijcWbfS5wDVJQMBiKRJuxc+x7nIp8iGZxlIWcun
	 aEuMZj8vxvYBHn8Z3zCJlhbcvPivpga603nAZwgagmAfnm6K3CkBa5xAIMgKPZjYMQ
	 7yrUPjEUoACKIU4JZ0vwMPAcy5r5nBUArLsLDQ4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 008/164] ALSA: usb-audio: Add retry on -EPROTO from usb_set_interface()
Date: Wed,  7 May 2025 20:38:13 +0200
Message-ID: <20250507183821.166668124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


