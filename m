Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02F1D151B;
	Wed,  2 Oct 2024 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879396; cv=none; b=sDxiSzHCeSVa8iXubu4SLs0oerQYbyvMm48x5pkMk8SnOctHyUyAEykJwA8nqcyRqbaC/7O/uZiIrXlA6hEN+06Fh6c1e7cHvJ0AEbXzHpv+BzLS3hBcVF7xju4dGOKuHN4i/s1mBMpwUagTUAAhHoKVW093mwX6KeL05/FRWNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879396; c=relaxed/simple;
	bh=xsE3oSmyeQqsonVnjqmW2vd+gWBBOcg1umvMJc84y44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP6oV7lnj6GXcoDrLo4OhO3XqGUG5M90rssU63S0BQixk/lHNMobKjAqYUI1FGlprq4u2lDAwkFCiwHLE76dn1kC0alJv13PnqxKD66IX/3S3gmS3fQ1kNzcd3uIyf6Q94cviOYIvVd93jWIkY6reKAV4J6gfC02r+yVkb6oIFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUMWJxj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUMWJxj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD777C4CECD;
	Wed,  2 Oct 2024 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879396;
	bh=xsE3oSmyeQqsonVnjqmW2vd+gWBBOcg1umvMJc84y44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUMWJxj87fMwA4juDMrzEdsLM4Ow9+G26XMAxQ0OYd6XY/b6rHV61ZtSjYdCPgDhh
	 Iih5GIQFD4o1qu8csifQkJY0CPvhZ8OE88vJslLcv+qkC37fA6xD7y10Ga69VTg+J+
	 a6dqKQWdKlChgPxLScd7zBuEkovzIoDHxQKjT7kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/538] ARM: versatile: fix OF node leak in CPUs prepare
Date: Wed,  2 Oct 2024 14:55:44 +0200
Message-ID: <20241002125756.377817402@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



