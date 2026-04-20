Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A6F421EED;
	Mon, 20 Apr 2026 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691662; cv=none; b=TFhrYuVKzZpYhzDF1DDCbEUa1sOFTdnFtgrwJ59PY7fD87Bi2Y2FeGu5zQKVNvXNGV7FnlPytx79pqcgPAPeQjWZEG3Dxuliy1GR3Ue8UKqq6QNC66TEslFepFKViSNFSeSURRlf2D5O5X7NACrR/yLGkm1b89ISzOQUYtEyWuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691662; c=relaxed/simple;
	bh=Tf4Ei6MdkhNcPZjezKs5U+/LpVEqkPdlydKjGE/88LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjThsq0TB5PGwainzHcR3h8esDFq4GQ4xIp9ULUeEF51dF8G3DrEat2LcSbUpE55xAxzqrXSvCc52Ub01/tcm2uJPl+lV530O4D87MKGvg3cB3Pyn09UVWxqDaXdsvCZ2SHBryki4UHradg391Z7Jc6K4uQ1WM9Q9R8YNb+Cvbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VEwyEMiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VEwyEMiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15349C2BCB4;
	Mon, 20 Apr 2026 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691662;
	bh=Tf4Ei6MdkhNcPZjezKs5U+/LpVEqkPdlydKjGE/88LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEwyEMiQyz+PynvkHxOPa8+Qpx3UengJAoG4PSrD99ih1u3okn457mciSxXRa1rK2
	 5K7bo7MCKcQVA7Jwd/ORphYQ30HhUEKKb+KC/zJ7jY8C27gkawNS1YZkAlYKpundEM
	 sD1i9zNmFoWOBQq9hyLNq6PdwPgpM3aZQDBdvCp77yWGr/+QknoZvTE2ZvANZBNU/f
	 ke6j0fhcjXbSN5tPPd/QW+PILT5qSPPA11pSVnBle43ySciESBCoD93iTYGuHCCzHT
	 swSn/nKOh226XEthcQhFP3gFM8nzKf07ylIKT+M0N6H6F0A1mwFSvkioruwLtJ4ibT
	 RJsWzjRHq5yMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Koskovich <akoskovich@pm.me>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: ipa: fix event ring index not programmed for IPA v5.0+
Date: Mon, 20 Apr 2026 09:19:13 -0400
Message-ID: <20260420132314.1023554-159-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 56007972c0b1e783ca714d6f1f4d6e66e531d21f ]

For IPA v5.0+, the event ring index field moved from CH_C_CNTXT_0 to
CH_C_CNTXT_1. The v5.0 register definition intended to define this
field in the CH_C_CNTXT_1 fmask array but used the old identifier of
ERINDEX instead of CH_ERINDEX.

Without a valid event ring, GSI channels could never signal transfer
completions. This caused gsi_channel_trans_quiesce() to block
forever in wait_for_completion().

At least for IPA v5.2 this resolves an issue seen where runtime
suspend, system suspend, and remoteproc stop all hanged forever. It
also meant the IPA data path was completely non functional.

Fixes: faf0678ec8a0 ("net: ipa: add IPA v5.0 GSI register definitions")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260403-milos-ipa-v1-2-01e9e4e03d3e@fairphone.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/ipa/reg/gsi_reg-v5.0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/reg/gsi_reg-v5.0.c b/drivers/net/ipa/reg/gsi_reg-v5.0.c
index 3334d8e20ad28..6c4a7fbe4de94 100644
--- a/drivers/net/ipa/reg/gsi_reg-v5.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v5.0.c
@@ -30,7 +30,7 @@ REG_STRIDE_FIELDS(CH_C_CNTXT_0, ch_c_cntxt_0,
 
 static const u32 reg_ch_c_cntxt_1_fmask[] = {
 	[CH_R_LENGTH]					= GENMASK(23, 0),
-	[ERINDEX]					= GENMASK(31, 24),
+	[CH_ERINDEX]					= GENMASK(31, 24),
 };
 
 REG_STRIDE_FIELDS(CH_C_CNTXT_1, ch_c_cntxt_1,
-- 
2.53.0

