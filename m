Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3643943990D;
	Thu, 16 Jul 2026 14:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212233; cv=none; b=SR8wEbh+WO09tkqeSQbMGfULkZTFukls9bCbocnDNtrDsNSyqScWqcI1DXsr8JiJivdCA8qQ7C8HhhBZWJpRzrnXZmEDZJUbrfUyqyI7D2hLIc4ZyhLYfM+FsSEsjBZud6haCYN/+jccKNZ6jXTb+CBuc5vCuNBaqteEL7zCy/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212233; c=relaxed/simple;
	bh=yHw3QaD7/suIuduexK+HmEHUzqUV+uxPbPrp0qXRXaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOYamuHvCIK5R1GeKEa83AonPtz9CJbfWaH0j8mVwUzkOOp2knlQ0Lfy1GBb9kkZx1NcjDaMUnd8TrIITn/M5TyaXR7zJZgS5tbVlhEe8sGxKyOJjjL8/TTX0XaQcG5AQp14HxVuXxoA53qmhl0rRhR55BUEXS7kX9zUJBjw9qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZMoybjs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZMoybjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B201F00ACF;
	Thu, 16 Jul 2026 14:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212232;
	bh=H8t/snMv3RdKGzxZlq1t0iqdSlNpFO2VvUSfPcM3efo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZMoybjs/98jRw/G/Cdw2b95wGnLw2xTH6yv0/yXspdZ6aLnepBgqtFWMrIv6fQlt
	 e8ysvepz1aDXpC9B86Dgt7SGBm7TlRz/h1N0oqNPId/EhpTJJB80LXEdV+IWJgelVC
	 7TXDWf7LJLpVqqEGHvKqFofTLVbG1wrMNoDte2OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 250/349] usb: typec: ucsi: Invert DisplayPort role assignment
Date: Thu, 16 Jul 2026 15:33:04 +0200
Message-ID: <20260716133038.947657849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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


