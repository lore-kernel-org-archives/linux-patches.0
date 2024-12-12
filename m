Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EB7215F5A;
	Thu, 12 Dec 2024 15:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016077; cv=none; b=pb+LBacP8CctxrVYmy5kqzfPpu+O6RSPl8UcyJZ3hrsmGZ4Lc3g3BY80UQ7wvBESHw2nTeHNvqw0M9gCJfNOzCKng9a5+uicgDvkT5naS2RQyQ55riOAxK1i3Y9YxLNaB4har+w93RvU+uKwkAbWtnf6oFy9ctclpjnhnbM7J1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016077; c=relaxed/simple;
	bh=Cbw18ISQsylULlJCcKcBZ0LeAe9LkLNkJXiXRrETngw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DF8h5mC+y7rqgXphiEtHHN3I84Qr+k4Kt2cpTor3gAzYp/USsFfZHXnE/CGYKxdelF9cW8gIV33tQ40w/mlQOeNdUF9IYRekHyrzvM5jLnQe4yVQeT0Zke6SpZd0Rl6YJbEWhhzcHjHZdM7K2aRmPGQQyDwsdDDIKbwxF+Dp7FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xd3Z5FOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xd3Z5FOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5732DC4CECE;
	Thu, 12 Dec 2024 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016077;
	bh=Cbw18ISQsylULlJCcKcBZ0LeAe9LkLNkJXiXRrETngw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xd3Z5FOgfYkq/lMBVNT1C7ujfWsi9/Vi12LZ+6vl17wJHexcUxFYOSdllllkvaiVw
	 SIFYqUjX42oHAoE5I2c7elMYGh3+Mx1zwcenWA+eaTDPCo+A8+wNwbBRvResiWpO/T
	 pPGTTKGR2hQvgm484d+hx4MQftWfaYZZPM/mP+4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/466] pmdomain: core: Add missing put_device()
Date: Thu, 12 Dec 2024 15:54:24 +0100
Message-ID: <20241212144310.567594093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit b8f7bbd1f4ecff6d6277b8c454f62bb0a1c6dbe4 ]

When removing a genpd we don't clean up the genpd->dev correctly. Let's add
the missing put_device() in genpd_free_data() to fix this.

Fixes: 401ea1572de9 ("PM / Domain: Add struct device to genpd")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <20241122134207.157283-2-ulf.hansson@linaro.org>
Stable-dep-of: 3e3b71d35a02 ("pmdomain: core: Fix error path in pm_genpd_init() when ida alloc fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index 29ad510e881c3..e330490d8d7c8 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -2182,6 +2182,7 @@ static int genpd_alloc_data(struct generic_pm_domain *genpd)
 
 static void genpd_free_data(struct generic_pm_domain *genpd)
 {
+	put_device(&genpd->dev);
 	if (genpd_is_cpu_domain(genpd))
 		free_cpumask_var(genpd->cpus);
 	if (genpd->free_states)
-- 
2.43.0



