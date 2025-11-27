Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7336E28135D;
	Thu, 27 Nov 2025 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255860; cv=none; b=Phz6bTDSnsTuHH0KVUHE7Z9jIjZf/32EcpvrwXvZhpL8gwbkXIM3xR379+wbYCQCNS8EgZaOpzuBJkAE9xTfuUCaDUdElwBEE50cUqMJtIXo0817l1jExJJaGHnDsWRMga71tZ725TQcHJkyOixhsDGEiJWJxY11GgHXc3Ool/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255860; c=relaxed/simple;
	bh=xEYcQDAsjxtpEyuP5RyYeF6Lq7ieN7HKIWrOrQu6Tjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRnl6nzxCbEafdBxvbpjDBSyyZ+VgMP41QwYvZ7tEZ2903xyNjX0xCd8RbElVeVwSV7FIO6Qt+FU6i180ivP/1gCBBgakIWldFFWlEiACwQY2Mi5Er64DZa2rkFOz9zHx+nbmyojgZl1aAxQEAUplRdgqIh3OcoiiUlMqbx8vIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3T1QV6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3T1QV6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F16C4CEF8;
	Thu, 27 Nov 2025 15:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255860;
	bh=xEYcQDAsjxtpEyuP5RyYeF6Lq7ieN7HKIWrOrQu6Tjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3T1QV6yN2Re3TeeiZPgJd6eGKnLY3d7w3h002KzZtHPmCOv2EsmIXviNwYH67EUD
	 tboEb+OaPzFMz9fbz8HkjSGq9Lf/icZsVtvO/a+jRUwKVHC8/eIRBa+WFxOoTb2nM1
	 0reEMi/QJgV7EViyyi6hQIOK2FQB9oQbd3Hf0TNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 096/175] mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()
Date: Thu, 27 Nov 2025 15:45:49 +0100
Message-ID: <20251127144046.467085240@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 6a4a81c63451c..353fd9ca89a68 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -830,8 +830,10 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
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



