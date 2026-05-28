Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3897722652D;
	Thu, 28 May 2026 20:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999768; cv=none; b=gOiJzMhBimUoIyO4/hEHy9x8sxhLejL5FAvv60Vq7oYFzbFWfXOolPVe0FSA3Qq77kgl13UpvBnM4GJGoPuv8LoMVG9IWj/sb9lzLgHLDmLR7lAww1ox600VfoU9u5MjMm24FWiroAwV1wnfE2dLxQmpqxPzGK4jfe/8BSxBZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999768; c=relaxed/simple;
	bh=8+fYDK7acgK7zExyPRwOisiUhbpEZa5+iVOhIUShRng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrkoZB6He6++ud38GzeEyvkDsMhZ9EIlU22qfdlDi4dyr5dOh8kCVock5WuIRuex0Jsq57NHLZyAbGuWqy0wMXZmEyQfaqE4a/HnNsyHPRByInhFsEpL+SeF11lSK1btHGafG+58uEhPpEYc5kuTKgOEF5v2+wj0aPcM8R6YqQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cew2oAOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cew2oAOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FAB1F000E9;
	Thu, 28 May 2026 20:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999767;
	bh=5bl52h8QW+DSG53G64vO2rXF99zKRKH9NGB57Pha188=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cew2oAOMyHnGxK2aNx+OfVwSGXaI2rroOyYRzufF648zSv2Lso/pKZk4DW+28gy8h
	 U74ZBVdFaO0NW/t/+49fWzB1d1Zw7AK8cInEmcSA9TDbwmUze/DmxXTR4bKHQrITXf
	 tuGddPZ3V0zm9dlWmOg3rGuMzY8vVvJCGq8nortM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Neuling <mikey@neuling.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/377] riscv: errata: Fix bitwise vs logical AND in MIPS errata patching
Date: Thu, 28 May 2026 21:47:01 +0200
Message-ID: <20260528194643.723700576@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Michael Neuling <mikey@neuling.org>

[ Upstream commit 4d2b03699460b8fd5df34408a03a84a1a7ff8aa1 ]

The condition checking whether a specific errata needs patching uses
logical AND (&&) instead of bitwise AND (&). Since logical AND only
checks that both operands are non-zero, this causes all errata patches
to be applied whenever any single errata is detected, rather than only
applying the matching one.

The SiFive errata implementation correctly uses bitwise AND for the same
check.

Fixes: 0b0ca959d206 ("riscv: errata: Fix the PAUSE Opcode for MIPS P8700")
Signed-off-by: Michael Neuling <mikey@neuling.org>
Assisted-by: Cursor:claude-4.6-opus-high-thinking
Link: https://patch.msgid.link/20260409091143.1348853-2-mikey@neuling.org
[pjw@kernel.org: fixed checkpatch warning]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/errata/mips/errata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/errata/mips/errata.c b/arch/riscv/errata/mips/errata.c
index e984a8152208c..2c3dc2259e93e 100644
--- a/arch/riscv/errata/mips/errata.c
+++ b/arch/riscv/errata/mips/errata.c
@@ -57,7 +57,7 @@ void mips_errata_patch_func(struct alt_entry *begin, struct alt_entry *end,
 		}
 
 		tmp = (1U << alt->patch_id);
-		if (cpu_req_errata && tmp) {
+		if (cpu_req_errata & tmp) {
 			mutex_lock(&text_mutex);
 			patch_text_nosync(ALT_OLD_PTR(alt), ALT_ALT_PTR(alt),
 					  alt->alt_len);
-- 
2.53.0



