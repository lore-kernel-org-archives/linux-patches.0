Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADAA198A20;
	Thu,  6 Jun 2024 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683055; cv=none; b=VgtrX4Uuu2GefG0kjJAuodIvMqUqvoELGA8Tv45rew5HmtTcVgkfD47XodVypK0Lf0KAsoPYUjJ5ObQS66NHvcLiBc6DZWb5fhW5YO01APWo5vjYtg0MJIKLX/G8QYKK0Vvd4LCdrO4vE9WRkd4F3gJ6kt2E/g30Fpb2D9OrdOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683055; c=relaxed/simple;
	bh=3n9XkyVschkoB2AVqgQUf+XsF/7OVm2727PBCrj1b1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7+AsRcBVP5HzmmNqegFNs36FzJSZJ/8v4GM3FHizO6JMvOjEM86KXgMV7MmM8JzgjWthrVbfNvQopOuT7CyMXcLDhnDAlQsh/3jFa7T9J/FwbiNSUqtkHbrZ3/I81MjhBrYueSMTULF7z7GbKQlckVdtnfhOSyVaNwa11e149c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J70di1Bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J70di1Bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA23C4AF15;
	Thu,  6 Jun 2024 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683055;
	bh=3n9XkyVschkoB2AVqgQUf+XsF/7OVm2727PBCrj1b1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J70di1BpaRSx52BYU9OSDM/LexechO3Ni2+46Sp1fKlepwSce6H2f+TP7Q4s+5C5q
	 a0xeWpZk0FXRsIuhN4menr6PTlwzV9QyyilmmvN//IwlE1m6T2jmRMInXOa23WVxZo
	 Py0fM6LuENHCg+wvZkle+LM6u4QVMISvLGD3ZrCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 299/374] net/mlx5: Use mlx5_ipsec_rx_status_destroy to correctly delete status rules
Date: Thu,  6 Jun 2024 16:04:38 +0200
Message-ID: <20240606131701.880848050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 16d66a4fa81da07bc4ed19f4e53b87263c2f8d38 ]

rx_create no longer allocates a modify_hdr instance that needs to be
cleaned up. The mlx5_modify_header_dealloc call will lead to a NULL pointer
dereference. A leak in the rules also previously occurred since there are
now two rules populated related to status.

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 109907067 P4D 109907067 PUD 116890067 PMD 0
  Oops: 0000 [#1] SMP
  CPU: 1 PID: 484 Comm: ip Not tainted 6.9.0-rc2-rrameshbabu+ #254
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Arch Linux 1.16.3-1-1 04/01/2014
  RIP: 0010:mlx5_modify_header_dealloc+0xd/0x70
  <snip>
  Call Trace:
   <TASK>
   ? show_regs+0x60/0x70
   ? __die+0x24/0x70
   ? page_fault_oops+0x15f/0x430
   ? free_to_partial_list.constprop.0+0x79/0x150
   ? do_user_addr_fault+0x2c9/0x5c0
   ? exc_page_fault+0x63/0x110
   ? asm_exc_page_fault+0x27/0x30
   ? mlx5_modify_header_dealloc+0xd/0x70
   rx_create+0x374/0x590
   rx_add_rule+0x3ad/0x500
   ? rx_add_rule+0x3ad/0x500
   ? mlx5_cmd_exec+0x2c/0x40
   ? mlx5_create_ipsec_obj+0xd6/0x200
   mlx5e_accel_ipsec_fs_add_rule+0x31/0xf0
   mlx5e_xfrm_add_state+0x426/0xc00
  <snip>

Fixes: 94af50c0a9bb ("net/mlx5e: Unify esw and normal IPsec status table creation/destruction")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 41a2543a52cda..e51b03d4c717f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -750,8 +750,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 err_fs_ft:
 	if (rx->allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(mdev);
-	mlx5_del_flow_rules(rx->status.rule);
-	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
+	mlx5_ipsec_rx_status_destroy(ipsec, rx);
 err_add:
 	mlx5_destroy_flow_table(rx->ft.status);
 err_fs_ft_status:
-- 
2.43.0



