Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940E43CF42;
	Wed, 21 Feb 2024 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525155; cv=none; b=uSrgzpZs9pygDaVWCctOmMk41bGbmCKhKIt0sSms5u5jReiBr0rWttGvOfAqp9CtE17uyAv5RPP9/fgcW0z7a80u04BVdGVmxddhEqlS9gU9TWnMfzpx0vRdyOtHL4JY3SLqbUteZMuQvThqcszXo5Nq9qN0ueAP9opdtbnczDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525155; c=relaxed/simple;
	bh=dfaIaZCTkMc1l5o5dPIjiXZ71B6x1ZrpYxBcpAYnwSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DbMfk0cv8XVwh3espJW1ZKS9PLHkXShR+O+SmasSljxotX/IW7S3kn6NpFWawcok90awBlQfstADb6VMubHX3hM47nC6fo0r/8d8DbCl8F2UXfEnkO0Iw/baAlUZ6h6gF++OkDzfaUJ0p+JCI9hN0O3bbfzjhvn6LIpQlB9Hi40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyrYpEl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyrYpEl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13481C43390;
	Wed, 21 Feb 2024 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525155;
	bh=dfaIaZCTkMc1l5o5dPIjiXZ71B6x1ZrpYxBcpAYnwSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyrYpEl47i8eeyU23oj8r6A+RAQI64dHkW4I7MRcNGfsq79LQGxrXSS5C+TrH/FuC
	 c3s9Vth+6igWUt7GeuzCFM8LDap4t4oYiSkItv46lvkXaFbVHlMoDg107MMvARVHLc
	 kfsFd0j9O5hrzwtbTS+ncorYZ2PtLgvTLWS3wcJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 5.4 049/267] drm: Dont unref the same fb many times by mistake due to deadlock handling
Date: Wed, 21 Feb 2024 14:06:30 +0100
Message-ID: <20240221125941.548564084@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit cb4daf271302d71a6b9a7c01bd0b6d76febd8f0c upstream.

If we get a deadlock after the fb lookup in drm_mode_page_flip_ioctl()
we proceed to unref the fb and then retry the whole thing from the top.
But we forget to reset the fb pointer back to NULL, and so if we then
get another error during the retry, before the fb lookup, we proceed
the unref the same fb again without having gotten another reference.
The end result is that the fb will (eventually) end up being freed
while it's still in use.

Reset fb to NULL once we've unreffed it to avoid doing it again
until we've done another fb lookup.

This turned out to be pretty easy to hit on a DG2 when doing async
flips (and CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y). The first symptom I
saw that drm_closefb() simply got stuck in a busy loop while walking
the framebuffer list. Fortunately I was able to convince it to oops
instead, and from there it was easier to track down the culprit.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231211081625.25704-1-ville.syrjala@linux.intel.com
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_plane.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -1203,6 +1203,7 @@ retry:
 out:
 	if (fb)
 		drm_framebuffer_put(fb);
+	fb = NULL;
 	if (plane->old_fb)
 		drm_framebuffer_put(plane->old_fb);
 	plane->old_fb = NULL;


