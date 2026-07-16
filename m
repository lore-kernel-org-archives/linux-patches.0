Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9516E424671;
	Thu, 16 Jul 2026 14:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211144; cv=none; b=kVKyz0HLaV7Xfv+VNR0EXA5vsRbFuVF1Gni1lWYf9c5zJOtLK/mMu2jkVZpwv5pR9Xt6igGs5ll8acrgtXZ39nj9qL+twvBmb4SfMe70evj5Ab+MYx2iVezr4WO4nvW5i5LTnlOjBLWfgQn99gB9a9aoZc6AyZ/E/KF2jiptv5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211144; c=relaxed/simple;
	bh=mcGeqjCBWkCEm0ioaM+aEJi7UC9RzUeJbV405Zgo5xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfD2bX+uG+Rs15yFvHH3rUXmrI++qXkWIqS8AdhLic94JEG4xjYinETHUYmbtw354kjXLb9kuoAW/EgRwW8o6wg+PJLn/VVidTYWN8+OWXN+zi3zEewdjWyH4jizQpkZW2fTdEmwaJFrl8wjzta813PuJoCbcqINurX+Kxwd5rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKo9CpYR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKo9CpYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080D81F000E9;
	Thu, 16 Jul 2026 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211143;
	bh=2y5i/bgvfZonpORk2hGeyK0mYnSTorz9Wbv1dKOpgPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKo9CpYR3dbqlguNkBLjAqaFlzO6WHDfsjL7Wp5+y9gCzhWbQ60v/5lmfYG89aHB4
	 SD3tD7w9mefNUVgJbXz8Utjti3AvW96btm6fiDb1IWSU2ayfeGLu5RvQRTqQUGxMaa
	 z/kh7dnU9ntl9VYgbjFpDAsvTb4k23ms/BIkj8GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 315/480] usb: typec: ucsi: Invert DisplayPort role assignment
Date: Thu, 16 Jul 2026 15:31:02 +0200
Message-ID: <20260716133051.637208882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


