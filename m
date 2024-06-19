Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F5D13DDC0;
	Wed, 19 Jun 2024 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804039; cv=none; b=kd3jl6JR1TH8C8EvbVBm3XSX3ALd8UJFxP8tRV/+pKtwaxKAi+D59KFgPhYd8nbKVnuqHaBSDckCTYAIGLVUhNyjMlcpGE0baeTnh/aoLi9NkJVzlZFbEOGEpjix5lC/aQNmWOL7OR9BrHGqkhCShhjzbJA7ZGNvl7Y2UX1Yyq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804039; c=relaxed/simple;
	bh=Lew2qnw5w94fnmgtIpo9FCYKvo6Q2+yEsAAyMtVvHMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oKeH5oZtfHf/2lslsgB9ZhGpW/ZsVvADfQZmFX8ktMnn/SlJ9h0KqQLB6TFoMFdpyyUoFCCMPSHzdij7zBQ7rl5egjMmkeQF7wQkIfdZjOQ5LvJASi8q9N7cySlPNhXUc+Lc0Ff7fmvrYQ6k0olHwstz6KeXdzEEU+sL6hXvrmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVdDXpB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVdDXpB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23CCC2BBFC;
	Wed, 19 Jun 2024 13:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804039;
	bh=Lew2qnw5w94fnmgtIpo9FCYKvo6Q2+yEsAAyMtVvHMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVdDXpB6Wq2ll9Z6emssx/B6brBbcPcnLVjmGqXPMIga4glK1gw5ziQSxgTYlt6rI
	 70g0nmC+/0Bo1rxlHQlXkMX9Cx2+dz5XZ2XPn0qsXqwsttLe9mwm9JeKRZjhYVuiJP
	 Luidq2RhobYCvWV4Locjld1CmuTR2z0tzAMpbGEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lee <shawn.c.lee@intel.com>,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 188/217] drm/i915/dpt: Make DPT object unshrinkable
Date: Wed, 19 Jun 2024 14:57:11 +0200
Message-ID: <20240619125603.940454993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -295,7 +295,9 @@ bool i915_gem_object_has_iomem(const str
 static inline bool
 i915_gem_object_is_shrinkable(const struct drm_i915_gem_object *obj)
 {
-	return i915_gem_object_type_has(obj, I915_GEM_OBJECT_IS_SHRINKABLE);
+	/* TODO: make DPT shrinkable when it has no bound vmas */
+	return i915_gem_object_type_has(obj, I915_GEM_OBJECT_IS_SHRINKABLE) &&
+		!obj->is_dpt;
 }
 
 static inline bool


