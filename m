Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3809C70812;
	Mon,  6 Jan 2025 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177701; cv=none; b=ibqcj3AcMGCzIUgTUO6FZrAR7r/2s7oYE8/lWB3wxrP6hSyn4tMQOrtTT83ir8PYDrBZnQkk6G4IhhBvCZj9DjD8FFYaO4RKWasZRbUSZwr+0yasnSpfMvYg2tjVn4SRhUZR38gI1NQnUrc8zjWlhsJcywpakdOKmGHhHBYVHWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177701; c=relaxed/simple;
	bh=UgL6rld0i6QwNPsP+6+PCvZ4l4FgShAzc96ZCe4Hzl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzXHlF8Vbb9tTnlRdNXm100hz8tnJS+2rL/WY7DaYze2hOhGpMCQksfDWLyh563I+Rj+qBiENBiwP1SXgU1b8T8+GXEsFmsDAC7pfuaXOnfjTehCbtctWZwxS7CFux8+mNHfq3d4CT8kpLIoinnFxlaL4tnZQwoodlUrdxd3LnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awNRu6pM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awNRu6pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D42EC4CED2;
	Mon,  6 Jan 2025 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177700;
	bh=UgL6rld0i6QwNPsP+6+PCvZ4l4FgShAzc96ZCe4Hzl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awNRu6pMCSM4uLSGucgrkSymRKPTF8buJ3Rc7O1mD+0qkAkNE4jXMbRINHe9rjVuS
	 q1WR6JTi8Et1uBw8zeUrzbAqC1a9E7uEcT3ShYDECZwAgDxnPvTnvtWPJXShXedkp0
	 jW1h0hqYUGoK4Selxa8p36y1uqpJoYazk4GLz/0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/156] RDMA/bnxt_re: Add send queue size check for variable wqe
Date: Mon,  6 Jan 2025 16:15:14 +0100
Message-ID: <20250106151142.800777732@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>

[ Upstream commit d13be54dc18baee7a3e44349b80755a8c8205d3f ]

For the fixed WQE case, HW supports 0xFFFF WQEs.
For variable Size WQEs, HW treats this number as
the 16 bytes slots. The maximum supported WQEs
needs to be adjusted based on the number of slots.
Set a maximum WQE limit for variable WQE scenario.

Fixes: de1d364c3815 ("RDMA/bnxt_re: Add support for Variable WQE in Genp7 adapters")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241217102649.1377704-4-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index b273db59454e..3cca7b1395f6 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -138,6 +138,10 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 		attr->max_qp_wqes -= BNXT_QPLIB_RESERVED_QP_WRS + 1;
 	}
 
+	/* Adjust for max_qp_wqes for variable wqe */
+	if (cctx->modes.wqe_mode == BNXT_QPLIB_WQE_MODE_VARIABLE)
+		attr->max_qp_wqes = BNXT_VAR_MAX_WQE - 1;
+
 	attr->max_qp_sges = cctx->modes.wqe_mode == BNXT_QPLIB_WQE_MODE_VARIABLE ?
 			    min_t(u32, sb->max_sge_var_wqe, BNXT_VAR_MAX_SGE) : 6;
 	attr->max_cq = le32_to_cpu(sb->max_cq);
-- 
2.39.5



