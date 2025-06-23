Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9DC4315A;
	Mon, 23 Jun 2025 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715087; cv=none; b=aB/2V0UN/qd4ZEoR6DIOGGEzCkst1/XIhcma3syFhYkG+6O5P3MuGRAZ9OfMjnICbYBdxIiLFsLDdMI6V5H2K/80VCxmtSoUfre8GsfsPLLYli9DpEvL0nNuiPR1JZRtfRhtSHWXwvPACmQcqz/ggACS0W6jp6W1s1frvCgxBkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715087; c=relaxed/simple;
	bh=KGL41m6LdOWif1arAKzZxeNWfI+O+uw/B6aqXiA0y6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoSlAdbrmQdmk0IpgtECZ3wcvpL4dNExB1B89dPBqUoLuGDxBJQSnQAQwgV3vg9du4NstkVitfN/uqFWPD1jlCyH7FvFlEgo4MKN6/3R2VDX3dV67s7fbHyBuGvckdzKRjT5TnZD4MdfXhQGERkNjDDL4otoHwbYoXWhvWCWSdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izxr0ORW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izxr0ORW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16354C4CEEA;
	Mon, 23 Jun 2025 21:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715087;
	bh=KGL41m6LdOWif1arAKzZxeNWfI+O+uw/B6aqXiA0y6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izxr0ORWnTlUn25a9VXUXRyGue+SsBWhsnop0sxNcze/MHlTDuxyenCbyzymnOjBq
	 U+C/AQw0XgTtLXOrw0pjzXJdSA31o6R3Ac0bJLv0ssefSxz3LNWjbc3zotV1MV5KH1
	 p/Fpizgfhlg0oaq/NJHLXcRRyL6Xo2Che3JBHyP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/508] pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()
Date: Mon, 23 Jun 2025 15:04:19 +0200
Message-ID: <20250623130650.529604001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0f5757667ec0aaf2456c3b76fcf0c6c3ea3591fe ]

The error checking for of_count_phandle_with_args() does not handle
negative error codes correctly.  The problem is that "index" is a u32 so
in the condition "if (index >= num_domains)" negative error codes stored
in "num_domains" are type promoted to very high positive values and
"index" is always going to be valid.

Test for negative error codes first and then test if "index" is valid.

Fixes: 3ccf3f0cd197 ("PM / Domains: Enable genpd_dev_pm_attach_by_id|name() for single PM domain")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/aBxPQ8AI8N5v-7rL@stanley.mountain
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 3c44b0313a10e..a19a1f70adb2a 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2840,7 +2840,7 @@ struct device *genpd_dev_pm_attach_by_id(struct device *dev,
 	/* Verify that the index is within a valid range. */
 	num_domains = of_count_phandle_with_args(dev->of_node, "power-domains",
 						 "#power-domain-cells");
-	if (index >= num_domains)
+	if (num_domains < 0 || index >= num_domains)
 		return NULL;
 
 	/* Allocate and register device on the genpd bus. */
-- 
2.39.5



