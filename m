Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FD01DE3C7;
	Mon,  6 Jan 2025 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178391; cv=none; b=PhIC5MDo1N7gHKpqF210UYG5KsZcIHIWlsofwn9TFxXj0qKwYftc7mY4HXv+acx2Mw7Cp///bFkyH6nQGN+tD0uUbqc/NNHMWtfE42JPwd2HuGxQUQnvOvciJrhykb/9Xv1n8vVuWeMxwnr9/lwTQjzZDV64qvCutnVMsAYjO0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178391; c=relaxed/simple;
	bh=N9uUgn9m/uaxWC+AjVD22vZ3JHdNvKvkynisoxyrLFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxsDHOWeTm9+HTwFzfreUaJNrOEsu8/ir65oXWhKlu3lYayaWRPtx148BlF0IHwWNzoN/maAbCR7ERiEihMF4M/iaF0XAm2i6x2pWWb9Krp9/s/adyB0qHyKAOY27Nn+AQMeDaFjzL3/eBml+p6Yg1bfgLSQwAKfXhI4YUB3vVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLiw8Puw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLiw8Puw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5821C4CED2;
	Mon,  6 Jan 2025 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178391;
	bh=N9uUgn9m/uaxWC+AjVD22vZ3JHdNvKvkynisoxyrLFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLiw8PuwEvZQ7FrrqE5LrhCzEwBW8i37ucYSBTrsJe9ok3LED8OGuaDOQJh8CRLbC
	 pLV+gBGMGCMjs8HAEa0utFFwxhpSdY0i7eb061eSEpiPh3MFzaaf/txgqdAqtBds8p
	 PaoG7IDoI7f7N7xNKbsb0R+dW1dENAr2J3XEstn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devesh Sharma <devesh.sharma@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/138] RDMA/bnxt_re: Fix max_qp_wrs reported
Date: Mon,  6 Jan 2025 16:17:07 +0100
Message-ID: <20250106151137.131059564@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit c63e1c4dfc33d1bdae395ee8fbcbfad4830b12c0 ]

While creating qps, the driver adds one extra entry to the sq size passed
by the ULPs in order to avoid queue full condition.  When ULPs creates QPs
with max_qp_wr reported, driver creates QP with 1 more than the max_wqes
supported by HW. Create QP fails in this case. To avoid this error, reduce
1 entry in max_qp_wqes and report it to the stack.

Link: https://lore.kernel.org/r/1606741986-16477-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Devesh Sharma <devesh.sharma@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index f53d94c812ec..f9ceb19dc993 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -118,7 +118,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 	 * 128 WQEs needs to be reserved for the HW (8916). Prevent
 	 * reporting the max number
 	 */
-	attr->max_qp_wqes -= BNXT_QPLIB_RESERVED_QP_WRS;
+	attr->max_qp_wqes -= BNXT_QPLIB_RESERVED_QP_WRS + 1;
 	attr->max_qp_sges = bnxt_qplib_is_chip_gen_p5(rcfw->res->cctx) ?
 			    6 : sb->max_sge;
 	attr->max_cq = le32_to_cpu(sb->max_cq);
-- 
2.39.5



