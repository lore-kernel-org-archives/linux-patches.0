Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021628;
	b=2XbyGO3RQeKZWYv/j/wHzsZthZ/xlpRoivN6rexKiHYPcmRR0+7IiNIyM2IZ6jKrjHjZ
	 h+DPOYtKbw0vordG/VLlqQuErV3Bo7b685ai5mN//aJi3mhltkLEyD8dLgDekGTDxvLNY
	 N8GS34Ez/kBy19V4ajALlsdaAPYTerJZRWXLa9LnSGES2LIfz1UxJ77pMZtISJ7UKbOGT
	 snIi+JWYVx9wZ7Y+OARl8eyiN47YX+dwPVMbcgsswwlcRKDvB4x1fEsVzgyXGX0Gp2y4z
	 KZUqNoxdYFuB45F3wTh4nNej2W49r0p3Yv29fWHtJI0X9Nexeb0ua5C8AMvjxfG13Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vvdrgGHa/bdabSGnkONfZyQKR1EtZVwUFnYG7pB03cU=;
	b=fpUFi3cqkhgMbrSzQVxVhVrrQ2eMSCdSX8cGGJI7LpwWbL91rgABlCUk8DPG7pHJBU5l
	 AKkS3Qtmr9qTcRY23hW30FFLZifysHIr49zwSTFeOmSrglOA0ECSUlYQELBkJ7BD5rub1
	 lsrrs+RB4ONPp4epjQOVTuGkCMLYXFm6lCrAwdhzj9JBSOp/Ibb83d7073wcJ+yxx8aru
	 tANzMbrOF0ePRGnnn4nknVGm50pW+yd5KR7YDKA3bPFFoH23s+dAi8HFgT6xBp2XEqZFk
	 o6ZLrfJBoneuqvvCU3Ukevfv203qiRp3M1LfMCxWnbNSbAfXINK5H4u1mFptbPPsC+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="twCYH/1B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C528D606A331;
	Wed, 18 Nov 2026 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twCYH/1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211261F000C4;
	Wed, 18 Nov 2026 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021628;
	bh=vvdrgGHa/bdabSGnkONfZyQKR1EtZVwUFnYG7pB03cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twCYH/1BNIc9OxIpksofN79VKe4Wv1GeX43kzuTr3fySEAO5E7QYbXJvXf0JhJ3Qd
	 ryTlnLCQgPfFx3ylSgUxir38EEpm/sjpb1iw6mm8CUWtljvjRrFY/yexCK7PFw6aK+
	 bVhHu9v6BN8cmDxfXFCA/4OYch4Ld9ABNmOVw8E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2376/2651] net: sparx5: fix tx DCB index drift in fdma xmit
Date: Wed, 18 Nov 2026 16:00:16 +0100
Message-ID: <20261118150411.022229282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 1df26063ab9ba64f5fb11049fa4be686b7fc309e ]

sparx5_fdma_xmit() advances dcb_index before checking that the FDMA is
done with the DCB, and does not undo the advance when the check fails.
Before commit f4aa7e361ae2 ("net: sparx5: use FDMA library for adding
DCB's in the tx path") the next DCB was always the one after last_dcb.
Since then dcb_index drifts one DCB further away from last_dcb on every
failed transmit.

While the ring is full, this drops frames even though completed DCBs
sit behind dcb_index. After a run of failures, dcb_index can also land
on last_dcb itself. Re-adding last_dcb loses the frame, because the
FDMA has already passed the tail of the chain, and that DCB is never
completed again.

Fix this by making dcb_index the next DCB to use, and advancing it only
after the DCB has been added, as the rx path does. dcb_index and
last_dcb now only move together, so dcb_index always points at the DCB
after last_dcb.

The issue was found by an AI code review agent. It was reproduced on a
sparx5 PCB135 board with a modified kernel that forces 63 consecutive
transmit failures. Afterwards, about 1 in 64 frames is lost for good.
With the fix, the same test loses no frames.

Fixes: f4aa7e361ae2 ("net: sparx5: use FDMA library for adding DCB's in the tx path")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021-sparx5-fdma-last-dcb-v2-1-7b8fabdb9239@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index dbe86f937b210..15ec9b053824f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -217,7 +217,6 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb,
 	struct fdma *fdma = &tx->fdma;
 	void *virt_addr;
 
-	fdma_dcb_advance(fdma);
 	if (!fdma_db_is_done(fdma_db_get(fdma, fdma->dcb_index, 0)))
 		return -EINVAL;
 
@@ -235,6 +234,8 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb,
 		     FDMA_DCB_STATUS_BLOCKO(0) |
 		     FDMA_DCB_STATUS_BLOCKL(skb->len + IFH_LEN * 4 + 4));
 
+	fdma_dcb_advance(fdma);
+
 	sparx5_fdma_reload(sparx5, fdma);
 
 	return NETDEV_TX_OK;
-- 
2.53.0



