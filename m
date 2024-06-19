Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D8682495;
	Wed, 19 Jun 2024 13:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803412; cv=none; b=OuP7etfCkHC9aPJLdp0EjHXq4mP95lVgxWTjIDGGOvZOgdlPRNcTIVdFtjDzJ6LSZ0HmemFoQsFtWF1n7V6tCBY0b99V/9/OHrQYrIRE42MzzbqLTJ/DnwXsSmvucqNOWQjM26J0g05pJZkjHBUWTqcxNb4c6XJnh+f3PZaS928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803412; c=relaxed/simple;
	bh=l7ILUkXuGXU7rD21qfutW+RyxjindHU9kFgkNl4Yf6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2m+UiRXYWMAIVxHkIx9bToX/5L1457tkdoYzDsS2oXsrOq/Rv5w1c2L+czGn24bXFqQNo9g4roPRuq2VMy1R+NtManh4QMKAsUngg5VwtjY3vbuu5hvLxTeX+7UNpYqm92dfxR97OX5Zpk0c05E00bshYdEX74/gjpAgx/sRFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4+YZKBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4+YZKBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B0EC2BBFC;
	Wed, 19 Jun 2024 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803412;
	bh=l7ILUkXuGXU7rD21qfutW+RyxjindHU9kFgkNl4Yf6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4+YZKBNiE4gD//l9HB3nbPyRsm1SfbqAvs4YD58U02EGJgQ+KcslD6TpuXuRldGx
	 23OROwFEHoI0Nvm/b1q7QpcotAshz+8pUNT62WQW5rpp4UwxfNA6VSjd55LAJYuJsF
	 PtZSro+wtmBOJrpM32O5Gs4gYOGQDBm4DbLqtj50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lee <shawn.c.lee@intel.com>,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.9 259/281] drm/i915/dpt: Make DPT object unshrinkable
Date: Wed, 19 Jun 2024 14:56:58 +0200
Message-ID: <20240619125619.947265977@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Srinivas <vidya.srinivas@intel.com>

commit 43e2b37e2ab660c3565d4cff27922bc70e79c3f1 upstream.

In some scenarios, the DPT object gets shrunk but
the actual framebuffer did not and thus its still
there on the DPT's vm->bound_list. Then it tries to
rewrite the PTEs via a stale CPU mapping. This causes panic.

Cc: stable@vger.kernel.org
Reported-by: Shawn Lee <shawn.c.lee@intel.com>
Fixes: 0dc987b699ce ("drm/i915/display: Add smem fallback allocation for dpt")
Signed-off-by: Vidya Srinivas <vidya.srinivas@intel.com>
[vsyrjala: Add TODO comment]
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240520165634.1162470-1-vidya.srinivas@intel.com
(cherry picked from commit 51064d471c53dcc8eddd2333c3f1c1d9131ba36c)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_object.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -284,7 +284,9 @@ bool i915_gem_object_has_iomem(const str
 static inline bool
 i915_gem_object_is_shrinkable(const struct drm_i915_gem_object *obj)
 {
-	return i915_gem_object_type_has(obj, I915_GEM_OBJECT_IS_SHRINKABLE);
+	/* TODO: make DPT shrinkable when it has no bound vmas */
+	return i915_gem_object_type_has(obj, I915_GEM_OBJECT_IS_SHRINKABLE) &&
+		!obj->is_dpt;
 }
 
 static inline bool


