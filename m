Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EC22253FE;
	Mon, 10 Mar 2025 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628251; cv=none; b=A264cVDOCYTseEZsTXxzwqIDaVqHbgIzHXdh26s01ZoHft8fz+eJdzBIg181ZeO/18J0TWNGVZghgiTp3sLgcClaSGwG8B/7oO7diRe87Otu0sK7cdOQwwoGxzkW9c6vxbw2KFWw6PmG4epUea4DGp3JT3uk8l9oFhbNPQhnIRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628251; c=relaxed/simple;
	bh=Y2e0JBgMbBTyrCIZvM56hUiNbbNHFCSk/EkyCICD/7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0iIyAKWKDLhXeq2xpsb3IHyrLY25CSJBAiuN+Vdor4nUV33HGPukPIjsCWi+y8LJ9zMa0vDvROGir2UmjXzml8LtjO5IuiNHvV1KJNyck994WB18zVsrj0BDRsD952SiIHW0O8e5H4VohkTEBJVYGSssBYZO7LvIiV878xyMPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIKj2HSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIKj2HSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464E1C4CEE5;
	Mon, 10 Mar 2025 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628250;
	bh=Y2e0JBgMbBTyrCIZvM56hUiNbbNHFCSk/EkyCICD/7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIKj2HSAR9cLEbYAa3YYA0YEWvYxuH8/x3vvyMOdotTP7Cc/JOaB7NTHnm2VOHtDC
	 s4XK/Mkg2RHkuS4/laB68m+FyZ3BzFX7pe+n364HBT0UDY9nogTUG+ZeDSI+4epCvS
	 tIEOixF2gsxxeh5y1HffSqhipBUM3cNe5KEvH2ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.6 098/145] usb: renesas_usbhs: Flush the notify_hotplug_work
Date: Mon, 10 Mar 2025 18:06:32 +0100
Message-ID: <20250310170438.709629587@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -770,6 +770,8 @@ static void usbhs_remove(struct platform
 
 	dev_dbg(&pdev->dev, "usb remove\n");
 
+	flush_delayed_work(&priv->notify_hotplug_work);
+
 	/* power off */
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);


