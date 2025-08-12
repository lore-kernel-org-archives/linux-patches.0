Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B942F7461;
	Tue, 12 Aug 2025 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020449; cv=none; b=fvLoO2A4L1wJGvLo5y/WKKjHe4+5yILJMcyt0s5SQrUNcjZ0cfymsMNh3+YFZXrimnzQEbRRTiSPPNhbORUo+2ZqR84g4js9yWb2jhjFZtYO9Rvj37JZoOEnupP9/uv1CYBome9OEUx2rE8Osz9RvAC6VB7a4FU3GSLwP7Xojhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020449; c=relaxed/simple;
	bh=JT7h8eNsV6ao0mb7ReXRhTWkWAcgg85YqqCceDYI3wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjatYufs+chRNNe0YPZytHBzD/jIWzuAIzYFRdsqg9ZYav4T8FWLgHYATbsiKushxGbNMx0KpWKlfr8qmKi5t9pM210K7hnLIdmHDn5txZBCbKXKUXS9crdFgY/ARf/yzYF+SWbPGB/Nc6s2kY0Nb9HGqOAwqV8Y+m6t9fO5ayo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyZXm53R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyZXm53R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93739C4CEF0;
	Tue, 12 Aug 2025 17:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020449;
	bh=JT7h8eNsV6ao0mb7ReXRhTWkWAcgg85YqqCceDYI3wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyZXm53R2wzgyDt6IXubXJzMxozna8L6QxlQI3uQ7h4gaTaiEbjF2cciGQsLzkVoO
	 pZIF2RJF4yJqYDnVmsLtRPZT4NWqU9p8LKWDn9sgRnzli7MDCFmOj/HeUaHbNSlzJZ
	 XjsbmhHG5yZTCeLWHAIS8hCGGL0kIcfLnaAF34tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/253] soc/tegra: cbb: Clear ERR_FORCE register with ERR_STATUS
Date: Tue, 12 Aug 2025 19:27:52 +0200
Message-ID: <20250812172952.315645454@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit a0647bca8966db04b79af72851ebd04224a4da40 ]

When error is injected with the ERR_FORCE register, then this register
is not auto cleared on clearing the ERR_STATUS register. This causes
repeated interrupts on error injection. To fix, set the ERR_FORCE to
zero along with clearing the ERR_STATUS register after handling error.

Fixes: fc2f151d2314 ("soc/tegra: cbb: Add driver for Tegra234 CBB 2.0")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/cbb/tegra234-cbb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/tegra/cbb/tegra234-cbb.c b/drivers/soc/tegra/cbb/tegra234-cbb.c
index f33d094e5ea6..5813c55222ca 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -189,6 +189,8 @@ static void tegra234_cbb_error_clear(struct tegra_cbb *cbb)
 {
 	struct tegra234_cbb *priv = to_tegra234_cbb(cbb);
 
+	writel(0, priv->mon + FABRIC_MN_MASTER_ERR_FORCE_0);
+
 	writel(0x3f, priv->mon + FABRIC_MN_MASTER_ERR_STATUS_0);
 	dsb(sy);
 }
-- 
2.39.5



