Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53725231A51;
	Mon, 10 Mar 2025 17:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628121; cv=none; b=qjLMfvj209iIJK2WNVS4NFai2Ndq8xdHdwWBS/8TYPICe31yjgCH9dUfMnZeTH3ixQ4gGJLLzZ7bQ03WvVbbjuUnenIauaaeooz8RVxgGAygnjhKvIBt2TNpOr0vJnSv5H+Mleqep4MxOzw9XNIHiXx2UZ7lm+vMQF+2yBsFLT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628121; c=relaxed/simple;
	bh=H91Eu9/JbA0+d+FMpzSpsWbiZH9twQH+BcW8JKrzOdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZw0P1vkd7Z2hL2WK/QZ5fqtOyzFLrSdiQtY/zqspR+4mN1+1th8EDk/Mtt9C9/VxuUT2K5XAiycZL9hO1VqpPcnNw41uuGS9Pr77Jd1PyGuBqdT2L1Ti9HM39/BnMYCkFQKC8jqAA9p05OQ59zgB8su4UAqtKQsRvOV0iduY9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgFVMs+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgFVMs+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00CC4CEE5;
	Mon, 10 Mar 2025 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628121;
	bh=H91Eu9/JbA0+d+FMpzSpsWbiZH9twQH+BcW8JKrzOdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgFVMs+PmHAWuYtM/G111nt8nhJba/J9hRlxANM58Y8KAWPlwZkX034HpkSD7inc5
	 F3E9nKyQSeqXsuTQ4KP+Vwjq6EIOiU7IPT3x5Zr1QTzMvB9lN0dsS34uk2cEIaO51E
	 7o2JIZ/FRHy/WgWa3oT/eOES5yHa0hp7bkl7rn0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.6 093/145] usb: renesas_usbhs: Call clk_put()
Date: Mon, 10 Mar 2025 18:06:27 +0100
Message-ID: <20250310170438.510696462@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


