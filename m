Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A3143E081;
	Thu, 30 Jul 2026 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424371; cv=none; b=PPWsy0aHfHGFqjcW9awRjat9B6hb4io4++2QRjjg8lUnjEed7vOhowvj8R6+45xAtoSCh4r/giL4GK4wx7hVQVm/X/XYLYp3WrPnzLWKiLOyss5IsGIFuCTUH0Z/6YH44E2dGHRET+a1k6kh26NJ5qwk09Hb+78NGi5d1QtcUs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424371; c=relaxed/simple;
	bh=BD+AvF2KAyozhc0uMbk0Vtw8aLW5vJxwWluVjLeVik8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyLlJemTIN7zc6USkrCgBFVfsxJ063R9KKOe1GZXF6lHxiy3oeObP7Oa/QVhFlsONUX0Mow0yA7E4qmjkzsxp7Uyz+RCHeUcdOolL9YGTIemO2T+fCg4JRW6xDMzjICGsvFMIJ/riYeVzg7eb+jj+oT+JwGgV5KEWlGex/FyY7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3+5AXEA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3+5AXEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9379B1F000E9;
	Thu, 30 Jul 2026 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424370;
	bh=o9HXGSuEZzq3RMPCrZicSCFjb1o1QQrcdYzQ5/AJ1Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3+5AXEAF0+yELZgCU379erThJtjvbKzEe3f52EPWKdJQ/MXB2zu0F+sQRmt6rnMN
	 HbFhnPK/TejLkfgYjxRFW7MXC1MWo78ogPBhQGQKDbZRGsFpdnILjvmdfSTksNE0vz
	 86vlp+wnbh+y+9h2e4bXo6wsuvnlIufwEWAIdLyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 371/675] drm/i915/mst: limit DP MST ESI service loop
Date: Thu, 30 Jul 2026 16:11:41 +0200
Message-ID: <20260730141453.019090031@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 005771c18c5b2c98cb4e7517661aea460990fd3f upstream.

The loop in intel_dp_check_mst_status() keeps servicing interrupts
originating from the sink without bound. Add an upper bound to the new
interrupts occurring during interrupt processing to not get stuck on
potentially stuck sink devices. Use arbitrary 32 tries to clear incoming
interrupts in one go.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Note: The condition likely pre-dates the commit in the Fixes: tag, but
this is about as far back as a backport has any chance of
succeeding. Before that, the retry had a goto.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 3c0ec2c2d594 ("drm/i915: Flatten intel_dp_check_mst_status() a bit")
Cc: stable@vger.kernel.org # v5.8+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260625142204.1078287-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit b4ea5272133059acb493cc36599071a9e852ec2e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5203,8 +5203,9 @@ intel_dp_check_mst_status(struct intel_d
 	struct intel_encoder *encoder = &dig_port->base;
 	bool link_ok = true;
 	bool reprobe_needed = false;
+	int tries = 33;
 
-	for (;;) {
+	while (--tries) {
 		u8 esi[4] = {};
 		u8 ack[4] = {};
 
@@ -5247,6 +5248,11 @@ intel_dp_check_mst_status(struct intel_d
 	if (!link_ok || intel_dp->link.force_retrain)
 		intel_encoder_link_check_queue_work(encoder, 0);
 
+	if (!tries) {
+		drm_dbg_kms(display->drm, "DPRX ESI not clearing, device may be stuck\n");
+		reprobe_needed = true;
+	}
+
 	return !reprobe_needed;
 }
 


