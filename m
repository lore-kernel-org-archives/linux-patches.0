Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBF113AA50;
	Tue, 27 Feb 2024 13:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042344; cv=none; b=Y/SewaNu9Q6lVbLNhDrYzasrH0A99EdX3il9VVkLJV0ujLPgEFMo3JoWUkL2dZbMXaogo+34UVyOaLbieCy0CClX90Y0Kv8ThZQpmDqhQjOHGveKq959JEMF0Js+JLiA83QFWmuXp9osPJi4I0PCb3JxrCVq8mFjnUWRJJ8YaqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042344; c=relaxed/simple;
	bh=L4cB2vYsuLmcds+stWhgKFBVm867HR8LxDhgwB549ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4hm5EYCiuUJMygnbUndHf8Pr1BXqCwNWM2iPuPHmiBXPgwzwwDv7CTHsuGleHcCwJoo/AW06jOZ0rFXEaQQcnp0ovYFnJUV4xmtyP+TSiJbv+zCExq6zJJWQ3Gzed5cIakVtZSQn2mUJfhd6RSYex6ggN0zMwVp/flCBEv4Irg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psN08IIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psN08IIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEDBC433C7;
	Tue, 27 Feb 2024 13:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042344;
	bh=L4cB2vYsuLmcds+stWhgKFBVm867HR8LxDhgwB549ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psN08IIwzlsnO0IU/6q1MDD/5sxXpKjaeKQrRj4Rry9kVlbrC+p1oxBRf2Xr0PMO6
	 HrvZL4mJBDiMzw9dlMI2NZTheUc8VzCFtdZ4Qr8kOb8k1HVLzcEYVGUzkrXs0XVN7N
	 8RlNDPp08w33UfFXw/L5lf03fBFcGQj1vXp2FOvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/299] octeontx2-af: Consider the action set by PF
Date: Tue, 27 Feb 2024 14:26:13 +0100
Message-ID: <20240227131634.130459863@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 3b1ae9b71c2a97f848b00fb085a2bd29bddbe8d9 ]

AF reserves MCAM entries for each PF, VF present in the
system and populates the entry with DMAC and action with
default RSS so that basic packet I/O works. Since PF/VF is
not aware of the RSS action installed by AF, AF only fixup
the actions of the rules installed by PF/VF with corresponding
default RSS action. This worked well for rules installed by
PF/VF for features like RX VLAN offload and DMAC filters but
rules involving action like drop/forward to queue are also
getting modified by AF. Hence fix it by setting the default
RSS action only if requested by PF/VF.

Fixes: 967db3529eca ("octeontx2-af: add support for multicast/promisc packet replication feature")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 3784347b6fd88..55639c133dd02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -437,6 +437,10 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 			return;
 	}
 
+	/* AF modifies given action iff PF/VF has requested for it */
+	if ((entry->action & 0xFULL) != NIX_RX_ACTION_DEFAULT)
+		return;
+
 	/* copy VF default entry action to the VF mcam entry */
 	rx_action = npc_get_default_entry_action(rvu, mcam, blkaddr,
 						 target_func);
-- 
2.43.0



