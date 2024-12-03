Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A413A1F7060;
	Tue,  3 Dec 2024 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236513; cv=none; b=LruKKQP3sajKzTbr+36yin/LDT4HM/LiSD6a4EIn655R8zLT9bAMaL1LN9cEHN8PXcRX+5JPWhOmxxHKhwmW0YeIbpnvzV6blAWdSYyO+m6xmsCa+WAy4k3u8NdkpwEo75IcPGOjIb75eTwxrlAYC2zETky5mYMGvu1hQpKO5CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236513; c=relaxed/simple;
	bh=4e+atGT+razKs3WZZUPJBMpKSHnke8gLiE3jwDra9+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tY/wHK4RUgsyhjHOu7VFnA/g63kJH55QtbY2zoWgIbrp0FO5FeDXkPATtZ0SQN3Kvxy0tFFxq2YVQFYgZtWS/xKy5L0Fgb6KqDLO0fHiObVGL9RP9i+LBQSuyGPRBQagMgMYdUCTjeH4tvIOcjIU9/I9JlOLGPXCJjrLQTxBxsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1zepymF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1zepymF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23623C4CED6;
	Tue,  3 Dec 2024 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236513;
	bh=4e+atGT+razKs3WZZUPJBMpKSHnke8gLiE3jwDra9+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1zepymFj8jObzZ3Qyfb7mqGQm70anPqH1aSGk8J6BTmJcvf+Sk3JR4qJTS9SjRN4
	 M9kEJFw/5UGzSsTvQ/BguxJKOxhE1HwH6/fWzwx7/ZuZZgyK4h7Ocbic3DOorLGx4v
	 BUMDPmaRCHJheZvwm+hYhOEyEzPdDv0z7nqy9kP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Mika Kuoppala <mika.kuoppala@linux.intel.com>,
	Matthew Auld <matthew.william.auld@gmail.com>,
	Jason Ekstrand <jason.ekstrand@intel.com>,
	Kenneth Graunke <kenneth@whitecape.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/138] drm/i915/gtt: Enable full-ppgtt by default everywhere
Date: Tue,  3 Dec 2024 15:31:11 +0100
Message-ID: <20241203141925.168805464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 79556df293b2efbb3ccebb6db02120d62e348b44 ]

We should we have all the kinks worked out and full-ppgtt now works
reliably on gen7 (Ivybridge, Valleyview/Baytrail and Haswell). If we can
let userspace have full control over their own ppgtt, it makes softpinning
far more effective, in turn making GPU dispatch far more efficient by
virtue of better mm segregation.  On the other hand, switching over to a
different GTT for every client does incur noticeable overhead, but only
for very lightweight tasks.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Reviewed-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jason Ekstrand <jason.ekstrand@intel.com>
Cc: Kenneth Graunke <kenneth@whitecape.org>
Acked-by: Kenneth Graunke <kenneth@whitecape.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20180717095751.1034-1-chris@chris-wilson.co.uk
Stable-dep-of: ffcde9e44d3e ("drm: fsl-dcu: enable PIXCLK on LS1021A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_gem_gtt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index d4c6aa7fbac8d..0b5b45fe0fe78 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -180,13 +180,11 @@ int intel_sanitize_enable_ppgtt(struct drm_i915_private *dev_priv,
 		return 0;
 	}
 
-	if (HAS_LOGICAL_RING_CONTEXTS(dev_priv)) {
-		if (has_full_48bit_ppgtt)
-			return 3;
+	if (has_full_48bit_ppgtt)
+		return 3;
 
-		if (has_full_ppgtt)
-			return 2;
-	}
+	if (has_full_ppgtt)
+		return 2;
 
 	return 1;
 }
-- 
2.43.0



