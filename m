Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214C267F68;
	Tue,  8 Apr 2025 11:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111406; cv=none; b=PdeYNe7SsfXLNTQVR/B7JSqibj3VUnMtLVMBSKPpqnG6rHrv5o0HCZMKOQZEpxpRckYpa8RXh/LA6rb7JquXiDrIYvElvjQI54f8LSgUA5Rsull82lHm9gcOu6/WbkpONVqnFj39h0KnCDTS7btdNMAK14De6fcYLNInAva3UpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111406; c=relaxed/simple;
	bh=Sd0WXVK/CxEsdMyJ0+qjDmEtzIesCktANn8rH6bnZFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNlcmqXsF6Pfg9iWpASi1zR2BEGfrg4LQOXF24M0fbLDhhlc7DkdwT3oYaG8KFdUTKLeAgdD3M95vlIAfXBUMxRDGRFy0kjQ6CMojRk2G50DyKkrJBEilUUDL/WjVC4jSqn7eLi9F/nJUrtIIE0zZ8snCL1fxEY1drhFM48GC7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKuNqOGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKuNqOGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BF0C4CEE5;
	Tue,  8 Apr 2025 11:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111406;
	bh=Sd0WXVK/CxEsdMyJ0+qjDmEtzIesCktANn8rH6bnZFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKuNqOGPP6i6cf7Dn+s8OXLMfj77KnEyY3BoxvPNE647YKkDYWy+xSJe2Z11vhqM0
	 a5SeiVRHuHTHc9270D+O3Y1xmftE+qiLaULLcWrEw7aC40Tc2plAMhC6nsdf7pvQRi
	 zmnYsnS9vS7WbI3MQyKQ39Z+vX0S4U4GyeIahZPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 419/731] crypto: nx - Fix uninitialised hv_nxc on error
Date: Tue,  8 Apr 2025 12:45:16 +0200
Message-ID: <20250408104924.020289427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 1660c5cf3641c..56129bdf53ab0 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1145,6 +1145,7 @@ static void __init nxcop_get_capabilities(void)
 {
 	struct hv_vas_all_caps *hv_caps;
 	struct hv_nx_cop_caps *hv_nxc;
+	u64 feat;
 	int rc;
 
 	hv_caps = kmalloc(sizeof(*hv_caps), GFP_KERNEL);
@@ -1155,27 +1156,26 @@ static void __init nxcop_get_capabilities(void)
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
@@ -1185,13 +1185,10 @@ static void __init nxcop_get_capabilities(void)
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



