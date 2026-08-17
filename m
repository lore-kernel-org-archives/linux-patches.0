Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287BC26461F;
	Mon, 17 Aug 2026 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980341; cv=none; b=RXT5dYk7/QV5dFOcpSY2h4myhkgANsNrQiHUiovWCMai/vaLvfosgrRNKybEG/4QkPonw4yaKi+6Jg+Vgi5FB+RkdcpmzAKTqfOHPmUY6z/yeVs0LC+iMZV6Za2bpqhi9n3VfYpFp1ebRbcmkv5GqVuL/bpNjo7irFT9CmcVUIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980341; c=relaxed/simple;
	bh=KRGBw6/AFesAcLs70jZgwu4bLOUJ4h/CQVvXk8fmevA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozl7u0RS/CtWL4uAZVw99GMyic0XCIxvw8RPkCSYmx6+GYiaDmTcgR0cakdfoSrQbJwXzgvukjUmn0C48DY1fJzigmRHdCACGpaBepeS35YKXXWjSTeekU+glCwF+/p/lZKbEDW/0GGl2tKRf+PIsXArxcXGMWIiUgdWhXRH/5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HG/7OP1h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HG/7OP1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805021F000E9;
	Mon, 17 Aug 2026 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980340;
	bh=fX0FUgDq8Zw/1buOWrPVQhveg4Q1VKAwpROmmq102sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HG/7OP1hazkNHJ9Qit3YRfH2C+89Q7yFPViQhnomcS6cdm6ecFCpz6LuGrkJmDsA4
	 9JaEzlCsh3r5UQM4//KoqB0+qsQyBtZ8gO3a+NrkI6xw9U+sqo4k466OrIgFBI+BHy
	 8DsPWJnBgoH/pygA/4FcKvtrvldSY6ZZmb8vBg4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+c9dff578c3a41775176a@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH 6.1 540/609] usb: atm: cxacru: properly kill rcv_urb on error in cxacru_cm()
Date: Mon, 17 Aug 2026 15:33:56 +0200
Message-ID: <20260817132601.836187749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

commit c2f811314be351d86b6ab41e9297ae80d8da6f86 upstream.

If cxacru_cm() encounters an error while submitting or waiting for snd_urb,
it aborts and returns the error without killing the already submitted
rcv_urb. This leaves the rcv_urb active.

When this happens during initialization (e.g., in cxacru_atm_start()), the
driver may ignore the error and proceed to call cxacru_poll_status(), which
invokes cxacru_cm() again. Attempting to submit the still-active rcv_urb
triggers a warning in usb_submit_urb():

cxacru 1-1:1.0: send of cm 0x84 failed (-104)
ATM dev 0: cxacru_atm_start: CHIP_ADSL_LINE_START returned -104
------------[ cut here ]------------
URB ffff88812658d200 submitted while active
WARNING: drivers/usb/core/urb.c:379 at usb_submit_urb+0x79/0x18b0
drivers/usb/core/urb.c:379
...
Call Trace:
 <TASK>
 cxacru_cm+0x21a/0xf10 drivers/usb/atm/cxacru.c:631
 cxacru_cm_get_array drivers/usb/atm/cxacru.c:722 [inline]
 cxacru_poll_status+0x178/0x1110 drivers/usb/atm/cxacru.c:828
 cxacru_atm_start+0x185/0x360 drivers/usb/atm/cxacru.c:814
 usbatm_atm_init+0x144/0x3a0 drivers/usb/atm/usbatm.c:927
 usbatm_usb_probe+0x15cb/0x1db0 drivers/usb/atm/usbatm.c:1178
 cxacru_usb_probe+0x17f/0x220 drivers/usb/atm/cxacru.c:1370
...

To fix this, ensure that rcv_urb is properly killed if cxacru_cm() aborts
early. We can safely call usb_kill_urb() on rcv_urb in the error path, as
it is safe to call even if the URB is not active (e.g., if it failed to
submit in the first place, or if it already completed).

Fixes: 1b0e61465234 ("[PATCH] USB ATM: driver for the Conexant AccessRunner chipset cxacru")
Cc: stable <stable@kernel.org>
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c9dff578c3a41775176a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c9dff578c3a41775176a
Link: https://syzkaller.appspot.com/ai_job?id=75fec6f2-c8a6-43b1-b184-4d26baba86cc
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Link: https://patch.msgid.link/91edfa4c-a63d-400c-9f00-31f3e1f98c00@mail.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/atm/cxacru.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -700,6 +700,8 @@ static int cxacru_cm(struct cxacru_data
 	ret = offd;
 	usb_dbg(instance->usbatm, "cm %#x\n", cm);
 fail:
+	if (ret < 0)
+		usb_kill_urb(instance->rcv_urb);
 	mutex_unlock(&instance->cm_serialize);
 err:
 	return ret;


