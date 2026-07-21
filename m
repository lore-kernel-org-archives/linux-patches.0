Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FC0342173;
	Tue, 21 Jul 2026 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648533; cv=none; b=N/WiN48mbwL2fQ3TF3Ftwn1Qa19P57NUZ+VFohH7/hEbyNXOfJNtHGLPHwaOZF9Ryc0NJzgEX6TGo73yDqPZO43rynlODC94k13Er9QggMjCnvJtLpK4WCHInypOhS455bRJ64EgX2VT8m9/Dlou1ySYF6angBecQakbMOydfAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648533; c=relaxed/simple;
	bh=LvpnfKpRRF6wUwlycnLxcYMjRryrsNX1DMb//sBldU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saCusXwyaslC72EitNVvEUOUCZ7qssr+hQrzGqXQIS2clApmh9h3KMFMDo+1WmSMxUiEUMC3b1PrnQV1ptsLzLUeXp0SHebSDuE6glCbAOgCBSzBoytQWmSn9AJmexnLwHyBPOuyZGk4mKbrcZHIhRTfCtwkFItLpAtGW0Is/qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jc2UfmYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jc2UfmYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1321F000E9;
	Tue, 21 Jul 2026 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648531;
	bh=YQLXtDLSjC/CUC4Wa3noNBDevJiCYvhP4BUhhkAQadU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jc2UfmYhT2OknGCzl+nFf39tkHCYSNGB1w+WwwCNF8+Ecrqjnk/H7YthWh6uRjjgU
	 QoZCACCOlxZMGQUMEl94OL8g0KhBaxm/sWncLaSH9sMdSuaXEKR5Y0VpjQWR8tI2UL
	 LujW4Lh4Cte9KHEA/GtIp+A2/QFFPBgqhORcvVcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0236/2077] selftests/mm: Fix resv_sz when parsing arm64 signal frame
Date: Tue, 21 Jul 2026 16:58:29 +0200
Message-ID: <20260721152558.241522617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Brodsky <kevin.brodsky@arm.com>

[ Upstream commit c364aa56d6738c8759e88941d7a45a1d6b4c52d0 ]

get_header() wants the size of the reserved area in struct
sigcontext, but instead we pass it the size of the entire struct.
This could in theory result in an out-of-bounds read (if the signal
frame is malformed).

Fix this using one of the existing macros from
tools/testing/selftests/arm64/signal/testcases/testcases.h.

This issue was reported by Sashiko on a patch that copied this
portion of the code.

Link: https://sashiko.dev/#/patchset/20260421144252.1440365-1-kevin.brodsky%40arm.com
Fixes: f5b5ea51f78f ("selftests: mm: make protection_keys test work on arm64")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/pkey-arm64.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/pkey-arm64.h b/tools/testing/selftests/mm/pkey-arm64.h
index 8e9685e03c441a..c5a78a2f211d52 100644
--- a/tools/testing/selftests/mm/pkey-arm64.h
+++ b/tools/testing/selftests/mm/pkey-arm64.h
@@ -130,9 +130,10 @@ static inline u64 get_pkey_bits(u64 reg, int pkey)
 static inline void aarch64_write_signal_pkey(ucontext_t *uctxt, u64 pkey)
 {
 	struct _aarch64_ctx *ctx = GET_UC_RESV_HEAD(uctxt);
+	size_t resv_size = GET_UCP_RESV_SIZE(uctxt);
 	struct poe_context *poe_ctx =
 		(struct poe_context *) get_header(ctx, POE_MAGIC,
-						sizeof(uctxt->uc_mcontext), NULL);
+						  resv_size, NULL);
 	if (poe_ctx)
 		poe_ctx->por_el0 = pkey;
 }
-- 
2.53.0



