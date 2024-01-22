Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2C36025E;
	Tue, 23 Jan 2024 01:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974710; cv=none; b=q/UYKzrortbfil5TKmF+qn2N/C2Y2JZHJA5NU/wQrPSKQ8Gkom2qrWHQxJuP9BzdB9uoOaydwK1RQpZgyNJSOnW1y8iZecfklhXX3moBc+xdgrT18C8iShr5y3PRWXYKTmPOmjKfxRXnLVk2A2GS5mLOOYk+M9bhAiRtIyYFZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974710; c=relaxed/simple;
	bh=ZVHqVav/VE11gFIW46c87C5Nj3NwFnRGcqrYCjYJSJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhDofDc0RRE5BryXPbrFxMFmaTHEetdrFxek52HUDabghHIIvzS2wQG92YjJilHGLDiSDrOdEClVBgrJVdb21CcWXZddhd8yJWfx12q+NPkelJW1fREslIlm7hFpkABXZj7b6IToR/oZ97g8Q7enP15gp2u8hmGRnEZN56LAK9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPPp7QP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPPp7QP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C5DC433F1;
	Tue, 23 Jan 2024 01:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974710;
	bh=ZVHqVav/VE11gFIW46c87C5Nj3NwFnRGcqrYCjYJSJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPPp7QP28vuhPSV0mtbZNM+qAlNRavq5kuWul3QJgfcvFlEzO2EW1BORx6JI/Zb6+
	 Q5o6loXEpBWuTnXDU0H1CfZtsEmMzdlBPXwC3Y5UUadMaV7pqGy9ro/0njb/j6hRr3
	 ryAsfGl3whD36HpJ3yFtx4hw53N5+I8rYBAPCvq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 262/374] usb: typec: class: fix typec_altmode_put_partner to put plugs
Date: Mon, 22 Jan 2024 15:58:38 -0800
Message-ID: <20240122235753.876853060@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RD Babiera <rdbabiera@google.com>

commit 5962ded777d689cd8bf04454273e32228d7fb71f upstream.

When typec_altmode_put_partner is called by a plug altmode upon release,
the port altmode the plug belongs to will not remove its reference to the
plug. The check to see if the altmode being released is a plug evaluates
against the released altmode's partner instead of the calling altmode, so
change adev in typec_altmode_put_partner to properly refer to the altmode
being released.

Because typec_altmode_set_partner calls get_device() on the port altmode,
add partner_adev that points to the port altmode in typec_put_partner to
call put_device() on. typec_altmode_set_partner is not called for port
altmodes, so add a check in typec_altmode_release to prevent
typec_altmode_put_partner() calls on port altmode release.

Fixes: 8a37d87d72f0 ("usb: typec: Bus type for alternate modes")
Cc:  <stable@vger.kernel.org>
Co-developed-by: Christian A. Ehrhardt <lk@c--e.de>
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Signed-off-by: RD Babiera <rdbabiera@google.com>
Tested-by: Christian A. Ehrhardt <lk@c--e.de>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240103181754.2492492-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -261,11 +261,13 @@ static void typec_altmode_put_partner(st
 {
 	struct altmode *partner = altmode->partner;
 	struct typec_altmode *adev;
+	struct typec_altmode *partner_adev;
 
 	if (!partner)
 		return;
 
-	adev = &partner->adev;
+	adev = &altmode->adev;
+	partner_adev = &partner->adev;
 
 	if (is_typec_plug(adev->dev.parent)) {
 		struct typec_plug *plug = to_typec_plug(adev->dev.parent);
@@ -274,7 +276,7 @@ static void typec_altmode_put_partner(st
 	} else {
 		partner->partner = NULL;
 	}
-	put_device(&adev->dev);
+	put_device(&partner_adev->dev);
 }
 
 /**
@@ -495,7 +497,8 @@ static void typec_altmode_release(struct
 {
 	struct altmode *alt = to_altmode(to_typec_altmode(dev));
 
-	typec_altmode_put_partner(alt);
+	if (!is_typec_port(dev->parent))
+		typec_altmode_put_partner(alt);
 
 	altmode_id_remove(alt->adev.dev.parent, alt->id);
 	kfree(alt);


