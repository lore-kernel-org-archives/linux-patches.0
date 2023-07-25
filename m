Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6101ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF12CC433C7;
	Tue, 25 Jul 2023 11:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285432;
	bh=Doceio9ZV421efEcN/Dyu2frYvEDriVuJfpiPB1cIR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1K9ZVpSkVA7IbaEgekueC2bBMedpUF+i5Qtz/KAWAWS1jhbL5oPCbgcttGFbJIso
	 SbwsNE/1LeBVuOXuJMfsvT9m+S2RK+ymCx1AlC+KNcfJmZu4lHam/1Ot+S2L/Gud9N
	 aBBb0ET0bdnQ8VgkqrmjtBWp5VdNOJx3Jb16HvqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <snelson@pensando.io>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/313] ionic: improve irq numa locality
Date: Tue, 25 Jul 2023 12:45:56 +0200
Message-ID: <20230725104529.799822557@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit b7f55b81f2ac40e52c5a56e22c80488eac531c91 ]

Spreading the interrupts across the CPU cores is good for load
balancing, but not necessarily as good when using a CPU/core
that is not part of the NUMA local CPU.  If it can be localized,
the kernel's cpumask_local_spread() service will pick a core
that is on the node close to the PCI device.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: abfb2a58a537 ("ionic: remove WARN_ON to prevent panic_on_warn")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d0841836cf705..975cda9377ec4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -418,8 +418,9 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		ionic_intr_mask_assert(idev->intr_ctrl, new->intr.index,
 				       IONIC_INTR_MASK_SET);
 
-		new->intr.cpu = new->intr.index % num_online_cpus();
-		if (cpu_online(new->intr.cpu))
+		new->intr.cpu = cpumask_local_spread(new->intr.index,
+						     dev_to_node(dev));
+		if (new->intr.cpu != -1)
 			cpumask_set_cpu(new->intr.cpu,
 					&new->intr.affinity_mask);
 	} else {
-- 
2.39.2



