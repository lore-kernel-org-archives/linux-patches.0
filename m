Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BA71ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7070FC433C8;
	Tue, 25 Jul 2023 11:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284480;
	bh=IfFn1U4p0mZPNYQVRDAlV3WzNAnMOmd4fwyZYbQc12M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sav4F9oyahf28tHiOs1XoD7cztnYvi6SmXl7mKHN/JSJhG0gDi4nKus5HQrmBuaDw
	 YvaDtxSE575OGhIcDdd9KhGDJE+OxHvOXfRg/PBXLil6d2I4ZsqCZ48j6HsDFxcwvD
	 WgSGRZKZcTopty9RNzv/Pyvzc6Axsm2QthnBQJRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 344/509] net: mvneta: fix txq_map in case of txq_number==1
Date: Tue, 25 Jul 2023 12:44:43 +0200
Message-ID: <20230725104609.477130165@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Klaus Kudielka <klaus.kudielka@gmail.com>

[ Upstream commit 21327f81db6337c8843ce755b01523c7d3df715b ]

If we boot with mvneta.txq_number=1, the txq_map is set incorrectly:
MVNETA_CPU_TXQ_ACCESS(1) refers to TX queue 1, but only TX queue 0 is
initialized. Fix this.

Fixes: 50bf8cb6fc9c ("net: mvneta: Configure XPS support")
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://lore.kernel.org/r/20230705053712.3914-1-klaus.kudielka@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f5567d485e91a..3656a3937eca6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1471,7 +1471,7 @@ static void mvneta_defaults_set(struct mvneta_port *pp)
 			 */
 			if (txq_number == 1)
 				txq_map = (cpu == pp->rxq_def) ?
-					MVNETA_CPU_TXQ_ACCESS(1) : 0;
+					MVNETA_CPU_TXQ_ACCESS(0) : 0;
 
 		} else {
 			txq_map = MVNETA_CPU_TXQ_ACCESS_ALL_MASK;
@@ -4165,7 +4165,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 		 */
 		if (txq_number == 1)
 			txq_map = (cpu == elected_cpu) ?
-				MVNETA_CPU_TXQ_ACCESS(1) : 0;
+				MVNETA_CPU_TXQ_ACCESS(0) : 0;
 		else
 			txq_map = mvreg_read(pp, MVNETA_CPU_MAP(cpu)) &
 				MVNETA_CPU_TXQ_ACCESS_ALL_MASK;
-- 
2.39.2



