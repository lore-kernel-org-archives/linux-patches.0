Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD281DEFEE;
	Wed, 19 Feb 2025 09:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956789; cv=none; b=GtDYKBk4/ZJ3SfGSRVh8USZ9Y09HdOxeJGIKRzIbxD3OWW/SI0BvzdTacmnKYqhkzydhC1Sq9TEHHYouiFWrJMN4AjfHMCLw2Xr+XzJXd6r01MVRmUYSR2P9D5uNJtJ3nFadG+l5cDYQOgFqWeQA2vFiD0Qh/qZDeMgaWegaUbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956789; c=relaxed/simple;
	bh=tmPNOPuFwGR5Q5DVl72xS8oLu+qojdYSjJyVpxumEuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZWxeDvN8UxTu8MaWsWzwjG9AtO6Ly+P8gtXmbT30jCCVc4Pr43saHKiZPknZ7kUbQAILDnMO2ssvfQEbMDMJOH72K0FNT94Zjr6jcfyMaDW5n/rpgYe49yZK0s55c9G+SIhvaMnQs8Vfuk41pal3mO9QSHYXTZ5aUSk5sP8DPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z71dkdoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z71dkdoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8699CC4CEE6;
	Wed, 19 Feb 2025 09:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956788;
	bh=tmPNOPuFwGR5Q5DVl72xS8oLu+qojdYSjJyVpxumEuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z71dkdoEX5tL8OxlUD4DV+BnsrseQ6cw/ONdxeAOJVI/ubJIvEmVwR/F92FAWzRzi
	 yYQTgGQmBBq/i0yDeql34Gg8BlATvA6CqnLf4SgT3g0VJZarlX41YCfmrwhlcCJIrD
	 QgIS6nmVlqzTdfSMNg03I/w5CL+37kb3c9yXNG2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 300/578] tipc: re-order conditions in tipc_crypto_key_rcv()
Date: Wed, 19 Feb 2025 09:25:04 +0100
Message-ID: <20250219082704.820314959@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5fe71fda89745fc3cd95f70d06e9162b595c3702 ]

On a 32bit system the "keylen + sizeof(struct tipc_aead_key)" math could
have an integer wrapping issue.  It doesn't matter because the "keylen"
is checked on the next line, but just to make life easier for static
analysis tools, let's re-order these conditions and avoid the integer
overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 65f59739a041a..25c18f8783ce9 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2293,8 +2293,8 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
 
 	/* Verify the supplied size values */
-	if (unlikely(size != keylen + sizeof(struct tipc_aead_key) ||
-		     keylen > TIPC_AEAD_KEY_SIZE_MAX)) {
+	if (unlikely(keylen > TIPC_AEAD_KEY_SIZE_MAX ||
+		     size != keylen + sizeof(struct tipc_aead_key))) {
 		pr_debug("%s: invalid MSG_CRYPTO key size\n", rx->name);
 		goto exit;
 	}
-- 
2.39.5



