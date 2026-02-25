Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA8624A05D;
	Wed, 25 Feb 2026 01:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983601; cv=none; b=fnd4aBE6Ct2Z3dClXEFE85HO5n/Uy3/GvhMe6cd+Lpq8pGwu3bBe52lFJEge3vhIyS1rwn6c446KUxIghZ93savOhaQATuL4YIB0bOg9ylPnUyk5aqQ1LAbLlp7pHvkJl1uSQ190RxtSZWNjSlmrz7CfvDcpfmUK34OHwEFcvqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983601; c=relaxed/simple;
	bh=sJfBNjtc7gdsFLuaj5QUfgwUsVZL5EM4nAT6SGmT0Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoJoNrQmJ5m2Frg6gjcbw/wSX9yvxBUPabn1iXdcDGI9S1dx7174Pbc+ryLExEfrGCx9vbcXJcLNBS9eaGA2EaWQb26JoleQuF47/QYTDZo1vQml0bzLOGzMbS6vP2o8OuxBL9vJFRjMzFee6UoHuwHaR7M3zPeGNsIcYGW1Vr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZQbO95R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZQbO95R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDF9C116D0;
	Wed, 25 Feb 2026 01:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983601;
	bh=sJfBNjtc7gdsFLuaj5QUfgwUsVZL5EM4nAT6SGmT0Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZQbO95RRha5SKA83MM2KhGKHtmV1UgRW/OQMtWDzFOC/mv3rIA3NvdrjeyCNOqcK
	 7qvWNmgft90yUJ0M9fcABtbfZt8Idk4e6yXiUrgdobkMAUsyOnXGj5moc4XewT4UG2
	 UZr9IHdgQJR99jtSd1p8jOrsROdtxJDDMt61hESA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 673/781] dpll: zl3073x: Fix ref frequency setting
Date: Tue, 24 Feb 2026 17:23:02 -0800
Message-ID: <20260225012416.289198345@linuxfoundation.org>
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

[ Upstream commit a047497f952831e377564b606dcb74a7cb309384 ]

The frequency for an input reference is computed as:

  frequency = freq_base * freq_mult * freq_ratio_m / freq_ratio_n

Before commit 5bc02b190a3fb ("dpll: zl3073x: Cache all reference
properties in zl3073x_ref"), zl3073x_dpll_input_pin_frequency_set()
explicitly wrote 1 to both the REF_RATIO_M and REF_RATIO_N hardware
registers whenever a new frequency was set. This ensured the FEC ratio
was always reset to 1:1 alongside the new base/multiplier values.

The refactoring in that commit introduced zl3073x_ref_freq_set() to
update the cached ref state, but this helper only sets freq_base and
freq_mult without resetting freq_ratio_m and freq_ratio_n to 1. Because
zl3073x_ref_state_set() uses a compare-and-write strategy, unchanged
ratio fields are never written to the hardware. If the device previously
had non-unity FEC ratio values, they remain in effect after a frequency
change, resulting in an incorrect computed frequency.

Explicitly set freq_ratio_m and freq_ratio_n to 1 in zl3073x_ref_freq_set()
to restore the original behavior.

Fixes: 5bc02b190a3fb ("dpll: zl3073x: Cache all reference properties in zl3073x_ref")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260216194007.680416-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/ref.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dpll/zl3073x/ref.h b/drivers/dpll/zl3073x/ref.h
index efc7f59cd9f9c..0d8618f5ce8df 100644
--- a/drivers/dpll/zl3073x/ref.h
+++ b/drivers/dpll/zl3073x/ref.h
@@ -91,6 +91,8 @@ zl3073x_ref_freq_set(struct zl3073x_ref *ref, u32 freq)
 
 	ref->freq_base = base;
 	ref->freq_mult = mult;
+	ref->freq_ratio_m = 1;
+	ref->freq_ratio_n = 1;
 
 	return 0;
 }
-- 
2.51.0



