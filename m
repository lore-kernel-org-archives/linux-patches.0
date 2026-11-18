Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052277;
	b=12sLjjxUDyhlND+WuXc3Ha7gdN69apom/HSQaolETPc2U2wKLrheb3V/T5F71XVm+mFL
	 bpQyRv488nEsLSSYybqGPg9U74VSR6u3/i+9XFaN8io6Gy9+ridKHD7MOuzQ3btnlfHxA
	 NP3VtrFyLdE2bTOYV0JkdInso/ce7eEUChfDXe8qy3fgOYxbG4VO4u7UiVbbzgkWeBEN8
	 lTgNCNqUyu0hoY/3h/D4RNQmAZDR4QbO1psG7fmVp7873L9mr6nPsWL67lqWzWiF0xXFw
	 qSfTpJmpbffgdq40pcRI50cBdf1DO9bN6eQ7qUEmyY9f2z748FzlKKBKmaLuqVmMCtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TKjAX7D2Pr5pvFHg8MT0YhViZH97/BzlNy5SsS11+dI=;
	b=abd9zgdyKm5GmiQkcASbVO0w095xBeBhWGc8KLJV6mtY17tzZC+3QBzNEcWNSr1fWUbU
	 wc8Qy2zAhSL48SG1oaUcGsNr+sIOufREy4thQPXTkUP0mdIYmgYfbFSYwifwU58rTUb3O
	 AOul8u1b1uugl03VtyeSLQpUtRYSSxE0+WeXMMVWOJB/R2L+Ll3DJU00Fz7xbuBZz/iMg
	 nk1OU/RI69JEv5BX5IERDc2pUKcJI45SAyC8YkLVtxJpNpjavh9nXF751YYnQPG2AbXmE
	 yzp1cKeK4/1qsEYdQfkhvMKruFEMXS4MQthomvYlosnE0tE+rHXae5URmi6ClRUo/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bmAK/Hcm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E7E606A32C;
	Thu, 19 Nov 2026 01:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bmAK/Hcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49B81F000C4;
	Thu, 19 Nov 2026 01:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052277;
	bh=TKjAX7D2Pr5pvFHg8MT0YhViZH97/BzlNy5SsS11+dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmAK/HcmJuwaUmXPMzrUB2e8WvgEBodGTsZyD1ZurapFefw99KgrHURx0jCG9Z6P/
	 De2CVbsmmu/v/olepqAIbc/VKymnWbtBqohC/c0t+msS2CplM5M9/oAfWOeZd4wmVs
	 cPOdlezc8c+8ORgsz7lG0dBOsbP4JUwgwNbJhDtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0505/2214] regulator: core: Fix rdev reference leak in regulator_resolve_supply()
Date: Wed, 18 Nov 2026 15:36:21 +0100
Message-ID: <20261118150031.348502174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 195bbe5e1c29aa1349655a6162958149c1176034 ]

regulator_resolve_supply() takes a reference on the looked-up regulator
with regulator_dev_lookup(), but when the supply resolves to the
regulator itself that reference is never dropped: it leaks on the early
return and is lost as well when r is replaced with the dummy regulator.

Release the reference before handling the self-referent case.

Fixes: 4b639e254d3d ("regulator: avoid resolve_supply() infinite recursion")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142810.2156816-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d711dbe59ac10..3babf26da8545 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2086,6 +2086,7 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	if (r == rdev) {
 		dev_err(dev, "Supply for %s (%s) resolved to itself\n",
 			rdev->desc->name, rdev->supply_name);
+		put_device(&rdev->dev);
 		if (!have_full_constraints()) {
 			ret = -EINVAL;
 			goto out;
-- 
2.53.0



