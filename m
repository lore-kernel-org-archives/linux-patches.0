Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036E92C11CF;
	Wed, 25 Feb 2026 06:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002586; cv=none; b=ZwcXo0mRYOxRqd097fB46jVhEuEVxWTfOidUfIm7siPa6hlY21+CE8KfawTOiKpWHM7FWaAsQxmywzho0nVFUjkBRrL58ekq1yLEhNgBXMIpLOCqTdYIkCSPov4uS/T1GivmFVJNkAtnRQCag0kwF12d5LEVEA33mTX1c0dHFsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002586; c=relaxed/simple;
	bh=DAW3SZpW+fxoMm+bdYz/508j9eZ8hKJ+RAI5Ag8AOGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxaLyVXwz6PhMb94jd06oaHSScdPSastyPCeVARUVi1wVg1Aox4OE8EgqDzA/bfuNJKGDUJR/pg4NAkWmfkEJf2khaXo1I6IxsxLG1cSs/tX+FCCjzBidBc0bHwYMX5AeXdv91sgbsc+hP7x2V4WUdNkxt9itpcJeIJfuJ/ilPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPGm5l/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPGm5l/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4FDC116D0;
	Wed, 25 Feb 2026 06:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002585;
	bh=DAW3SZpW+fxoMm+bdYz/508j9eZ8hKJ+RAI5Ag8AOGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPGm5l/5rRmpkf1aJoY41tEj3UBvOboEcJTNSb0jq+Re5UA67LyrgjVEDrjxWd9q9
	 uAYEmTsnmD6SntPR8SLHbe+ZFoti2uEIxRZc/Z38uUgwb6wwbUtCaFkvhjO0u6/EYp
	 dAi9DUJYGda2Lm3vGG09j5U1V6PwX6Kp9/YfD5xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 322/641] dpll: zl3073x: Fix output pin phase adjustment sign
Date: Tue, 24 Feb 2026 17:20:48 -0800
Message-ID: <20260225012356.507956631@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 38551cf788494..11ca32e1bb829 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -1222,10 +1222,8 @@ zl3073x_dpll_output_pin_phase_adjust_get(const struct dpll_pin *dpll_pin,
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
@@ -1247,10 +1245,8 @@ zl3073x_dpll_output_pin_phase_adjust_set(const struct dpll_pin *dpll_pin,
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



