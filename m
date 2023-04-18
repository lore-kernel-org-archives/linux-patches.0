Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D652572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A205C433D2;
	Tue, 18 Apr 2023 12:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821759;
	bh=Wv4e16uRRrKhpTeME6jbvXsBSDPmDTT148k+e8OyN9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atTpylgXyZ4Mlnsidl/kaT57w+SKTZTPK2B2bkWL4YolCdRKfNonwE9DPNBVKv72H
	 VvKaRgMJM4kt7f+NGMIIJbDG8T/qB0qa6ba4e2U2q6zdzFuBJ1EgokxKgbGIxBXlm9
	 e4eQLi+h1PByMTbQs0azqjT1ZZdXH49igXTYYYmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/134] RDMA/irdma: Fix memory leak of PBLE objects
Date: Tue, 18 Apr 2023 14:21:26 +0200
Message-Id: <20230418120314.039957191@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit b69a6979dbaa2453675fe9c71bdc2497fedb11f9 ]

On rmmod of irdma, the PBLE object memory is not being freed. PBLE object
memory are not statically pre-allocated at function initialization time
unlike other HMC objects. PBLEs objects and the Segment Descriptors (SD)
for it can be dynamically allocated during scale up and SD's remain
allocated till function deinitialization.

Fix this leak by adding IRDMA_HMC_IW_PBLE to the iw_hmc_obj_types[] table
and skip pbles in irdma_create_hmc_obj but not in irdma_del_hmc_objects().

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230315145231.931-3-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 2e1e2bad04011..43dfa4761f069 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -41,6 +41,7 @@ static enum irdma_hmc_rsrc_type iw_hmc_obj_types[] = {
 	IRDMA_HMC_IW_XFFL,
 	IRDMA_HMC_IW_Q1,
 	IRDMA_HMC_IW_Q1FL,
+	IRDMA_HMC_IW_PBLE,
 	IRDMA_HMC_IW_TIMER,
 	IRDMA_HMC_IW_FSIMC,
 	IRDMA_HMC_IW_FSIAV,
@@ -827,6 +828,8 @@ static int irdma_create_hmc_objs(struct irdma_pci_f *rf, bool privileged,
 	info.entry_type = rf->sd_type;
 
 	for (i = 0; i < IW_HMC_OBJ_TYPE_NUM; i++) {
+		if (iw_hmc_obj_types[i] == IRDMA_HMC_IW_PBLE)
+			continue;
 		if (dev->hmc_info->hmc_obj[iw_hmc_obj_types[i]].cnt) {
 			info.rsrc_type = iw_hmc_obj_types[i];
 			info.count = dev->hmc_info->hmc_obj[info.rsrc_type].cnt;
-- 
2.39.2



