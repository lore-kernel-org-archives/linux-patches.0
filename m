Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC4A1F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF78C433C8;
	Fri, 21 Jul 2023 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965709;
	bh=d79wVLmJKTqcUfOeTfiLiviudnimvNoWGvnBd5i5l3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w09TAYBgcYIFJlNZtPNjYslNFKWfDhwSWV5nJ+51ncnxNCv4vUdikiHpJQAfvzkIq
	 m0pRIEwY3MqdYLPgsrUIQ1cHS2ww0QJtyqtQs2Y+FsXiGz9VYfn3iIB0n2hmzRX1Hm
	 fW8iEjWJzicLpZQFSgkc+9hl5POYzcjzjtXtm7Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/532] iwlwifi: dont dump_stack() when we get an unexpected interrupt
Date: Fri, 21 Jul 2023 17:59:33 +0200
Message-ID: <20230721160618.360561089@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 91ca9c3ade1be665f5ce88594ee687c56b0357d5 ]

It is yet unclear if the WARNING really points to a real problem,
but for sure the stack dump doesn't help fixing it.
Just use a regular error print instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220205112029.a79e733a12f7.I8189344294222be0589fa43cc70fdf38e3057045@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Stable-dep-of: 1902f1953b8b ("wifi: iwlwifi: pcie: fix NULL pointer dereference in iwl_pcie_irq_rx_msix_handler()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index fea89330f692c..8885b19fd8de6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1608,10 +1608,13 @@ irqreturn_t iwl_pcie_irq_rx_msix_handler(int irq, void *dev_id)
 	if (WARN_ON(entry->entry >= trans->num_rx_queues))
 		return IRQ_NONE;
 
-	if (WARN_ONCE(!rxq,
-		      "[%d] Got MSI-X interrupt before we have Rx queues",
-		      entry->entry))
+	if (!rxq) {
+		if (net_ratelimit())
+			IWL_ERR(trans,
+				"[%d] Got MSI-X interrupt before we have Rx queues\n",
+				entry->entry);
 		return IRQ_NONE;
+	}
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
 	IWL_DEBUG_ISR(trans, "[%d] Got interrupt\n", entry->entry);
-- 
2.39.2



