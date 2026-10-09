Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32B93EC805;
	Fri,  9 Oct 2026 14:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556102; cv=none; b=VRZx8oZ+U+PaHv2p1Bzhxbbg0vMQe3AMBX+bhFE7ZrE2iFZtZysL6Iy4D4j1B2HL7ApvcvU/XVoYS8lMG9bs+9p7Ec9iZuIf5uYO3IEGNV2gGlT9ljkYWoPM5b/5cPNAGBids9/iBWYNhe55wuIEEgIp0NhC+kd+CVqfzkcqgGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556102; c=relaxed/simple;
	bh=6rGIG4YGFoyL1K+EEujynaC0lKm9t1W2rMiIK0ouuSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duQMI1tgxPUZLn2YpJv9TQOUGCek9vT3pBX57vW2nizQjzd0+nPTtvkm+2wu1o1Mh/P+I35tfu/RhVh5XSMyET5cfs92zCL6N2jMuDCemQJpuakiEUtNu4m0tpc2aRgw8FyGvHGnx42V1oPn1VjkgiA9xaTi+IW88qiojDLEAVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsQCuk6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsQCuk6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B641F000FF;
	Fri,  9 Oct 2026 14:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556101;
	bh=APdvnH/WLsD7WeUBt/ocYpj40fk2+gBhDsKm7fBgpGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsQCuk6CKGdBulxHT+KmMp6oLA4V4pvpt0umEBxhfSEpc4/KGBGCTpUg+ajv5p9Sr
	 ymrM7BCM0sEDN9KWPAsrtltW12AKuqUG8unJwZYN9LhoMnIoJmWh9oLgM0JYE4kQ0W
	 IsiJuwVyKDo4oIXE+9gHc9SCcYi5kWCbegjXCeZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.18 174/403] usb: dwc3: am62: Fix runtime PM usage count leak on probe error path
Date: Fri,  9 Oct 2026 16:08:55 +0200
Message-ID: <20261009140956.184362394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -298,6 +298,7 @@ static int dwc3_ti_probe(struct platform
 
 err_pm_disable:
 	clk_disable_unprepare(am62->usb2_refclk);
+	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	return ret;


