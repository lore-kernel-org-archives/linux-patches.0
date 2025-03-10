Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5055B22D4C3;
	Mon, 10 Mar 2025 17:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628465; cv=none; b=QKM+W28XzZRTXvApgg8NlphzAIxxU4MpCopIxsoMcY9xlUNUNM6kKwfQJBY704RumO9aXT6MGw9Rzh0RRHTMmWHWHFu83HtnNpOdfxo1HCKX2wW70TPvt5Hd1MfHcFdrXAtZCtVSaGDW9bjeywWfBS6WMJXKbw8p2EmkoZyPt7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628465; c=relaxed/simple;
	bh=4s3gU41rPPtxeCyyVzxZ7oTJRv/yddpDYMUZ29iyIQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egkbKBBBITmXuFi2EU6xPcT77c0uc6q3fS5t+Uw7CSGevzlmu/ivpw6S/3z+MMSzLLj9T8tMWJqktYX57YP1pKnQWmUy+L+5HoEVnOanivd05D7rUBFUJlT+LzsEqqR4RqO5Ek3n60aa77cMT4eslGIXKf3idC0VhRgA3pA8R2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVceC8Ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVceC8Ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF214C4CEE5;
	Mon, 10 Mar 2025 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628465;
	bh=4s3gU41rPPtxeCyyVzxZ7oTJRv/yddpDYMUZ29iyIQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVceC8Ta6zQ/FNUJDi9uQ9pWkM6Oz4ceKoUX/9mMZ65DR1CRrMlHmv5LO9S38ghTb
	 w8TonEx/swFBLh6YKZBX+4gg4T4rfajn4KaxH2LM7GKvbRUhN2AkrKiNC8FZM4aMLG
	 1C4ptcVNjPrB1r/s3aABPvxe7qw/XtMs34aDBCuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.1 068/109] usb: renesas_usbhs: Flush the notify_hotplug_work
Date: Mon, 10 Mar 2025 18:06:52 +0100
Message-ID: <20250310170430.269963168@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -770,6 +770,8 @@ static int usbhs_remove(struct platform_
 
 	dev_dbg(&pdev->dev, "usb remove\n");
 
+	flush_delayed_work(&priv->notify_hotplug_work);
+
 	/* power off */
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);


