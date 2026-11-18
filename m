Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017791;
	b=M7q7qNarnT6qmlGYgbBoYi2lc7V6Es5ao3zDDvAEuXJ5xRQxjbCMbkrb/Kf81Jp8GTL7
	 5IGNQImvYowBQYdxrM9u+5KiYKssLMzNhy6sN/Pybcx1KdT56IV9bFHeP5fDavRDcoSOu
	 OEBwIfycwVzWNLcbTU5+2pzraA5ZGEFAPH5r5cCXgTaRJd4mpwzHexR8bySits6Hbb/KF
	 J7HYbcYZl4nZ7glRlb1uIniSzxv8fLso7HqCq08+cWaDUQ8mEeE2NWTaBnPBlxqGjQroQ
	 bCKXxijGjFyfDWkQ7CSneI72KHVu4jgJSbaJvRfK5akjRk9urqaI6uHgfBzbdjenk5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G0DZDPjziBbHUT/StZRfyBDEQmO85DVukIEB/7EL9KI=;
	b=2biPs/j+3PLGhPW3LYoXCiWjcCETXgsHWJTrnYAVQxQqWyAnBop9+0pPeBcaXavq9rY6
	 IqAdV43DZFWZ2tNGLjgi/k6CQjTubETAUVPqIaLrwt+urLzopr4y+tbRUBQShls5x9MVh
	 cuGTKABngYjsXtTjfSivPQIV7VaibCVf6UWbyz3230x4d2FYKc6qQDieiztut+fNm6fee
	 cOFMPXZHgDJE+75Vl9/am/C4yg2VcWLQ0OoI8dEE+xFoC22tskB6yLdLziCJXaaKm+yDf
	 GKHpeFlOhIQIjkONwcvVIN66mNzOcwuGri2hy6aUCHbtX7iupgSlcP8GStOMiKQgF9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddn0P9DW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C482606A325;
	Wed, 18 Nov 2026 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddn0P9DW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52DC1F000C4;
	Wed, 18 Nov 2026 16:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017791;
	bh=G0DZDPjziBbHUT/StZRfyBDEQmO85DVukIEB/7EL9KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddn0P9DWOhQgn+gCM3rhP9GvlCWXNYy9eWSNKjueHWHnNbEurJ5TIgx1JJN5jIw0C
	 Fu5K4fQujHO//1jGMfazrOZP6IUFh7D5u2bTJO4MarVWKPkLGKR6AsFDs1Nryj82Ju
	 7vRYNWIGGRyDYMdQiN7/Kp/zejVGVPzk71IJ5h38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1011/2651] RDMA/bnxt_re: Validate SRQ max_sge at create time
Date: Wed, 18 Nov 2026 15:37:31 +0100
Message-ID: <20261118150324.316164827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 1894ed9a664d19c190ce1bd2146759efbae77e4b ]

bnxt_re_create_srq() stored attr.max_sge into srq->qplib_srq.max_sge
unvalidated, which defeats the num_sge check in
bnxt_re_post_srq_recv() since that check compares against this same
attacker-chosen value. Reject max_sge > dev_attr->max_srq_sges at
create time, and clamp dev_attr->max_srq_sges to BNXT_STATIC_MAX_SGE
since SRQ WQEs use the fixed-size SGE array.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index c293c30da13e2..f81490fab0d10 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2236,6 +2236,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		goto exit;
 	}
 
+	if (srq_init_attr->attr.max_sge > dev_attr->max_srq_sges) {
+		ibdev_err(&rdev->ibdev,
+			  "Create SRQ failed - max_sge %d exceeds supported %d",
+			  srq_init_attr->attr.max_sge, dev_attr->max_srq_sges);
+		rc = -EINVAL;
+		goto exit;
+	}
+
 	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
 		rc = -EOPNOTSUPP;
 		goto exit;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index ec9eb52a8ebf7..9aaa2b5204b8e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -160,7 +160,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 
 	attr->max_srq = le16_to_cpu(sb->max_srq);
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
-	attr->max_srq_sges = sb->max_srq_sge;
+	attr->max_srq_sges = min_t(u32, sb->max_srq_sge, BNXT_STATIC_MAX_SGE);
 	attr->max_pkey = 1;
 	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
-- 
2.53.0



