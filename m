Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EDE30567C;
	Thu, 30 Jul 2026 15:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425241; cv=none; b=YfHNzD0vttWkPhFSMPU5u6+pXG+e6a5xAqHpTqnT26phh8gWsF1ZkCF14D/dM6PzAuAMfgXZidwF/gp2ALZw7mu3nLFwnAkuBplr1/sT6sqiUONdhiIzoZnopa1LwVa9QP9MvR3dp2E+nq7D6ugrvnYZYWhM/Ukp1DHZYcIQn7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425241; c=relaxed/simple;
	bh=eTeY5XCZGovikOhin8Sc1t1pjZKI2mdJ/oxhPhvG/3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LseMe3hhekSr2pf6VXP+G0Jy/sN/wmnCVgdinm15ME9+6DDlpb+nJ2JBBFKTtXglrAQIWJpu2riwCyqfsHPlLP/FCq37tHI2/h8i3JKLqVTUyI5CK6nVDFHpb6HcI6eLeeoOM13MmwtLMgp1Swu4j0RmW/daPnSZq8DxoJyWmTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvS81O2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvS81O2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628431F000E9;
	Thu, 30 Jul 2026 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425240;
	bh=JL7FVxGKfdbjd9Wn9x+eEcTr/j+LW2FVxJSOF7m64iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvS81O2qX5Y6VyErB+eix2j9q/ZxQmKrO+t9JRlqNoV6+sHEtDrZi47lJQtRMydNs
	 Sks7nxuemC/ERRAGL4HKOjdxrUFeQw5YgMEC3eqPky8Bgca6CHm9VD/fvM/yCIJikc
	 sZQbvp8Go7W+YDZEEqwbOlNSGJkfgCcnropJ3D/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 672/675] net/mlx5e: Fix NULL pointer dereference in ioctl module EEPROM query
Date: Thu, 30 Jul 2026 16:16:42 +0200
Message-ID: <20260730141459.445149105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

commit 7d36a4a8bf62dc508bc6bb4b59727aec25064ca5 upstream.

The mlx5_query_mcia() function unconditionally dereferences the status
pointer to store the MCIA register status value.
However, mlx5e_get_module_id() passes NULL since it doesn't need the
status value.

Add a NULL check before dereferencing the status pointer to prevent a
NULL pointer dereference.

Fixes: 2e4c44b12f4d ("net/mlx5: Refactor EEPROM query error handling to return status separately")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20251225132717.358820-4-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -393,9 +393,11 @@ static int mlx5_query_mcia(struct mlx5_c
 	if (err)
 		return err;
 
-	*status = MLX5_GET(mcia_reg, out, status);
-	if (*status)
+	if (MLX5_GET(mcia_reg, out, status)) {
+		if (status)
+			*status = MLX5_GET(mcia_reg, out, status);
 		return -EIO;
+	}
 
 	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 	memcpy(data, ptr, size);


