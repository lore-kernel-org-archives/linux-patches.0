Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465DE304BB3;
	Mon, 17 Aug 2026 15:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979330; cv=none; b=D2Sz2wDlUQrAgKQ1I2ISTPP93UOzoH7qRrvNvqV5T/6fFtF40/laOhYo9N9TwfqSgcIcim28nN6fqVAxmxL2dIqPRxcRZz8D4YgBIfYZbWU0UTw6Hpr5Um1Wy+x0yEt2Lo9ewV0FqQo3qGG2/qeHugw/XZB2KZnHrGTpJXMNges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979330; c=relaxed/simple;
	bh=UmpReeMhFxBXOAbW40f2LxcP2m8npryV2iUj7MnMN9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3ciMvZy6fnxXctA+3NtPHUcEdqwa9dWXCN3DgzeJvusiX5Z9dn9ZLLX4iYpzIV16Y7xZ2ipdOZugH0NBOcLVapFc9tnBkcm7o44DMY1MDv1EZee5iGoRGinYPx7SzOQ/YZtBcZ2bqUOmMh4DQoZK1SM4seqLegp2UEjQ2Qm218=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7HCaBXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7HCaBXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA751F000E9;
	Mon, 17 Aug 2026 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979329;
	bh=VBCXBohnLBW4zzmSazQxG8wbNI5yjI7UuXA80j1F/vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7HCaBXQyUJGb1ha39ZjyrJ8TopLsLG08wA61bmoMt5SUkiQp1ij+LkN9GbVenKWD
	 s6aEmIJ205Ttrk39MFCPH2u9N3yYWj3t/+yuiYNU0+aOyOeH9GijSJqMEeJMahOlSR
	 GhskeCWa04UTcqf/wLLolITrYJGjxX4qtlejikog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.1 187/609] drm/vmwgfx: Validate vmw_surface_metadata::array_size
Date: Mon, 17 Aug 2026 15:28:03 +0200
Message-ID: <20260817132550.340365049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

commit a4f55260f7f7d4dc4d0ee55063dfb0c457b77991 upstream.

This field comes from userspace and should be validated against specific
limits depending on which Shader Model (SM) is available.

Fixes: 504901dbb0b5 ("drm/vmwgfx: Refactor surface_define to use vmw_surface_metadata")
Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20260623193314.506257-1-ian.forbes@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -98,7 +98,7 @@ static int vmw_gb_surface_unbind(struct
 static int vmw_gb_surface_destroy(struct vmw_resource *res);
 static int
 vmw_gb_surface_define_internal(struct drm_device *dev,
-			       struct drm_vmw_gb_surface_create_ext_req *req,
+			       const  struct drm_vmw_gb_surface_create_ext_req *req,
 			       struct drm_vmw_gb_surface_create_rep *rep,
 			       struct drm_file *file_priv);
 static int
@@ -1406,7 +1406,7 @@ int vmw_gb_surface_reference_ext_ioctl(s
  */
 static int
 vmw_gb_surface_define_internal(struct drm_device *dev,
-			       struct drm_vmw_gb_surface_create_ext_req *req,
+			       const  struct drm_vmw_gb_surface_create_ext_req *req,
 			       struct drm_vmw_gb_surface_create_rep *rep,
 			       struct drm_file *file_priv)
 {
@@ -1424,9 +1424,21 @@ vmw_gb_surface_define_internal(struct dr
 				req->base.svga3d_flags);
 
 	/* array_size must be null for non-GL3 host. */
-	if (req->base.array_size > 0 && !has_sm4_context(dev_priv)) {
-		VMW_DEBUG_USER("SM4 surface not supported.\n");
-		return -EINVAL;
+	if (req->base.array_size > 0) {
+		if (has_sm5_context(dev_priv)) {
+			if (req->base.array_size > SVGA3D_SM5_MAX_SURFACE_ARRAYSIZE) {
+				VMW_DEBUG_USER("Invalid Surface Array Size.\n");
+				return -EINVAL;
+			}
+		} else if (has_sm4_context(dev_priv)) {
+			if (req->base.array_size > SVGA3D_SM4_MAX_SURFACE_ARRAYSIZE) {
+				VMW_DEBUG_USER("Invalid Surface Array Size.\n");
+				return -EINVAL;
+			}
+		} else {
+			VMW_DEBUG_USER("SM4+ surface not supported.\n");
+			return -EINVAL;
+		}
 	}
 
 	if (!has_sm4_1_context(dev_priv)) {


