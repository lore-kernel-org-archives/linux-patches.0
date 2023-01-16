Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51FC33F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C6DC433D2;
	Mon, 16 Jan 2023 16:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885551;
	bh=bp/R7mMv/SCi3w1gAk8gp9y1YEpKRXZ/rRW6Vci6Yv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b51m13duL/kNUKtGGg1b3eMN1QVub+LY1mEdQcUyi2IMdTG6L8dsam1QKvvLPcPnW
	 Ik8xopD5ItZDMYlEcpGI0a7tJwruxxdeV8LWNEHSGqIWzksf9gEq0H1AIoiV2v1UkY
	 xHAlAKTdc1P6kz/v8z0WT4su03CCMZSKAai92uNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/658] perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()
Date: Mon, 16 Jan 2023 16:42:34 +0100
Message-Id: <20230116154912.672731635@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 1ff9dd6e7071a561f803135c1d684b13c7a7d01d ]

pci_get_device() will increase the reference count for the returned
'dev'. We need to call pci_dev_put() to decrease the reference count.
Since 'dev' is only used in pci_read_config_dword(), let's add
pci_dev_put() right after it.

Fixes: 9d480158ee86 ("perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20221118063137.121512-3-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 0f61f46e6086..fe2edc760e60 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -2762,6 +2762,7 @@ static bool hswep_has_limit_sbox(unsigned int device)
 		return false;
 
 	pci_read_config_dword(dev, HSWEP_PCU_CAPID4_OFFET, &capid4);
+	pci_dev_put(dev);
 	if (!hswep_get_chop(capid4))
 		return true;
 
-- 
2.35.1



