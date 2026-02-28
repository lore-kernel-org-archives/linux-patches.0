Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F010F3382D6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301653; cv=none; b=KMSO4nN8NUhJPcm5CdVtAJoIAmO/iA7C2LuA6eG7onn0mgywz1k5loFYZz5p3jpJH6eipMbzdDZl9WfAp5YZsWhO3X/PrgK57SVCIBjApF51nZ8IReXF0uQITGsTRtyt5ebw2+kNWcVIqvpp1pFyPOZPAqtwXfMNUJ+M5vDdE4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301653; c=relaxed/simple;
	bh=87yCKRrv3CFIt/4sbkowBCbC1rqiQRwFMZhESynciz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQANWPRim3dDm3ChrnSaxLbNJyZG8+6Gi85+VlntY+RlWjAkNasAFQOmr2VbUEPAZ8uSsBTCC+fXnbrt49WdJ0Dc7ErCT40pZiMIjxp7sS41bN5dxRd7Uo6QwT+AYKjuvBd5w5NFZcWF6Jxp78vRTEm0YPEiX9GrEI8nYpZAqsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmYwEbgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmYwEbgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFC7C19425;
	Sat, 28 Feb 2026 18:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301652;
	bh=87yCKRrv3CFIt/4sbkowBCbC1rqiQRwFMZhESynciz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmYwEbgsWVtmHLImlFddGPVeIQIV7rXR+9Xot1GSvsHiffCzqTRWM8UOkD+BsoZxr
	 iPezhnzRZyr57PePwinTJZm7zSKT6TZujNl7KEKwWeMWHjEHGJM6B2cjQjK2xmh4RY
	 yld5naHBqD/o9ebAiTgZSc68LmlIylPdZhwa/WiAfbEdK/HWE4+9CRv6oUAtWPMZ1W
	 FetnxWEP4OYdnpwINwF2MAubi/ipJaRXamBiHUSYh2oLlntdbHsHTpRgMy/T/p9dJd
	 9bZ7FCsu7t/kjxtaLFnVNx5p0fTIai9V5rl6dEKV/3hueXnaqtSV1QW0Z3T2+uIHPo
	 cI3BO6Y0HXZ4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/385] crypto: qat - fix warning on adf_pfvf_pf_proto.c
Date: Sat, 28 Feb 2026 12:54:31 -0500
Message-ID: <20260228180011.1568201-49-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index b9b5e744a3f16..af8dbc7517cf8 100644
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

