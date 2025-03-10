Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE91A233145;
	Mon, 10 Mar 2025 17:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627804; cv=none; b=jmgUR7q+nitsJlfTcisiQeDAiN8HnOdjwtD6qz8mqira97CoM+n0nsP3wDwowGyqyZozEHtOu6ZezWpow6SGNDqWVfDRtnYyUpMOXpmpfjgM6r6gDAv46U/FDaz+KzPx3nx2Iig6wOtlwRdfecSeI0rBUldNjKgKM1Ekj3ekzpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627804; c=relaxed/simple;
	bh=Aay2TFQj1ZhmU9F35W8FtETXxv48fm+p6X6NkTfHoB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDMkOdGhBTWVK506k2V+QY6wa0y9vGQ2vO8AAGbM+1sdKIRoywa4MByiUmdzuS2iWXSCm5Y2Wh4LTOF3BGQlHqy9OG7TiIyaFbHdEJoaTcvQZYzbp8viG1F5vNN6xHd6ES44DMuh4fTFJ2QfcTh5A903iSYrMNKchRdRsXtTeTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vK4TeLht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vK4TeLht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4D6C4CEE5;
	Mon, 10 Mar 2025 17:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627803;
	bh=Aay2TFQj1ZhmU9F35W8FtETXxv48fm+p6X6NkTfHoB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vK4TeLhtDMt9jsbHYsK5timrGbY1xbICYgoogwj2bYKwiJxxBkq+qlz3Pgj4adSiP
	 ZptB3wACqi+nhfhvnGCrDQscamkIxqOcwNEm5utK5llsK8vMQ85xt+pnqng2BAUN0H
	 wePbiGES7fy5OXArtqPL2Gx5VArVdHdngTyzJh/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.12 213/269] usb: renesas_usbhs: Flush the notify_hotplug_work
Date: Mon, 10 Mar 2025 18:06:06 +0100
Message-ID: <20250310170506.180479545@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 552ca6b87e3778f3dd5b87842f95138162e16c82 upstream.

When performing continuous unbind/bind operations on the USB drivers
available on the Renesas RZ/G2L SoC, a kernel crash with the message
"Unable to handle kernel NULL pointer dereference at virtual address"
may occur. This issue points to the usbhsc_notify_hotplug() function.

Flush the delayed work to avoid its execution when driver resources are
unavailable.

Fixes: bc57381e6347 ("usb: renesas_usbhs: use delayed_work instead of work_struct")
Cc: stable <stable@kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250225110248.870417-4-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -781,6 +781,8 @@ static void usbhs_remove(struct platform
 
 	dev_dbg(&pdev->dev, "usb remove\n");
 
+	flush_delayed_work(&priv->notify_hotplug_work);
+
 	/* power off */
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);


