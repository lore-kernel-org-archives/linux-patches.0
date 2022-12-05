Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEA115C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F430C433C1;
	Mon,  5 Dec 2022 19:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269414;
	bh=2zb17M+tACjXU5ka8LUoOI0mkgF/fyr3rncP5z9Fw8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQzOvbJpOFPiupEXtqvvQt9frcywsWyaTZMnr8yVGsfpzWK2gZvwu1hZETomkTa+z
	 fyKucl0ezcQxUf+HUG61cqI9CI7y5yd4mPGnenDpJ/ss9aR6McLWR/Wpl4WWg0ywUe
	 kHfC91dahMGX0xAloKAf/PQDkbPEz6xQQF2kHOCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 081/153] drm/i915: fix TLB invalidation for Gen12 video and compute engines
Date: Mon,  5 Dec 2022 20:10:05 +0100
Message-Id: <20221205190811.048084667@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
@@ -348,6 +348,10 @@ void intel_gt_invalidate_tlbs(struct int
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
+		if (INTEL_GEN(i915) == 12 && (engine->class == VIDEO_DECODE_CLASS ||
+		    engine->class == VIDEO_ENHANCEMENT_CLASS))
+			rb.bit = _MASKED_BIT_ENABLE(rb.bit);
+
 		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 	}
 


