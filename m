Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F152B2737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302312; cv=none; b=IXQf42+Qiasc4kOsqQ9TX279k+yZ8gzWd+AasBdDjNRGI0uPimJN3qY1i19/Dy5B0/X526Bq7tR9hljNX/HdNxYMGi70xKIYhLJr3HzKh0r1A8LpIUXJ+vCsmwFClYTWbxRoo5wEigXeeu0EkyWmG0AUTjsebWhD0af6Lv90Vro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302312; c=relaxed/simple;
	bh=c/AINV9LiMukHIiNifuK2PU1c3+RxezjeJuoOAs8A2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dYmTl1bdcDpaWG2Nv66dEJgtvEShee+946rys5PmyD/Q/yLPmEGUOQctgJXtPAwlITDOjgQ1pecTDzTf0ZKpt51yf2vMNf45Aqoo+vcb8IdFWhM4JkaE413IS+lzLr8kPa2kTVjwfgrfUUR/t26QN9grHPDIsAlYoeK/lKU/iAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYyAtl9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYyAtl9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A9DC19423;
	Sat, 28 Feb 2026 18:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302311;
	bh=c/AINV9LiMukHIiNifuK2PU1c3+RxezjeJuoOAs8A2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYyAtl9tT23RXmhaZy8U+ppWmgLmXImhrX3c7M5UJleS9BnrcdpZCkOe2E0MNoUVR
	 JRbuhwoK/Fn4uKMrxvy9OsL2nDFVZiTYPXFy8JiKAQ0FevHhLWQqX56d7x3RKx36pg
	 S85JdVhEOn4/jCo5Tif1KHv2WfcIcd8a/EJHcmMMr91Wypw7WIDsuNKMYhZLAi5p28
	 gU8Zpt7rYWPlQ9j2pcGjgtTwQeAiEFIrgU0QmEZ5dahqYEo9ZoiEa6QIuGJ8+7/Qbv
	 qhGyGmKvv/Lv6VjtW3VbLOLx13agcBdYc/riyDzpaFRuVUnPpsHbkhsAXp04ROoRnS
	 3CJm2jAvi1woQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/232] crypto: qat - fix warning on adf_pfvf_pf_proto.c
Date: Sat, 28 Feb 2026 13:08:01 -0500
Message-ID: <20260228181127.1592657-28-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 388e58bcbcaf2..4a1ea3e720329 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
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

