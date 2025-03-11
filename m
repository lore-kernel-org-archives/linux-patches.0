Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501B325E47F;
	Tue, 11 Mar 2025 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707546; cv=none; b=O1V3qv0KjjtyDsx7/AOwGhHTTUMEK/dsXhGXgxiEbmf+kGDmVrVbRWuUYcu9JGOWGo4UQUjcZLx1/4/GX1mfi3GU8NyQC2dr9qVEWS90gdW14OLTM0XXG7LTozC8TEDC3ftLH1iqqFzp8G7kmtI+2umk9MY5lwHK2l6nQ4MSB8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707546; c=relaxed/simple;
	bh=d9IU3pXkKNAgAIbgAmxYcVA6qlZoGRdxKcwzSnRyhZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM+2kBITkjTiVksN8WqF0bUtr/sXnjFuGchRtdyICvZ9wiZHSAxWqgwU61maU09Y6E6R21JO1D5SSNdsANgNs4m0g04uBG7CijUg8M5rn3PeGA8AijWggY/L3PBmqpXxXqVVw/qdbKbff6NM1gNkJuGN3kt6GhHltnwShW593L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qi9QNEqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qi9QNEqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5CAC4CEEA;
	Tue, 11 Mar 2025 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707546;
	bh=d9IU3pXkKNAgAIbgAmxYcVA6qlZoGRdxKcwzSnRyhZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qi9QNEqrayW2AdY5tC0+DMdVWjp9Lhe3WfzRcevFzwTAKVhYFlvS5ht6C7oR92qiw
	 1Tou5wd2B3+UJLzx457mvEoYhVihDx5xQxBBQnAWLnH2z9j4ty0fDslEvzu3MIbhph
	 iL6Ms5bxAQkD+Wd2LYcRIylmAInutLkicLo4xJsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.10 426/462] usb: renesas_usbhs: Call clk_put()
Date: Tue, 11 Mar 2025 16:01:32 +0100
Message-ID: <20250311145815.165452935@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -312,8 +312,10 @@ static int usbhsc_clk_get(struct device
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


