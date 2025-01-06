Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D4A158525;
	Mon,  6 Jan 2025 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177900; cv=none; b=j3vQ36E1MeEbdIigYY/EOmJFNcIMK+bIrmF3bPdtH5yiIglGix5Gm1q0Nt4kAd/iNPCGC0iMVA63Y3ZIk/g53a2V4UBYF9KRgowjE+7PrAmR1Dp0oDtsewgDzrkqWJxm+x54mWon/fEA579TMo1EqHbchVKnNPwylOZgfXxI2is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177900; c=relaxed/simple;
	bh=HrY0rkXhVgWiGVDQg2USHIWPLuuk5sQqRjSWpgEUt6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh7hnxe7POMxGTH4VE+OUnsDeIxT3uXhs5SVCiKhb2W3/6IBRzJ/i/hqRJExaDL/qfZdtPAMKgrUxncZBjlQO6ptQccKRNIg7kMZOMcWo6/VNerlno2gl0Zpi9VHiDM1qzbQdQIKNwdjJcOFTEMPCPu1ks/brn0duZHlJVC5LIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8xtsDvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8xtsDvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE45C4CED2;
	Mon,  6 Jan 2025 15:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177900;
	bh=HrY0rkXhVgWiGVDQg2USHIWPLuuk5sQqRjSWpgEUt6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8xtsDvK3hdCWFlSaWTIGY7BC9yR9saLKKATV8ElGyNPmHpbBBD7nmV9PT4HNiQJk
	 /kmh2bzE6GvJ7QHhpOSN1VMerUeaEJj/kBY23SI+a8iI5/eFPweVNN4nnS4r16zpuu
	 GQ5V6cqLMMaywtHmTXFHErXyjSX44HM7NHwifcpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Shahab Vahedi <list+bpf@vahedi.org>,
	Hardevsinh Palaniya <hardevsinh.palaniya@siliconsignals.io>,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/156] ARC: bpf: Correct conditional check in check_jmp_32
Date: Mon,  6 Jan 2025 16:16:21 +0100
Message-ID: <20250106151145.302314405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hardevsinh Palaniya <hardevsinh.palaniya@siliconsignals.io>

[ Upstream commit 7dd9eb6ba88964b091b89855ce7d2a12405013af ]

The original code checks 'if (ARC_CC_AL)', which is always true since
ARC_CC_AL is a constant. This makes the check redundant and likely
obscures the intention of verifying whether the jump is conditional.

Updates the code to check cond == ARC_CC_AL instead, reflecting the intent
to differentiate conditional from unconditional jumps.

Suggested-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Acked-by: Shahab Vahedi <list+bpf@vahedi.org>
Signed-off-by: Hardevsinh Palaniya <hardevsinh.palaniya@siliconsignals.io>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/net/bpf_jit_arcv2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/net/bpf_jit_arcv2.c b/arch/arc/net/bpf_jit_arcv2.c
index 4458e409ca0a..6d989b6d88c6 100644
--- a/arch/arc/net/bpf_jit_arcv2.c
+++ b/arch/arc/net/bpf_jit_arcv2.c
@@ -2916,7 +2916,7 @@ bool check_jmp_32(u32 curr_off, u32 targ_off, u8 cond)
 	addendum = (cond == ARC_CC_AL) ? 0 : INSN_len_normal;
 	disp = get_displacement(curr_off + addendum, targ_off);
 
-	if (ARC_CC_AL)
+	if (cond == ARC_CC_AL)
 		return is_valid_far_disp(disp);
 	else
 		return is_valid_near_disp(disp);
-- 
2.39.5



