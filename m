Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7E624677D;
	Tue, 20 May 2025 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750228; cv=none; b=Xo/zBpkpkVLrER4xqRocKJ4ykj4tLpP5uvbeNEV0+0IXihkhdysm0FEFQGy72Z/jxbZPJ5+4sgNWUCBLnCuUsroPIwHpjlz6JnvWfydhO/iawggPffKrIfdugTy6y33vVip4qcx8BJK2mhzYAsYXZsfvKah5upTY0GorqbodCQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750228; c=relaxed/simple;
	bh=UorKLqo1eH4t95nJFwt7HULNY1b2DDMkMLCF11NRvfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMvrQxze7Puw9oUEvlsTP8E6bNzjN0H8is6CEFQgbG4AYzw9yu435JZo2TgVOEYmMZu2R1O33mUySAaqoJxprJVoSd1XJQTDD9m6vefJVbufFyhpjGRAhvfJGgeb1Syu4TECpEMLYSiU25/Dwz/IJTJh0MOiXV7aJ38Tfk1OeU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlrE/zBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlrE/zBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C5BC4CEE9;
	Tue, 20 May 2025 14:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750227;
	bh=UorKLqo1eH4t95nJFwt7HULNY1b2DDMkMLCF11NRvfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlrE/zBegIgPfxvqo2MgTsFubEdNHJtXY8ofril4fAgzox9QDcn9kCvmINUFWYkBh
	 BYsTstNlKSDeYQfeIsNm4S8aswo0c4/InrLr5di8iMrVAkbe0lFgZ6KW/jkw3OatYP
	 vRRKjvgqu87WtOEFFS8vZh+MuOIQWCjHuo0ltkDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>
Subject: [PATCH 6.12 084/143] drm/amdgpu: fix incorrect MALL size for GFX1151
Date: Tue, 20 May 2025 15:50:39 +0200
Message-ID: <20250520125813.369823057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <tim.huang@amd.com>

commit 2d73b0845ab3963856e857b810600e5594bc29f4 upstream.

On GFX1151, the reported MALL cache size reflects only
half of its actual size; this adjustment corrects the discrepancy.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0a5c060b593ad152318f89e5564bfdfcff8a6ac0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -747,6 +747,18 @@ static int gmc_v11_0_sw_init(void *handl
 	adev->gmc.vram_type = vram_type;
 	adev->gmc.vram_vendor = vram_vendor;
 
+	/* The mall_size is already calculated as mall_size_per_umc * num_umc.
+	 * However, for gfx1151, which features a 2-to-1 UMC mapping,
+	 * the result must be multiplied by 2 to determine the actual mall size.
+	 */
+	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
+	case IP_VERSION(11, 5, 1):
+		adev->gmc.mall_size *= 2;
+		break;
+	default:
+		break;
+	}
+
 	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
 	case IP_VERSION(11, 0, 0):
 	case IP_VERSION(11, 0, 1):


