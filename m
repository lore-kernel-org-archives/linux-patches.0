Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF68B1925AA;
	Thu,  5 Sep 2024 09:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529379; cv=none; b=DW815ue7iS7fmF6tfPqJ4i88USBzESU/GA3X6mI/MEv0vNL+YxdlvGHa9NXdlKGrI9IA8ciV1eUyKBp3h9itJO8bFlHnphGSAV6WTfA18hCQ2W9Uxdt07N/HVg/17qnFUO8BrW8TJG0YCtIIC59LpHyCkvJ/+n61hYUQVN7tYsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529379; c=relaxed/simple;
	bh=r8NH1EmK87BmBNBPhgUhQTZs9BvvWbhe33KVCLfB1cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgWll8noyTHAUnazDLW4+acjW236kJAzL7TmVFGltzEIAfjnUTcZgR9nbX/vwWNmCA1jUNSmLtqVXJG8p/elBfrSvyGlLRQph1mc0GDd+j4UZmXeytzxut26ie3kJVHqllCpsdSszYQUsMhg0b7CjMZ7MolXDKWz6i6uW4IIvM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSdIbayq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSdIbayq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166EBC4CEC3;
	Thu,  5 Sep 2024 09:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529378;
	bh=r8NH1EmK87BmBNBPhgUhQTZs9BvvWbhe33KVCLfB1cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSdIbayqbG0qxJjJ9OZY4WHU0druoZpkKwEUB/zWlq00nAqB7u7qJInMTNjgqD6an
	 zFuJ/4dwTAMDyKHKTwWVWd/x1znW3gPomSHVEoPWuO0hw7IYaw1lXi7g1L8jthGx+o
	 5z3pzpI/1h7fofUu1gdn7H9PBf1kdAP79NXahI8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Alex Vesker <valex@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 014/184] net/mlx5: DR, Fix stack guard page was hit error in dr_rule
Date: Thu,  5 Sep 2024 11:38:47 +0200
Message-ID: <20240905093732.798162271@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 94a3ad6c081381fa9ee523781789802b4ed00faf ]

This patch reduces the size of hw_ste_arr_optimized array that is
allocated on stack from 640 bytes (5 match STEs + 5 action STES)
to 448 bytes (2 match STEs + 5 action STES).
This fixes the 'stack guard page was hit' issue, while still fitting
majority of the usecases (up to 2 match STEs).

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 042ca03491243..d1db04baa1fa6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -7,7 +7,7 @@
 /* don't try to optimize STE allocation if the stack is too constaraining */
 #define DR_RULE_MAX_STES_OPTIMIZED 0
 #else
-#define DR_RULE_MAX_STES_OPTIMIZED 5
+#define DR_RULE_MAX_STES_OPTIMIZED 2
 #endif
 #define DR_RULE_MAX_STE_CHAIN_OPTIMIZED (DR_RULE_MAX_STES_OPTIMIZED + DR_ACTION_MAX_STES)
 
-- 
2.43.0



