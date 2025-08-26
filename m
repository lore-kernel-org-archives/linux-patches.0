Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3B2239573;
	Tue, 26 Aug 2025 11:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207632; cv=none; b=lbjDEsOWHYEwQXxSXfv8IVAVM9p6cHYOeDoDaLVee+J6IdYBrtKIPO+vhnEnnMoDq0oK8tU2CkhOmKY6E14Nfvj+ePGs30plUpvbClohnGR3lG+w6D0xfqycCYXIf7pX/5fWL+Dtk1Mwil40Tr2zkRGzeNFPweRS8XruWo0r/Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207632; c=relaxed/simple;
	bh=fTUQ8rTpVCgDoqFSX+TZnux322Rubg0X5CtwayIzPCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ierij/GeBJPOQ6rCLK4S8icPUij5ZPxZRSkydEVFT1HPZnTdGvxxjr5BrVjruFjL2ftx46+zXLfccSy64Fl48++Cj5lRFJL6iw3/PeP1DEDylH+LRYNcHez5lmoFeV3dR4iLgoyUJVYKjwmLBY0XF1vH3y5cTdweDluEHxXydrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ov68a1Hy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ov68a1Hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A53FC4CEF1;
	Tue, 26 Aug 2025 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207631;
	bh=fTUQ8rTpVCgDoqFSX+TZnux322Rubg0X5CtwayIzPCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ov68a1HygYXg/T0EM0rC5bFtJNgWqASE2ah0/x4qp+ak2zFaAv/5UNnLC8rnhRCZf
	 4iS5zAyp+cqa+Sm+gr/mknjJMDTrLulW2bYso5HcAWLb6QP6to6j51zoIBLqnWYLN5
	 0dD5KS/fiMGmeNA2JlLXGqCjL/E2NXpYGwYyD61w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.16 258/457] drm/i915: silence rpm wakeref asserts on GEN11_GU_MISC_IIR access
Date: Tue, 26 Aug 2025 13:09:02 +0200
Message-ID: <20250826110943.731761159@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit ff646d033783068cc5b38924873cab4a536b17c1 upstream.

Commit 8d9908e8fe9c ("drm/i915/display: remove small micro-optimizations
in irq handling") not only removed the optimizations, it also enabled
wakeref asserts for the GEN11_GU_MISC_IIR access. Silence the asserts by
wrapping the access inside intel_display_rpm_assert_{block,unblock}().

Reported-by: "Jason A. Donenfeld" <Jason@zx2c4.com>
Closes: https://lore.kernel.org/r/aG0tWkfmxWtxl_xc@zx2c4.com
Fixes: 8d9908e8fe9c ("drm/i915/display: remove small micro-optimizations in irq handling")
Cc: stable@vger.kernel.org # v6.13+
Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://lore.kernel.org/r/20250805115656.832235-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit cbd3baeffbc08052ce7dc53f11bf5524b4411056)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_irq.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display_irq.c
+++ b/drivers/gpu/drm/i915/display/intel_display_irq.c
@@ -1492,10 +1492,14 @@ u32 gen11_gu_misc_irq_ack(struct intel_d
 	if (!(master_ctl & GEN11_GU_MISC_IRQ))
 		return 0;
 
+	intel_display_rpm_assert_block(display);
+
 	iir = intel_de_read(display, GEN11_GU_MISC_IIR);
 	if (likely(iir))
 		intel_de_write(display, GEN11_GU_MISC_IIR, iir);
 
+	intel_display_rpm_assert_unblock(display);
+
 	return iir;
 }
 


