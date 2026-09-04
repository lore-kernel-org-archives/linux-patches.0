Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEC018D636;
	Fri,  4 Sep 2026 05:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501329; cv=none; b=jVLyrB96Lem7sklp58cwuhYuBvE2BoqmOwGxQKIZUZbzLIUDvFI5Hm+3y9pLO3zt1J88HRc3/R7jlLpHK46q/VRSIqIRlsjhdVNGzfUNvOzhEcmV1b2zMh1m7T9cMlkM8/DCdH3b7QhdaEOsCrJ7L1vgRvzvKlaLxuAVm8fQIww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501329; c=relaxed/simple;
	bh=DualSPhzGXeuXt3Tp7wEDEEZm6yj7cITn8FffGP1aSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYspBAyJnz4WxIeDCoVVmOzC+7WsJDfUnQeiCnD4hgwwtwT+15qNgMWVf9HIFmcYj7qeEkQCOen4n2q+bjRfI+bvVBfb21ghbJZq8EQo3IbBiAxm3d+/vIKfurya9asg9XfP8ihhfhF+1RoidGjMeqQbZOtCCu7zEY6C1Mm2iec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zf4CdO2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zf4CdO2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FBF1F00A3D;
	Fri,  4 Sep 2026 05:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501327;
	bh=jeKA5/vqto9qWZFGvwYHeKMcfu2FVuxO9a145IMOT4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zf4CdO2y3fn/3rSCcPCJDduOWO76t5O/Eatv7UiYg+7Y3iEOFSj/fRWcs+CCD+qzk
	 FAVxbXkekQrjfFC1VrCSmTVtVLmbzbjIA4kF0gWcMlZGy+MzuDR5I6mqj3YHsuxSgd
	 eE5QJkQNRi/J40LrpjMYwuH805n2dW+P2Wi/U89A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 371/552] power: supply: cros_usbpd: Limit port counts to EC_USB_PD_MAX_PORTS
Date: Fri,  4 Sep 2026 06:58:48 +0200
Message-ID: <20260904045758.636601741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
 


