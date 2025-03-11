Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDB91BD00C;
	Tue, 11 Mar 2025 15:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706304; cv=none; b=LVr1V2L5Jo/eG5pBP9MnHc9HbiD4DBPAs4Inrni9Q1eBVwOZ8Z16HGptWB+sdZVW90qn1fRMjczQMuF9xwKgxPGuQkRd4mpd2Gfkxlg0SiQSdZAQEzuXbNqp20aFCmOBaLB69YjSUSNpDKb170JtNwSI4D1I7/XENW0i9yCsWfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706304; c=relaxed/simple;
	bh=dILFDyXUmO56rmXeSGFC8P7uJG4XQYgnxQhXs/vFCEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD4QzVuV1eRo0WeAV1oNaGzTffpCscsd3+L8TEvN3fNBoKa+ycdWEwCUReL4rdyJtQZYylfToaupkhDiZxwolXlFGvu7Y9iCBnQ4z8J3NkWrOYyiG95f/1PBmn/4UieCWE4sabmC4mg9kRFIPvr66fFcTy/hLL68DFVcSvjC77o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaniy4D9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaniy4D9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7917C4CEE9;
	Tue, 11 Mar 2025 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706304;
	bh=dILFDyXUmO56rmXeSGFC8P7uJG4XQYgnxQhXs/vFCEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaniy4D9Zgqik0fNlTlAP8vJI5K7hjFZb9SNPLiof0HclWIPobOIOy6pKEmuXut4t
	 S9HoMj9Xs6sk5iHx2feVau4GUc+YfgC8mcTMH50BzF3TsgnT0b568rWVG4rHyELvG+
	 83nylknaxLJ6EScrloyymcl31z+R7s+mhaS962/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.4 312/328] usb: renesas_usbhs: Call clk_put()
Date: Tue, 11 Mar 2025 16:01:22 +0100
Message-ID: <20250311145727.307688705@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit b5ea08aa883da05106fcc683d12489a4292d1122 upstream.

Clocks acquired with of_clk_get() need to be freed with clk_put(). Call
clk_put() on priv->clks[0] on error path.

Fixes: 3df0e240caba ("usb: renesas_usbhs: Add multiple clocks management")
Cc: stable <stable@kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250225110248.870417-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -313,8 +313,10 @@ static int usbhsc_clk_get(struct device
 	priv->clks[1] = of_clk_get(dev_of_node(dev), 1);
 	if (PTR_ERR(priv->clks[1]) == -ENOENT)
 		priv->clks[1] = NULL;
-	else if (IS_ERR(priv->clks[1]))
+	else if (IS_ERR(priv->clks[1])) {
+		clk_put(priv->clks[0]);
 		return PTR_ERR(priv->clks[1]);
+	}
 
 	return 0;
 }


