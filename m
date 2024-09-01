Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0591DFD1;
	Sun,  1 Sep 2024 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210504; cv=none; b=Wnp+DRtpUKFK+GdF7Czffy9RgQ3Ti2GUYwGNh74Zp0WRAQ3yyxX1uQtKL1/U67BPKDLMKdj+nJfxfMaDhJwZfnomETJUAC0qHV4VpOSA8yDPIxq8nGCWGK3MsoUDTvtNl4ntgivVJZZ3lt1PU1dZy2Q7X7Ljch6hg+P1ZS1hBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210504; c=relaxed/simple;
	bh=nP2dcNfMWzln7cdW/+pEJi/C3piFyrhrT35jBrnAwLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKPPb/5z0foHI5QTUaOWr6K1996vkWCVc0i+Y4SDqHn4X5K/k/pPbbNRI2cS0xddQa+zFBM3BS2QKLyN9nCv7o5Y457sfbQH6uSeoNlmPSXXvOo/3N4c7jxP7Wf8PAsmP4gmu8IRPn9DH9bbxG/SkW3OnBZQSVp2NQAIxABIBS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CorTJmNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CorTJmNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D44C4CEC3;
	Sun,  1 Sep 2024 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210504;
	bh=nP2dcNfMWzln7cdW/+pEJi/C3piFyrhrT35jBrnAwLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CorTJmNLkBucIJTOuhlG4r6GkJyhM96Wey+TyI5sXcUWDKgVHP+1ay61vGuNfC3sc
	 eO2bAmXmHZydIRBF22lIiUYMx1khFFO0llUPg9JHs0Pu34LKARoGWw8A2S+vbSZwqo
	 MuCvyV2KPvI8y8jgKwIqnfR7TNjeBqQ8jEDwo+vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 178/215] pinctrl: single: fix potential NULL dereference in pcs_get_function()
Date: Sun,  1 Sep 2024 18:18:10 +0200
Message-ID: <20240901160830.090991964@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ma Ke <make24@iscas.ac.cn>

commit 1c38a62f15e595346a1106025722869e87ffe044 upstream.

pinmux_generic_get_function() can return NULL and the pointer 'function'
was dereferenced without checking against NULL. Add checking of pointer
'function' in pcs_get_function().

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 571aec4df5b7 ("pinctrl: single: Use generic pinmux helpers for managing functions")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://lore.kernel.org/20240808041355.2766009-1-make24@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-single.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -350,6 +350,8 @@ static int pcs_get_function(struct pinct
 		return -ENOTSUPP;
 	fselector = setting->func;
 	function = pinmux_generic_get_function(pctldev, fselector);
+	if (!function)
+		return -EINVAL;
 	*func = function->data;
 	if (!(*func)) {
 		dev_err(pcs->dev, "%s could not find function%i\n",


