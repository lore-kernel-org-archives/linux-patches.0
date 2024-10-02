Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10971D042F;
	Wed,  2 Oct 2024 13:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875672; cv=none; b=RRFsHajbS+smnmQavpsXxyjlCTYeYCLzEiKgGOeEZc7y/f04WIkY5vlLapmiXubIZrjDnhgmgH3iwfaAnEm9bqm6p0BWdJJrd4h6/IptMJxJSzN4xbhi6rCwWq5BW5iM8cvzK/QR4lhP7zXc/Jeo9gn7gvGVl1Ulvrk9dYl44nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875672; c=relaxed/simple;
	bh=7N0Qu49M7iDcQ+A6BBc/C/FkmBXI2RuiitgUTDyoku4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AG4BZnuz6kmfCOJDGamvm96xRPe3/84v1Sd/QIHivZargpTOKm5VNRTqIfDetNHx2hWB8TA2HeQWE+GYKy6obXIJa6AHMg010HSrPhnT7nUXyZ9D5BIqvHBaBHF5OqNgc4lGq56PIIJOgjJsI5lictiQSB2H268GgbBkkA58FDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ffs/L3G7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ffs/L3G7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38006C4CED2;
	Wed,  2 Oct 2024 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875672;
	bh=7N0Qu49M7iDcQ+A6BBc/C/FkmBXI2RuiitgUTDyoku4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ffs/L3G7WtG26bTkyuzBfkFnW1R3USoJ/hHV2YBzz1kN61kOKfbBj5Y3vcghCmpZe
	 TFERZPWnEoVu0J0paU+eAyH6nuB3VEk3YUifa8sYT8mW6aEnjQZZ/zgDEuQw4k4+tI
	 DILidirL8AfE1cq5jAWVDk5mVEHEw8TuNCd1DrjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 154/695] ARM: versatile: fix OF node leak in CPUs prepare
Date: Wed,  2 Oct 2024 14:52:32 +0200
Message-ID: <20241002125828.626769578@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



