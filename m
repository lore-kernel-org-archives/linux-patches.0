Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F8D1C07C4;
	Tue, 15 Oct 2024 13:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997243; cv=none; b=iZHo3/aMi8ztv32cxHpEhcplgS4bdJX/JTNnCardjbuu55C1k7cHiiYUJE+/TCw/2IRwxFoYu2R2ZKOp9pkHRAFVQUbhIrV/sb238otOsUBJ6Lu7+9yaIzvbshQ8HTQxJQeu8tO+JiD5y1FOMjtEr05zU3LIW4kwc4BxXUejhvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997243; c=relaxed/simple;
	bh=5SBqq1YkfLUM6cS6yShXCy9tVTAvbTBoUWbdJJI+V40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USm0gM4kH3wfKTIipu6turd6H8P5/bh2yzDmirVCOKnqA8IgXpHCy59C2JhcsDTaaAzg/I8LULsoeRlBZh51Kq2bFqs2hfV16qSeyAQ54iHhRkGh9khZLDHFjAUZhVX032CYF2enf8Jbuu1jCCQIheuCpVOJg/v/2mw4N01uwgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brVB1I37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brVB1I37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EA4C4CEC6;
	Tue, 15 Oct 2024 13:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997243;
	bh=5SBqq1YkfLUM6cS6yShXCy9tVTAvbTBoUWbdJJI+V40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brVB1I37ahqoZrjv0KsFmSPbJ6GOloTilyZFm8QJVlZNIwEjrS6p88mjq1tdq9o/K
	 Yi7pWRnQ3sriW/qbf4r4VLZsCJufpQr0RmCsubUTQwzrXM3iuymcZCQJ5VEZBHJckW
	 0frBKJBI+8FakY+aPMTrgKb39QMRqULbG3LUsOoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/518] ARM: versatile: fix OF node leak in CPUs prepare
Date: Tue, 15 Oct 2024 14:40:03 +0200
Message-ID: <20241015123920.822502213@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



