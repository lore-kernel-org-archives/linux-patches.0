Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159536A37E;
	Sat, 12 Sep 2026 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205024; cv=none; b=FWpU+He3KQdpU4GdiqaNWRytAZnkndSS+1bsVeLzZd5b2ZPL5o7z+Xmw6fxFkzfq8CCBmvHrIh54LCceYlN7HLLf6MKKdpZOasoQDTYNVX72CTf+bytyWSo6rIvwz7vVlXkiuyftoqnX8/hZYAD0kXm78LCDpImSPe6S/+c7IOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205024; c=relaxed/simple;
	bh=P4o3cQLLVVwzjDZgxzVEQ8hCI0u1X5uMKGHD+XbgLL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNdMRDPZ2TFHKD2dBiP6gNa6y3aZSjQ6skZYbUKmbKAy1jpU06dU8E0y6yIBxbmt8dpfxOrM/tyG/CBPunugBma6JWThHmo57frroKobtPMA6BfnpPyOBp7kbd443WGkHEc7PQRWbZy2Y55zUvgidH50ddiHCCNOyhgm2qBg1Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSo8zQho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSo8zQho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806071F000FF;
	Sat, 12 Sep 2026 09:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205023;
	bh=4lWFPxEz3Yl165wMj3mW7dirXKC2rNpSn4+TFDHIZak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSo8zQhocuiF46c/c3d5dwfBYyGA0xnqJQ9wSOL2n0BdBuvxAfAfiTUMCYA+6WDzb
	 qa+f+wM/0zcl/8ylp95aNKTTzwP/NVrRIPY09jfiRbmZIQXChB23Z8Dc0dLbAm3eQM
	 +dizTjRot7lR8ykfwMVfBPFCvUkNsw48Q6mMSh1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1731/1815] octeontx2-af: fix out-of-bounds read setting MSI-X irq affinity
Date: Sat, 12 Sep 2026 08:58:01 +0200
Message-ID: <20260912065729.613835498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshumali Gaur <agaur@marvell.com>

[ Upstream commit 4d5df98369c5f45710b786499f8bd7ffc3196433 ]

rvu_register_interrupts() walks every MSI-X vector and uses strstr()
to match "Mbox" or "FLR" in irq_name before pinning those interrupts
to CPU 0. irq_name is a per-vector NAME_SIZE buffer, but not every
slot is populated before this loop runs. strstr() keeps scanning until
it finds a NUL terminator, so an uninitialized slot can trigger a KASAN
slab-out-of-bounds read at boot when debug options are enabled.

Use strnstr() with NAME_SIZE to bound the search within each vector's
name buffer.

Fixes: 4e527f1e5c15 ("octeontx2-af: npc: cn20k: Add new mailboxes for CN20K silicon")
Signed-off-by: Anshumali Gaur <agaur@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260820055451.2642358-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index ffba56ee8a60c..43062390aa4ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3331,8 +3331,8 @@ static int rvu_register_interrupts(struct rvu *rvu)
 		goto fail;
 
 	for (i = 0; i < rvu->num_vec; i++) {
-		if (strstr(&rvu->irq_name[i * NAME_SIZE], "Mbox") ||
-		    strstr(&rvu->irq_name[i * NAME_SIZE], "FLR"))
+		if (strnstr(&rvu->irq_name[i * NAME_SIZE], "Mbox", NAME_SIZE) ||
+		    strnstr(&rvu->irq_name[i * NAME_SIZE], "FLR", NAME_SIZE))
 			irq_set_affinity(pci_irq_vector(rvu->pdev, i),
 					 cpumask_of(0));
 	}
-- 
2.53.0



