Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7907F3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/TgWLtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BA8C433CB;
	Wed, 15 Nov 2023 19:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078254;
	bh=9/IQE+e64UTPPylHTUdWfA4ut1u7rOFJXgj9EuqKvuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/TgWLtgLgIBu7dzqSFXTvg1QtaRcQjUgQ6xfCRKanhAd7bV+bdNPxEblibLoazBb
	 HiSBuTqfqiV+5OpzX+ztGDdAj8qORRA2t3JMPgIVtoZrHiymEYst7aXy2ozlIvK8Y4
	 /bNd1ycmBgdoRnVm51JWbqxYxT9KthQgvYS+rWWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/379] PCI: vmd: Correct PCI Header Type Registers multi-function check
Date: Wed, 15 Nov 2023 14:24:43 -0500
Message-ID: <20231115192657.413784268@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 5827e17d0555b566c32044b0632b46f9f95054fa ]

vmd_domain_reset() attempts to find whether the device may contain multiple
functions by checking 0x80 (Multi-Function Device), however, the hdr_type
variable has already been masked with PCI_HEADER_TYPE_MASK so the check can
never true.

To fix the issue, don't mask the read with PCI_HEADER_TYPE_MASK.

Fixes: 6aab5622296b ("PCI: vmd: Clean up domain before enumeration")
Link: https://lore.kernel.org/r/20231003125300.5541-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index d4c9b888a79d7..5c35884c226e6 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -510,8 +510,7 @@ static void vmd_domain_reset(struct vmd_dev *vmd)
 			base = vmd->cfgbar + PCIE_ECAM_OFFSET(bus,
 						PCI_DEVFN(dev, 0), 0);
 
-			hdr_type = readb(base + PCI_HEADER_TYPE) &
-					 PCI_HEADER_TYPE_MASK;
+			hdr_type = readb(base + PCI_HEADER_TYPE);
 
 			functions = (hdr_type & 0x80) ? 8 : 1;
 			for (fn = 0; fn < functions; fn++) {
-- 
2.42.0



