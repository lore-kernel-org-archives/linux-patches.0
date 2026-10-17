Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44353394785;
	Sat, 17 Oct 2026 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256530; cv=none; b=TNjzLg1ejQ5sdH5NgrtgSx/JpJJ3aq0B+Wr1hnZkjIiEcXwqLnNt8oCzqB+1MZNRF0xlMKWqaOF717yElO0+bpmUFhfPFScVE0kqRMvTcI8UDWOfKtl18GVtIMvwOmZgBv3u0OAvZqex40WLzkc7EXasjmoujgicPFhabxLJ39U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256530; c=relaxed/simple;
	bh=KoTLZDGynvCrpbh7ItRY9DaQo4PlWbGq1gm1SK9+5wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnOLnjNjnl2/+UcsyATAhIqOyb2gUls/J0PqOPnaR9n4UOUHvKHyJVtdcRP8YXBBATuy9Q6u/6O5uoivkK3N4fuQqeikwSlDNqepoo92DKx5mc8HSD+v8x6yjJxkxpDiECfkRuXWxYeIOdGTEBNICf0ksoDGUYEybQL2jA+AOs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iv2IpPZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iv2IpPZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF411F000C4;
	Sat, 17 Oct 2026 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256529;
	bh=fjOVwMPlXZpztITJmSZzUuQkKcf5w0s6vhMlqxjq7EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iv2IpPZKnfEXNKQixRIet/HOFlelBYtmFR3ggfBgbdyDWK1/DGu6ItJWr+5i0nVd2
	 Rn+xWfyCf1k/wcj6E8yxq8v7BYPjDiw9+nPo34F+3P/CNU9dnzRu5d6TxwMYzo4Baw
	 TQv8vz07iGGyCR0fVocHNHdqGPL2Pc54CktUIvdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 0267/1674] usb: dwc3: am62: Fix runtime PM usage count leak on probe error path
Date: Sat, 17 Oct 2026 17:42:19 +0200
Message-ID: <20261017160437.975629566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -263,6 +263,7 @@ static int dwc3_ti_probe(struct platform
 
 err_pm_disable:
 	clk_disable_unprepare(am62->usb2_refclk);
+	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 	return ret;


