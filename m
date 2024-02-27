Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614332F2D;
	Tue, 27 Feb 2024 13:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041314; cv=none; b=h84G0JQcZB+NljFGsWj8BCvs9Tzan4Hc9jjkO0hv688dvoJCnAXEPcCHAmnWBEbh44OQ/aUu56pcDEVSur+jPWhF4nxBzSPn5EuWj57OTx+U/kSmaEqgDEVYvKNPuIM5JNi5X1UpdbBiZU7NWtIZEItqv7ySDfkPj1NWYquA+9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041314; c=relaxed/simple;
	bh=8Q0VOCrZ6nQyJ5byS3BBZfqw5hsOMUl4e2lBG/yBmB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXdpfyClG7mg1mfQFIoTU/UYrE0gmGeSDHJCnejM0dd0ewUCWc/NW0YdGzUbRyFwlMC93OZ46ejENjmrr4mdyeNnJ8W+67FaYHb/VEexz8nC6hkyepuwK6pO2yZpBcJMpJN4Zlndm0MUf6jUUJiulJm3RqRG9dvWy5KoZuL7KTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ne//Gnwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ne//Gnwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4205C433F1;
	Tue, 27 Feb 2024 13:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041314;
	bh=8Q0VOCrZ6nQyJ5byS3BBZfqw5hsOMUl4e2lBG/yBmB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ne//GnwqadDlTGLfToR8w61WmqUZO5eynJsxEgOdrTyMcvIjluRxs9at2ng90z56L
	 n2ZuDU7vKdh30T6pICyeA+eTz2RKsPaypP0cd5Z3zBp20hVO42XEPyJLsRhC91xp0n
	 PPNaK5WmsrW1nrldRrZMMbNd/e0wWF7Yj9xY+tCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 295/334] octeontx2-af: Consider the action set by PF
Date: Tue, 27 Feb 2024 14:22:33 +0100
Message-ID: <20240227131640.564029844@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



