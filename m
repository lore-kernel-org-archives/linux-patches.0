Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10BE1D1512;
	Wed,  2 Oct 2024 14:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877715; cv=none; b=KGHIlwCmBQIuDqhRxmlDxeb1HyaPvKdSMEaYlS6c9Op1hjH4kdmO0qaeE4z95pQJ6/jstJJg7bbIPXilrq6kvdFXa2XWUL3c5cmrDZoJ8kEBE/UnhdH47Wesn0kPmTmKV+sWyQ4SKJiBe6Qz8Kv+Kts1nCr2g1BOUbMS0keyPmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877715; c=relaxed/simple;
	bh=vCWDj6so1pxb5d7EgzUkvVkLOwXk6Gmhx0rrrfbgkA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkleja1xQet3brRrnQVWK1LvOg68TwUmnv+I7iY5B6i+lTAt0FqW96Wn494mB4H/ZscX9UCwJBB7OoAas3nWZ3kP0JjLe/WrtFFdwEWsJp8WIQbx67meo7Tch0aKDoRLz5ks3cn1SgdyOfVSLSa06C6n6iBiwYLDcHV5cJs4ajE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/T//Owc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/T//Owc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C94C4CEC2;
	Wed,  2 Oct 2024 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877715;
	bh=vCWDj6so1pxb5d7EgzUkvVkLOwXk6Gmhx0rrrfbgkA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/T//Owc09K0G+KO938/Cp4yWfRXQ2TGf1df0I8MwuxcQ3wFySF72PRi0lJh3ria6
	 bNaHSXhLarywUf3gMapTtnWbEZ6kZaAoVHhHyLhVMMv94CWTGKz8Dw9fIjg7fr9aMB
	 ZaS9uAQswbi3NeMpqUnYKi1GL8iX31iFGx1fqBUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 138/634] ARM: versatile: fix OF node leak in CPUs prepare
Date: Wed,  2 Oct 2024 14:53:58 +0200
Message-ID: <20241002125816.555203238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f2642d97f2105ed17b2ece0c597450f2ff95d704 ]

Machine code is leaking OF node reference from of_find_matching_node()
in realview_smp_prepare_cpus().

Fixes: 5420b4b15617 ("ARM: realview: add an DT SMP boot method")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/20240826054934.10724-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-versatile/platsmp-realview.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-versatile/platsmp-realview.c b/arch/arm/mach-versatile/platsmp-realview.c
index 6965a1de727b0..d38b2e174257e 100644
--- a/arch/arm/mach-versatile/platsmp-realview.c
+++ b/arch/arm/mach-versatile/platsmp-realview.c
@@ -70,6 +70,7 @@ static void __init realview_smp_prepare_cpus(unsigned int max_cpus)
 		return;
 	}
 	map = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(map)) {
 		pr_err("PLATSMP: No syscon regmap\n");
 		return;
-- 
2.43.0



