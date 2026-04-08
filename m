Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A3352C3C;
	Wed,  8 Apr 2026 19:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674930; cv=none; b=Rh1k0q0tFVFL7oO3HmEAj/x0CYuIz7xp7T8D0kuLwDUQj7iO3Cb1C5qeOrm4+iUsIW+WUNcRND7wIE9H7Ks03jxB2LBlQl1AvFA/8MEAjF8aKvOVJvhEw2tLKQkjfmnwgUwqq1UfvE6qqtMV3cyzGqVA8m642g90uj2CvAXB+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674930; c=relaxed/simple;
	bh=YVHkD4titp/Ouy5UreKNucId30ZfKO1W5T/LT66Zl6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRaQU46jChP69DLX3qYyIsqbLRPncvHGDKIXPplfZwsW16am7c3hDrswz6uBLOS9d0Auda02/LknFf4KNmtSlSKbxeLg86/i1DeonRaMf5BDOfyXwxerELbFsvZOjlJNwXtpkNaGNdGxlzW2z/CkTGm7fJlG0mzG+EbW5zJwJZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REC5nE6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REC5nE6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2532BC19425;
	Wed,  8 Apr 2026 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674930;
	bh=YVHkD4titp/Ouy5UreKNucId30ZfKO1W5T/LT66Zl6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REC5nE6mVYW1615GYtUl+079t1ScZ7LtPi+e+PCpfNGfL6k/DaEuWs5DyuJgMNCxY
	 jjv2oEhWO1s1cSfSGq2zauDX2Dcb3vk5Hc/rD9FHycrpTLFYpttEfTAO8aDEbhzaPW
	 w/3JxLjWR4tFC731e47OQqfjoyq9sBjiW0x8N+bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Madhu M <madhu.m@intel.corp-partner.google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.19 289/311] usb: typec: thunderbolt: Set enter_vdo during initialization
Date: Wed,  8 Apr 2026 20:04:49 +0200
Message-ID: <20260408175950.172357887@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 3b8ae9817686efb3ea789ca9d4efdff2ce9c1c04 upstream.

In the current implementation, if a cable's alternate mode enter operation
is not supported, the tbt->plug[TYPEC_PLUG_SOP_P] pointer is cleared by the
time tbt_enter_mode() is called. This prevents the driver from identifying
the cable's VDO.

As a result, the Thunderbolt connection falls back to the default
TBT_CABLE_USB3_PASSIVE speed, even if the cable supports higher speeds.
To ensure the correct VDO value is used during mode entry, calculate and
store the enter_vdo earlier during the initialization phase in tbt_ready().

Cc: stable <stable@kernel.org>
Fixes: 100e25738659 ("usb: typec: Add driver for Thunderbolt 3 Alternate Mode")
Tested-by: Madhu M <madhu.m@intel.corp-partner.google.com>
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/20260324103012.1417616-1-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/thunderbolt.c |   44 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/drivers/usb/typec/altmodes/thunderbolt.c
+++ b/drivers/usb/typec/altmodes/thunderbolt.c
@@ -39,28 +39,7 @@ static bool tbt_ready(struct typec_altmo
 
 static int tbt_enter_mode(struct tbt_altmode *tbt)
 {
-	struct typec_altmode *plug = tbt->plug[TYPEC_PLUG_SOP_P];
-	u32 vdo;
-
-	vdo = tbt->alt->vdo & (TBT_VENDOR_SPECIFIC_B0 | TBT_VENDOR_SPECIFIC_B1);
-	vdo |= tbt->alt->vdo & TBT_INTEL_SPECIFIC_B0;
-	vdo |= TBT_MODE;
-
-	if (plug) {
-		if (typec_cable_is_active(tbt->cable))
-			vdo |= TBT_ENTER_MODE_ACTIVE_CABLE;
-
-		vdo |= TBT_ENTER_MODE_CABLE_SPEED(TBT_CABLE_SPEED(plug->vdo));
-		vdo |= plug->vdo & TBT_CABLE_ROUNDED;
-		vdo |= plug->vdo & TBT_CABLE_OPTICAL;
-		vdo |= plug->vdo & TBT_CABLE_RETIMER;
-		vdo |= plug->vdo & TBT_CABLE_LINK_TRAINING;
-	} else {
-		vdo |= TBT_ENTER_MODE_CABLE_SPEED(TBT_CABLE_USB3_PASSIVE);
-	}
-
-	tbt->enter_vdo = vdo;
-	return typec_altmode_enter(tbt->alt, &vdo);
+	return typec_altmode_enter(tbt->alt, &tbt->enter_vdo);
 }
 
 static void tbt_altmode_work(struct work_struct *work)
@@ -337,6 +316,7 @@ static bool tbt_ready(struct typec_altmo
 {
 	struct tbt_altmode *tbt = typec_altmode_get_drvdata(alt);
 	struct typec_altmode *plug;
+	u32 vdo;
 
 	if (tbt->cable)
 		return true;
@@ -364,6 +344,26 @@ static bool tbt_ready(struct typec_altmo
 		tbt->plug[i] = plug;
 	}
 
+	vdo = tbt->alt->vdo & (TBT_VENDOR_SPECIFIC_B0 | TBT_VENDOR_SPECIFIC_B1);
+	vdo |= tbt->alt->vdo & TBT_INTEL_SPECIFIC_B0;
+	vdo |= TBT_MODE;
+	plug = tbt->plug[TYPEC_PLUG_SOP_P];
+
+	if (plug) {
+		if (typec_cable_is_active(tbt->cable))
+			vdo |= TBT_ENTER_MODE_ACTIVE_CABLE;
+
+		vdo |= TBT_ENTER_MODE_CABLE_SPEED(TBT_CABLE_SPEED(plug->vdo));
+		vdo |= plug->vdo & TBT_CABLE_ROUNDED;
+		vdo |= plug->vdo & TBT_CABLE_OPTICAL;
+		vdo |= plug->vdo & TBT_CABLE_RETIMER;
+		vdo |= plug->vdo & TBT_CABLE_LINK_TRAINING;
+	} else {
+		vdo |= TBT_ENTER_MODE_CABLE_SPEED(TBT_CABLE_USB3_PASSIVE);
+	}
+
+	tbt->enter_vdo = vdo;
+
 	return true;
 }
 


