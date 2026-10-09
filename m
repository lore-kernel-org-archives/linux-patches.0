Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3173D9DDB;
	Fri,  9 Oct 2026 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556679; cv=none; b=okBlhL8c+kAnMwx7/JR9/Csc+UOubr/5afToJ0UDEZKMr02Sx6Lu7lEwtcwbvnIF0C6LpVEBDj04Dp4i8JbdyXOYpokl3hl4+uSdEePHLP3shkqpzd4CX3D+JJaDNXACM4b692Je73fgG7M+zNRXGI04nmjLlEaZU9NP+Dn72HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556679; c=relaxed/simple;
	bh=TdqyLAG/eXomE44sog9fRa1Xj4zfaIyNU627+wCqOMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7KrXKNqfcJsqOEMg7SdN1i8Z4G3zLElEAwaFqlMk9RXiQEZlvCoI9VLYdNoFh+5IpRzGCtl5hCc+X6XbLa9/zRkMGhXbxGL6bGSsEEz/ajZDuTCQn4+byAv/DuY9sVxnSZY72PjUEwd6n2oxyBzKndqUMarOwhHaI9QUqRJtbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdIsyrZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdIsyrZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DEE1F000FF;
	Fri,  9 Oct 2026 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556678;
	bh=xtEdXqm5ageo60VRElFmuDN5DqxVMdN28bX8wshPwQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdIsyrZ+Gp4gt7xQCkKrCwH1WJ8sWdkEXrPmwywe3zObOK4G20+xCgW8YAO3kQmsY
	 VBoDNM1q/LDDM7J+cFCO4/PyZU2oZLtr0QargQJzql7zeFAbqXxIaACH7CBpCeUcn/
	 SOzCFjfT5s+Pdc3v4ingIyDCbGg4My1ExpgyM8oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.2 219/428] usb: dwc3: am62: Fix runtime PM usage count leak on probe error path
Date: Fri,  9 Oct 2026 16:09:16 +0200
Message-ID: <20261009140950.932139175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit 3d9bbf0ffeb9b7ac1b6ad06b52e037870a7e0c63 upstream.

dwc3_ti_probe() takes a runtime PM reference with pm_runtime_get_noresume()
before creating the dwc3 core child device, and releases it with
pm_runtime_put_autosuspend() once probe has succeeded. The err_pm_disable
error path only disables runtime PM, so the reference taken a few lines
earlier is never dropped.

The usage counter lives in struct device and is not reset when the driver
is unbound, so the leaked reference outlives the failed probe. If the
device is probed again, through a manual rebind or a module reload, the
counter starts at one instead of zero and the pm_runtime_put_autosuspend()
on the success path can no longer bring it back down. The wrapper then
stays runtime resumed for good and autosuspend never kicks in.

Drop the reference before disabling runtime PM, matching the ordering
already used in dwc3_ti_remove().

Fixes: e8784c0aec03 ("drivers: usb: dwc3: Add AM62 USB wrapper driver")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260902-dwc3-am62-rpm-fix-v1-1-7a2807e33307@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-am62.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -297,6 +297,7 @@ static int dwc3_ti_probe(struct platform
 
 err_pm_disable:
 	clk_disable_unprepare(am62->usb2_refclk);
+	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	return ret;


