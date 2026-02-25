Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21414369A;
	Wed, 25 Feb 2026 01:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982936; cv=none; b=PBExTTMvk15R6ZdjpONaPJIgsIvxj0XblWVyXtq93LSHGKBX9/doew7LzPT/OK5Es26ao1MFQ9b2dB/YwqILlorKPlBedITDAztvz3nqOSc5difSFOYR56TvnhyrYim29o+dm4RN417qHvDXZPWI5w7I8/TWyjql7BYLBoxmfTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982936; c=relaxed/simple;
	bh=uXVl0YsMJ2wwAaVe1Th5f0YuA9lg+Z6v9fd5xo7/Q5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiKttNnZhv5hXGROxmQG26sEM3Ev2UKZzkCZ28GrY8oy8kOzZVoEG3gwkMSJb8IUDtF80EG9si79Zc1hXwg8wKzySCXwu3FbFaaCSv+lgowa/v5KtvImg9YmS2UR1T1f/rC7G+/IVr3VqPiYIFxblGybn80NFMorW16l4LmpR5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xMX8q9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xMX8q9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5E7C116D0;
	Wed, 25 Feb 2026 01:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982936;
	bh=uXVl0YsMJ2wwAaVe1Th5f0YuA9lg+Z6v9fd5xo7/Q5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xMX8q9DzRHCOLTZUPXdAMtaFRQT5yFK70d6paOuFuh1/JNCYFGDh++R3nYuiuOKC
	 plOOIdHQNtKkxBo9b8A8kYSQoruZ7L/kUGxqyY6YBxpqstWHnJChYOFw8nlcbAjdW3
	 xhgTH89JAqewA2Dp/RVBDCZj7io/HTLeUUX2pJk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	Qihua Dai <qihua.dai@intel.com>
Subject: [PATCH 6.19 070/781] crypto: qat - fix parameter order used in ICP_QAT_FW_COMN_FLAGS_BUILD
Date: Tue, 24 Feb 2026 17:12:59 -0800
Message-ID: <20260225012401.417860211@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit e3d036fecd6f89d4d262034de7bef8d6e49b661b ]

The macro ICP_QAT_FW_COMN_FLAGS_BUILD sets flags in the firmware
descriptor to indicate:

  * Whether the content descriptor is a pointer or contains embedded
    data.
  * Whether the source and destination buffers are scatter-gather lists
    or flat buffers.

The correct parameter order is:

  * First: content descriptor type
  * Second: source/destination pointer type

In the asymmetric crypto code, the macro was used with the parameters
swapped. Although this does not cause functional issues, since both
macros currently evaluate to 0, it is incorrect.

Fix the parameter order in the Diffie-Hellman and RSA code paths.

Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
Fixes: c9839143ebbf ("crypto: qat - Add DH support")
Reported-by: Qihua Dai <qihua.dai@intel.com> # off-list
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 85c682e248fb9..e09b9edfce423 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -255,8 +255,8 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	qat_req->areq.dh = req;
 	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
 	msg->pke_hdr.comn_req_flags =
-		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
-					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_CD_FLD_TYPE_64BIT_ADR,
+					    QAT_COMN_PTR_TYPE_FLAT);
 
 	/*
 	 * If no source is provided use g as base
@@ -731,8 +731,8 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	qat_req->areq.rsa = req;
 	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
 	msg->pke_hdr.comn_req_flags =
-		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
-					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_CD_FLD_TYPE_64BIT_ADR,
+					    QAT_COMN_PTR_TYPE_FLAT);
 
 	qat_req->in.rsa.enc.e = ctx->dma_e;
 	qat_req->in.rsa.enc.n = ctx->dma_n;
@@ -867,8 +867,8 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	qat_req->areq.rsa = req;
 	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
 	msg->pke_hdr.comn_req_flags =
-		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
-					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_CD_FLD_TYPE_64BIT_ADR,
+					    QAT_COMN_PTR_TYPE_FLAT);
 
 	if (ctx->crt_mode) {
 		qat_req->in.rsa.dec_crt.p = ctx->dma_p;
-- 
2.51.0



