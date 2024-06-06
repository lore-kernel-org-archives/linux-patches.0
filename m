Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D576A1C95E2;
	Thu,  6 Jun 2024 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683733; cv=none; b=Npv0xoKRCOLDOyZAbd81rNZdoutGHoxLkVVpjWvi61zNS4MTTWaWNFI3ypYzxTJhSlpU7jo17A2kdlFyFPSd025YsmH0MokNnmpiWoGh5IM1j4gMs4fsHZkOWnFuV49EY39DeLdChzCDs4DjpIlmAP6qH94TITXaSt0eDSWdSZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683733; c=relaxed/simple;
	bh=We5U7r9KzFKQ76wwzxSRoisoiFKBy2Roscf7HCueZ7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9NWQnI5ktc5FtXCMMhNsmq+FhhmUdSm9nzSELouHKhlYQhcERBlX7MQlAsRi6AMraGB4b1BFBnbHRCiR6M9eZ+Spe5QltQtWMiaTjHlvHUxb5GjkhVMXb0T10MU+SlUj1Z0ILFsZ+/Iym5lOdXnpaZn3gQiCPzXlBQgaJ7jP10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bwm9/H4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bwm9/H4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9694C2BD10;
	Thu,  6 Jun 2024 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683733;
	bh=We5U7r9KzFKQ76wwzxSRoisoiFKBy2Roscf7HCueZ7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bwm9/H4LivH2CBbLuKBwOVj3KghIvGXLbXG3oofl2HQ3gdmz4ztyCZOK2/5aONdYU
	 d9QhiAGgKYJCsgK5W/uivGKF1UvyJAEAy/rdmKDc/H/189ssl/riVdH5Jb15TWj6C7
	 Kvv5H8cK55hHQdvV8TUHJvvCuLN8fGUag6A8+BM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 687/744] net/mlx5: Use mlx5_ipsec_rx_status_destroy to correctly delete status rules
Date: Thu,  6 Jun 2024 16:05:59 +0200
Message-ID: <20240606131754.522824838@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 81e6aa6434cf2..61288066830d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -512,8 +512,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
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



