Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800A02054F8;
	Thu, 12 Dec 2024 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016996; cv=none; b=smmc0M5bkmVZoFazj08fd4ZSgM7+LJB8JX+Fi9fnYqg6NiPaaM+ieu2iFIMc4oGIzmRjmABcp/KQOgevxfDv+Ew4F/KyNI3ocN/ckTY7tQfr+QO5d9mbDk4wNi/285hpixtYQ7YCkSC/UzDVOizUsgxqn2qo6txKbadrYQK+3VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016996; c=relaxed/simple;
	bh=3wae159dIRdG6sxBQfs48pMNTWOlIUFeteN60VhT6As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcMeR/TEvceBminBVzTEkktyUJpVBohGTZX7thPJDkBzAsO4CuKEPHi8jYKAxFobB0q5HIkhem7hTbACJIIe0VCVi1iYVaykbwYvjHuhY/LLNmZ8hz6nVCr1/c6a9rxWTNs17FBBNyiepzlA55lr/Ks8mqn4YFLyv+gshyKNr0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5/rq8Bx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5/rq8Bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A30C4CECE;
	Thu, 12 Dec 2024 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016996;
	bh=3wae159dIRdG6sxBQfs48pMNTWOlIUFeteN60VhT6As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5/rq8BxHrNOcYpuZDD41XApZGedRfXxz4dqfqqGalmg6OjClbhqsm2upnbQvP639
	 JjJIC/cbCQXP/0QSVikPXaezPAsUhC7QbToF9y4sUR0UZnXEUTLc0fBwsy8C7rKQyP
	 v5CQIFI3XxLLuvVg8S7Xzi69u24t1aJs91qxFUBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/466] drm/panic: Add ABGR2101010 support
Date: Thu, 12 Dec 2024 15:58:14 +0100
Message-ID: <20241212144319.632411099@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit 04596969eea9e73b64d63be52aabfddb382e9ce6 ]

Add support for ABGR2101010, used by the nouveau driver.

Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241022185553.1103384-2-jfalempe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index 74412b7bf936c..0a9ecc1380d2a 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -209,6 +209,14 @@ static u32 convert_xrgb8888_to_argb2101010(u32 pix)
 	return GENMASK(31, 30) /* set alpha bits */ | pix | ((pix >> 8) & 0x00300C03);
 }
 
+static u32 convert_xrgb8888_to_abgr2101010(u32 pix)
+{
+	pix = ((pix & 0x00FF0000) >> 14) |
+	      ((pix & 0x0000FF00) << 4) |
+	      ((pix & 0x000000FF) << 22);
+	return GENMASK(31, 30) /* set alpha bits */ | pix | ((pix >> 8) & 0x00300C03);
+}
+
 /*
  * convert_from_xrgb8888 - convert one pixel from xrgb8888 to the desired format
  * @color: input color, in xrgb8888 format
@@ -242,6 +250,8 @@ static u32 convert_from_xrgb8888(u32 color, u32 format)
 		return convert_xrgb8888_to_xrgb2101010(color);
 	case DRM_FORMAT_ARGB2101010:
 		return convert_xrgb8888_to_argb2101010(color);
+	case DRM_FORMAT_ABGR2101010:
+		return convert_xrgb8888_to_abgr2101010(color);
 	default:
 		WARN_ONCE(1, "Can't convert to %p4cc\n", &format);
 		return 0;
-- 
2.43.0



