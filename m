Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD48F2DE702;
	Sat, 12 Sep 2026 13:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220778; cv=none; b=S6W7MjoJnudq9hQ9FXk6IVyJ3/vmEteUQ1NTdYvOY01mflltLQIB892Azvps8QCVt3q3LDCxeyNE80qVMW3i+EzSpbM0CL+YU3SggMieET/Z3CEMKB85DOWQeHwoGAm5n1ZKOypZovEh0tW1KtHnReIdS7t7Y1Rbr9lhd5JGsQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220778; c=relaxed/simple;
	bh=JF6mgCMrWfQkqhVqLF1ti/w24E/PZWO0TWaM13osOG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8yDZYpDxqH0VXdMozFrAqYbIq+QiNlNXNSWQpkhSocZOIHfp80bII2D3mQ68XXM049If5BK8Cb8MitbUWCgTSYXB18JLCyqwmLJ1XHBKhjPiyPrpiD79qon1imbVLalRQhkTcbv0M3s8YulQdNiy5N9zjniHE59VuNy+MVvAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10PzfH64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10PzfH64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9551F000FF;
	Sat, 12 Sep 2026 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220777;
	bh=uojtr0NSjIgU0YYWNC+NQ04a5RgTTDQvcG0Zl6HBYzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10PzfH64tAY+JdVKzWsABvl0jSjSJgheJdmn6ctlSKBmCkuznpOGVH8X+E7U1ru3n
	 gKOl9RQ/MhS0iEh2e/R4/wG0ttj9MfKZkuv4Nhf5RTaZwtOIeCq7i0CU4teB2Tm69U
	 CSXpdyjIfQckvmU48uGT2UIUMc1Lc0JcrNdSmwzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 0210/1424] power: supply: cros_usbpd: Limit port counts to EC_USB_PD_MAX_PORTS
Date: Sat, 12 Sep 2026 08:44:02 +0200
Message-ID: <20260912065611.991465391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -136,6 +136,11 @@ static int cros_usbpd_charger_get_num_po
 	if (ret < 0)
 		return ret;
 
+	if (resp.port_count > EC_USB_PD_MAX_PORTS) {
+		dev_warn(charger->dev, "Charge port count out of bounds\n");
+		return EC_USB_PD_MAX_PORTS;
+	}
+
 	return resp.port_count;
 }
 
@@ -149,6 +154,11 @@ static int cros_usbpd_charger_get_usbpd_
 	if (ret < 0)
 		return ret;
 
+	if (resp.num_ports > EC_USB_PD_MAX_PORTS) {
+		dev_warn(charger->dev, "USB PD port count out of bounds\n");
+		return EC_USB_PD_MAX_PORTS;
+	}
+
 	return resp.num_ports;
 }
 


