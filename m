Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9659D41D135;
	Sat, 12 Sep 2026 10:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207332; cv=none; b=fueMT/V83ZXfJlXRFsuHyb30ZaJfFp8Ifldh1iF4X0puZ3Bm7UaAPl7EGO8LeS/t0DGK19wW0aadB+oyeFex3ePgUsSTt+zjrx6BIiq4A3Vrsn1iscNW6EDA20k8v2GAYtjIo9yD5UiaqY/D/Lq60NOvY0vtmsPUfck14ERR+jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207332; c=relaxed/simple;
	bh=JFAbHIOs6pHDiGMd+z1X5/ncdECZHFx9ZnJPpTSP5iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYqRe6MyV/bJvrMGifa4Pm2eYeCK1C9Aiqju1FPAX5FhQKBJ9B2B5OZuQDyPS4PFwzBvtDJkFeLIqd8yCr+VSyICcJ9eA7icGXre+/bI40ifL5wWVeqaiRb5LPC306fBE87BU7aniWp1Jh98adusKXsf2aVeoZd+60TahFTCQso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eq+y8pCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eq+y8pCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500A01F000FF;
	Sat, 12 Sep 2026 10:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207331;
	bh=WqovUMe9gv9SE/TC5LwxbmFmGLrefxE3jrqvrCkZUSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eq+y8pCFXY55CMLtXLecm2cPS0IQL/468hsPMQ7eV5P6gAg9Vzc9R7QtMsF0LA1Zm
	 H/oS8VbvfWlearWKrU3S+ZJbTvTLvadjyblS2kUa4Bv8SQ2qTYaoieitzna7un4AlN
	 Tl1/r55iFVf+C+86esXkABDJfLQ5nYN6d0wrQe2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0391/1518] cxl/features: Reject Set Features output buffer smaller than the header
Date: Sat, 12 Sep 2026 08:42:40 +0200
Message-ID: <20260912065632.303328064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit cde18d6c1d913a67ab0afd3d9475ece4be79da50 ]

cxlctl_set_feature() sizes its output buffer from the user's
fwctl_rpc.out_len but never checks it is large enough to hold even the
fwctl_rpc_cxl_out header. With out_len == 0 , kvzalloc() returns
ZERO_SIZE_PTR, which passes the !rpc_out check, the subsequent
rpc_out->size = 0 then writes through the poison pointer.

Reject requests whose output buffer can't hold the response header,
before allocating. The Set Feature reply carries no payload, so the
header is all that is required.

Fixes: eb5dfcb9e36d ("cxl: Add support to handle user feature commands for set feature")
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260626104102.53892-3-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 32bded289ebc7..c45b6dfcc2445 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -520,6 +520,9 @@ static void *cxlctl_set_feature(struct cxl_features_state *cxlfs,
 	flags = le32_to_cpu(feat_in->flags);
 	out_size = *out_len;
 
+	if (out_size < offsetof(struct fwctl_rpc_cxl_out, payload))
+		return ERR_PTR(-EINVAL);
+
 	struct fwctl_rpc_cxl_out *rpc_out __free(kvfree) =
 		kvzalloc(out_size, GFP_KERNEL);
 	if (!rpc_out)
-- 
2.53.0



