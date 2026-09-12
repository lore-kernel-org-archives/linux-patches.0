Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6813E5A14;
	Sat, 12 Sep 2026 09:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205581; cv=none; b=rEPVofvhp2Bqka8Pf1+h3fhMguDaWG7MxjoZZiilLHTrVkJdfR/OWxnNv3NoH0JVrqIk3T4yzpGxspfo/zkbICaZzt5WPS5kg50wK4g1mXN+UakD3KWeP2T2j10Mzt0Exs+D8pnFcl7womUAQOYZOqtrKleB/84RQEH9FugaRmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205581; c=relaxed/simple;
	bh=UUy+QdSo2QmEkK55LIWvqCpb+jyXAIHEOZKlwkJ+/fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFYSlgDhxaHMYlZRrUbpb4YoZU1rR77KHmPv7sFqh4TSMBJM2zfx4hcfTWRwKvklGlKR4WBgOa+JAVA8kuF215BVrFk9olnWiZP50aonWy2SZFPKyptQAO4q4KL551S46e37+R/9aLki4tCCt5Wv2SPCw8XX1fysW0a3Vxuqx0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGceU4rA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGceU4rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63B81F000FF;
	Sat, 12 Sep 2026 09:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205579;
	bh=K4pR3k9FrdM8ZWhLMow/jtADuCiUv5AF26vN912idms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGceU4rAxsnTaijlBEfRo2Z85Q/wvcUvxg+s/xY/IY3pIi0BH18lZMC1vHP91k2nN
	 qEIA3FJLaA2CvFzu9Am7FdcFZjOUCiFURN4kwseEb/SrhnFKGV2TSBLaa3Cuj9bmzs
	 tITKmwhrqCMBL7vghWqjXiTmKRApQfs8jfjguV6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0030/1518] ALSA: FCP: do not copy out an uninitialised init response
Date: Sat, 12 Sep 2026 08:36:39 +0200
Message-ID: <20260912065624.104978462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

[ Upstream commit 4335e387786479889e6db691fe06d345e52ea536 ]

fcp_ioctl_init() allocates its response buffer with kmalloc() and copies
the whole buffer back to userspace:

	buf_size = init.step0_resp_size + init.step2_resp_size;

	void *resp __free(kfree) =
		kmalloc(buf_size, GFP_KERNEL);
	...
	if (copy_to_user(arg->resp, resp, buf_size))
		return -EFAULT;

Nothing clears the buffer, and the only writer of its leading
step0_resp_size bytes is the step-0 control transfer:

	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0),
		FCP_USB_REQ_STEP0,
		USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
		0, private->bInterfaceNumber,
		step0_resp, private->step0_resp_size);
	if (err < 0)
		return err;

usb_fill_control_urb() does not set URB_SHORT_NOT_OK, so a short or
zero-length data stage completes with status 0 and snd_usb_ctl_msg()
returns a small actual_length.  The only check is err < 0, so a short
transfer is accepted as success.

snd_usb_ctl_msg() copies the full size back unconditionally:

	buf = kmemdup(data, size, GFP_KERNEL);
	...
	memcpy(data, buf, size);

Bytes the device never wrote are therefore restored into resp unchanged
and copied to userspace.  step0_resp_size and step2_resp_size are each
validated only to 1..255, so the caller also picks the slab cache, from
kmalloc-8 up to kmalloc-512.

On 7.2.0-rc5 (arm64), device answering step 0 with a zero-length data
stage, s0 = s2 = 255:

  # init_on_alloc off, no spray
  step0 window [0,255): nonzero=94/255
  000: 00 80 60 06 00 00 ff ff 18 00 00 00 57 01 ea 01
  010: 08 78 22 13 00 00 ff ff a8 c4 5f 80 00 80 ff ff

  # same kernel, kmalloc-512 pre-seeded with an 8-byte tag
  step0 window [0,255): nonzero=219/255  tagbytes=232

  # identical run, init_on_alloc=1
  step0 window [0,255): nonzero=0/255  tagbytes=0

  # all three runs
  step2 window [255,510): device words matched=62/62

a8 c4 5f 80 00 80 ff ff is the little-endian kernel text address
ffff8000805fc4a8.  The step-2 window is unaffected, so the disclosure is
exactly the step-0 region.

Zero the buffer, and require the step-0 transfer to deliver the full
step0_resp_size bytes so a short data stage is reported as an error.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 46757a3e7d50 ("ALSA: FCP: Add Focusrite Control Protocol driver")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260805013804.38839-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/fcp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/usb/fcp.c
+++ b/sound/usb/fcp.c
@@ -494,7 +494,7 @@ static int fcp_ioctl_init(struct usb_mix
 	buf_size = init.step0_resp_size + init.step2_resp_size;
 
 	void *resp __free(kfree) =
-		kmalloc(buf_size, GFP_KERNEL);
+		kzalloc(buf_size, GFP_KERNEL);
 	if (!resp)
 		return -ENOMEM;
 
@@ -1033,6 +1033,8 @@ static int fcp_init(struct usb_mixer_int
 		step0_resp, private->step0_resp_size);
 	if (err < 0)
 		return err;
+	if (err != private->step0_resp_size)
+		return -EIO;
 
 	err = fcp_init_notify(mixer);
 	if (err < 0)


