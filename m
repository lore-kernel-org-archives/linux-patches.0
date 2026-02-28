Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A573D3446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302060; cv=none; b=NxTB1uBEZaOud3oApVEIh2wafcYQiyikHwveuxt2mnCK+TIC5ZHI/+gQoiYzHCmRvGi6YTr+JDilYbXElS9l620n1enZsWBIBO8TpwcEqW7jypWbeIu6lnXTfz/koQNZPMeriPl+fqVWTFiJn10aHO94m6hE8rac0RBt3U/ePss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302060; c=relaxed/simple;
	bh=q8X8MBEwp2Go2BrwBJReHiSh+RdnnXqRLSsk8xBt+nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K1/mp9ik7lwi6zPgRyFVF0g9W9iHldBO3+JwbfITQ1H3I7nrPg+bg84FLmx+4eh40IWeBkTuLtyHEsp0Ev2K7fSaE6MteTb7PJRSJz++X/k64FV0le9wfoF5uwqo19K+wBOakmd/BWVCIEQR8W3gFA9OLiHPOabrU0zGdK7NoXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=At8pHzom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="At8pHzom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C5DC116D0;
	Sat, 28 Feb 2026 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302060;
	bh=q8X8MBEwp2Go2BrwBJReHiSh+RdnnXqRLSsk8xBt+nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=At8pHzomhfOBm2NT/KxAUprT6fymFl6wpC0PunjTrFH0WrvWL54nx+vW7RaasXCSw
	 KHDRx/hqTkfsZU/+7zR5aKv5SGYTNbd0E6crNu941i1O8s7tF1GYvHDW6SVYTELvVE
	 8JzvUmOAqnzlgj2z/hysnC0uEEclLY2YIDiHHcPJWcihaK+V2dnDSAcrS6wbytTMPH
	 viZQSkStyJ94N4YzXWumVn8GlYFTBnuZX5AaUgvja5GDJEmax9y+bAkzGm0yB0LweV
	 QZi0KeWxmsyIdgoFSHJ2wS7nupGupf0xgGfjiXWRd583au9imkL2AInt+Jf41/HpRp
	 vn6iBfv2h3Tew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/283] crypto: qat - fix warning on adf_pfvf_pf_proto.c
Date: Sat, 28 Feb 2026 13:02:59 -0500
Message-ID: <20260228180709.1583486-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 994689b8f91b02fdb5f64cba2412cde5ef3084b5 ]

Building the QAT driver with -Wmaybe-uninitialized triggers warnings in
qat_common/adf_pfvf_pf_proto.c. Specifically, the variables blk_type,
blk_byte, and byte_max may be used uninitialized in handle_blkmsg_req():

  make M=drivers/crypto/intel/qat W=1 C=2 "KCFLAGS=-Werror" \
       KBUILD_CFLAGS_KERNEL=-Wmaybe-uninitialized           \
       CFLAGS_MODULE=-Wmaybe-uninitialized

  ...
  warning: ‘byte_max’ may be used uninitialized [-Wmaybe-uninitialized]
  warning: ‘blk_type’ may be used uninitialized [-Wmaybe-uninitialized]
  warning: ‘blk_byte’ may be used uninitialized [-Wmaybe-uninitialized]

Although the caller of handle_blkmsg_req() always provides a req.type
that is handled by the switch, the compiler cannot guarantee this.

Add a default case to the switch statement to handle an invalid req.type.

Fixes: 673184a2a58f ("crypto: qat - introduce support for PFVF block messages")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
index 388e58bcbcaf2..4a1ea3e720329 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_proto.c
@@ -148,6 +148,16 @@ static struct pfvf_message handle_blkmsg_req(struct adf_accel_vf_info *vf_info,
 		blk_byte = FIELD_GET(ADF_VF2PF_SMALL_BLOCK_BYTE_MASK, req.data);
 		byte_max = ADF_VF2PF_SMALL_BLOCK_BYTE_MAX;
 		break;
+	default:
+		dev_err(&GET_DEV(vf_info->accel_dev),
+			"Invalid BlockMsg type 0x%.4x received from VF%u\n",
+			req.type, vf_info->vf_nr);
+		resp.type = ADF_PF2VF_MSGTYPE_BLKMSG_RESP;
+		resp.data = FIELD_PREP(ADF_PF2VF_BLKMSG_RESP_TYPE_MASK,
+				       ADF_PF2VF_BLKMSG_RESP_TYPE_ERROR) |
+			    FIELD_PREP(ADF_PF2VF_BLKMSG_RESP_DATA_MASK,
+				       ADF_PF2VF_UNSPECIFIED_ERROR);
+		return resp;
 	}
 
 	/* Is this a request for CRC or data? */
-- 
2.51.0

