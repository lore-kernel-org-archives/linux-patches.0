Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D91DF249;
	Wed,  6 Nov 2024 12:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894918; cv=none; b=FZKx7kA5wqDjqDoZGkFm6VJvoXICV0Bg08xiq+TPQ9eKzr0FdvzZ5+82tPa8BwISPlfqUtNOwWkcJE/EbHjuE10hdSIgs7JDQmYl7Jq+Ok4Xeg1MheoDxPgDXMstIKp19WStaR81Pykkzp2yOk3g+B5itrHMleiAUslaBAhvV2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894918; c=relaxed/simple;
	bh=UgJXE36GtBX7eCrhgQdQs8V3t5DV3EL4VP3Z58zzb68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEp6tAjEiKD3hpPFfyQuwcpd5gcNiEIA6Vu5F9sgHOJ+L0kko9yfNqyUwZU0NYmVjR2YgEGO8GEVKrKxS5MqsCAfKE8TwwhTKM64j2pRMFeOo9sMouCYjQpHQ4EZ3xS4xz2HVIWyaeBB/61cSmg2qMCvFS5vpsxAFpqc/vDgM8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiYGJcZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiYGJcZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41B4C4CECD;
	Wed,  6 Nov 2024 12:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894918;
	bh=UgJXE36GtBX7eCrhgQdQs8V3t5DV3EL4VP3Z58zzb68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xiYGJcZjxtHQfD8XPzu0MOahMX4hs7VSTsm5i8YwR7g4OdiQN52fVPI+N3LzVE9bC
	 I84RlvXLlvyyd8d3rPoJRKLQ9Oijup4/RO6MucvgfKiN5KaAcKFxAERKIOc+VW35ub
	 Wn2CJhuXXoo03tK1xgg9s5TL947Yz3TGFfjGS3bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/350] ARM: versatile: fix OF node leak in CPUs prepare
Date: Wed,  6 Nov 2024 12:59:30 +0100
Message-ID: <20241106120321.925110932@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/mach-realview/platsmp-dt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-realview/platsmp-dt.c b/arch/arm/mach-realview/platsmp-dt.c
index c242423bf8db5..66d6b11eda7bd 100644
--- a/arch/arm/mach-realview/platsmp-dt.c
+++ b/arch/arm/mach-realview/platsmp-dt.c
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



