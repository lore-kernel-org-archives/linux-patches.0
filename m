Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1449144330F;
	Tue, 21 Jul 2026 21:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671192; cv=none; b=TYn7V+Z+MrYu7rBm4WZ5MnJJKUM9j/teJ71i3JhhocMCaG0XfEWkfPo95rpgrC++QdGikZpjp+lkxuhhsMZmWJp2T4MumTezvV++5JtTo5gaj3f+NZUFxbmx7xhdyrFpwiCHXtmUtoY6CCd9Qw1hzXkEKhPhljJZ13beY8Ypsh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671192; c=relaxed/simple;
	bh=Fp66lnX567J7zfidyzV/mKk6LHu+m/9uFM0LVJhNSkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbkFQIMD61qoUheS95bjHOV4LJ6ZLUpZtFUAT/9vza33gaFMG67Euh0Pzzxy2UF7tynBNINj+SEEpN9vnwglRNb+Ut3Kwclnm7e51aCuOhHzUsQMWcrGXIt0fTrd/yOGbmXsx8/cw72/doINTo6wlisyUmAKXd8L5NzKBq9r8kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5Bdzfg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5Bdzfg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD621F000E9;
	Tue, 21 Jul 2026 21:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671191;
	bh=zA+cUzpPEsGIEL7w09dJrGYSZpME5zLH9S58TvNDBJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5Bdzfg25qR+zxw2z2xxHsaJD+lEZ5NKBhS+dV5vJpTEPHhUe8ahdGZhiuakgMlvS
	 jwLiX4F0lhJTXLBG4NYJKaqDhl1Of2eESaVb6ZAJn44At/rS3aSbp7DHZ1uiP8X+Yb
	 TIQSbf4bBaFP6zDwOEESC1DYyrPyOzjFjIm/TqgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 153/843] usb: typec: ucsi: Invert DisplayPort role assignment
Date: Tue, 21 Jul 2026 17:16:28 +0200
Message-ID: <20260721152409.455807330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

commit d092d7edf8faefa3e27b9fc7f0e7904b06c833a2 upstream.

The existing implementation assigned these flags backwards, configuring
the partner's DisplayPort role to match the port's role instead of
complementing it.
This prevents proper configuration during DP altmode activation, often
causing `pin_assignment` to remain 0 in `dp_altmode_configure()` and
resulting in VDM negotiation failures:

    [  583.328246] typec port1.1: VDM 0xff01a150 failed

Additionally, the fix ensures that the `pin_assignment` sysfs attribute
displays the correct values.

Cc: stable <stable@kernel.org>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260601142837.3240207-1-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -166,12 +166,12 @@ static int ucsi_displayport_status_updat
 	 * that Multi-function is preferred.
 	 */
 	if (DP_CAP_CAPABILITY(cap) & DP_CAP_UFP_D) {
-		dp->data.status |= DP_STATUS_CON_UFP_D;
+		dp->data.status |= DP_STATUS_CON_DFP_D;
 
 		if (DP_CAP_UFP_D_PIN_ASSIGN(cap) & BIT(DP_PIN_ASSIGN_D))
 			dp->data.status |= DP_STATUS_PREFER_MULTI_FUNC;
 	} else {
-		dp->data.status |= DP_STATUS_CON_DFP_D;
+		dp->data.status |= DP_STATUS_CON_UFP_D;
 
 		if (DP_CAP_DFP_D_PIN_ASSIGN(cap) & BIT(DP_PIN_ASSIGN_D))
 			dp->data.status |= DP_STATUS_PREFER_MULTI_FUNC;


