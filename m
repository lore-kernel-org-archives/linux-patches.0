Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A9C17C79;
	Wed,  5 Feb 2025 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768564; cv=none; b=rjrKlAIPMkcyP0a/U72tGncOdJEPevVHX75atTvQijWVwBfjQ7owYQrF4HwTjaxX+s+fxEtltzHrJCmef+nD3f1OEdA6U8+Y6yPDLcG3iv5zAHNruYOIWZaSfnaslTz/F5Iz/12qCsUMmNlkTPto/YmC53fB3S0CvHhq29LTmcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768564; c=relaxed/simple;
	bh=sZ2Dlzmb1Il/SKkvDrs/RqvG9mTFlaz27EUp+X/cpKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDAugbOfrhsvfH4M/zsMR3UifuLCRceWzuV0x9NIgGQWCqC6e/sjoPvlLW+V/Qwty5LCfWTlnpsnf8m6Vlt+3OtRG1AOnczxhAMIA3xUF8rj6ltnDiqcseCjGqU75weMV8cw8tDHY6g6j4TnqBjotNHKb1+xs7AvhZjEsWr1/nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dwrq+5xg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dwrq+5xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3C5C4CED1;
	Wed,  5 Feb 2025 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768564;
	bh=sZ2Dlzmb1Il/SKkvDrs/RqvG9mTFlaz27EUp+X/cpKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dwrq+5xghVBS9px4I5g/cJHblfL9SKQH3JxHxZ6LKUrNx4+PfVkoeJm7AmCw3otj5
	 r2d9H0ff0CZJm3In7CD9KYiY2KhB2W2aa7/4rz5mKIn5ZGtO9pBi6U5ymf/fn4OE4K
	 4OnEhbyrv4TjZJ8A5aBWwF7ockot0PAgumvcunWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.13 593/623] usb: dwc3-am62: Fix an OF node leak in phy_syscon_pll_refclk()
Date: Wed,  5 Feb 2025 14:45:35 +0100
Message-ID: <20250205134518.912425024@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit a266462b937beba065e934a563efe13dd246a164 upstream.

phy_syscon_pll_refclk() leaks an OF node obtained by
of_parse_phandle_with_fixed_args(), thus add an of_node_put() call.

Cc: stable <stable@kernel.org>
Fixes: e8784c0aec03 ("drivers: usb: dwc3: Add AM62 USB wrapper driver")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250109001638.70033-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-am62.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -166,6 +166,7 @@ static int phy_syscon_pll_refclk(struct
 	if (ret)
 		return ret;
 
+	of_node_put(args.np);
 	am62->offset = args.args[0];
 
 	/* Core voltage. PHY_CORE_VOLTAGE bit Recommended to be 0 always */


