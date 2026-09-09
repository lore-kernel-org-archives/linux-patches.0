Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18502548549;
	Wed,  9 Sep 2026 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962701; cv=none; b=knTl/C4UNlb8xbdmeeZ4VULVAcLxGHAteLyhllUWxM7rBG2vLtb1u9zKUO70/tiYqz0vV1gTvdss0ZEfsPNVJZHAl7Oy2FAbr6DJI6Sah6tftDXm6JeBPrmD5TYm6HQlQVNzlYOWVdaOHn8NKYnhWUwnAt2VxuCEUn3c2bM7y98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962701; c=relaxed/simple;
	bh=DVYGZOtkqrxxVhzPqlZF6KOcC7gYH5Y4+SYrSmDDT3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOIRjgq2c8uIkwV9ScIwEzwH3n/xTFHaI7nHBfw40Xe4kViXJqGTNWTSjc6ETBqKcyQbt2CuAb86SMoPlGq4NzY4uEhBo7H2YVarm4wVrPDgu3dUFWSCJ9uDx98mDP2NonWLLqtexfAT0gx0dWkFa6yTYGBDOzm04LgPLaCw0ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1sE7LTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1sE7LTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727EE1F00A3A;
	Wed,  9 Sep 2026 14:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962700;
	bh=Wc57G2OUTASZddnzezNtUxsBUaK1dJqlmVL0TOlti0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1sE7LTMZnr67a6k+Ruf9itxZzREnH816F1+O7sgxIunSqXFt7eyoDCDRLInCRhrV
	 muSA0IHbED4yfYI+7w7k6SgEmTLk4qtqcLclTUQBclGHeMTR8Zc5hq/+GlLw5M8UCn
	 JQZxFE0YWMqRr734jPJhinoIHXDxFLqIdETsE4Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 380/556] media: mali-c55: fix dropped last AEC histogram zone weight
Date: Wed,  9 Sep 2026 15:41:00 +0200
Message-ID: <20260909134244.046516531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit fb9b87145624eedaf3d50edac9b11d707494cb5b upstream.

The 15x15 AEC histogram metering grid has 225 per-zone weights, packed
by userspace as a u8 array. The driver writes the first 56 registers
(zones 0 through 223) in a loop, then handles the final register on its
own to keep static analysers from flagging the array access.

That separate path computes the address and value for the 225th weight
(the bottom-right zone) but never issues the register write, so the zone
keeps its stale or default weight. Any non-default weight userspace sets
for the last zone is silently ignored, skewing auto-exposure metering.
Both the AEXP_HIST_WEIGHTS and AEXP_IHIST_WEIGHTS blocks are affected as
they share this handler.

Issue the missing write, masking the value as the loop does.

Fixes: 01535ea08674 ("media: platform: Add mali-c55 parameters video node")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-params.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-params.c b/drivers/media/platform/arm/mali-c55/mali-c55-params.c
index de0e9d898db7..33e2232ec8f5 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-params.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-params.c
@@ -212,6 +212,7 @@ mali_c55_params_aexp_hist_weights(struct mali_c55 *mali_c55,
 
 	val = params->zone_weights[MALI_C55_MAX_ZONES - 1];
 	addr = base + MALI_C55_AEXP_HIST_ZONE_WEIGHTS_OFFSET + (4 * 56);
+	mali_c55_ctx_write(mali_c55, addr, val & MALI_C55_AEXP_HIST_ZONE_WEIGHT_MASK);
 }
 
 static void mali_c55_params_digital_gain(struct mali_c55 *mali_c55,
-- 
2.55.0



