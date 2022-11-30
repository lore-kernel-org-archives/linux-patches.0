Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4574079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECE0C433C1;
	Wed, 30 Nov 2022 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834555;
	bh=9DsdmpoIkCxuUwjz+xAM8ITITmonZJUuh86GCvRCLOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7RTOIGxF+jrU4T5zPol8v11raUv8gawjbNnDzt0EfJRqu3C9tvDFJdOC6jycGaCC
	 iHwAadY9VDz3LkHiSvMuDyXeWwvdXV58rU+79w88DqhmjywwHkAugwXWasWsxo980A
	 mDPqz0toLAsHABnCp+js0fmh+Lag0zvT30vutc8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.0 289/289] drm/i915: fix TLB invalidation for Gen12 video and compute engines
Date: Wed, 30 Nov 2022 19:24:34 +0100
Message-Id: <20221130180550.653919544@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrzej Hajda <andrzej.hajda@intel.com>

commit 04aa64375f48a5d430b5550d9271f8428883e550 upstream.

In case of Gen12 video and compute engines, TLB_INV registers are masked -
to modify one bit, corresponding bit in upper half of the register must
be enabled, otherwise nothing happens.

CVE: CVE-2022-4139
Suggested-by: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -961,6 +961,11 @@ static void mmio_invalidate_full(struct
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
+		if (GRAPHICS_VER(i915) == 12 && (engine->class == VIDEO_DECODE_CLASS ||
+		    engine->class == VIDEO_ENHANCEMENT_CLASS ||
+		    engine->class == COMPUTE_CLASS))
+			rb.bit = _MASKED_BIT_ENABLE(rb.bit);
+
 		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 		awake |= engine->mask;
 	}


