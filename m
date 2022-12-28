Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DDE1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFFBC433EF;
	Wed, 28 Dec 2022 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239008;
	bh=35wUNQA3z0odziUalHmDpCk9+LKaQ4zeghy4IUYunuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z54z3eHwK/Sky2VTQfUQ9g8tEpbZci1mQZ1xEBOYGmDVx0gDiqlAuxvCh43sP9Pog
	 H/vtPDW5bsk6gCLLeSn01mFGaS9dd6od/Jw+f0Na1bZL9YSkc9kZ7g/35UkY0vQ+Kg
	 jTAAukoKCwZ5Pk8klal9u+Lb2+rRpih7VZTlUR4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/731] perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()
Date: Wed, 28 Dec 2022 15:33:21 +0100
Message-Id: <20221228144259.275400669@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 76fedc8e12dd..f5d89d06c66a 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -2891,6 +2891,7 @@ static bool hswep_has_limit_sbox(unsigned int device)
 		return false;
 
 	pci_read_config_dword(dev, HSWEP_PCU_CAPID4_OFFET, &capid4);
+	pci_dev_put(dev);
 	if (!hswep_get_chop(capid4))
 		return true;
 
-- 
2.35.1



