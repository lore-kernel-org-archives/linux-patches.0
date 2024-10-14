Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6C61ABEA7;
	Mon, 14 Oct 2024 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917607; cv=none; b=BI2KrmxuPRU+gKCUkD3Cq/IEEqDLiBxJlSU8PsHna4WPBhxQsXO0L1/dGAyOgW4G+xSLukVsfVRxh6Nvguynq1ZI9zX9YkAchEzKOmvjIrao33W5RnoroPoTI9o/g4RWw+7tug0NkoXp+lu/UoC11HDWe0OprDRVrLhfjOxEyhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917607; c=relaxed/simple;
	bh=7AYE/q3Is+YGlNKb5lKFY1NKCyWLz3DIdjr61ZmaBQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRhiN0hQrpKxg4Nh7Ba4ut6jHMR4H+y/LM0SIJWwYihXSgUpkKjjOZKx7aRJmzBerDw6z1jXg+al5dYKxJ2ccJBKtZL/uWd9C0EPDn+GupXbF0z1g0iPfg4e4cBDLQxfaw47CYVPdUktGQQrBE9Im5KJWblVFYvUdmUHd1/hyIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhUlvbIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhUlvbIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BDAC4CEC3;
	Mon, 14 Oct 2024 14:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917606;
	bh=7AYE/q3Is+YGlNKb5lKFY1NKCyWLz3DIdjr61ZmaBQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhUlvbIcagxvE9HhETloxPFHZqWg7uznHd2HgTeWOBH+C94ObivbIn5kzVev8cJaQ
	 UJusJfPmVdvB13D/Zv/ceTWlx+yFDzDvNjx0UZlaDHXDaPpzQDhDBJO7tLzGgkcrFb
	 wpv7+uL3gj6pZSh0Sp3IRTT+tT+nrbeV4jHAAoYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/798] ARM: versatile: fix OF node leak in CPUs prepare
Date: Mon, 14 Oct 2024 16:10:34 +0200
Message-ID: <20241014141221.077836095@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5d363385c8019..059d796b26bc8 100644
--- a/arch/arm/mach-versatile/platsmp-realview.c
+++ b/arch/arm/mach-versatile/platsmp-realview.c
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



