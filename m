Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F59B30C37B;
	Mon, 13 Oct 2025 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368024; cv=none; b=eXgWuJuaQLUEMDQy8DrUAHVtQ6N8i7AArs+uGpqRMdjTKOSkDfjEPnXdLsbgmgzUAZPZUbEPqCoTwbVFxXwnhwGwrHXStewDTsUJ0Guzb07/KkV6RfG/0MN3vqMXHWyatno7X/soY1jrYegggLkkc76w4Ht9oSZ+pSBE4Rl5oQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368024; c=relaxed/simple;
	bh=7a1gDoXXv1UfwRFLqtsxvV/Vj2XDwOhXdsJT3XePFtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2UNXbalnRoMi5Ji0w48i6Vri0p3JlP7sNkGKeD8LHmUbJqQdM2LjwmnAk+Bq3uiDr4KMO6PRKXK1OnC8n7MMSxoeOGg4lvMVMVp5rbML3L0Os2w1LeKNzR81kQj7rg1P7wjYFYgQHgigJIDpeDIlQWDv40fIu2NqwnLv6esLdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJAtGXjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJAtGXjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EFFC4CEE7;
	Mon, 13 Oct 2025 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368024;
	bh=7a1gDoXXv1UfwRFLqtsxvV/Vj2XDwOhXdsJT3XePFtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJAtGXjk3YGH4u3O3ABWJdrGIL8nW7IgvlyRFwbOzFLf3QXWxdzy99bkc+Df8OWf6
	 SCeYW73WkQsRMjCWQx19KrXKyYAzcUse9z8ch6RmLwPO44fJ4APFPBCO8Jnx88yehh
	 bWZR/FgxL2dZ/l8t3wHTaXi0zf04d3u60pFzAjD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/262] regmap: Remove superfluous check for !config in __regmap_init()
Date: Mon, 13 Oct 2025 16:42:40 +0200
Message-ID: <20251013144326.786700223@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5c36b86d2bf68fbcad16169983ef7ee8c537db59 ]

The first thing __regmap_init() do is check if config is non-NULL,
so there is no need to check for this again later.

Fixes: d77e745613680c54 ("regmap: Add bulk read/write callbacks into regmap_config")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/a154d9db0f290dda96b48bd817eb743773e846e1.1755090330.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index de4e2f3db942a..66b3840bd96e3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -828,7 +828,7 @@ struct regmap *__regmap_init(struct device *dev,
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	if (config && config->read && config->write) {
+	if (config->read && config->write) {
 		map->reg_read  = _regmap_bus_read;
 		if (config->reg_update_bits)
 			map->reg_update_bits = config->reg_update_bits;
-- 
2.51.0



