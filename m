Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E12222C2;
	Mon, 23 Jun 2025 21:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715433; cv=none; b=L5cfIUgT9rahV55LiAojPTXmv1UgAOLGiN+7BQ1wLVmVSkpFiOKJqZL1SUNxdPXFxgCZkZ/lfTJAmhUlmEYyiqpCVRt05FVPCjGa9aCyJ3jUTPaEqdTkRsDVNmTnDHzoP0gOtQDUENjlgE+UxWzBzwkThRP1TORdnme1rljD6BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715433; c=relaxed/simple;
	bh=vAFQenjUZJCWXEUuQv6y2Zrf2sjClweuoQEKrBUxXY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edM3G6NssAYYTDpTvIYGZnWxpkAYDESKS9/BxkeMtZTVFGaCXVSa8ie2hEruUu7ErpO9dRHC4+18sYWTyabx8wsZCUAZUVwGw5PA9lbz16sW+cwmZULxUcFkvUhJN54ahp0eRqfMsCcRQVmFYokFgDppof/HrUATFUsHSAFcdL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCbjw7M7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCbjw7M7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A203C4CEEA;
	Mon, 23 Jun 2025 21:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715433;
	bh=vAFQenjUZJCWXEUuQv6y2Zrf2sjClweuoQEKrBUxXY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCbjw7M7s3Vq7X7KY/djo4ScG2pGGTI7PHlu9F3MUTjEfN6/gNzkMEEMhn6eG3yhM
	 QhxPWFJIYZ+95Mk6RNABZA6yjvyjoGXD35gf3LvdtSbJ0ujUOCLCxTsZ8rIpQiPZOS
	 6pqpWbRX08TKQYCyD97wwmf91gkpWQVj2PMaT0rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dhruva Gole <d-gole@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/414] pmdomain: core: Reset genpd->states to avoid freeing invalid data
Date: Mon, 23 Jun 2025 15:05:19 +0200
Message-ID: <20250623130646.573672453@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 99012014c902cd9ad85fd288d8a107f33a69855e ]

If genpd_alloc_data() allocates data for the default power-states for the
genpd, let's make sure to also reset the pointer in the error path. This
makes sure a genpd provider driver doesn't end up trying to free the data
again, but using an invalid pointer.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20250402120613.1116711-1-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index 8b1f894f5e790..2643525a572bb 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -2228,8 +2228,10 @@ static int genpd_alloc_data(struct generic_pm_domain *genpd)
 	return 0;
 put:
 	put_device(&genpd->dev);
-	if (genpd->free_states == genpd_free_default_power_state)
+	if (genpd->free_states == genpd_free_default_power_state) {
 		kfree(genpd->states);
+		genpd->states = NULL;
+	}
 free:
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);
-- 
2.39.5



