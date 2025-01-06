Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DDC155325;
	Mon,  6 Jan 2025 15:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177364; cv=none; b=ePSFwZ3vv+qqGR6grxSV5KRys9sgy6ZtObVY+LHz2LU48rqx4L9Cntc3X9Kg736F3BosPsSRugLT5pf/CYkXK/fYVEtrMg8XlEAdu73MmCEj3igvtbbd9l9NtDaX2Ol++kAOEySnsP2Kew9fPQGvGa8LPFONG5F8U2mR+u/toSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177364; c=relaxed/simple;
	bh=fVaL2GGZwFAI1x8Y0OdUfpKEoJllukFY0zy4PnQd2lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj7YTBKO/Qe1LcqOgJ7YHmw0n0453Ag6/wyQxhbLTaFFpkEAX/bDR11XFRN+rDGS+jBzyizxzglo9PvVh9hKgqCAY/FbkAK1OH5cE25B4tWFYUtqNmy4x078tz08nEpaC1FcMqWyBrfTbuRjI6Aszu+PKL0sCljFq43wiIzpxM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Og7e5DmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Og7e5DmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA7C4CED2;
	Mon,  6 Jan 2025 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177364;
	bh=fVaL2GGZwFAI1x8Y0OdUfpKEoJllukFY0zy4PnQd2lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Og7e5DmLNwYPMmhSwVBCVly7My6OnlrmUNWoAWnwnt+eQ+CVooChrwAMlRwgvQMYd
	 BOGmDZnn+umFBehX+LTT9OFBmyqBBBxx4V4xAyAzbBlMKTVV1Pp1j4pvDdXaENxrLe
	 IZta4THDm9WeLwJzHOfDR11Q0Tyn2gba9IJ3kxIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/222] RDMA/bnxt_re: Fix MSN table size for variable wqe mode
Date: Mon,  6 Jan 2025 16:15:44 +0100
Message-ID: <20250106151156.066821881@linuxfoundation.org>
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

[ Upstream commit bb839f3ace0fee532a0487b692cc4d868fccb7cf ]

For variable size wqe mode, the MSN table size should be
half the size of the SQ depth. Fixing this to avoid wrap
around problems in the retransmission path.

Fixes: de1d364c3815 ("RDMA/bnxt_re: Add support for Variable WQE in Genp7 adapters")
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241217102649.1377704-5-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 2f85245d1285..1355061d698d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1013,7 +1013,12 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 				    : 0;
 	/* Update msn tbl size */
 	if (qp->is_host_msn_tbl && psn_sz) {
-		hwq_attr.aux_depth = roundup_pow_of_two(bnxt_qplib_set_sq_size(sq, qp->wqe_mode));
+		if (qp->wqe_mode == BNXT_QPLIB_WQE_MODE_STATIC)
+			hwq_attr.aux_depth =
+				roundup_pow_of_two(bnxt_qplib_set_sq_size(sq, qp->wqe_mode));
+		else
+			hwq_attr.aux_depth =
+				roundup_pow_of_two(bnxt_qplib_set_sq_size(sq, qp->wqe_mode)) / 2;
 		qp->msn_tbl_sz = hwq_attr.aux_depth;
 		qp->msn = 0;
 	}
-- 
2.39.5



