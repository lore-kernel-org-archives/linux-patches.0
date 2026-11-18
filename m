Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060977;
	b=IvrFhcXygh02G1IsHq3tdX5MarB8Sb5R99uXQO4VV4jWdfj+eohoAZTecRXsDQuARiE9
	 Wxxazppadw7JmOpuBmBCsIZkMHAfUwUTj5r28IWWGmxrQGd4Zmc/EeKvEnULjOMuv72pZ
	 ebeqXmbEZ8HzeswXFTuMBGAwuaoGWmELgRG6bbxogCQPNIT2/ynQkuV+UW/98F4/8CYNr
	 JstV/KwRcRo9gDJLeotBrxEPlqS0EN1XxyRV9dR2K+D2klRXKJcIQ4Ajm3fcdJrOVAIZ/
	 p2gYPdpljsJAONZ9WoOYmqjUCcyYcKymZdo95sK7FbihNcQfpx+NdP7R8ezDHRrAmIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N4ckOIEiYy80v09AMG3fEndlD9md6OzfXZ9lBQzmUVE=;
	b=ifu/Tpz1BsMDNABjGnNKpLsb89j41KP74041gH8N3fajrPbvufO9woeNVoWkCevQ//a3
	 X09j5SVorTMBHBRUILukNG45HdRxlJB+Hwb8SSAymYSAGTKHJuRmIsjmQiDaJ+iuPaKDd
	 pGKvht+ALShpDSNTdfmg3zvh0rRAJlmhynzk3EYjUcpVWfI5WkLCqbjdx6qbtdSeMn1wA
	 SHG4pa5p+gj5SSAbY9Pj3ceDTSWbFDj7hN6URDpYqBN0QuI2a6yYhI6tVPY3NHgq/IbgD
	 yIunRSwNiFkLcAFBeGST1NKsPPK0e7zsbc/ZuJT6hS1dDzwTfqAYmwitq+FQqruOdjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcyXu5vi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A48E606A326;
	Thu, 19 Nov 2026 04:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcyXu5vi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08111F000C4;
	Thu, 19 Nov 2026 04:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060977;
	bh=N4ckOIEiYy80v09AMG3fEndlD9md6OzfXZ9lBQzmUVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcyXu5viwgro49edfrGUn9HWjiOPFos/gTPNUdavaDJWMgSPVv+8JGCoz70c1arvU
	 ho871u493U5RrpY+HggVTVbZ6KiHsdSccsRXKj0ZVJ1DdK15bJJtj92KbSywPGOjos
	 kTrddGbQigFFrO5jZua1Upk+Syez3PYdJxn62o6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1392/1848] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
Date: Wed, 18 Nov 2026 15:57:10 +0100
Message-ID: <20261118150017.717891905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9728effe43d8fc4d58e12b697d0d6127355abdd5 ]

In handle_reg_mr_integrity, when mr->pi_mr is NULL (physical-address
optimization path), the code points mr->pi_mr at a stack-local pa_pi_mr
so set_pi_umr_wr can read it during this call. The pointer is never
restored, so after the function returns mr->pi_mr dangles at a freed stack
frame. A second IB_WR_REG_MR_INTEGRITY posted on the same MR without
remapping reads the stale pointer and dereferences it.

Save the original pi_mr (captured at function entry) and restore it on
the out path.

Fixes: 2563e2f30acb ("RDMA/mlx5: Use PA mapping for PI handover")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260919100848.2442-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/wr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 19fd440a6ce38..52c3ed0abb241 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -1146,6 +1146,7 @@ static int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 	qp->next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 
 out:
+	mr->pi_mr = pi_mr;
 	return err;
 }
 
-- 
2.53.0



