Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B978277CB8;
	Mon, 13 Oct 2025 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367321; cv=none; b=ZC3sOWPpccafgo59xRbk0CGAs87U73BiiwuScLrpIexX56tBR4R9kvgY0PndAuXhZd+jW58wHePVu9dME9temFbNCmDWa4c3ka6Y3CzSMwYxIigyBC+pbqJGFsDryN/lleeFpdMtWK+psA3J/B63Q0JRukJSj+LUNEMUoNt+DmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367321; c=relaxed/simple;
	bh=SsqTnDHw0m4CU3s2fBFpEEHaD3Zq3E+VOjdeE5+rKoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IroIFj3XWsZfkisf1ZgaT/UdynC05NJaNownILfFdc1VEYEteppkVC4yxiQubPT+o4SvIrEHLoOZnN3XTN1hVOugLaMMDMbdb9JLkBP9RnkjnrUkLmwqaU1V2J05r1s7CG/D3z21owOkLYjUd+tjhsBqqGTqvwEEkeT5PmMpgsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPH+V+cV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPH+V+cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DB6C4CEE7;
	Mon, 13 Oct 2025 14:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367321;
	bh=SsqTnDHw0m4CU3s2fBFpEEHaD3Zq3E+VOjdeE5+rKoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPH+V+cVl50Kbww4aw2JeqkVGFs5i+rIirogdIpZ6u64IBxoecqsN56TqazYkK2+1
	 vz39hXy1ADElECGlMTproHIYRu4Dh7ev+UDo62GvmTmlEBwcmzFNeDOrNcT0gjlW4/
	 PBJiPrRtqtmrf4HFnhwiDP7MWKL4nGbz5DUQPE8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/196] net/mlx5: pagealloc: Fix reclaim race during command interface teardown
Date: Mon, 13 Oct 2025 16:45:42 +0200
Message-ID: <20251013144320.810584900@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 79a0e32b32ac4e4f9e4bb22be97f371c8c116c88 ]

The reclaim_pages_cmd() function sends a command to the firmware to
reclaim pages if the command interface is active.

A race condition can occur if the command interface goes down (e.g., due
to a PCI error) while the mlx5_cmd_do() call is in flight. In this
case, mlx5_cmd_do() will return an error. The original code would
propagate this error immediately, bypassing the software-based page
reclamation logic that is supposed to run when the command interface is
down.

Fix this by checking whether mlx5_cmd_do() returns -ENXIO, which mark
that command interface is down. If this is the case, fall through to
the software reclamation path. If the command failed for any another
reason, or finished successfully, return as before.

Fixes: b898ce7bccf1 ("net/mlx5: cmdif, Avoid skipping reclaim pages if FW is not accessible")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 99909c74a2144..cab25eb30ca66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -483,9 +483,12 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	u32 func_id;
 	u32 npages;
 	u32 i = 0;
+	int err;
 
-	if (!mlx5_cmd_is_down(dev))
-		return mlx5_cmd_do(dev, in, in_size, out, out_size);
+	err = mlx5_cmd_do(dev, in, in_size, out, out_size);
+	/* If FW is gone (-ENXIO), proceed to forceful reclaim */
+	if (err != -ENXIO)
+		return err;
 
 	/* No hard feelings, we want our pages back! */
 	npages = MLX5_GET(manage_pages_in, in, input_num_entries);
-- 
2.51.0



