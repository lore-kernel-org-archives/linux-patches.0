Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8E42737FC;
	Sat, 12 Sep 2026 07:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198720; cv=none; b=j76fNzmm6O0MQOtc7EdSEBot4f2iCuXtO2RncEPl7/E5k4eufCcVN1xmojklFC89nloz9G2d8Ng8jdghEZP/iknNKKlISFtSEcoNq0YclYk0uX7qUvBMLGayzMCs/T4XoTpS/6mNDGi/VyUriKiJnbg2l2ynxdKKlSNDQ42FTBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198720; c=relaxed/simple;
	bh=5rFvRDpDsQH9hgfQPH18EblkfEhKIcyMcZXPP2XXlb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyDhzMLXhKi5JlPNYxnHX2ASaudfzMRrmQhJs5vCCNTv9dZS1yvu2FQG5XPLlI4ZTS0zVMPKFNSX7mLlw1rF8iA+eTM+JRuFL2sNiVLqFJBzdtlQBAyafKQdyn4aqfZzhHwKxxev1uwrhSCI6QESi/Jvc10cMzNV1hQTdVv3T24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fo286ORj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fo286ORj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19501F000FF;
	Sat, 12 Sep 2026 07:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198719;
	bh=O9bkMRqGr3wY7/VUO38XXPfYJjStLl1GYoO+d/PLt+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fo286ORjJMnmvlK4OAzrFEJEcEoxKjpZPXiRbiJ1xEMgSmRIW0HBxjG8o+hQ6zzHG
	 VgFL+Fu2f32BtT3DGT8khWamZor2eSWkRZx/qLM4k08C9LDXksBF0YktxbFJoakjvi
	 SRJHqj+kHBwrnF+CwusQqxcbQTJLp884rMWYc1EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0411/1815] cxl/features: Clamp Get Feature output size to the remaining buffer
Date: Sat, 12 Sep 2026 08:36:01 +0200
Message-ID: <20260912065658.540210847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 2aeb21fe557ef154f0cdf4f9745ebd8d5b31ca83 ]

cxl_get_feature() reads a feature in a loop but passes a fixed size_out
as the output capacity every iteration. On the last partial iteration
the buffer has less room left, so a device that returns more than asked
can overflow feat_out.

Use the per-iter size data_to_rd_size, which already tracks the
remaining room, as the output capacity.

Fixes: 5e5ac21f629d ("cxl/mbox: Add GET_FEATURE mailbox command")
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260626104102.53892-4-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 2eedabb5f7023..ba6d2a5acb74a 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -225,7 +225,7 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 		       void *feat_out, size_t feat_out_size, u16 offset,
 		       u16 *return_code)
 {
-	size_t data_to_rd_size, size_out;
+	size_t data_to_rd_size;
 	struct cxl_mbox_get_feat_in pi;
 	struct cxl_mbox_cmd mbox_cmd;
 	size_t data_rcvd_size = 0;
@@ -237,7 +237,6 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 	if (!feat_out || !feat_out_size)
 		return 0;
 
-	size_out = min(feat_out_size, cxl_mbox->payload_size);
 	uuid_copy(&pi.uuid, feat_uuid);
 	pi.selection = selection;
 
@@ -252,7 +251,7 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 			.opcode = CXL_MBOX_OP_GET_FEATURE,
 			.size_in = sizeof(pi),
 			.payload_in = &pi,
-			.size_out = size_out,
+			.size_out = data_to_rd_size,
 			.payload_out = feat_out + data_rcvd_size,
 			.min_out = data_to_rd_size,
 		};
-- 
2.53.0



