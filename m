Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6DE35BDAF;
	Wed,  3 Dec 2025 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780094; cv=none; b=Ev+RHFAzsgWW1Fkzwvx0KkDoiyB0p3yeASLz7YskQcw1HkMH/LYFo9UI8N4PS5BGuE3OJSfHSO3tKY2w/CSFWlJCVPbmfj2zShxtp7fa9JYqwRmC5czQcDOSGtD62CbSJW7HBmrHmb3JLsGFvvl65ni2g3EbipsvxPmDrc2XvIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780094; c=relaxed/simple;
	bh=pX5hTD6PQwQ6H5V2F+z3zNxoFpdef0liAEEPmLQn2zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPYJkxmXisbRRbyqRgKA05PORUaSxe/vOtespD5tY3zMu49AyleST5Q7weDC9agfmtnm+A4qMXhiJfPdHnO2v5QP0XN1XPMFazyxys3+x3Q+rmnuVjTOWPMqRjLmfQFuyt1UhZDl4gzjxj5wr7HywyaHGWWfl+mosS+4eKiyz6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5WbNHfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5WbNHfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3873C4CEF5;
	Wed,  3 Dec 2025 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780094;
	bh=pX5hTD6PQwQ6H5V2F+z3zNxoFpdef0liAEEPmLQn2zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5WbNHfiG/Jn4QYmOr4knS31CSjV8d+qnYTkKzV8bWbrap1EOxbE+L+yf8Bv7K1Ql
	 9k0XsuGOuAVWNEI+gfP1vNHSqAdPlmb0sBPNj2bPCly+zyA7DFcjNuaDjBkAfoGTZM
	 w8LdEi3X6CNhTl4Ael2Z7LcXSOYoZPTXq9Rq6DaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 452/568] mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()
Date: Wed,  3 Dec 2025 16:27:34 +0100
Message-ID: <20251203152457.261176628@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 407a06507c2358554958e8164dc97176feddcafc ]

The function mlxsw_sp_flower_stats() calls mlxsw_sp_acl_ruleset_get() to
obtain a ruleset reference. If the subsequent call to
mlxsw_sp_acl_rule_lookup() fails to find a rule, the function returns
an error without releasing the ruleset reference, causing a memory leak.

Fix this by using a goto to the existing error handling label, which
calls mlxsw_sp_acl_ruleset_put() to properly release the reference.

Fixes: 7c1b8eb175b69 ("mlxsw: spectrum: Add support for TC flower offload statistics")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251112052114.1591695-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index e91fb205e0b4c..66e95918bdf6e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -719,8 +719,10 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 
 	rule = mlxsw_sp_acl_rule_lookup(mlxsw_sp, ruleset, f->cookie);
-	if (!rule)
-		return -EINVAL;
+	if (!rule) {
+		err = -EINVAL;
+		goto err_rule_get_stats;
+	}
 
 	err = mlxsw_sp_acl_rule_get_stats(mlxsw_sp, rule, &packets, &bytes,
 					  &drops, &lastuse, &used_hw_stats);
-- 
2.51.0



