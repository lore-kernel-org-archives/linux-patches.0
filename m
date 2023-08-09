Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405E0613A
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDB1C433C9;
	Wed,  9 Aug 2023 10:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577836;
	bh=70iMD/RLSO8mNOULLpYpKy79TorPQ1CjsuicQaxDrOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mELL/agGXba8pAoK8boL99x2+vWf6EJVTiRyuJaQvm6z3N3AK6DVTJ5V0X+0ZWMta
	 JoAraZtkjKAFytoibxxGXAkgBnGpoPAQMfBHgGqW2gDtlOJspfVpVKxT7W07hdEYnd
	 cvcD4FTztN8HpXpnqkIS8aHkfd/uTlD0xQUDNFoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punit Agrawal <punit.agrawal@bytedance.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Vikram Sethi <vsethi@nvidia.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 012/165] firmware: smccc: Fix use of uninitialised results structure
Date: Wed,  9 Aug 2023 12:39:03 +0200
Message-ID: <20230809103643.168074363@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Punit Agrawal <punit.agrawal@bytedance.com>

[ Upstream commit d05799d7b4a39fa71c65aa277128ac7c843ffcdc ]

Commit 35727af2b15d ("irqchip/gicv3: Workaround for NVIDIA erratum
T241-FABRIC-4") moved the initialisation of the SoC version to
arm_smccc_version_init() but forgot to update the results structure
and it's usage.

Fix the use of the uninitialised results structure and update the
error strings.

Fixes: 35727af2b15d ("irqchip/gicv3: Workaround for NVIDIA erratum T241-FABRIC-4")
Signed-off-by: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Vikram Sethi <vsethi@nvidia.com>
Cc: Shanker Donthineni <sdonthineni@nvidia.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230717171702.424253-1-punit.agrawal@bytedance.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/smccc/soc_id.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/smccc/soc_id.c b/drivers/firmware/smccc/soc_id.c
index 890eb454599a3..1990263fbba0e 100644
--- a/drivers/firmware/smccc/soc_id.c
+++ b/drivers/firmware/smccc/soc_id.c
@@ -34,7 +34,6 @@ static struct soc_device_attribute *soc_dev_attr;
 
 static int __init smccc_soc_init(void)
 {
-	struct arm_smccc_res res;
 	int soc_id_rev, soc_id_version;
 	static char soc_id_str[20], soc_id_rev_str[12];
 	static char soc_id_jep106_id_str[12];
@@ -49,13 +48,13 @@ static int __init smccc_soc_init(void)
 	}
 
 	if (soc_id_version < 0) {
-		pr_err("ARCH_SOC_ID(0) returned error: %lx\n", res.a0);
+		pr_err("Invalid SoC Version: %x\n", soc_id_version);
 		return -EINVAL;
 	}
 
 	soc_id_rev = arm_smccc_get_soc_id_revision();
 	if (soc_id_rev < 0) {
-		pr_err("ARCH_SOC_ID(1) returned error: %lx\n", res.a0);
+		pr_err("Invalid SoC Revision: %x\n", soc_id_rev);
 		return -EINVAL;
 	}
 
-- 
2.40.1



