Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A556FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2577C433EF;
	Mon, 15 May 2023 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169433;
	bh=Ft2/+1LqFml0ZneYjQyDyvTcZW3SscIozkhhGIbKal8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrYVtnV7kICpCyxu5dWHRORL8zIKjrcJbqow7K44cEMomMZ6/UZMef7p8ez98wSM8
	 FZCs6oKgR/+jHpFAwHdaCNLmA+OSoJADOoO53mqztqLsRn5esH2qTdhlIhk1/X5Bbf
	 +DC+R9KznF99EjTGKT9OIyJLeIf25i9I8wValV/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 026/246] octeontx2-af: mcs: Write TCAM_DATA and TCAM_MASK registers at once
Date: Mon, 15 May 2023 18:23:58 +0200
Message-Id: <20230515161723.393669544@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit b51612198603fce33d6cf57b4864e3018a1cd9b8 ]

As per hardware errata on CN10KB, all the four TCAM_DATA
and TCAM_MASK registers has to be written at once otherwise
write to individual registers will fail. Hence write to all
TCAM_DATA registers and then to all TCAM_MASK registers.

Fixes: cfc14181d497 ("octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 492baa0b594ce..148417d633a56 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -473,6 +473,8 @@ void mcs_flowid_entry_write(struct mcs *mcs, u64 *data, u64 *mask, int flow_id,
 		for (reg_id = 0; reg_id < 4; reg_id++) {
 			reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_DATAX(reg_id, flow_id);
 			mcs_reg_write(mcs, reg, data[reg_id]);
+		}
+		for (reg_id = 0; reg_id < 4; reg_id++) {
 			reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
 			mcs_reg_write(mcs, reg, mask[reg_id]);
 		}
@@ -480,6 +482,8 @@ void mcs_flowid_entry_write(struct mcs *mcs, u64 *data, u64 *mask, int flow_id,
 		for (reg_id = 0; reg_id < 4; reg_id++) {
 			reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_DATAX(reg_id, flow_id);
 			mcs_reg_write(mcs, reg, data[reg_id]);
+		}
+		for (reg_id = 0; reg_id < 4; reg_id++) {
 			reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
 			mcs_reg_write(mcs, reg, mask[reg_id]);
 		}
-- 
2.39.2



