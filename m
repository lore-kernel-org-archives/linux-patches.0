Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72C129ECD;
	Mon, 18 Dec 2023 13:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzsU2rGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1A0C433C7;
	Mon, 18 Dec 2023 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907980;
	bh=7wRPsUBq+fzThGFp/Ilsl8ezJnAQzawJHs4gZl5rMH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzsU2rGTD+Uo24BQIMqT6sh1Dvh0hzH8jLxB8dEgSBEgnajffleHi8Ka6uG2kEzeH
	 w3FnTqlVgdLe1UQpmJK8m8Z9e0p25kzzDQDN60gqKWpu+wvuDwHVEqPUHPEwpPrTTB
	 v1E3zGfA7Fu//JUwisBogh8hViCzcVX+8hypJ1fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/166] net/mlx5e: Tidy up IPsec NAT-T SA discovery
Date: Mon, 18 Dec 2023 14:49:36 +0100
Message-ID: <20231218135105.421637705@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c2bf84f1d1a1595dcc45fe867f0e02b331993fee ]

IPsec NAT-T packets are UDP encapsulated packets over ESP normal ones.
In case they arrive to RX, the SPI and ESP are located in inner header,
while the check was performed on outer header instead.

That wrong check caused to the situation where received rekeying request
was missed and caused to rekey timeout, which "compensated" this failure
by completing rekeying.

Fixes: d65954934937 ("net/mlx5e: Support IPsec NAT-T functionality")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 22 ++++++++++++++-----
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index fc6aca7c05a48..6dc60be2a697c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -974,13 +974,22 @@ static void setup_fte_esp(struct mlx5_flow_spec *spec)
 	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, IPPROTO_ESP);
 }
 
-static void setup_fte_spi(struct mlx5_flow_spec *spec, u32 spi)
+static void setup_fte_spi(struct mlx5_flow_spec *spec, u32 spi, bool encap)
 {
 	/* SPI number */
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
 
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters.outer_esp_spi);
-	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.outer_esp_spi, spi);
+	if (encap) {
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 misc_parameters.inner_esp_spi);
+		MLX5_SET(fte_match_param, spec->match_value,
+			 misc_parameters.inner_esp_spi, spi);
+	} else {
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 misc_parameters.outer_esp_spi);
+		MLX5_SET(fte_match_param, spec->match_value,
+			 misc_parameters.outer_esp_spi, spi);
+	}
 }
 
 static void setup_fte_no_frags(struct mlx5_flow_spec *spec)
@@ -1339,8 +1348,9 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	else
 		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
 
-	setup_fte_spi(spec, attrs->spi);
-	setup_fte_esp(spec);
+	setup_fte_spi(spec, attrs->spi, attrs->encap);
+	if (!attrs->encap)
+		setup_fte_esp(spec);
 	setup_fte_no_frags(spec);
 	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
@@ -1443,7 +1453,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	switch (attrs->type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
-		setup_fte_spi(spec, attrs->spi);
+		setup_fte_spi(spec, attrs->spi, false);
 		setup_fte_esp(spec);
 		setup_fte_reg_a(spec);
 		break;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f08cd13031458..8ac6ae79e0835 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -620,7 +620,7 @@ struct mlx5_ifc_fte_match_set_misc_bits {
 
 	u8         reserved_at_140[0x8];
 	u8         bth_dst_qp[0x18];
-	u8	   reserved_at_160[0x20];
+	u8	   inner_esp_spi[0x20];
 	u8	   outer_esp_spi[0x20];
 	u8         reserved_at_1a0[0x60];
 };
-- 
2.43.0



