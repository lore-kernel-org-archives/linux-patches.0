Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB8726D4E2;
	Tue,  2 Sep 2025 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820359; cv=none; b=UDcSTjIDZE6uiLY6zBs63k0WXwINLAcRvoLocBaeOa9bGUPxd9NLIniuG5O6xIEmWujYW877Rk8Lavs15OpqFialigDY9GfFhT98zKECy6h7xz2gIYV49FXvBFQ0eAaFpbpZbt5OCwY85CHKgflH9ER+SS7Gqa1rkuVkO9kfhg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820359; c=relaxed/simple;
	bh=r/wSvhzzqd3yrN/OlzDeNhtM0wFNPASluUJM5KBn+2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbCGDfsuTotK3aF9tIIVQbjoRgyeW2J2+s99ngvJR6aJMZe+9YnKCf2y+BttFDcWbweAI7vuS6oTChM9MlmwCzYClWnk/209FBnvIH1Fy+RmFUlD/cNIiUdKfluu1MrHCg5sv4KD9xgj0FJT8o6mkelg9zJarBOlAiwJuuKwHwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZX1AKhu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZX1AKhu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E247C4CEED;
	Tue,  2 Sep 2025 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820356;
	bh=r/wSvhzzqd3yrN/OlzDeNhtM0wFNPASluUJM5KBn+2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZX1AKhu5NjyxnsDH++3op/WfjCQW3gf78Nx/FfvqxbKH0utAggV/tK0zJi1koNX0u
	 5KagGdFTtDtbtQDi6WlrWrERfL6LT6Vi9vLoSv8BIXVJoIwITpcW0RF8aTkIofgVSx
	 YB9WirR8NF+90OPj0RvRNeGk12MvLukI+1zGWmts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 71/75] net/mlx5: SF, Fix add port error handling
Date: Tue,  2 Sep 2025 15:21:23 +0200
Message-ID: <20250902131937.896057657@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

From: Chris Mi <cmi@nvidia.com>

commit 2011a2a18ef00b5b8e4b753acbe6451a8c5f2260 upstream.

If failed to add SF, error handling doesn't delete the SF from the
SF table. But the hw resources are deleted. So when unload driver,
hw resources will be deleted again. Firmware will report syndrome
0x68def3 which means "SF is not allocated can not deallocate".

Fix it by delete SF from SF table if failed to add SF.

Fixes: 2597ee190b4e ("net/mlx5: Call mlx5_sf_id_erase() once in mlx5_sf_dealloc()")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -280,6 +280,7 @@ static int mlx5_sf_add(struct mlx5_core_
 	return 0;
 
 esw_err:
+	mlx5_sf_function_id_erase(table, sf);
 	mlx5_sf_free(table, sf);
 	return err;
 }


