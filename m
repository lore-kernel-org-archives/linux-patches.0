Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296191E909B;
	Wed,  6 Nov 2024 12:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897907; cv=none; b=tKgtwJhPJk4BrYF2tjv8sOvznnk7XHhill2//kzbEih1GX5fr1Y7xgMMej+hDEfJqeu69rC8QZiFuJwRgQ6aiCSkDKD7OQYZ/ZZNHZvgxUcEF5B2VfO00upw9NVmCb+FVW4LkHVh8QRVvrAo9QjyKeTJap7Hcjr9oUcDJ30GzEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897907; c=relaxed/simple;
	bh=TLKThlhoqND1IVH3wf0lTlijcfd4qCPbrbp60UPupFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrqA9nK3SrpFgBQDM4ghK/bJGU97jwVcH4580FAtkqnCRZ1zZavM/xgp7KETs2frCniFz3tb3De0rmOea5RjVHrcpHqSyUh0vb+QuwFherl0dOiP6sCptU6xz5tyu3BesmXV6ZfddnNDzDNV3XZiYxRgSVx0kR2++mVHeOMB+/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOlfhfFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOlfhfFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0233C4CED4;
	Wed,  6 Nov 2024 12:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897907;
	bh=TLKThlhoqND1IVH3wf0lTlijcfd4qCPbrbp60UPupFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOlfhfFeHwKKvwVtwfiik2AbByqCkPnKH1AdV3ho50vHM0e62ZlweIw765MfCVO3q
	 5DkD8WFlbrE2M+II16i6o09wU0ms/LCdzkp3A2Q6ly8cGoHi2JbkfpVTcakn1ZIqEE
	 1/dEA2fqZTcl+CTCiHHqcRmb2yc2tbxOl0Z9fhpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/462] ARM: versatile: fix OF node leak in CPUs prepare
Date: Wed,  6 Nov 2024 12:59:11 +0100
Message-ID: <20241106120332.949367769@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5ae783767a5d3..083e6a6f75205 100644
--- a/arch/arm/mach-realview/platsmp-dt.c
+++ b/arch/arm/mach-realview/platsmp-dt.c
@@ -66,6 +66,7 @@ static void __init realview_smp_prepare_cpus(unsigned int max_cpus)
 		return;
 	}
 	map = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(map)) {
 		pr_err("PLATSMP: No syscon regmap\n");
 		return;
-- 
2.43.0



