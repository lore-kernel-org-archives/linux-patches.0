Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849F6259CBB;
	Mon,  1 Dec 2025 11:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588732; cv=none; b=p2GeH2zfHijakzPSgF/xKsvDevtibl7c/CJaO8M2wSNNLHNTxiYnXccnr2JXn0McOvLutYB2zIxam7CI8HIUIF+lG97FqjnBSihUBWchUTi2xcNtYlaFccI0AWnkFes8RZy9dIqAETcsp3LfJKLkwgaak/XMyIi7iPL+JbymUQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588732; c=relaxed/simple;
	bh=FaTD6hsNAsWWNvN8M+pkeTYcBWMSzL9mnwc5PxYOoc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is9PsEreLrj5KVl553S9AAcWA8BBZYvxQGD4wObRRzd04hUv3NlFPwg1br1/ekmXOZhaWeC/+HTQykOPJq6zAWoP+X3YdMP8fmJunEPH3rB47YbDuqqrOjYCM51JqsqIXVFWys4PAsl5WmnztF1Z5K1pnQPzao7CCe9W/3RKv5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdQ8n29r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdQ8n29r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00408C4CEF1;
	Mon,  1 Dec 2025 11:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588732;
	bh=FaTD6hsNAsWWNvN8M+pkeTYcBWMSzL9mnwc5PxYOoc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdQ8n29rkOyTKgUXKoRqmZnZtXiB+s9nZkbWOmxwA2y9rCZkc0qYWW+pb+0J+z2qf
	 3skzvegihYKsrDg47d7g6y5yezS6Zc+P3PAye+yjDD5b6xLxyt6kIBPSvZnuOFAogT
	 4nQpjrYEKgC0wZkshGo/1eCemmWLLy2RT37fVlRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haein Lee <lhi0729@kaist.ac.kr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/187] ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd
Date: Mon,  1 Dec 2025 12:24:18 +0100
Message-ID: <20251201112246.637317243@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haein Lee <lhi0729@kaist.ac.kr>

[ Upstream commit 632108ec072ad64c8c83db6e16a7efee29ebfb74 ]

In snd_usb_create_streams(), for UAC version 3 devices, the Interface
Association Descriptor (IAD) is retrieved via usb_ifnum_to_if(). If this
call fails, a fallback routine attempts to obtain the IAD from the next
interface and sets a BADD profile. However, snd_usb_mixer_controls_badd()
assumes that the IAD retrieved from usb_ifnum_to_if() is always valid,
without performing a NULL check. This can lead to a NULL pointer
dereference when usb_ifnum_to_if() fails to find the interface descriptor.

This patch adds a NULL pointer check after calling usb_ifnum_to_if() in
snd_usb_mixer_controls_badd() to prevent the dereference.

This issue was discovered by syzkaller, which triggered the bug by sending
a crafted USB device descriptor.

Fixes: 17156f23e93c ("ALSA: usb: add UAC3 BADD profiles support")
Signed-off-by: Haein Lee <lhi0729@kaist.ac.kr>
Link: https://patch.msgid.link/vwhzmoba9j2f.vwhzmob9u9e2.g6@dooray.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index f2c697ff50b57..11a74cc0e94d8 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2967,6 +2967,8 @@ static int snd_usb_mixer_controls_badd(struct usb_mixer_interface *mixer,
 	int i;
 
 	assoc = usb_ifnum_to_if(dev, ctrlif)->intf_assoc;
+	if (!assoc)
+		return -EINVAL;
 
 	/* Detect BADD capture/playback channels from AS EP descriptors */
 	for (i = 0; i < assoc->bInterfaceCount; i++) {
-- 
2.51.0



