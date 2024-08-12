Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B091494B8;
	Mon, 12 Aug 2024 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480636; cv=none; b=PVG0R3s7TNN1e5SE7BkFBuFnqNOR761HTTLBtGZjKqDxa5lEesJaSsV/ALZk5mLqDZD70I7QRBbBABpMefN2dOXrtBnuhd+0TCJDjz6iNVRzMdqlGHv5PB182xzfCvwPkpDNrOVCj5A9QeBzOVX/7Uuj5a1KHdhUYBD7ESPEPiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480636; c=relaxed/simple;
	bh=6pGFNfdV2pkIJfVh16vLNlbeabLQe60uMPbFyCXThkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/b+MtWwDPonBUMFQNxdE7vxTARo1M4ZWbHTGft40eBbDubSxATaBPXSiNCnVbChc3ZsY/9/1EGLApSoTg/k6dcAdZyqzstPDW9r7VIJ8u5MqwObHPuteQIB9OeuincUqU5MBXPk6B2CT22chcY8vQFd/e2oz3eHIlanWEuaLCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdAjYh/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdAjYh/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC21AC32782;
	Mon, 12 Aug 2024 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480636;
	bh=6pGFNfdV2pkIJfVh16vLNlbeabLQe60uMPbFyCXThkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdAjYh/1BME/hBis5XOq47UbDGCDE7XfskvMgWzdGleq9Lutw1ad9wUf2T4gNUc9w
	 dS8pYuSHAVGS6SZqCfYNdASNUHO/vItDm+alEjTagH6y3TZx8IDPzzz1bNHLZuL8H5
	 LAUd7PsHwV4zzxKhZe7Bzagd+KxQ4ZMOsUtkbnKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.10 225/263] power: supply: axp288_charger: Round constant_charge_voltage writes down
Date: Mon, 12 Aug 2024 18:03:46 +0200
Message-ID: <20240812160155.151280554@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 81af7f2342d162e24ac820c10e68684d9f927663 upstream.

Round constant_charge_voltage writes down to the first supported lower
value, rather then rounding them up to the first supported higher value.

This fixes e.g. writing 4250000 resulting in a value of 4350000 which
might be dangerous, instead writing 4250000 will now result in a safe
4200000 value.

Fixes: 843735b788a4 ("power: axp288_charger: axp288 charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240717200333.56669-2-hdegoede@redhat.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/axp288_charger.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -178,18 +178,18 @@ static inline int axp288_charger_set_cv(
 	u8 reg_val;
 	int ret;
 
-	if (cv <= CV_4100MV) {
-		reg_val = CHRG_CCCV_CV_4100MV;
-		cv = CV_4100MV;
-	} else if (cv <= CV_4150MV) {
-		reg_val = CHRG_CCCV_CV_4150MV;
-		cv = CV_4150MV;
-	} else if (cv <= CV_4200MV) {
+	if (cv >= CV_4350MV) {
+		reg_val = CHRG_CCCV_CV_4350MV;
+		cv = CV_4350MV;
+	} else if (cv >= CV_4200MV) {
 		reg_val = CHRG_CCCV_CV_4200MV;
 		cv = CV_4200MV;
+	} else if (cv >= CV_4150MV) {
+		reg_val = CHRG_CCCV_CV_4150MV;
+		cv = CV_4150MV;
 	} else {
-		reg_val = CHRG_CCCV_CV_4350MV;
-		cv = CV_4350MV;
+		reg_val = CHRG_CCCV_CV_4100MV;
+		cv = CV_4100MV;
 	}
 
 	reg_val = reg_val << CHRG_CCCV_CV_BIT_POS;


