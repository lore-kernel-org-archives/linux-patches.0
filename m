Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060947;
	b=QrZ8vngoa/7ZZDLFmm7UrD27zA9Txqx9TsAv7/JUnotgPh0SKKOLC6VZlp7C09cvHMO/
	 QcQFOBg0dG3uJWVnLBjV66NVil8U7Cd4judgwSYikc2FuVR/Yqfn5CH7IeXJI7vdzKVE4
	 oxC3L0H15DIRSipz2D/y9Voa+bWGilabWw1ACc+B26mwKsl2x0emFeWX7mKxzVE2ts5Vk
	 azqB5DFqgCfntrKIgnxGjzVxRp8nyDfzT8c2DFEjWKb/GacbAx+d1sGpMNcJXsPXwxRx9
	 d1epQu4hlBFyelaykKwJfuXdhNikHcWd2UM3cL1duKJ8J/QZ2m6CcoimiebOFF5hRSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mjJ2UulGYriwcZkAd7IF/hYNvGlHEQLxqmPM0qFDrh4=;
	b=RadUH3IRa4MWGjlGddYW1ZvmdeZ40jmS8jR4HxGLrN3eu7krA1beBijvbqWu6j27iMI7
	 j7cG4+Wpm/Yn1r3S4ENJog22OmED4ELlf0QG+6TCrk+EC0rDRf/68obXkJa+3J2BZmIaW
	 fbtdifDGpDO2lqwpCroX/kHMxXXjvPCR0428VCh/EPwYShSjgPoccpl7cAdnYgKbgmiE2
	 eoMv91S95Pnut+8h5cP4jjjiMfighIai0tkxl0L6Sb/caUbYR7DTMY4KbfCyecf7Trbxd
	 ItLySaMpVlH+p+evoWgnpiE/Znvx2YI+yP5qQbwAFDRgW4YX5kEU97NRHaOYc5UlLQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPnfKrQG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B407606A320;
	Thu, 19 Nov 2026 04:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPnfKrQG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7D61F000C4;
	Thu, 19 Nov 2026 04:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060946;
	bh=mjJ2UulGYriwcZkAd7IF/hYNvGlHEQLxqmPM0qFDrh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPnfKrQGdO5abSOoKVbxR7mV9fsWy9vufqYJks/4s+1FXxNWCz/fWkRgSQbourDiE
	 IkvV2wGNoDzBSksXEECFnnpCf58gz6a+aeg5u0x4mqMNr9X8ODc4VR4BZHEC7TIM7c
	 NU8eDBPiBya8DuF1QbwElLdjzGt8LykbvcT6mCZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1382/1848] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Wed, 18 Nov 2026 15:57:00 +0100
Message-ID: <20261118150017.340817934@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 829a0e65deff3f826a7870a52404aeaf1a3fec3f ]

create_resource_common() inserted the resource into the radix tree
before its initialization was complete. A firmware EQE in that window
finds a zero refcount_t and calls refcount_inc() on it; the refcount API
treats this as a use-after-free, saturates the counter, and permanently
breaks the resource's lifecycle tracking.

Move the initialization before the radix_tree_insert().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-15-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qpc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 245b7675bb4d9..c17feea1a6248 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -159,6 +159,10 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	int err;
 
 	qp->common.res = rsc_type;
+	refcount_set(&qp->common.refcount, 1);
+	init_completion(&qp->common.free);
+	qp->pid = current->pid;
+
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree,
 				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
@@ -167,10 +171,6 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	if (err)
 		return err;
 
-	refcount_set(&qp->common.refcount, 1);
-	init_completion(&qp->common.free);
-	qp->pid = current->pid;
-
 	return 0;
 }
 
-- 
2.53.0



