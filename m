Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47408192D8A;
	Sat, 12 Sep 2026 07:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197998; cv=none; b=Z6xd+Y85TAZhmzhDVAVX6nkXZn2zYDt5dfHt8WgKyeI+Sneug6vQFuBPh5DRfb757oMbZzU3OCgBRLtvsali4mfX6uvPIvS6Jso4dRHqxjDLztKwhsUAlu1BSi4Ixb9OpWTPTLseanqAae3wDn4iGMfAotdMXneHgYsB4bFWKoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197998; c=relaxed/simple;
	bh=t1HkcIMAb0pWhbT3CLy0LvAZxOX4ySyYc9Jnuy6FSBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvNTgQ6zK7zCcEW6vnhXVvC4nLxEt1VMfJ9GfIpwYBQKAXj5UmACqYQMfLoLSbF/n5CPureYcHEKM6mugGXiX68tumXmVGtmkKSGH7yL0MgO+zNcSr7N2UESgFJThZeUIOK/4VHh5Kt4y6nKkx1YKBid2KSF/0ZZeWUfNVcoBmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNqOtUEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNqOtUEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BD01F000FF;
	Sat, 12 Sep 2026 07:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197997;
	bh=qSmbKsOyDIYDh07zq+anGC24djscxLA/5WvMj6M4be8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNqOtUEaZ2ADWpk98u8oqIRMdQj5bWK8Uo9x3pr1HLRJQG466uzzuwnmCxjXO9E9N
	 67QW3OtfsZSzgm3H+LmLzJ55LhpoLeIw8YZq9u1bz5hTNfViFjeFhoV4nzcZOo4bi1
	 SOSmk87KgzZXyR0dNrIQvR6Bu1s7ZaD0KcOSa1B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Slavin Liu <220245772@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0273/1815] usb: gadget: r8a66597: avoid double free of ep0_req in probe error path
Date: Sat, 12 Sep 2026 08:33:43 +0200
Message-ID: <20260912065655.377089020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 41d541e3718db01668a4cd29815ee4b3b55f76d2 ]

If usb_add_gadget_udc() fails, r8a66597_probe() jumps to err_add_udc
and frees ep0_req, then falls through to clean_up2 where ep0_req is
freed again when it is non-NULL.

Remove the redundant free from err_add_udc and keep the cleanup in
clean_up2 so the request is released exactly once.

Fixes: 776976a67ae2 ("usb: gadget: r8a66597-udc: cleanup error path")
Issue found using a prototype static analysis tool
and confirmed by code review.

Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Signed-off-by: Slavin Liu <220245772@seu.edu.cn>
Link: https://patch.msgid.link/20260624140908.1282-1-getshell@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/r8a66597-udc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index e7a5d8553c0ea..d190e16d43fc0 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1951,7 +1951,6 @@ static int r8a66597_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_udc:
-	r8a66597_free_request(&r8a66597->ep[0].ep, r8a66597->ep0_req);
 clean_up2:
 	if (r8a66597->pdata->on_chip)
 		clk_disable_unprepare(r8a66597->clk);
-- 
2.53.0



