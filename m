Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2828F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BE3C433C8;
	Sun, 16 Jul 2023 20:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540352;
	bh=xYxV1rGxbaP2vXs+9Z1STBbEhQYwB2PJoc431I6lGnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUmXwNrBUouDmMSuirUa4R0s4Sz06UbXlNTmN3G5JYnxLtSXtQaIAJsqRI7NJhxIw
	 vP+sxXtd0I1rWATuM+E624aSo5qtISVxhx2OQLr1hvx3DQRq8PjzG0SqT5vRRv5VF9
	 zaEtcnjOmONHA1JxFngNVSCtA8EffZFLDnkhlVC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Xinghui Li <korantli@tencent.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 332/591] PCI: vmd: Fix uninitialized variable usage in vmd_enable_domain()
Date: Sun, 16 Jul 2023 21:47:51 +0200
Message-ID: <20230716194932.482032468@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xinghui Li <korantli@tencent.com>

[ Upstream commit 0c0206dc4f5ba2d18b15e24d2047487d6f73916b ]

The ret variable in the vmd_enable_domain() function was used
uninitialized when printing a warning message upon failure of
the pci_reset_bus() function.

Thus, fix the issue by assigning ret with the value returned from
pci_reset_bus() before referencing it in the warning message.

This was detected by Smatch:

  drivers/pci/controller/vmd.c:931 vmd_enable_domain() error: uninitialized symbol 'ret'.

[kwilczynski: drop the second patch from the series, add missing reported
by tag, commit log]
Fixes: 0a584655ef89 ("PCI: vmd: Fix secondary bus reset for Intel bridges")
Link: https://lore.kernel.org/all/202305270219.B96IiIfv-lkp@intel.com
Link: https://lore.kernel.org/linux-pci/20230420094332.1507900-2-korantwork@gmail.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Xinghui Li <korantli@tencent.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 50a187a29a1d8..d1eb17e3f1474 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -872,7 +872,8 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 		if (!list_empty(&child->devices)) {
 			dev = list_first_entry(&child->devices,
 					       struct pci_dev, bus_list);
-			if (pci_reset_bus(dev))
+			ret = pci_reset_bus(dev);
+			if (ret)
 				pci_warn(dev, "can't reset device: %d\n", ret);
 
 			break;
-- 
2.39.2



