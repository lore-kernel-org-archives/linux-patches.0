Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805693F1AB8;
	Fri,  4 Sep 2026 06:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502754; cv=none; b=qnpBU1eY1Weucn4bbnhNoedk11yqnDdrrxan6AelxRzU6/FuvjjRyyrdu1ZPFwv/XVEVoM74A/KC12MF8CHL66lBgjGCMlOkCmoOHvBblfHObPnKOeXWKgM1SlfEqyNmdxqMEpzboP1e2LTVsf+FuC0n1ic4HW5qfPXt046Inuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502754; c=relaxed/simple;
	bh=YHPtjv3PeX1Xkp6Fkbm8TVS6hSD4LKmN1zAHS6mody0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeQY3TfNStPvnBQrlSn1nsv9dy41+gy97JvsCrlH8nN6yhUGNkYXlb+x1y9E1RZ29HUMTz44Z4jkeEouQ802uboV5uhiqDx2h0z69vXxzJO8ijCFgIbcu5ubvyKnljIJJQBLiqz3uF9QksycfD3fSBZBZQHkQ2l5vEyzjN+hyoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GM8LOei4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GM8LOei4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6411F00A3D;
	Fri,  4 Sep 2026 06:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502753;
	bh=P/IvSjR/MPGBPq3llpZAFpbH/abXEaf23+6QhnEGaJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GM8LOei4vr81GldJS3mFISkkWJQhq+tVKsYYfoT49s169gkGc1897T3bAz1+PfCN6
	 cn3WJQ9B119+F6VtlYqAdW+DW0OJW3BhM1BJ9tMT8GpJToo/SlEF/0dlaQP6c0Sz9w
	 3sr4Ey61UEbPbMBX4Q/kXXcBhkFImO3CtoHXvQlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 275/403] power: supply: cros_usbpd: Limit port counts to EC_USB_PD_MAX_PORTS
Date: Fri,  4 Sep 2026 07:01:18 +0200
Message-ID: <20260904045741.111586718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jameson Thies <jthies@google.com>

commit 657cd3a42e937276262c0a8ae6b01a87004309de upstream.

Currently the cros_usbpd-charger driver probe iterates based on raw
charger port count returned by the embedded controller. The only check
is against the number of USB PD ports which the embedded controller
also defines. A malicious embedded controller could return an inaccurate
port count (up to 255) resulting in an out of bounds write and
subsequent memory corruption.

Update helper functions in cros_usbpd-charger to limit port counts to
EC_USB_PD_MAX_PORTS.

Fixes: 3af15cfacd1e ("power: supply: cros: add support for dedicated port")
Cc: stable@vger.kernel.org
Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/20260722195059.1420738-1-jthies@google.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cros_usbpd-charger.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -125,6 +125,11 @@ static int cros_usbpd_charger_get_num_po
 	if (ret < 0)
 		return ret;
 
+	if (resp.port_count > EC_USB_PD_MAX_PORTS) {
+		dev_warn(charger->dev, "Charge port count out of bounds\n");
+		return EC_USB_PD_MAX_PORTS;
+	}
+
 	return resp.port_count;
 }
 
@@ -138,6 +143,11 @@ static int cros_usbpd_charger_get_usbpd_
 	if (ret < 0)
 		return ret;
 
+	if (resp.num_ports > EC_USB_PD_MAX_PORTS) {
+		dev_warn(charger->dev, "USB PD port count out of bounds\n");
+		return EC_USB_PD_MAX_PORTS;
+	}
+
 	return resp.num_ports;
 }
 


