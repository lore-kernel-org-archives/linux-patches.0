Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2947D7405A;
	Mon,  6 Jan 2025 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177695; cv=none; b=sUTVZyhzihUh5ve7Ng7I9X/3+XJNCfxKzqfD+Ry4C5vDcEXUkKMb9R8IBeqv2VQTn4IdkPype1M4Y6znsiI1rNSCK3Gkg/x1Vs1HrrmP/BW6Gh25LLvrQ70E5MkYt+Vcr3LJK1o9JnxboaA0Bonx76I0TtDapZ3LqOwnJIAP9g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177695; c=relaxed/simple;
	bh=wirJ0Yfn/mNh2YDsghPQRLfp04MR3U9JDAxlVXQ+u3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBswUxcEVqWC6C8vWR/D7xTNxfIdG91mKiBaucL94+5uCRH1u5GiLhnagGLhN5TwEjNWF3aNZEw3x+A35PDbr8MVXOT1K6hqp4taiP6/BnSnVHL00MiLGODLCQd+Esginy+yAoVHZxoBhbQ+fBOo0uYFQhbYy8oy+1nUQIOdLdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaHQF5T8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaHQF5T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47755C4CED2;
	Mon,  6 Jan 2025 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177694;
	bh=wirJ0Yfn/mNh2YDsghPQRLfp04MR3U9JDAxlVXQ+u3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaHQF5T8OP/eYD8AD/N3MMIPmCNyNVSjgYa5RQMJYGHT4+Gjao6HgBbHofnB6MBKC
	 YpUJncnGJBIYs47Wrpfj9JWHhFfrn2U7OXrZACDJpJUnCCMeIxQb6ztA1//NuOgQLL
	 m+LUpFqXKS+0k1aytEFnxKMRjISRR6VcxNOEsqbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/156] RDMA/bnxt_re: Fix max_qp_wrs reported
Date: Mon,  6 Jan 2025 16:15:12 +0100
Message-ID: <20250106151142.726389331@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 40be32303ec829ea12f9883e499bfd3fe9e52baf ]

While creating qps, driver adds one extra entry to the sq size
passed by the ULPs in order to avoid queue full condition.
When ULPs creates QPs with max_qp_wr reported, driver creates
QP with 1 more than the max_wqes supported by HW. Create QP fails
in this case. To avoid this error, reduce 1 entry in max_qp_wqes
and report it to the stack.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241217102649.1377704-2-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index e29fbbdab9fd..63706d6d121c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -129,7 +129,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 	attr->max_qp_init_rd_atom =
 		sb->max_qp_init_rd_atom > BNXT_QPLIB_MAX_OUT_RD_ATOM ?
 		BNXT_QPLIB_MAX_OUT_RD_ATOM : sb->max_qp_init_rd_atom;
-	attr->max_qp_wqes = le16_to_cpu(sb->max_qp_wr);
+	attr->max_qp_wqes = le16_to_cpu(sb->max_qp_wr) - 1;
 	/*
 	 * 128 WQEs needs to be reserved for the HW (8916). Prevent
 	 * reporting the max number
-- 
2.39.5



