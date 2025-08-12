Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDBC2EF652;
	Tue, 12 Aug 2025 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023556; cv=none; b=WBzVHzfQENbdu26s8ylzRX39J79lMCjKCnaSDIqIjAoxEYI8S1hXe+C7xM7Wff7L4jzfM7Tm9ZRjpXlcmDRacU/LsFVLL4lRFmOUTrTQynv2+xnTqJ8JfUc2qgs/DH27kz3s8TtlQPcRb+h7CMwflIqyPkJn/x06wIZZsrJbWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023556; c=relaxed/simple;
	bh=1Fhs3fcyPLf63/WQXnMmYJiFpDFkJm3VSyWsl4qUI6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+BboSDwp9cciGOetSY1kFC7Lb4n3cBm5BUJfKa6v0gkDh9JdCRvEW5ns8NW3FfZ28fHaRTQmdZdFOPFGTlDF1vAOBYRVKweD6WRK4LfRpbzo2PFZyS4luizEmcUTPeNqXToJc3kiLFT17/sbQjuTx0VkTKFrfxQd0OevZSA8HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2s7DTBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2s7DTBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3632C4CEF0;
	Tue, 12 Aug 2025 18:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023556;
	bh=1Fhs3fcyPLf63/WQXnMmYJiFpDFkJm3VSyWsl4qUI6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2s7DTBXwHW+f+5eUmJrKBRG9awXxNgQ2BIX1g7JRpCbqVdhyQiOq8o1KZF1jn5K0
	 5Gr6Oa3YhaBMzX2Gb9913uwgqvE04kxSFwT7zp7v+e1WFP1UAt1hmxBBX0Z8m5ewNS
	 sBLNeFA4+nikQqobb3DtyTLrByp6ahmOA39opRfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 097/627] soc/tegra: cbb: Clear ERR_FORCE register with ERR_STATUS
Date: Tue, 12 Aug 2025 19:26:32 +0200
Message-ID: <20250812173423.007667199@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c74629af9bb5..1da31ead2b5e 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -185,6 +185,8 @@ static void tegra234_cbb_error_clear(struct tegra_cbb *cbb)
 {
 	struct tegra234_cbb *priv = to_tegra234_cbb(cbb);
 
+	writel(0, priv->mon + FABRIC_MN_MASTER_ERR_FORCE_0);
+
 	writel(0x3f, priv->mon + FABRIC_MN_MASTER_ERR_STATUS_0);
 	dsb(sy);
 }
-- 
2.39.5



