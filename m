Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054949;
	b=F75RrMd+l2oYocVJXrFmA53IT3ZNQQidBCoOeFOCvUoDH5qhposuHkt3KGSVmD1R/kDr
	 bv7dbwJEUJRZhrMIqYOvR5SkTPu32mxjFQ+tYt4M6Y/9NulFxFLcpMouXTpUj9/OrEwEu
	 KXZItAFT7KNkyRypcQIeSS8ViVl7Hw/bGs8LI2gcGkTfjoOfDIX09rms9HwrMR653cCi6
	 PgpXLXfh27YkItfsZyNIL2Fz8dkkaZXd97kTKTkDC5+jLI4RANoa12Eb/PWmXwQU/jsuO
	 00Ov3O2xabmrhBmcSQFsyWyIg26Lgyow0DuEeYwJs5C8OKvvKWU6s1YsbJRgoluPrag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=li1RxLWTWiIlSqSfA1fZqJAJakQzppEQMCSzSfYhucQ=;
	b=abt+CG/Vcn81TIPoE80mQo2ux4jJwzY/acXIJOK5xm5PY+OedZPKb6s5kZuGO4i9JGlE
	 6QO6FNc+Pqj1eYdiRJU4vNdQyq4nBw+ZtGnXtqBnHQubstt8xpRfIALXReqHlTmJPtAfP
	 100jKFgwH89sCOEeTffA4pVTSyiN81PpB1Eet/67fR4iXyyIOUVImGsFway7aJyagGhh5
	 O/aevbRzr3TwLG7AZ8f2LGl1lAUa1Hol626SKJMv/ERBASaYwoiqYTrk2gNv+5EoWxHdX
	 VP+j7WsOUEer937P4PIW/pTPYM1pwO3/iCdeOiSGnseTsesKWI9eBHKLEnW+1JjRw9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBUrvPrp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C62A606A31C;
	Thu, 19 Nov 2026 02:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBUrvPrp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16481F000C4;
	Thu, 19 Nov 2026 02:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054949;
	bh=li1RxLWTWiIlSqSfA1fZqJAJakQzppEQMCSzSfYhucQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBUrvPrpxK/dFtFFXqAJ2ITewbpSaSR5sV18yH9lc8P0NpQpcuXNS5DzfmCqRW00a
	 DVTIgGyjC7oRzi9/7rmHz/az1p1fV7YdcDzNwSMQorkGIImP+gPUw3g6xegtFA4Ds8
	 psrF9F9b1HTEHV18n5zA6nCZI3AZYwWjArC52GIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1456/2214] usb: gadget: f_mass_storage: ignore class requests while inactive
Date: Wed, 18 Nov 2026 15:52:12 +0100
Message-ID: <20261118150109.316376577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Tsukuda <catnyaaan@outlook.com>

[ Upstream commit e84caed6e7f58d96ea2e4aaa0b947ab05faa451b ]

SET_CONFIGURATION is handled asynchronously by the mass-storage thread.
A class request can arrive after the composite core selects the function
but before the thread installs common->fsg, or while the function is being
disabled.

fsg_setup() already rejects this state with -EOPNOTSUPP, but checking it
through fsg_is_set() also emits a warning. Check the active function
directly so normal requests during a configuration transition are rejected
without hiding fsg_is_set() warnings from other internal paths.

Fixes: 8876f5e7d3b2 ("USB: gadget: f_mass_storage: added eject callback")
Reported-by: syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d31109047baed8f3b590
Signed-off-by: Keisuke Tsukuda <tkdkei@outlook.jp>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260908203348.95825-3-tkdkei@outlook.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index b20aabf3fb2f3..5a4edb856e92f 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -461,7 +461,12 @@ static int fsg_setup(struct usb_function *f,
 	u16			w_value = le16_to_cpu(ctrl->wValue);
 	u16			w_length = le16_to_cpu(ctrl->wLength);
 
-	if (!fsg_is_set(fsg->common))
+	/*
+	 * fsg_is_set() warns when common->fsg is NULL, but that can happen
+	 * normally while a configuration change installs or removes the active
+	 * function.
+	 */
+	if (!fsg->common->fsg)
 		return -EOPNOTSUPP;
 
 	++fsg->common->ep0_req_tag;	/* Record arrival of a new request */
-- 
2.53.0



