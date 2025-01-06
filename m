Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AFF7405A;
	Mon,  6 Jan 2025 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177697; cv=none; b=TpbcVVxkp7T9wCihAqhgdUeToYX4TMV/pS8LdIs+/4f2M+Dn/nJSvFmWQ++o8bDKGJxz+zUqmfoQhL3jfDLoxteEK1e5fTG9scKc7WRzsEAi2KuwYAwx+EdaL9NxeyK1TzsLf+lYemLkuoPgGpn++xeOFSKirthHgtJwXXXp0MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177697; c=relaxed/simple;
	bh=dgl5lU4HL0RdDI2DK5X8zYai+C8Q/+WyFj18QOOOcTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJ03YaYs8ua9Mi8ChNXEcGNHNict63cz8Biwo/rGRhLRpUw8Ae/lUtcmV4lAR5uSMUNdpLeMcGUl1FElkUQLobXEvdp+k4PgtabW9ymdX61JQtWPr86pG1JnvepY7tMkdamjWeC0wIcikxDMTqClEw7CU3JD9C8a6Mw4T9BoqqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnvmCuzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnvmCuzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56039C4CED2;
	Mon,  6 Jan 2025 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177697;
	bh=dgl5lU4HL0RdDI2DK5X8zYai+C8Q/+WyFj18QOOOcTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnvmCuzvB4wBP4nSo0LL5QOIQVYuYO1LVvVN5k3S9voZURpFXiEZ5nIYbr0M0YErt
	 LBxyEEb9L7oW0uVfnVR7PAQeVquuhWZPvygvAVeICfg4cjp4fLG41KNk4TlfwD31g0
	 kCvOuSWBlTohoW1t+UMGqhEocURH+Sh9PLwHjbNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/156] RDMA/bnxt_re: Disable use of reserved wqes
Date: Mon,  6 Jan 2025 16:15:13 +0100
Message-ID: <20250106151142.763450347@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit d5a38bf2f35979537c526acbc56bc435ed40685f ]

Disabling the reserved wqes logic for Gen P5/P7 devices
because this workaround is required only for legacy devices.

Fixes: ecb53febfcad ("RDMA/bnxt_en: Enable RDMA driver support for 57500 chip")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241217102649.1377704-3-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 63706d6d121c..b273db59454e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -130,11 +130,13 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 		sb->max_qp_init_rd_atom > BNXT_QPLIB_MAX_OUT_RD_ATOM ?
 		BNXT_QPLIB_MAX_OUT_RD_ATOM : sb->max_qp_init_rd_atom;
 	attr->max_qp_wqes = le16_to_cpu(sb->max_qp_wr) - 1;
-	/*
-	 * 128 WQEs needs to be reserved for the HW (8916). Prevent
-	 * reporting the max number
-	 */
-	attr->max_qp_wqes -= BNXT_QPLIB_RESERVED_QP_WRS + 1;
+	if (!bnxt_qplib_is_chip_gen_p5_p7(rcfw->res->cctx)) {
+		/*
+		 * 128 WQEs needs to be reserved for the HW (8916). Prevent
+		 * reporting the max number on legacy devices
+		 */
+		attr->max_qp_wqes -= BNXT_QPLIB_RESERVED_QP_WRS + 1;
+	}
 
 	attr->max_qp_sges = cctx->modes.wqe_mode == BNXT_QPLIB_WQE_MODE_VARIABLE ?
 			    min_t(u32, sb->max_sge_var_wqe, BNXT_VAR_MAX_SGE) : 6;
-- 
2.39.5



