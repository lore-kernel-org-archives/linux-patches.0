Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1717C79;
	Wed,  5 Feb 2025 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768120; cv=none; b=gA/PhIRa6Zq5bmdPt41cKgeXVatSN9FvkluZKWa8m/DJGrlFfTQdlnVw+kzyNZFkAbCPxkwSI4HJuz6CywrLyTTQGi1F/d3tWEOhbzS7xTmAYbhzncRPIw5hu1rTEjhYWxNKPLWtoXf5MH/D6f3PQ6m8HRf1cNtRUg0s9mWxTeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768120; c=relaxed/simple;
	bh=IMsqBtmAIh4Hhl6VA4OL9h43O9zOg0Sct6KUjCRXDwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXlY7V+vNBEQjtO6NSU36z/sMKVniF2yMXjHgdYIIbQhQDh8RSq7+217sKAG/WztGdEXJmI5C/RNigwBALBJslT57Qm2+R3e2coyARxVNP0ijARpE054mlSZIXOU0QB3mU5jswlUm3lPc0NKqL1RL8aBYDt40U45rRAfPbSe74A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WerBd2fB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WerBd2fB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E8DC4CED1;
	Wed,  5 Feb 2025 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768120;
	bh=IMsqBtmAIh4Hhl6VA4OL9h43O9zOg0Sct6KUjCRXDwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WerBd2fB3j6+c8I7blopyOLdILWV4PUrNKoxhAg1So4j4Ok9R6UXoRbHpvZ/+m2qf
	 QWOButVeGnCLgeCdGis6awNbP0WJLJZPnEYQRcGYPQqbLSlUn8Q67HLxUmjpj14oIy
	 CTPl4RI5f1a3zhUDlWc1wiADafuZqmE3Mb9T3o8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 556/590] usb: dwc3-am62: Fix an OF node leak in phy_syscon_pll_refclk()
Date: Wed,  5 Feb 2025 14:45:11 +0100
Message-ID: <20250205134516.541651659@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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


