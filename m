Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21363AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5AEC433EF;
	Wed,  7 Jun 2023 20:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169397;
	bh=8iaHfVs8HFRAl1w/FO/EflbQD0KUfmgPT7hju30DLb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfbzBdXj+GzoVlgfwUj0zc4E7bH2hkBzEn9IIzQbR4ZKb8VjrzGUNJzKnhhA9aXpa
	 vd2mOYhcRAV7y1KIp0D44VdakltYLe/a0kKGRtZhGq/C5NzaYEX8pvyPTHv0zXG2f6
	 HbIKzQOaPYUS0vgpo0VZ3ZwyTKPiQSBcbzIdpU68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 064/286] sfc: fix error unwinds in TC offload
Date: Wed,  7 Jun 2023 22:12:43 +0200
Message-ID: <20230607200925.158013565@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Edward Cree <ecree.xilinx@gmail.com>

[ Upstream commit 622ab656344a288acf4fb03d628c3bb5dd241f34 ]

Failure ladders weren't exactly unwinding what the function had done up
 to that point; most seriously, when we encountered an already offloaded
 rule, the failure path tried to remove the new rule from the hashtable,
 which would in fact remove the already-present 'old' rule (since it has
 the same key) from the table, and leak its resources.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202305200745.xmIlkqjH-lkp@intel.com/
Fixes: d902e1a737d4 ("sfc: bare bones TC offload on EF100")
Fixes: 17654d84b47c ("sfc: add offloading of 'foreign' TC (decap) rules")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230530202527.53115-1-edward.cree@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index deeaab9ee761d..217f3876af722 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -379,9 +379,9 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 	if (old) {
 		netif_dbg(efx, drv, efx->net_dev,
 			  "Already offloaded rule (cookie %lx)\n", tc->cookie);
-		rc = -EEXIST;
 		NL_SET_ERR_MSG_MOD(extack, "Rule already offloaded");
-		goto release;
+		kfree(rule);
+		return -EEXIST;
 	}
 
 	/* Parse actions */
-- 
2.39.2



