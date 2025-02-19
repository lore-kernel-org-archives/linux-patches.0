Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6911A314B;
	Wed, 19 Feb 2025 09:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956657; cv=none; b=Mh9Spv/RB6pe93vplGAkkXYamaP9CgjSW0kocpo/nJ3LaXo24tIpQACdSnqWk7qUvt07b1/oEZdX3RRNXgWalAODqntk3t6UJ0B0AXBgGYCZqjU8hwOFnRnrxPqAxsN9dQZAM4QDrj8UfXktvj76aAdFEhDjyNBffhwldTJM6ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956657; c=relaxed/simple;
	bh=Zysz4vDOMQ22PDPqPtSojruqg3rriIsQQhiOVubAOPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRHcKlH9RzdHB0xUVGbQqve+D9lkKFNBgap83rw5yAFBBvkofxCp7cRX3/hIMbOH7w5j8r8eupovl5vD5vZeeDsXptY/upiXgfnygige9r81OFb/iRh0JUX0OyYKwDTfKOooAig17rNsnRcOC9FYBcZBgCRaQWo6XEIZrGzxKog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7+GhGWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7+GhGWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF536C4CED1;
	Wed, 19 Feb 2025 09:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956657;
	bh=Zysz4vDOMQ22PDPqPtSojruqg3rriIsQQhiOVubAOPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7+GhGWZyQt4zYTO11iXmpYFtK6Hl7n22hGCSRs8PUWuHe0d/uxOiHvQW59ygy5UA
	 gTWo+EEXAknAFBepts1maSCndXgfAHLAt68S6JFOaqweI1iEmu7pwpUh1+OPObBI9x
	 cDxUnR5AIZzZ+HJkkuQMnf/7VLGdKHjD+tXfSccg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 255/578] usb: dwc3-am62: Fix an OF node leak in phy_syscon_pll_refclk()
Date: Wed, 19 Feb 2025 09:24:19 +0100
Message-ID: <20250219082703.059894372@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
@@ -146,6 +146,7 @@ static int phy_syscon_pll_refclk(struct
 	if (ret)
 		return ret;
 
+	of_node_put(args.np);
 	am62->offset = args.args[0];
 
 	ret = regmap_update_bits(am62->syscon, am62->offset, PHY_PLL_REFCLK_MASK, am62->rate_code);


