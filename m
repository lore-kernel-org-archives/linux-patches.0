Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63FB230BE6;
	Mon, 10 Mar 2025 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626900; cv=none; b=Cywkex/8Xr/7eu+f2fB7jWpJCPOIQXmtxxqLWhCFOWcE388YcmUxGiNnXDpd0zSwmwXlQu+Vgz4a+HEwz39cB/phBo79nJTXg8V8Ns3os6NArM87J4r9tz5UzBqlvnkkEqnNmELIKpVHP/UAl6NMUQtzJobEZ+XOBLROD51MhPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626900; c=relaxed/simple;
	bh=mY2qvHevQxthjQKGYM0ASLMeINxY5CDFiVgssH01xg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqxAc2tppJcQahkcSOgTDDGtrrc4yG861H85IGp/AhJVL30FNDByo1v7ow+/NBYghHXvtxYTmI5IOE73+maN4PB51Q8FTywaWNRziQ9esbq4P9HDFCdCfU/b34gJHj80GOnQn11CqV+dxx5iif49WBNoIv1igaAZERaWWFjS9f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiFu5+q4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiFu5+q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7E0C4CEE5;
	Mon, 10 Mar 2025 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626900;
	bh=mY2qvHevQxthjQKGYM0ASLMeINxY5CDFiVgssH01xg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiFu5+q4Dznr8fcmLMtni/d78RIKUWdwve08m5SZJsAFY6r5jQkFa6XN4/5C2jl3k
	 TQzM/R7Z7YBroBZcliqJuD07B2La0nlbhmtCUuPMbKawcA0Cpqu+vExaGj6zrClLL/
	 LwGjfCuYv/+jL1TKyY7qoRWhQ/M59sfi5T6KTtU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.13 152/207] usb: renesas_usbhs: Call clk_put()
Date: Mon, 10 Mar 2025 18:05:45 +0100
Message-ID: <20250310170453.839249198@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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


