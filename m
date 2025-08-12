Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA092F8BE6;
	Tue, 12 Aug 2025 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020928; cv=none; b=a5Tt/NVxwb3/CwoHjufcAj5XEceNb/nn4ihLz3aHY/kmvjI4oclTANVOgobI8O0GM0A3M6C+WyQG+dBUlHOaoa+nctSIC5eZwc2JRLsZWV59Ru9kX39kyLKXfe2G5iqp76Br2bVDb9qUe3qRpH1/3+VLj9QAP2ckKI5fOkR0VWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020928; c=relaxed/simple;
	bh=e4OldpH+/PQkkk8DoDQGDrOj6SDBCIJ/5wi9AeMPDEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDjfbUAC+dzwv4g1r/4lHrYhBZ4JcLlpk/N/yIS+qdh50fCXoQoAKJBbEXPTaZgTw31k5lDNPeovNmk1apoErj1iYONrfegGL9KZPcHlu2VIql7FW7cfOl9Tt9OxZl2ubexSFta1xFBPhSEGA8IEceGUeSmb2wDt0gRwUjgE55c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6SBweRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6SBweRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804EBC4CEF0;
	Tue, 12 Aug 2025 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020928;
	bh=e4OldpH+/PQkkk8DoDQGDrOj6SDBCIJ/5wi9AeMPDEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6SBweRrb8sksNR3wr43m8h0/s6WzUoU60KzpZtUYvX2qvzqsM7ii5gVd3b2W0kM5
	 4+EHpQcBKtyiTaKV+JPl2J1Vb4rkc51FURouqkmD+lHoX3cSi56ceVTNiCghy3OLvW
	 78yqyuheG3HtBXcakZbD+zSsfDPZmMdn9TAmPw7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/262] soc/tegra: cbb: Clear ERR_FORCE register with ERR_STATUS
Date: Tue, 12 Aug 2025 19:27:02 +0200
Message-ID: <20250812172954.416078789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



