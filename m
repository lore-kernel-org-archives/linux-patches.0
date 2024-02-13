Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DB55F54E;
	Tue, 13 Feb 2024 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845555; cv=none; b=ZPpgs9sHAdUtSvTHWvIjoAQiTBEN7MN2EzJHbbIqizb2cuoem+5E3P9zLRLWd5YgBzeX/gAepQuhfTexcvOCW5g04VEhin9AlfuG307cmkBLx9DS3B19vD2htV9mvWuGhxUIxT5WpXd8mADNJSunq4QzzjYV5W8gJY4qfoEfPC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845555; c=relaxed/simple;
	bh=TmYtdWRlgP16Xcv5i0RH2N8Lgphc47Xirlvnx3CgYto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzqYxa6zahU5R1HC0TVvj4Z5lgnBmJxiXbTYTxIqNIOOiN6rw3of29UemggApF/jly9yDLCzQk/Me7lMp2GUG14Ie4g9HxkzfV49b30C9GmHEUVQolRGSZ0IjZAT2vyPOoz+xxuz9EIYYF82WgJ/ixck9FvhTkVEEGDpA2paR/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhJBjvTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhJBjvTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3594CC43394;
	Tue, 13 Feb 2024 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845554;
	bh=TmYtdWRlgP16Xcv5i0RH2N8Lgphc47Xirlvnx3CgYto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhJBjvTEK9NZMxSbvhsQARQTbypMdV/3oziAM+XdvirapgjCBFgpXcGXBlgTAtcTu
	 Dg6aYku2UjiXqi4Kx4mFBMly/kE+zdD8WG1rCMEjWse5wJeu5zcmwlfZ+y16gxzQ7F
	 froGVVRWm/ZDglJngcfbm20xl5j2bJXGLCtDm5L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wang <frank.wang@rock-chips.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 105/121] Revert "usb: typec: tcpm: fix cc role at port reset"
Date: Tue, 13 Feb 2024 18:21:54 +0100
Message-ID: <20240213171856.056990515@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Badhri Jagan Sridharan <badhri@google.com>

commit b717dfbf73e842d15174699fe2c6ee4fdde8aa1f upstream.

This reverts commit 1e35f074399dece73d5df11847d4a0d7a6f49434.

Given that ERROR_RECOVERY calls into PORT_RESET for Hi-Zing
the CC pins, setting CC pins to default state during PORT_RESET
breaks error recovery.

4.5.2.2.2.1 ErrorRecovery State Requirements
The port shall not drive VBUS or VCONN, and shall present a
high-impedance to ground (above zOPEN) on its CC1 and CC2 pins.

Hi-Zing the CC pins is the inteded behavior for PORT_RESET.
CC pins are set to default state after tErrorRecovery in
PORT_RESET_WAIT_OFF.

4.5.2.2.2.2 Exiting From ErrorRecovery State
A Sink shall transition to Unattached.SNK after tErrorRecovery.
A Source shall transition to Unattached.SRC after tErrorRecovery.

Cc: stable@vger.kernel.org
Cc: Frank Wang <frank.wang@rock-chips.com>
Fixes: 1e35f074399d ("usb: typec: tcpm: fix cc role at port reset")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240117114742.2587779-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4862,8 +4862,7 @@ static void run_state_machine(struct tcp
 		break;
 	case PORT_RESET:
 		tcpm_reset_port(port);
-		tcpm_set_cc(port, tcpm_default_state(port) == SNK_UNATTACHED ?
-			    TYPEC_CC_RD : tcpm_rp_cc(port));
+		tcpm_set_cc(port, TYPEC_CC_OPEN);
 		tcpm_set_state(port, PORT_RESET_WAIT_OFF,
 			       PD_T_ERROR_RECOVERY);
 		break;


