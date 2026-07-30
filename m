Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A94139A801;
	Thu, 30 Jul 2026 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424368; cv=none; b=G9PSqU/wUYBusYtzaAkikZCMRIDflV8fD+sneyfKfqx25n/RWIy3n6ag8cSiNSKCfeWW2aVUXJi1/KOEpK290IkSb/IE8tC5b2eFlnbL9xITdr43IkuaKflrQaBBEQl1QqsFwtkCKlJnWPNcrTdfGHpWD3qBMUBNZeRVqW5yVUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424368; c=relaxed/simple;
	bh=sRzgfudKaEUsbgCgVjxPtpAhz8ylRxuhA4ytiEvWvV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrDt9FK/RDVQfonSH5YubyY0+d+ZlNBrsVZgugqYDBicy50nx+vFJ/lcuX3d3F0s9jUEJPk84AmNLf4h1nuBK8JLnXaCsVsLLMX3fiY8O1d/eaH29OIULHUgSnP/x9ELJu2GeiuU28ZNH/jVWIbtR0wkmwteU64Abz0n/jtFlHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hz5Xy8xl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hz5Xy8xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5421F000E9;
	Thu, 30 Jul 2026 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424367;
	bh=iMnYNI6P6A2QXKkStoDnZ4WKicWv0BVDb8bkrA8Y9+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hz5Xy8xl+NU7MomO6EKcG1iw89a7uE0mADsXRNaO4b55pFpvXxuSqg08ZCxPku8YO
	 p1PGuJqJCGsi/0Pcr6wUkCh7UOY9epi61SvfVYqBJuN5s0++1tZfRN376djsMXDlaj
	 66LXRRLsE3/lbH7imi5p17IiOD7oChm06SBhB/Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 370/675] drm/i915/gem: Fix NULL deref in I915_CONTEXT_PARAM_SSEU
Date: Thu, 30 Jul 2026 16:11:40 +0200
Message-ID: <20260730141452.995397282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

commit 2b56757a9a7456825eb668fde92299e01c5e2721 upstream.

Setting context engine slot N into I915_ENGINE_CLASS_INVALID /
I915_ENGINE_CLASS_INVALID_NONE and attempting to apply
I915_CONTEXT_PARAM_SSEU to the same slot N will deref NULL.
Fix that.

Discovered using AI-assisted static analysis confirmed by
Intel Product Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: d4433c7600f7 ("drm/i915/gem: Use the proto-context to handle create parameters (v5)")
Cc: Faith Ekstrand <faith.ekstrand@collabora.com>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260701075555.52142-1-joonas.lahtinen@linux.intel.com
(cherry picked from commit 36eda5b5c2d40da41cc0a5403c26986237cf9e87)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -857,7 +857,7 @@ static int set_proto_ctx_sseu(struct drm
 		pe = &pc->user_engines[idx];
 
 		/* Only render engine supports RPCS configuration. */
-		if (pe->engine->class != RENDER_CLASS)
+		if (!pe->engine || pe->engine->class != RENDER_CLASS)
 			return -EINVAL;
 
 		sseu = &pe->sseu;


