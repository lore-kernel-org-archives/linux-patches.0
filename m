Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFACD1805B;
	Wed, 19 Feb 2025 09:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956298; cv=none; b=TlD+aC358JMT/veBK44opx3auNJd3wM1qNVUoaxHjggeti4PMcilZF3rfSDVDVTRapaRIXVa4qdBJxOUM6str9PZAf9S8CLqohB7YEArzxPZprM+blze0o6lWUdxlqBI22DNYrjvOh2NC26fU3ZeOGbJNPBOT4RhcCBe9iQ+NTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956298; c=relaxed/simple;
	bh=AtKd4lQADqnrLHB5Sg0GX4PrLYE47KibRQ33b1Gzni8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4GEVSJwqmRiPk2yMVJRMvXoNcCeZQCtGq1edwHifP8vPG43V2TMZbQBuOAzCfkhg8Xxmk4Vx2lgUwv7uLCCkoY4xFfFtR9GCVKlnTGG73yPiHIpyxUpABV/uUmie7ZBS5espgv+4tKK6o4WGnNvBSek6IFS7folLxQpsrW9qAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYfRZBMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYfRZBMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E8DC4CED1;
	Wed, 19 Feb 2025 09:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956297;
	bh=AtKd4lQADqnrLHB5Sg0GX4PrLYE47KibRQ33b1Gzni8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYfRZBMKq0cw8K65Zg8cjsU+5czuTKP8Hee5frcYdqqhjXuHsFyinWy24NxxT8JQo
	 uGyJPbT0YYUNPZCKM/YvfLiK4XJfKzQlPLLgRCUDqU+qsycONLAZvN5TWaxB2viqyb
	 nJHsgcXYrSa8lZCpUteUlop+mSD+1JdsIx+IrT4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/578] soc: atmel: fix device_node release in atmel_soc_device_init()
Date: Wed, 19 Feb 2025 09:22:16 +0100
Message-ID: <20250219082658.181271364@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d3455ab798100f40af77123e7c2443ec979c546b ]

A device_node acquired via of_find_node_by_path() requires explicit
calls to of_node_put() when it is no longer needed to avoid leaking the
resource.

Instead of adding the missing calls to of_node_put() in all execution
paths, use the cleanup attribute for 'np' by means of the __free()
macro, which automatically calls of_node_put() when the variable goes
out of scope.

Fixes: 960ddf70cc11 ("drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241031-soc-atmel-soc-cleanup-v2-1-73f2d235fd98@gmail.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/atmel/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/atmel/soc.c b/drivers/soc/atmel/soc.c
index dae8a2e0f7455..78cb2c4bd3929 100644
--- a/drivers/soc/atmel/soc.c
+++ b/drivers/soc/atmel/soc.c
@@ -367,7 +367,7 @@ static const struct of_device_id at91_soc_allowed_list[] __initconst = {
 
 static int __init atmel_soc_device_init(void)
 {
-	struct device_node *np = of_find_node_by_path("/");
+	struct device_node *np __free(device_node) = of_find_node_by_path("/");
 
 	if (!of_match_node(at91_soc_allowed_list, np))
 		return 0;
-- 
2.39.5



