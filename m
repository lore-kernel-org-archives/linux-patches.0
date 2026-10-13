Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42BC199FAB;
	Tue, 13 Oct 2026 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895049; cv=none; b=WXxD1UTJFfTvMMoslbmTq3xU2phZ/yza3K0nHHW8Svqu9gl8uh2x55JdJtNoPWItJRxR0TD2E70y0LwPrFOcT6EmI8r95+hBlCdKYNhrEye1LoVlBoB5TUUkEkxM2+hn1SfpVzY3pO8ROFmRNEEg7hkVSods0QuvMCAMNgTsvbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895049; c=relaxed/simple;
	bh=++JeObfdB5JQ42U4mt8FrNbNKfwmesP6BPj7bv2qvQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfUxUnI1Y/fevzAYzPzujMyhri86GrGTtYADkCc+Khlhtp65BSqGETjqiYledjhz599QbA9LO23Q6bYbw4VWPe3GogvCI5rPBc3PH+l69Nig8k8VoZCu3rQlVY/q2ugon47miwyELxEO74t2cJYsa102jk7lZHlT/VWi5Roh2PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FXsnTO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FXsnTO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289AD1F000FF;
	Tue, 13 Oct 2026 12:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895048;
	bh=VxP0nZzPR9zDytOvgAuukVn8edloK6bGXBMPnZlHTsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FXsnTO4VGAMGC8kGser2vlqwrjnliudPy7i31N9s6cVNA2DQiX5V/4t/sPNBnxfM
	 LDeCrqrZit/zmBRsc+zVwungwCbLR2dGn+ACjGDFVWiV2xJXGCcF/NbZWOBVsRmxzq
	 zKxnlpb1oriidTa5EYvNPb78CpSjD5T1aDDO/19w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 145/497] usb: dwc3: am62: Fix runtime PM usage count leak on probe error path
Date: Tue, 13 Oct 2026 13:35:12 +0200
Message-ID: <20261013112911.328505570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -288,6 +288,7 @@ static int dwc3_ti_probe(struct platform
 
 err_pm_disable:
 	clk_disable_unprepare(am62->usb2_refclk);
+	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	return ret;


