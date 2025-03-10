Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3961C3F34;
	Mon, 10 Mar 2025 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630924; cv=none; b=c+aTi32ENHcBCUPQpUKnh+H3EUX1nm9IJYqaWAQYPl+gY2R/KDBIs0amYRJAcTCwVge6Zw+ZoRPvtdm5IkaJVHdQ9n+0EPT1Nqdvlz8miP+2gbNVG886u4R2EbjRWnaF1cLi2yINuhIkxE7YHjImy7haYFG+cA9nLsXqcMUzOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630924; c=relaxed/simple;
	bh=yNAWlPCvcTASrILR6GIMRPysVVkhGH1wDM6PtJzr5lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn6mt4LHZUfgSFsEOk7fS0qs7SiNLWFEAfHsm/sn3ifDgQdgkdxZC8cwR+PxT4+r2wFEyvrt7kjR3wRuOYJUvWJSds5aQvlk235tvAz+XOS9FoybHu3ttSWe1SehQi4n1cXRQQ9u7ovRyWupNKiDXJyv9d/JqhqBv7LFv/qJ0+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uM7UeOMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uM7UeOMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CFBC4CEE5;
	Mon, 10 Mar 2025 18:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630924;
	bh=yNAWlPCvcTASrILR6GIMRPysVVkhGH1wDM6PtJzr5lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uM7UeOMOGqSLXpoaYZQF+3jIhTLS3ccS03STK+iYY92W7W6hOp1eeS6iH2NukY/oE
	 n/dVje3GW98jmO4RCUxQO+pmM150WAnJW4ezuto1GVmOFHZXIwFuudvr4yMVUxxhAV
	 7sJwhtlul8Qqpb+WftFZPkyEYcsSdhbJsBuLjJ+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 5.15 581/620] usb: renesas_usbhs: Call clk_put()
Date: Mon, 10 Mar 2025 18:07:07 +0100
Message-ID: <20250310170608.469737838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


