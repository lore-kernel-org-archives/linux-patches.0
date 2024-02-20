Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1029D76C9C;
	Tue, 20 Feb 2024 21:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463822; cv=none; b=iOEUal4MTrFjymXoa5dFRW1skyOG0OsaoIJx4j3EQJyRiJFvNmojI5SDm4ZHOgkYHeJ9J2KoCi4bDVbuBtyYk887fL517QFY1mS+nZv4pdRQsiH8Z4kC8XKUb1E9oVBVZ/v2hsbWIueRafbAyq7uyfT4SbqS6pWcH8svZ23OkiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463822; c=relaxed/simple;
	bh=WA5rbB69OY7s/87VBaLnt8Q47U0AQyYMvK4nNsXr1Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9Uy4qs0dr6JK5HQ3LvtoheUvI5AUAdaHg5hrbBbCHJZ1un1FiLhIXMb/vIcFX9BD5IePl3y5FrdDRplVmt+FpURF3qydjD4qSGmNwSVUeRU2FN+teAb5fZrqbttDWj8nQG+GiTUBk3dWTPVDhNlMQmLdZrOR+yFcy1EL3wRgvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyA78aZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyA78aZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9245AC433F1;
	Tue, 20 Feb 2024 21:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463821;
	bh=WA5rbB69OY7s/87VBaLnt8Q47U0AQyYMvK4nNsXr1Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyA78aZXFnQm0V1h8ZtIyVqmqUEr6sEQ4j0AVgHt9r4DmLab/m3uNKujdhaRZIkJF
	 AuITNtwXPZ9sy2EQWMoTQIFrnX2RWct/uKh3IVvLax3c3MGMhHyXIw+ElVdpUUjNCZ
	 7eAicdekXdmpRcUhym1eITBaQIijxXdhJfxxG7BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 164/331] pmdomain: mediatek: fix race conditions with genpd
Date: Tue, 20 Feb 2024 21:54:40 +0100
Message-ID: <20240220205642.686244741@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Eugen Hristev <eugen.hristev@collabora.com>

commit c41336f4d69057cbf88fed47951379b384540df5 upstream.

If the power domains are registered first with genpd and *after that*
the driver attempts to power them on in the probe sequence, then it is
possible that a race condition occurs if genpd tries to power them on
in the same time.
The same is valid for powering them off before unregistering them
from genpd.
Attempt to fix race conditions by first removing the domains from genpd
and *after that* powering down domains.
Also first power up the domains and *after that* register them
to genpd.

Fixes: 59b644b01cf4 ("soc: mediatek: Add MediaTek SCPSYS power domains")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231225133615.78993-1-eugen.hristev@collabora.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-pm-domains.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/pmdomain/mediatek/mtk-pm-domains.c
+++ b/drivers/pmdomain/mediatek/mtk-pm-domains.c
@@ -508,6 +508,11 @@ static int scpsys_add_subdomain(struct s
 			goto err_put_node;
 		}
 
+		/* recursive call to add all subdomains */
+		ret = scpsys_add_subdomain(scpsys, child);
+		if (ret)
+			goto err_put_node;
+
 		ret = pm_genpd_add_subdomain(parent_pd, child_pd);
 		if (ret) {
 			dev_err(scpsys->dev, "failed to add %s subdomain to parent %s\n",
@@ -517,11 +522,6 @@ static int scpsys_add_subdomain(struct s
 			dev_dbg(scpsys->dev, "%s add subdomain: %s\n", parent_pd->name,
 				child_pd->name);
 		}
-
-		/* recursive call to add all subdomains */
-		ret = scpsys_add_subdomain(scpsys, child);
-		if (ret)
-			goto err_put_node;
 	}
 
 	return 0;
@@ -535,9 +535,6 @@ static void scpsys_remove_one_domain(str
 {
 	int ret;
 
-	if (scpsys_domain_is_on(pd))
-		scpsys_power_off(&pd->genpd);
-
 	/*
 	 * We're in the error cleanup already, so we only complain,
 	 * but won't emit another error on top of the original one.
@@ -547,6 +544,8 @@ static void scpsys_remove_one_domain(str
 		dev_err(pd->scpsys->dev,
 			"failed to remove domain '%s' : %d - state may be inconsistent\n",
 			pd->genpd.name, ret);
+	if (scpsys_domain_is_on(pd))
+		scpsys_power_off(&pd->genpd);
 
 	clk_bulk_put(pd->num_clks, pd->clks);
 	clk_bulk_put(pd->num_subsys_clks, pd->subsys_clks);


