Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A02C26E146;
	Tue, 11 Nov 2025 01:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825487; cv=none; b=orpHvZYfpW7zgVgGwU8v6cV8z3EJOHx+lKQPyuMYMIuFqzBvjFFBfLvcCQSyD8ppeKRNDilPFLVkaqPeMnDF7SlXs5sbFwn5UMIY3Vli4c/lLGNst6oMRJDJobF4qOf93+nh7Rvki7q22kXvOrDc+nFeQ/VNVRllMuUGyGZL71s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825487; c=relaxed/simple;
	bh=dSH/tbCa07HqYVWI8fcJK4pqnivrcIwo8xl5P9NzwUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgJxqJ/t2dCW1gAqeh8hAnP9XMKr6lWyTw9Nc7tQF1gWopBZQj+cvr1H+vOSXueCnZuTstkiiCFpvvPDOTEswSC/xVFQI0b9yFMTGb+L8m+iJR5jOB5FFbPGQ45fpfz0sVh7ZO0yiu/lg9xmcUs2jeH4wgpfroR2Xk3UB9RPYbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aknd/43x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aknd/43x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A495C116D0;
	Tue, 11 Nov 2025 01:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825487;
	bh=dSH/tbCa07HqYVWI8fcJK4pqnivrcIwo8xl5P9NzwUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aknd/43xBGuZjdqhfmRFWpDUCRR8BBhp3S1wowCx4oKm9/E5WA6/t72xotaPMWWZA
	 YBd7CU8PI/IJaX940ErGEhb5gZ1IDELTK/3E0b191QW0J1lYDMp1PK08GddhOW0c5C
	 M2t0cQ3bTOzsk1ZPWmVIlsKS18aG1vZ8sppF4r1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Jones <jajones@nvidia.com>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.17 823/849] drm: define NVIDIA DRM format modifiers for GB20x
Date: Tue, 11 Nov 2025 09:46:33 +0900
Message-ID: <20251111004556.323964151@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Jones <jajones@nvidia.com>

commit 1cf52a0d4ba079fb354fa1339f5fb34142228dae upstream.

The layout of bits within the individual tiles
(referred to as sectors in the
DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D() macro)
changed for 8 and 16-bit surfaces starting in
Blackwell 2 GPUs (With the exception of GB10).
To denote the difference, extend the sector field
in the parametric format modifier definition used
to generate modifier values for NVIDIA hardware.

Without this change, it would be impossible to
differentiate the two layouts based on modifiers,
and as a result software could attempt to share
surfaces directly between pre-GB20x and GB20x
cards, resulting in corruption when the surface
was accessed on one of the GPUs after being
populated with content by the other.

Of note: This change causes the
DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D() macro to
evaluate its "s" parameter twice, with the side
effects that entails. I surveyed all usage of the
modifier in the kernel and Mesa code, and that
does not appear to be problematic in any current
usage, but I thought it was worth calling out.

Fixes: 6cc6e08d4542 ("drm/nouveau/kms: add support for GB20x")
Signed-off-by: James Jones <jajones@nvidia.com>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030181153.1208-2-jajones@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/drm/drm_fourcc.h | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index ea91aa8afde9..e527b24bd824 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -979,14 +979,20 @@ extern "C" {
  *               2 = Gob Height 8, Turing+ Page Kind mapping
  *               3 = Reserved for future use.
  *
- * 22:22 s     Sector layout.  On Tegra GPUs prior to Xavier, there is a further
- *             bit remapping step that occurs at an even lower level than the
- *             page kind and block linear swizzles.  This causes the layout of
- *             surfaces mapped in those SOC's GPUs to be incompatible with the
- *             equivalent mapping on other GPUs in the same system.
+ * 22:22 s     Sector layout.  There is a further bit remapping step that occurs
+ * 26:27       at an even lower level than the page kind and block linear
+ *             swizzles.  This causes the bit arrangement of surfaces in memory
+ *             to differ subtly, and prevents direct sharing of surfaces between
+ *             GPUs with different layouts.
  *
- *               0 = Tegra K1 - Tegra Parker/TX2 Layout.
- *               1 = Desktop GPU and Tegra Xavier+ Layout
+ *               0 = Tegra K1 - Tegra Parker/TX2 Layout
+ *               1 = Pre-GB20x, GB20x 32+ bpp, GB10, Tegra Xavier-Orin Layout
+ *               2 = GB20x(Blackwell 2)+ 8 bpp surface layout
+ *               3 = GB20x(Blackwell 2)+ 16 bpp surface layout
+ *               4 = Reserved for future use.
+ *               5 = Reserved for future use.
+ *               6 = Reserved for future use.
+ *               7 = Reserved for future use.
  *
  * 25:23 c     Lossless Framebuffer Compression type.
  *
@@ -1001,7 +1007,7 @@ extern "C" {
  *               6 = Reserved for future use
  *               7 = Reserved for future use
  *
- * 55:25 -     Reserved for future use.  Must be zero.
+ * 55:28 -     Reserved for future use.  Must be zero.
  */
 #define DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(c, s, g, k, h) \
 	fourcc_mod_code(NVIDIA, (0x10 | \
@@ -1009,6 +1015,7 @@ extern "C" {
 				 (((k) & 0xff) << 12) | \
 				 (((g) & 0x3) << 20) | \
 				 (((s) & 0x1) << 22) | \
+				 (((s) & 0x6) << 25) | \
 				 (((c) & 0x7) << 23)))
 
 /* To grandfather in prior block linear format modifiers to the above layout,
-- 
2.51.2



