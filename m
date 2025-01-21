Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950F61F4275;
	Tue, 21 Jan 2025 18:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482709; cv=none; b=eI8eG2TFT7bX3purTrovhuyRL4Fh0M9ZUCuF1s0XApcqGoYvcd5i+ZFYZKw4IrP/OsqN7oR4fiyqdWR9RgC0Srwed2lYHAQH6tK3Xn0y9t7/7X3H4CLogGTddceN7pZDhb4z8wXJ7B52lXWrqKlSsSuOR2wcnY2WDUSvPGsBh8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482709; c=relaxed/simple;
	bh=UUGU7bYLylqngRYmnbybCc8924AID9S46lMDLGyaTsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjWope3014KsU/aWK5rtrs/mHVreaV0HZWDlSWo5e6YR6bnOXSwiEMwu6rPU9z9wXxihsavnZgAfJ7Jnw679t6RHY1hnB1JD/V6USP9GblF/KWNjBcyskvCVjjeFRfA1uxefPHfcVipjoF6JkXXm6fzNpgEHJc3ZoLPOKyIWbRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjTNwonA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjTNwonA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDD9C4CEDF;
	Tue, 21 Jan 2025 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482709;
	bh=UUGU7bYLylqngRYmnbybCc8924AID9S46lMDLGyaTsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjTNwonAj28Gy3eP3kjA8CSKm0kFulahYlJO74Jzjg+WuowYKafQIvBJG7DX2aOGe
	 3QKO1h51ftUKc2ctXdWICUY6nU57OlaFogUCB6cP9deU/N1/VvHV7l2pqSjmfRR2eZ
	 ZBiS/E9LUcR7bD3qiZBEXT9VHI6NuvkqJ0708WkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagar Ghuge <sagar.ghuge@intel.com>,
	Nanley Chery <nanley.g.chery@intel.com>,
	Xi Ruoyao <xry111@xry111.site>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.1 47/64] drm/i915/fb: Relax clear color alignment to 64 bytes
Date: Tue, 21 Jan 2025 18:52:46 +0100
Message-ID: <20250121174523.345975512@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 1a5401ec3018c101c456cdbda2eaef9482db6786 upstream.

Mesa changed its clear color alignment from 4k to 64 bytes
without informing the kernel side about the change. This
is now likely to cause framebuffer creation to fail.

The only thing we do with the clear color buffer in i915 is:
1. map a single page
2. read out bytes 16-23 from said page
3. unmap the page

So the only requirement we really have is that those 8 bytes
are all contained within one page. Thus we can deal with the
Mesa regression by reducing the alignment requiment from 4k
to the same 64 bytes in the kernel. We could even go as low as
32 bytes, but IIRC 64 bytes is the hardware requirement on
the 3D engine side so matching that seems sensible.

Note that the Mesa alignment chages were partially undone
so the regression itself was already fixed on userspace
side.

Cc: stable@vger.kernel.org
Cc: Sagar Ghuge <sagar.ghuge@intel.com>
Cc: Nanley Chery <nanley.g.chery@intel.com>
Reported-by: Xi Ruoyao <xry111@xry111.site>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13057
Closes: https://lore.kernel.org/all/45a5bba8de009347262d86a4acb27169d9ae0d9f.camel@xry111.site/
Link: https://gitlab.freedesktop.org/mesa/mesa/-/commit/17f97a69c13832a6c1b0b3aad45b06f07d4b852f
Link: https://gitlab.freedesktop.org/mesa/mesa/-/commit/888f63cf1baf34bc95e847a30a041dc7798edddb
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241129065014.8363-2-ville.syrjala@linux.intel.com
Tested-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit ed3a892e5e3d6b3f6eeb76db7c92a968aeb52f3d)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fb.c
@@ -1571,7 +1571,7 @@ int intel_fill_fb_info(struct drm_i915_p
 		 * arithmetic related to alignment and offset calculation.
 		 */
 		if (is_gen12_ccs_cc_plane(&fb->base, i)) {
-			if (IS_ALIGNED(fb->base.offsets[i], PAGE_SIZE))
+			if (IS_ALIGNED(fb->base.offsets[i], 64))
 				continue;
 			else
 				return -EINVAL;


