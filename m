Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE001E9B38;
	Tue, 21 Jan 2025 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482043; cv=none; b=C+H+8OhKIXO26b0tOVR6r5av2o5JLJrm9NwKTXy1teogKRjJuO6jaJS0gfxwoEuWJwYacOSSJratRHogl6aajnMYBKS/Dcsf/uVwXLI0DsoLIrIm4P9Tps45Zmfkjs5lqdZ8oEkKuy0GQin2vSqqYgPC71JHiSutbG/Fshlbf2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482043; c=relaxed/simple;
	bh=6rb6ZqroCk7MOoOPus7r2o5WeKDmtC9PSsG4PA40nC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6ThfN/L4wvtPkv0kIwn3v325OVap4YzkrwQ2NPTr9pMtmn4/Ip9Fd9PDhqiqc73W6IBDPmhfbugH9YHBgvLYAEooWh99uu8bZJMeYH2z4SNpu5L8xW923y/AGHA78Y3celEOR/m6wnHjyUnUpCacaC3g4wuzwkyUMMCshv94JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojUyJBKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojUyJBKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1056C4CEDF;
	Tue, 21 Jan 2025 17:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482043;
	bh=6rb6ZqroCk7MOoOPus7r2o5WeKDmtC9PSsG4PA40nC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojUyJBKo8fLte6ShN1QmzLyp/GxD4g/8hHF7YyzsZPF2MuU/TrVBKkE8HzwuEWcLj
	 XMvalJNBJ2z+azuWaij50XvR1bZBboDthgwOMUOrKM72KmNA8k6+i4bLxx62cJCIlw
	 SjQweHGRXIvihgszVaAqTx2zfYk702E2MwHFJXNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 15/72] net/mlx5e: Rely on reqid in IPsec tunnel mode
Date: Tue, 21 Jan 2025 18:51:41 +0100
Message-ID: <20250121174524.013191410@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 25f23524dfa227959beb3b2c2c0f38e0222f4cfa ]

All packet offloads SAs have reqid in it to make sure they have
corresponding policy. While it is not strictly needed for transparent
mode, it is extremely important in tunnel mode. In that mode, policy and
SAs have different match criteria.

Policy catches the whole subnet addresses, and SA catches the tunnel gateways
addresses. The source address of such tunnel is not known during egress packet
traversal in flow steering as it is added only after successful encryption.

As reqid is required for packet offload and it is unique for every SA,
we can safely rely on it only.

The output below shows the configured egress policy and SA by strongswan:

[leonro@vm ~]$ sudo ip x s
src 192.169.101.2 dst 192.169.101.1
        proto esp spi 0xc88b7652 reqid 1 mode tunnel
        replay-window 0 flag af-unspec esn
        aead rfc4106(gcm(aes)) 0xe406a01083986e14d116488549094710e9c57bc6 128
        anti-replay esn context:
         seq-hi 0x0, seq 0x0, oseq-hi 0x0, oseq 0x0
         replay_window 1, bitmap-length 1
         00000000
        crypto offload parameters: dev eth2 dir out mode packet

[leonro@064 ~]$ sudo ip x p
src 192.170.0.0/16 dst 192.170.0.0/16
        dir out priority 383615 ptype main
        tmpl src 192.169.101.2 dst 192.169.101.1
                proto esp spi 0xc88b7652 reqid 1 mode tunnel
        crypto offload parameters: dev eth2 mode packet

Fixes: b3beba1fb404 ("net/mlx5e: Allow policies with reqid 0, to support IKE policy holes")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c  | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 61288066830d9..2382c71289857 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1442,23 +1442,21 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		goto err_alloc;
 	}
 
-	if (attrs->family == AF_INET)
-		setup_fte_addr4(spec, &attrs->saddr.a4, &attrs->daddr.a4);
-	else
-		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
-
 	setup_fte_no_frags(spec);
 	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
 	switch (attrs->type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
+		if (attrs->family == AF_INET)
+			setup_fte_addr4(spec, &attrs->saddr.a4, &attrs->daddr.a4);
+		else
+			setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
 		setup_fte_spi(spec, attrs->spi, false);
 		setup_fte_esp(spec);
 		setup_fte_reg_a(spec);
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
-		if (attrs->reqid)
-			setup_fte_reg_c4(spec, attrs->reqid);
+		setup_fte_reg_c4(spec, attrs->reqid);
 		err = setup_pkt_reformat(ipsec, attrs, &flow_act);
 		if (err)
 			goto err_pkt_reformat;
-- 
2.39.5



