Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70033748C
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA85FC433C8;
	Sun, 16 Jul 2023 19:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537359;
	bh=IYKDcxIVQKu3FQXVAGF9R5TBKMof6I4j6UvZuNWVqZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XiCkfGxCM3Wm+AJEDwelbDm4131MQ9RLibZsKDdSnfHjLdaRdxxLD1jAQNp4jtJF
	 95PY9QLBN5/PFwt3Rih8uMyBnsB62x6xg4mydwl9nCRTSJk0yuY3V7Qmy7ZeY4Tjtm
	 /lkDahBucJdT4jPJAk4WhHqP+BU/DaNxSPXiU4/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 068/800] perf: arm_cspmu: Set irq affinitiy only if overflow interrupt is used
Date: Sun, 16 Jul 2023 21:38:41 +0200
Message-ID: <20230716194950.678900478@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit 225d757012e0afa673d8c862e6fb39ed2f429b4d ]

Don't try to set irq affinity if PMU doesn't have an overflow interrupt.

Fixes: e37dfd65731d ("perf: arm_cspmu: Add support for ARM CoreSight PMU driver")
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20230608203742.3503486-1-ilkka@os.amperecomputing.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_cspmu/arm_cspmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_cspmu/arm_cspmu.c b/drivers/perf/arm_cspmu/arm_cspmu.c
index a3f1c410b4173..d0572162f0632 100644
--- a/drivers/perf/arm_cspmu/arm_cspmu.c
+++ b/drivers/perf/arm_cspmu/arm_cspmu.c
@@ -1232,7 +1232,8 @@ static struct platform_driver arm_cspmu_driver = {
 static void arm_cspmu_set_active_cpu(int cpu, struct arm_cspmu *cspmu)
 {
 	cpumask_set_cpu(cpu, &cspmu->active_cpu);
-	WARN_ON(irq_set_affinity(cspmu->irq, &cspmu->active_cpu));
+	if (cspmu->irq)
+		WARN_ON(irq_set_affinity(cspmu->irq, &cspmu->active_cpu));
 }
 
 static int arm_cspmu_cpu_online(unsigned int cpu, struct hlist_node *node)
-- 
2.39.2



