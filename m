Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF44D471250;
	Tue, 21 Jul 2026 18:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660198; cv=none; b=mgoRSZfRuwHvpLntAIP/V9DKX+pbMz9pZ5hkLLol2Nw9F+CzK6vUGgsRKg2xeuv9s5Voj8G4pc0BzwNf+n83b9bvDrAzr0vz6Zy4W0vN1Njt413crBhEPKR7oz32j6rm/XryikBwY/UUYreml/d1bX+KDlhtiWnja4mwNZmd9/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660198; c=relaxed/simple;
	bh=762fxRv9CUufEEuPNfklSQon+Yc3uFmI1aE+D3lfYbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVlo1f1eWWqk6GcIncGdiI7o5UBs5g4426BW+ms5H2c5dOsJMAhWQ8Ynfeo9aZlIM2Uqoy6s8oZUEeW7ERpaDd19n8JeTS70Umbqbtv4g+w9pQ0e4JiIYya6Rl9JFn6TmQMHphlj/1kJPhPUfLs87b+CDDB6DQqbiV1Hlw9V5EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gfv5gK8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfv5gK8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F301F000E9;
	Tue, 21 Jul 2026 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660197;
	bh=Qm5nr5qUHBKp7MDBRihj9FeRqCy2MR82vTdk5wPceYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gfv5gK8pIB9LH1SH2QWTHurFmSKX73g7q6gkrMEB1SaY24E0v2XQz3Lfq453iU4/l
	 S9ueHa7DCIGXwrEYhNmv4lOfJJmpEbK6kTJoJB+VFbfwDOnNv+vp5cHG6p9YyzbncJ
	 dzVjLcuPDalmg+MK67V+Nkn8U+ttep8BnmWVCTJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0890/2077] usb: host: max3421: Fix shift-out-of-bounds in max3421_hub_control()
Date: Tue, 21 Jul 2026 17:09:23 +0200
Message-ID: <20260721152613.806050772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit cff06b03b530ae1fe8a13e93a7848f2130e00fb4 ]

The `max3421_hub_control()` function handles USB hub class requests
to the virtual root hub. In the `default` branches of both the
`ClearPortFeature` and `SetPortFeature` switch statements, it modifies
`max3421_hcd->port_status` by left shifting 1 by the request's `value`
parameter. However, it does not validate whether this shift will exceed
the width of `port_status`.

So if a malicious userspace task with access to the root hub via
/dev/bus/usb/.../001 issues a USBDEVFS_CONTROL ioctl with `wValue`
greater than or equal to 32, the left shift operation invokes
shift-out-of-bounds undefined behavior. This results in arbitrary
bit corruption of `port_status`, including the normally-immutable
change bits, which can bypass internal state checks and confuse the
hub status.

Fix this by rejecting requests whose `value` exceeds the shift width
before performing the shift.

This issue was found using a KLEE-based symbolic execution tool for
kernel drivers that I'm currently developing.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://patch.msgid.link/20260518224901.1887013-1-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 0e17c988d36a2d..3d6b351dcb1a28 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1694,6 +1694,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 						!pdata->vbus_active_level);
 			fallthrough;
 		default:
+			if (value >= 32)
+				goto error;
 			max3421_hcd->port_status &= ~(1 << value);
 		}
 		break;
@@ -1747,6 +1749,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 			max3421_reset_port(hcd);
 			fallthrough;
 		default:
+			if (value >= 32)
+				goto error;
 			if ((max3421_hcd->port_status & USB_PORT_STAT_POWER)
 			    != 0)
 				max3421_hcd->port_status |= (1 << value);
-- 
2.53.0



