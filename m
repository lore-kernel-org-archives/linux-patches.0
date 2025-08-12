Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BAA1C84C7;
	Tue, 12 Aug 2025 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022080; cv=none; b=emCYSfoy4UCdCbswN2nLIN0Y6i2l/WL8D/lqGhm87e2VMTki/sjeNDvutQSOeyThtJntOSMkS/1/XLng078CyBxDbuhCo+Ohn7X6gXfSHdtNd6plWRQ2ef4ydacDL7wA1ka03WbaiuFacX132Lx5M1NcTyDPxRNePvCkJieqau8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022080; c=relaxed/simple;
	bh=lYcpEMqoWEoEp2Ou7Z67CsI7/DjmVQ9lskya7zCBz4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyFDpIoe4fdQTgJU32B2BfllisrxVulLRKZq0kv+4AkWvGXxd99CgsYxo9m2g/kcaLedzl2XJygoo5pzkzm2WQhn8/QHvkZEuX5dt4rUzvpemOAlJ9cu5JUilv62r9CsWMXm5E8BnapXTGLE1YyW5yxU29DepkwoG19R0Az6hDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXcfa8UX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXcfa8UX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54040C4CEF0;
	Tue, 12 Aug 2025 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022079;
	bh=lYcpEMqoWEoEp2Ou7Z67CsI7/DjmVQ9lskya7zCBz4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXcfa8UXP8XS/kr1BiSi5y0AncJ/vGj52UKivl3fJZgaB9lUh27Y3lcfMkxKWmyK+
	 jc7OEF1wJcrD873KIpsFEugBOtgM+YlaIzcSNGW3mPokbV+fsaFr+ImNqSlU9vx99j
	 4JENz648VkO/SDAw5Y6e97MTBIKbY57v+rq8T42U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/369] soc/tegra: cbb: Clear ERR_FORCE register with ERR_STATUS
Date: Tue, 12 Aug 2025 19:25:46 +0200
Message-ID: <20250812173016.608609974@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 5cf0e8c34164..e8cc46874c72 100644
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



