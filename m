Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FCA26461E;
	Tue,  8 Apr 2025 12:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115827; cv=none; b=I9gPXPDqx2134DKaJmRKBegU2I4QinOEtzDpFbTt53HiPRScsobO40UezTjSVJhMIwjAhw104UTiW8JXku+6WwFPMy9tGK2gTvqxiV604PSemaJlKOXYkUQVeVrbRgUNSpJttgdwNGswS9VGjU3Qvh6Lnwy0eTPJMrpFEW5/ndc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115827; c=relaxed/simple;
	bh=Ssh/P4AbuKfleL/KmjcNifZk+NE5PIUBQgdH8Xv3kpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH6iImx/yq64dLzYRPeucRJsSb6Jna1+kjcmHSDPzzjLn+0sbAeGwdJzpOoPYedDT5VHypKi7yxaMXv0lc/jfWUMZO4La+JaAigaQIwyEUMCkL/gh83vGRz75E/fHap7X2bq8f9+Vbr2znhpIkGkuKelXyGqu3S2h9jFY2EtduY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSbt4BM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSbt4BM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779E9C4CEE5;
	Tue,  8 Apr 2025 12:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115826;
	bh=Ssh/P4AbuKfleL/KmjcNifZk+NE5PIUBQgdH8Xv3kpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSbt4BM6fQCWpiaYmEZg/Hr7uBHfFsjEQbROAbj4CLtg0SNs6Zs33Z8wsv28nt+JJ
	 mYYvdg2HCeb2o+EdcvuYHYE2d8x2WfdjqlC2BZwo1Tol1muoK8mBxnufOPyO/SIFaH
	 DljoQHJN6Nvdzlh4g4t8elnlEUvTDCtVYB4WvPXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/204] crypto: nx - Fix uninitialised hv_nxc on error
Date: Tue,  8 Apr 2025 12:50:09 +0200
Message-ID: <20250408104822.681145381@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 9b00eb923f3e60ca76cbc8b31123716f3a87ac6a ]

The compiler correctly warns that hv_nxc may be used uninitialised
as that will occur when NX-GZIP is unavailable.

Fix it by rearranging the code and delay setting caps_feat until
the final query succeeds.

Fixes: b4ba22114c78 ("crypto/nx: Get NX capabilities for GZIP coprocessor type")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-common-pseries.c | 37 ++++++++++++---------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 3ea334b7f820c..1b0308ce7ce76 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1142,6 +1142,7 @@ static void __init nxcop_get_capabilities(void)
 {
 	struct hv_vas_all_caps *hv_caps;
 	struct hv_nx_cop_caps *hv_nxc;
+	u64 feat;
 	int rc;
 
 	hv_caps = kmalloc(sizeof(*hv_caps), GFP_KERNEL);
@@ -1152,27 +1153,26 @@ static void __init nxcop_get_capabilities(void)
 	 */
 	rc = h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES, 0,
 					  (u64)virt_to_phys(hv_caps));
+	if (!rc)
+		feat = be64_to_cpu(hv_caps->feat_type);
+	kfree(hv_caps);
 	if (rc)
-		goto out;
+		return;
+	if (!(feat & VAS_NX_GZIP_FEAT_BIT))
+		return;
 
-	caps_feat = be64_to_cpu(hv_caps->feat_type);
 	/*
 	 * NX-GZIP feature available
 	 */
-	if (caps_feat & VAS_NX_GZIP_FEAT_BIT) {
-		hv_nxc = kmalloc(sizeof(*hv_nxc), GFP_KERNEL);
-		if (!hv_nxc)
-			goto out;
-		/*
-		 * Get capabilities for NX-GZIP feature
-		 */
-		rc = h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES,
-						  VAS_NX_GZIP_FEAT,
-						  (u64)virt_to_phys(hv_nxc));
-	} else {
-		pr_err("NX-GZIP feature is not available\n");
-		rc = -EINVAL;
-	}
+	hv_nxc = kmalloc(sizeof(*hv_nxc), GFP_KERNEL);
+	if (!hv_nxc)
+		return;
+	/*
+	 * Get capabilities for NX-GZIP feature
+	 */
+	rc = h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES,
+					  VAS_NX_GZIP_FEAT,
+					  (u64)virt_to_phys(hv_nxc));
 
 	if (!rc) {
 		nx_cop_caps.descriptor = be64_to_cpu(hv_nxc->descriptor);
@@ -1182,13 +1182,10 @@ static void __init nxcop_get_capabilities(void)
 				be64_to_cpu(hv_nxc->min_compress_len);
 		nx_cop_caps.min_decompress_len =
 				be64_to_cpu(hv_nxc->min_decompress_len);
-	} else {
-		caps_feat = 0;
+		caps_feat = feat;
 	}
 
 	kfree(hv_nxc);
-out:
-	kfree(hv_caps);
 }
 
 static const struct vio_device_id nx842_vio_driver_ids[] = {
-- 
2.39.5



