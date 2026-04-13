Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAB324DCF6;
	Mon, 13 Apr 2026 16:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096955; cv=none; b=T3HF8CO67286fMzJ0C8xf1PhIpOlY0ir39IJADa6AoeAtpbF3Zzfulxb3WrYiafk3/sibgRBS/AMhSmAlJ+Sel67X+FLDR5b1VcUAlNu9J/TJs9m1b0xOjB2TpchkRQ1WVoxE6sGjn6P0BXkMmEzeqEFNEzVZGI0K0LWUq5Zi9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096955; c=relaxed/simple;
	bh=cZ01T/+YAYgyhxYjp7uWYhQ3vXvQ0MK0Xd15oyOSL+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avNLPFusLY1B3AZJPlV6vvtP16M0ZXlT61GdGkD45YO0MpEX1NN6aGLtE5MHL1CE5HDPKJUkehhqley0a/zsgXGQ1cFlHhsQ0rv7Px271GmaDbxbiMrFlC4vcVU1Guek+Qfy8YXOk3G69s3MUcwM+V/8GW5zlqxfUEyHvUct+tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPpY+9WF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPpY+9WF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4939DC2BCAF;
	Mon, 13 Apr 2026 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096954;
	bh=cZ01T/+YAYgyhxYjp7uWYhQ3vXvQ0MK0Xd15oyOSL+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPpY+9WF3NreLS15f741JwKcNeouuKJkev5IVPsXXZS7QamTJSNBmgLbrTzAaNdXC
	 qWNXY0aPbtbSRLt1KIDqy6+2aaDePfWKsObz5Ix6ksveILZ3t6TKIOqEnSuyhfzqks
	 zH8GeJCKGD54mZONy0znmezhcCODITDjAfEQV+/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 38/50] mmc: vub300: fix NULL-deref on disconnect
Date: Mon, 13 Apr 2026 18:01:05 +0200
Message-ID: <20260413155725.935894588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit dff34ef879c5e73298443956a8b391311ba78d57 upstream.

Make sure to deregister the controller before dropping the reference to
the driver data on disconnect to avoid NULL-pointer dereferences or
use-after-free.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2369,8 +2369,8 @@ static void vub300_disconnect(struct usb
 			usb_set_intfdata(interface, NULL);
 			/* prevent more I/O from starting */
 			vub300->interface = NULL;
-			kref_put(&vub300->kref, vub300_delete);
 			mmc_remove_host(mmc);
+			kref_put(&vub300->kref, vub300_delete);
 			pr_info("USB vub300 remote SDIO host controller[%d]"
 				" now disconnected", ifnum);
 			return;


