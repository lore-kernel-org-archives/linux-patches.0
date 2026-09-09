Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5C1440626;
	Wed,  9 Sep 2026 13:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961810; cv=none; b=awSxC9blKClkRvA1BZeEmryOU9N5rXmYb+PapMqD71VsLs3NeZrYBIBRm++RXnDH9IiF8eZ1dzDmfLQHivpcyMCvZLvLD3vh1GSV282HWNVMqLK7bI9+iqw50LSdXGrCzMBSKz8zwwYKouvCkH1PcQcz2oSng4LHsYZpU7NGWrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961810; c=relaxed/simple;
	bh=WLHHwqeB1Dnrz0FXdvNoz8WIJPmmJJqE+ZSu5hHVoW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMOZzmWNxLGKshqcYbA4wDr0hKyWakF6ByOt2bseV4WcALgnfMX1g8lZuHJoLyZpHpRNJqeyCdsbEXYtkID4f4jSE25SuqsE8vXkKBdABG04tz6R8mN2U1tHdyUTLaHrh221FDh2uPQ5GmmbcoykA7hs3qgN8QCMnJBYjroJz8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ/YoJ+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ/YoJ+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DD21F00A3A;
	Wed,  9 Sep 2026 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961808;
	bh=buBqy8Oc3FtYfw8ZnmkXMMSZ906kMaRWDkofM1t+9tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJ/YoJ+CjLeG4cRwXSsW4G+6j2xtYBP2qKdVafed+dDvNQeFCEDsDGlvBtLNhzhRY
	 QcUO7NXSG2blrtvRfgAqCdJ4FLfg1X5b2jljqJ+UjtKh5io1hUlJn35zWWbPqQ/EQh
	 olInxkdg4ov75UuttRd4fr8RA50i8fY/dnp80bwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Vasut <marex@nabladev.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 037/556] usb: typec: mux: Fix typec_switch_match()
Date: Wed,  9 Sep 2026 15:35:17 +0200
Message-ID: <20260909134231.801445054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

commit dea99705bc8fcda12590cfeeae6d2ba47a7ef572 upstream.

The fwnode_typec_switch_get() sporadically returns NULL instead of an
-EPROBE_DEFER for orientation-switch described in DT. This makes it
impossible to discern whether the DT does describe an orientation-switch
which did not probe yet, or whether the DT does not describe the switch.
This happens with gpio-sbu-mux connected to an I2C GPIO expander.

The class_find_device() on typec_switch_match() may return NULL in case
the mux did not probe just yet early on boot. The sw_devs[] array can be
empty on boot as well. If these two conditions occur, then the conditional
if (to_typec_switch_dev(dev) == sw_devs[i]) evaluates to true and the match
function returns NULL, which propagates to fwnode_typec_switch_get() which
makes it look as if the orientation-switch was not described in DT.

This is incorrect, because the mux driver will probe a bit later on, but
at that point, the caller of fwnode_typec_switch_get() already got the
NULL return value. The NULL return value also does not trigger IS_ERR(),
therefore the caller driver interprets this as if the orientation-switch
is not described in DT, and does not return -EPROBE_DEFER to try again,
even if it should.

Fix this by checking the class_find_device() return value, and return
-EPROBE_DEFER if it is NULL right away. If the return value is not NULL,
perform the deduplication test, and if that test passes, consider the
return value to be already non-NULL.

Fixes: a53b4f9c51a9 ("usb: typec: mux: avoid duplicated orientation switches")
Cc: stable <stable@kernel.org>
Signed-off-by: Marek Vasut <marex@nabladev.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260817182302.146546-1-marex@nabladev.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -57,6 +57,8 @@ static void *typec_switch_match(const st
 	 */
 	dev = class_find_device(&typec_mux_class, NULL, fwnode,
 				switch_fwnode_match);
+	if (!dev)
+		return ERR_PTR(-EPROBE_DEFER);
 
 	/* Skip duplicates */
 	for (i = 0; i < TYPEC_MUX_MAX_DEVS; i++)
@@ -65,7 +67,7 @@ static void *typec_switch_match(const st
 			return NULL;
 		}
 
-	return dev ? to_typec_switch_dev(dev) : ERR_PTR(-EPROBE_DEFER);
+	return to_typec_switch_dev(dev);
 }
 
 /**


