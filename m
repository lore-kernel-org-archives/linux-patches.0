Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFA936B92A;
	Thu, 20 Aug 2026 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238466; cv=none; b=MiHg0CuawBaFCLyhekFlopTqnp7qMh0DEkmXilhuc+RqK8fcf4rcDw1Vd2t22K9kMueF7kZF+MBFtuYbQV4QqFIh8qCCLlBI85YDw1+9yAQQQprQiFjGaNFVLpkKc39s0GD3xB5x25dd203WFR+W9dEokZqmBTrvodq8PLXQkPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238466; c=relaxed/simple;
	bh=rDWo1MJTCLvNpKnN6Sn0g2uUO1ipx9nyF7gRcKZdB3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wb3jeZ+JviDdaK3LrgHUA613U9yxPKWHX7mDsjmPbVFvgOhi73dYs8VLEf9mpCTfbZNQlvgbJaFY1TLKkkSNUgTXER5F64TKVa/5NaK6Y11kNx5cbMPjSn+nEIq0EEy+EGU3Gh3P/mYu2g9EPO/S7oj9255qx3N/lvt9vC2KesU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrcK8aEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrcK8aEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83F61F000E9;
	Thu, 20 Aug 2026 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238465;
	bh=fKJ4ge8fYK4lyjuzcwAwLafVNdsHwprhJTmMiefuzWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrcK8aEHcVamxkcZxZMGHPTzu88acSf8xL/vCYDBtiz9fJuIE/c3O9prhGIeEn1nS
	 fgfzljPuh+3SiUQVFfS8Gn2uTExpBpmdUxgb3wbFLCBnIyYpQz+C9rn5qDWUz2xeGp
	 StJxSqaBD48Ef3k49/TfWgeppiRpBzYRw28cbZ+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 158/228] drm/amdkfd: Add bounds check for CRAT subtype length
Date: Thu, 20 Aug 2026 16:55:00 +0200
Message-ID: <20260820145249.462417661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Palacek <William.Palacek@amd.com>

[ Upstream commit 6e7566ba4739dd573c331adde1c96690f7a567bd ]

The CRAT parser validates that the subtype header fits within the image,
but does not verify that the advertised subtype length fits. A malformed
CRAT table with an oversized length field causes out-of-bounds reads when
kfd_parse_subtype() casts the header to specific subtype structures.

Add validation that sub_type_hdr + length does not exceed the image
boundary before parsing the subtype contents.

Signed-off-by: William Palacek <William.Palacek@amd.com>
Reviewed-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 48e1d1e6e8798aef0312e68d8e586021b5b3cf4d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1404,6 +1404,15 @@ int kfd_parse_crat_table(void *crat_imag
 	sub_type_hdr = (struct crat_subtype_generic *)(crat_table+1);
 	while ((char *)sub_type_hdr + sizeof(struct crat_subtype_generic) <
 			((char *)crat_image) + image_len) {
+		/* Validate subtype fits within remaining image */
+		if ((char *)sub_type_hdr + sub_type_hdr->length >
+		    (char *)crat_image + image_len) {
+			pr_warn("CRAT subtype length %u exceeds image bounds\n",
+				sub_type_hdr->length);
+			ret = -EINVAL;
+			break;
+		}
+
 		if (sub_type_hdr->flags & CRAT_SUBTYPE_FLAGS_ENABLED) {
 			ret = kfd_parse_subtype(sub_type_hdr, device_list);
 			if (ret)


