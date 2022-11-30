Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F47D79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC134C433D6;
	Wed, 30 Nov 2022 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833745;
	bh=g0TavgUPjrv9YffA1TuZS6EoWZUwl01Up0MsoOK//aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHT51plYyZcj+9M0QdgoNv9uWzl2NY6Pa3ILt1oj3aBO+VX63E5LtR+0RHViljJVe
	 zcT3gw4ouqH7Bg+b73tmASOuv/qh5KEnv2AR60QjuTaBzdu2kT98xRSrn2e3tx61yH
	 aHlNtaSIeHzagQDQp7Q3uZDAfAacZ0IbSJRVALRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 206/206] drm/i915: fix TLB invalidation for Gen12 video and compute engines
Date: Wed, 30 Nov 2022 19:24:18 +0100
Message-Id: <20221130180538.266586586@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
 drivers/gpu/drm/i915/gt/intel_gt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -982,6 +982,10 @@ void intel_gt_invalidate_tlbs(struct int
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
+		if (GRAPHICS_VER(i915) == 12 && (engine->class == VIDEO_DECODE_CLASS ||
+		    engine->class == VIDEO_ENHANCEMENT_CLASS))
+			rb.bit = _MASKED_BIT_ENABLE(rb.bit);
+
 		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 	}
 


