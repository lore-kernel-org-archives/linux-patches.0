Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D985212F399;
	Mon,  6 Jan 2025 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177361; cv=none; b=kIbXq7PtinarzBzsF+ySLWgIJpdgkIMxzcp0YkVaeBWcwk4Gn0VldbqZ9q+no6hlOC7S+AC7rwj8Rf1SjBWBBfxB3sMc8jPHUx24PjJlkoDuPF5MkfVaoWszxshqcXuHy0SrDUKqPjTGl8T68O1iavWXLBfw2Q2EYTwvvDKkR7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177361; c=relaxed/simple;
	bh=tPSiHTOuhca7lIqWSKtuPR8m1GsVegW9GqbF6gM8c9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnEWygEspI0fIXgnwMitBR5KTU+vxJPj2uNeRyU3jkxe/k3qqts6EWfBT8Z/ApBqmLDsskwHrHmp2xmKqNKBU+aqb9VAR8TbkHGBnGqFl2aj6a2cTlALsNpK4xmVz4yxHmwZgqgtW8A6RHyU+nROIbgJEWVifI7wY/j8+8bFvH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdOopKmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdOopKmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B823C4CED6;
	Mon,  6 Jan 2025 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177361;
	bh=tPSiHTOuhca7lIqWSKtuPR8m1GsVegW9GqbF6gM8c9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdOopKmFsh1b69pAv2sFx6H1lQY2ho3r7zZ74YDqC+UFkkObqIRG/P6J2ULREICoR
	 YtZGYsH8X4jQTqitLcpHzsZjLFSm0Y9KbAd4eMu8zq4Ni211D+3KkKF6JknfdkVGAp
	 O6v+4pD8sHL8cDzTvN+VBXPzs0hxoIo2zl0+j+vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/222] RDMA/bnxt_re: Add send queue size check for variable wqe
Date: Mon,  6 Jan 2025 16:15:43 +0100
Message-ID: <20250106151156.029390528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 577a6eaca4ce..74c3f6b26c4d 100644
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



