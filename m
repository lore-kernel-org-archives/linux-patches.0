Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A7633EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F382FC433EF;
	Mon, 16 Jan 2023 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884924;
	bh=OfKYDGteaeDMBUjlPgA7wAX12P/sUamu1cZaY3GuOCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qV8ORVfPSDmDtMega4r7X/RcBqs2EMrP2VT3K3nKDIDT/+snUduJplhsNm67TEYuL
	 GR4nSQXpBKlyoH/HO3u831lHGgOQw3jFMRqn3NmqSBoiRXFvOsj6WxgY4z24UfukO0
	 uRwLo8uDVpLj7CxMWlJi3EkF8qml2en3u4SMgPAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/183] octeontx2-pf: Fix resource leakage in VF driver unbind
Date: Mon, 16 Jan 2023 16:51:27 +0100
Message-Id: <20230116154810.229977332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 53da7aec32982f5ee775b69dce06d63992ce4af3 ]

resources allocated like mcam entries to support the Ntuple feature
and hash tables for the tc feature are not getting freed in driver
unbind. This patch fixes the issue.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Link: https://lore.kernel.org/r/20230109061325.21395-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 86653bb8e403..7f8ffbf79cf7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -758,6 +758,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	if (vf->otx2_wq)
 		destroy_workqueue(vf->otx2_wq);
 	otx2_ptp_destroy(vf);
+	otx2_mcam_flow_del(vf);
+	otx2_shutdown_tc(vf);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
-- 
2.35.1



