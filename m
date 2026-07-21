Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4014444AB9E;
	Tue, 21 Jul 2026 21:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668878; cv=none; b=L65q9/O7pXcIIUvaWCQuM3VOAnh3REV7WNL98bq2BxsWpuSpFOVgNfxb3hggT2ZJI2eOfOns4nRtUvPuIQpWFVC5THPT83qGnrAr72dn0d/m7oANVTZJf9lsGILP3YYnj6sCmQuF4EiwZfxS16SzqvB72ddjTJCYCaIRFaqUj3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668878; c=relaxed/simple;
	bh=1vfUKRPmUkQPqXDiQgWBpwJe7oPvm5SNqryADVkljEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZRJJCHlI20f2QXREZthSz1Zns5bR21EbJ3jLTcv/qLaIKd9kijn4GJNl4vSszR5a0a9d7gV3kQf153Qp23aV7JPoIVkNB4jbCAKJX41qauEcw7rl4ujbFHl6qQw3z68tkPNASVi9FBX7g6633QmZt+Y280CGCwW7J190vSO4XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIc4An1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIc4An1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDF01F000E9;
	Tue, 21 Jul 2026 21:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668877;
	bh=qAjzRv2M6oyd72AIE3l+/nUhroOhtygGpWkTLp8+V0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIc4An1S+p5SxMtmX1rREj+1H9P37f6HV8SuT217lvG64Ye3cR5c/VEUa253eHC3C
	 9UEvpyCZ6jA5mi1qCi6eEU/fiijGDQ6p+ci/zXUBQBVpHVXeTQfIcPih2keeBKPRrM
	 TB0BQmjeEFQl46lMpehCJE+pDUxtmVTgVdmatQtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0343/1067] drm/tegra: dc: Fix device node reference leak in tegra_dc_has_output()
Date: Tue, 21 Jul 2026 17:15:44 +0200
Message-ID: <20260721152432.267320057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 63a3998d792ab5c45304bf879e385a31fa923b61 ]

The of_for_each_phandle() macro increments the reference count of the
device node it iterates over. If the loop exits early, the reference must
be released manually.

In tegra_dc_has_output(), the function returns true immediately when a
match is found, failing to release the current node's reference.

Fix this by adding a call to of_node_put() before returning from the loop.

Fixes: c57997bce423 ("drm/tegra: sor: Add Tegra186 support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260128-dc-v1-1-a88205826301@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 35a1371fb10e2d..0e5051cda70f31 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -99,8 +99,10 @@ bool tegra_dc_has_output(struct tegra_dc *dc, struct device *dev)
 	int err;
 
 	of_for_each_phandle(&it, err, np, "nvidia,outputs", NULL, 0)
-		if (it.node == dev->of_node)
+		if (it.node == dev->of_node) {
+			of_node_put(it.node);
 			return true;
+		}
 
 	return false;
 }
-- 
2.53.0



