Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D798915665D;
	Mon,  6 Jan 2025 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177617; cv=none; b=ih/+bHUxFzgiahJPJc8hIfSbHfqBEqcVZCowTmcYnqmC20aioDjzBBN9wwRDsekSbtVBWVHMCCXjH9qwcLB0FIRIZaSaIm6k8u1V3cNPbuE2xTaDxH3L1eVCVdidDdP0h8jDysUaecA+uGsMQDPhqNGav9iltIEwswH2hGsgA4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177617; c=relaxed/simple;
	bh=ZPqio91KfyA5ISM+3CZNw2ikOwwDt9CsMd93SQ0TyuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNdos/TVKR6ADDAUenBFDxrkF8PDynS3B9T2UWSUvglowHsat47r8zf9FW6FhsMXIZgOe2EzjPIh9CcYrvD6ROc/ln2EFm4d89Q/mvbvdvYGnbq6PzfUnbNxDJaldPzhNTTQ9K5BtqNowAjea7lEw0S68FQxMk+fwLCCA75v+3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tM1bKw11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tM1bKw11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAECC4CED2;
	Mon,  6 Jan 2025 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177617;
	bh=ZPqio91KfyA5ISM+3CZNw2ikOwwDt9CsMd93SQ0TyuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tM1bKw11MuhsB5s/blJA3qVPEsdzcwy/S0ghnaVElHzcQusRtL0MFW7s+qwBddISI
	 gh9N7gcAfDitJQOgRW/yp7vD3/gP93jCNOHrNwh0dArlqyROAvxaMWT2gqETItUAka
	 7dM+REWzkSg++2DwnHdtBvUeXJadH0SoPrFVaWeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 221/222] RDMA/bnxt_re: Fix max SGEs for the Work Request
Date: Mon,  6 Jan 2025 16:17:05 +0100
Message-ID: <20250106151159.129143990@linuxfoundation.org>
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

From: Kashyap Desai <kashyap.desai@broadcom.com>

commit 79d330fbdffd8cee06d8bdf38d82cb62d8363a27 upstream.

Gen P7 supports up to 13 SGEs for now. WQE software structure
can hold only 6 now. Since the max send sge is reported as
13, the stack can give requests up to 13 SGEs. This is causing
traffic failures and system crashes.

Use the define for max SGE supported for variable size. This
will work for both static and variable WQEs.

Fixes: 227f51743b61 ("RDMA/bnxt_re: Fix the max WQE size for static WQE support")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241204075416.478431-2-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -113,7 +113,6 @@ struct bnxt_qplib_sge {
 	u32				size;
 };
 
-#define BNXT_QPLIB_QP_MAX_SGL	6
 struct bnxt_qplib_swq {
 	u64				wr_id;
 	int				next_idx;
@@ -153,7 +152,7 @@ struct bnxt_qplib_swqe {
 #define BNXT_QPLIB_SWQE_FLAGS_UC_FENCE			BIT(2)
 #define BNXT_QPLIB_SWQE_FLAGS_SOLICIT_EVENT		BIT(3)
 #define BNXT_QPLIB_SWQE_FLAGS_INLINE			BIT(4)
-	struct bnxt_qplib_sge		sg_list[BNXT_QPLIB_QP_MAX_SGL];
+	struct bnxt_qplib_sge		sg_list[BNXT_VAR_MAX_SGE];
 	int				num_sge;
 	/* Max inline data is 96 bytes */
 	u32				inline_len;


