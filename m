Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553EF46D083;
	Tue, 21 Jul 2026 18:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657140; cv=none; b=e5EnQrXDiewYOgjN64QSEtFHmX/22ngM9ZxNa77Md4p+d66Vpvo8Ba1QdjE3UOI39mkTJA+g7GPK3Q77oPjrcKp3tfg2O4u6WX0zHc4kkV0+C0o9/909WxtNVoYaX8LWR8GCXtiba59EDoSy7c/IrhUQiaNnoSqnYJ6lbIgQnZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657140; c=relaxed/simple;
	bh=3ulCjdci3HI3YRlPaC9+WldQXCosvi+1tJYFPV7qC2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i++mvsMEtWBDi52MeQVmZ8VGYEAV/6+fFSxZrQqotDM55M7xjbPx1Dl5NWJl94oD2t5xsAVZlNOu/B78vduPvVousl0wGfnz3DdwnNzHKMJ4kzrxkITjuEAXwtzHPlnyM1pXkpXrGxuZfJ5aq/QA9bG59PgeO0tPLh6WVKw3RUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHqwI7MY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHqwI7MY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B661C1F000E9;
	Tue, 21 Jul 2026 18:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657139;
	bh=pme+MUmpYZp+bQGkdcZjoS8/NvWy9d+Gb7IPXg7vU8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHqwI7MYTM2lU+X4yIZTXsARbc1dcIcqyCuvQlSu11Dq2vN96796abJG5Ue5nvm3N
	 mkpzK1mEaB3yQHGheSRFv697jMEbGzzAJAyPnmAOq7mMY8PBvbbRZTgP4ghS4JWkTF
	 rmPSrMQbQypzHE/OEkIWp6xp0gKFFH7Z+JrnsxVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0609/1611] usb: host: max3421: Fix shift-out-of-bounds in max3421_hub_control()
Date: Tue, 21 Jul 2026 17:12:05 +0200
Message-ID: <20260721152529.085531655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 4b5f03f683f775..823dc61d31e86b 100644
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



