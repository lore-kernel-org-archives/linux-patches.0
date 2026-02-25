Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD67218DB2A;
	Wed, 25 Feb 2026 01:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983288; cv=none; b=FuKfATA6h21HKBPFX0JYN00DWL82wlgB+CN4+z+XDxe1V3v38V/X2tcihveL6vCBes2KiSyPAtd/tpVBV2Cr445wm5oTP6h71wgJXYLpyd+xNdyVAN2nBnyQkrsJ5+/TdA5NG8RAKPr4SB4uR4grwOnNpWniZmh61oLHQmXkaa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983288; c=relaxed/simple;
	bh=isiufB0vqG3Wl2XX2GcFO19M+CzFSggoUoAiQVtt0Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0c9VAF9n0am+bnzHFO7R/0pwFP0Xa57DhoL8/cNMYN0MrKZj4YSDbe64QEuPE0k04E8D0QpWOc4g5NGcrEax8Ng/hAvg/uJf/XW+b+N+Idr920Vm8Rta6tbcEKEHBP/w3AWUZK/qTVjga+wKxyLOYLk2QfsnVde8rz7AE420X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nONYuKbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nONYuKbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774A7C116D0;
	Wed, 25 Feb 2026 01:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983288;
	bh=isiufB0vqG3Wl2XX2GcFO19M+CzFSggoUoAiQVtt0Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nONYuKbH3UplP2fklTI7Tgpf+h22eOtiMoskHzFWyk/BwA+iYk0rYYwsUFi6094eb
	 KTTTIRFsnMakwOUe2nLQgWnkbRgtJOZnG7GgELc6EPmP+nl8jdNrc4JBv97ICPHYA2
	 GhgnhoOXNz+weFrQCSKA62mzUz3Ys9je44XI7Rrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 424/781] dpll: zl3073x: Fix output pin phase adjustment sign
Date: Tue, 24 Feb 2026 17:18:53 -0800
Message-ID: <20260225012410.102134708@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 5d41f95f5d0bd9db02f3f16a649d0631f71e9fdb ]

The output pin phase adjustment functions incorrectly negate the phase
compensation value.

Per the ZL3073x datasheet, the output phase compensation register is
simply a signed two's complement integer where:
 - Positive values move the phase later in time
 - Negative values move the phase earlier in time

No negation is required. The erroneous negation caused phase adjustments
to be applied in the wrong direction.

Note that input pin phase adjustment correctly uses negation because the
hardware has an inverted convention for input references (positive moves
phase earlier, negative moves phase later).

Fixes: 6287262f761e ("dpll: zl3073x: Add support to adjust phase")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260205181055.129768-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/dpll.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index 9879d85d29af0..a8001c9760382 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -1039,10 +1039,8 @@ zl3073x_dpll_output_pin_phase_adjust_get(const struct dpll_pin *dpll_pin,
 	out_id = zl3073x_output_pin_out_get(pin->id);
 	out = zl3073x_out_state_get(zldev, out_id);
 
-	/* Convert value to ps and reverse two's complement negation applied
-	 * during 'set'
-	 */
-	*phase_adjust = -out->phase_comp * pin->phase_gran;
+	/* The value in the register is expressed in half synth clock cycles. */
+	*phase_adjust = out->phase_comp * pin->phase_gran;
 
 	return 0;
 }
@@ -1064,10 +1062,8 @@ zl3073x_dpll_output_pin_phase_adjust_set(const struct dpll_pin *dpll_pin,
 	out_id = zl3073x_output_pin_out_get(pin->id);
 	out = *zl3073x_out_state_get(zldev, out_id);
 
-	/* The value in the register is stored as two's complement negation
-	 * of requested value and expressed in half synth clock cycles.
-	 */
-	out.phase_comp = -phase_adjust / pin->phase_gran;
+	/* The value in the register is expressed in half synth clock cycles. */
+	out.phase_comp = phase_adjust / pin->phase_gran;
 
 	/* Update output configuration from mailbox */
 	return zl3073x_out_state_set(zldev, out_id, &out);
-- 
2.51.0



