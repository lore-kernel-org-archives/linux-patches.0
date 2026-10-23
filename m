Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774420;
	b=oa/y2spr15GzLtpZppuStYJCDhcASzds2y1Xif2eIXqXQDvfIs008FKh6sp7K7kGszzU
	 FaTXr/+I/Z4TOrEsYgY0YNrJJvZ4QzQemlO6NgBtjDjERRKeaalhw3oNeLo/aTFEc58qQ
	 ZMIDBkmsuFYtyTEg4eiptf27ez7k4S9pq1D9sY6NpmS4+tiyRlnTDtOjSmCPh1nzLVy5f
	 WiHXlcmo8mmeRWRPb+OoEfD8OFjILLRJbJziCM8p0CdNIfULVwS7IVQlRGSMbpXY8ghc4
	 SgVZtrt9U9MEFS6KEVq1bD0r04HrmyGBRwov0JqHRgTGt79nGsS6ntptsOjdFYjK/9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RkOwJ2T1tesTLoMaGySRx0ynb+1PtyLP5eRcpnIzS9U=;
	b=Q+oT6db7Oq66C+XWNcwrP4c4ROAh7Xxcgoeg6Yi2IudhsZ+ZBQiIN1y+AjpWzIF4qx67
	 uWZjOHE90TwuUKCZ5OFlc0KJQutGVTWDSESAsFgukILmXdRsyrMrwaYpQpPojbheQ+MPN
	 w2QgvS0rjDMhLsHzxS8Vijtq/dSFa/9JQPiX5Bjtb7Uk28S7itw29bQACsn7WgiegmOOa
	 0FL3q6AEY0gLStEbxmeNp4UWyD5be0a4aiQVd+Ae54JlN04LQJ6+AZZu3u/CNPAw9Sbsd
	 omYace8aAT/wqtuErBlqjdy/GMjrjr261OkcIotbBseQowg61RK9DLq/a/m6W1oIUWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0+wxaUu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF280606A31A;
	Fri, 23 Oct 2026 16:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0+wxaUu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7861F01825;
	Fri, 23 Oct 2026 16:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774419;
	bh=RkOwJ2T1tesTLoMaGySRx0ynb+1PtyLP5eRcpnIzS9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0+wxaUu0fJXPlUSZlOYXHNQo3g9HqXPIzl+c1lgPSc/uHVT7unCmo3I5sx13vtRO
	 qfbFHLd0vBTyy3E4vZHWaEr33f2Jbq86CVyhCRo8oI01iiwmoa1bzYz0XTsPBk9ZNY
	 Nt0VZlx5MaKiOG2fJJh+1boDpr+uTA2in6oZymtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 007/242] soc/tegra: pmc: Fix uninitialised clock rate
Date: Fri, 23 Oct 2026 18:37:29 +0200
Message-ID: <20261023163713.977420178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit c5c95dbdc9011a56359df4dc00be829bbcc0b036 ]

For legacy 32-bit Tegra devices, the warning in the
tegra_pmc_enter_suspend_mode() function is being triggered because the
early_pmc->rate variable is never configured and hence, always 0. This
issue started occurring after updating the PMC driver to create the PMC
context dynamically which causes the 'rate' to be set in the new dynamic
context, but missed updating the rate in the early PMC context.

Fix this by initialising the early_pmc->rate variable for 32-bit Tegra
devices when the rate for the PMC context is initialised.

Fixes: 4d61f0342689 ("soc/tegra: pmc: Create PMC context dynamically")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
[treding@nvidia.com: move assignment to existing #ifdef block]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index f419a5395545f..f8792b7950ae3 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -3148,6 +3148,7 @@ static int tegra_pmc_probe(struct platform_device *pdev)
 
 #if defined(CONFIG_ARM)
 	mutex_lock(&early_pmc->powergates_lock);
+	early_pmc->rate = pmc->rate;
 	iounmap(early_pmc->base);
 	early_pmc->base = pmc->base;
 	mutex_unlock(&early_pmc->powergates_lock);
-- 
2.53.0



