Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CF8DDAB;
	Wed,  3 Dec 2025 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776440; cv=none; b=TTol4h2y5Olif/e94aPNMwzP6us3afxVgKTiAqLEIO8c17eQLLcjYssnTXPopLnHAUHNWaUnLvObmNopyC/fkGU8Mn3AYC4PPC31C4QWWnR8cdTlMyUU4EOWEpvCg/CdCyTY6C9Df7S+6YrxkTFBFh9/eJJ9BR9rDtk1ruIQj0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776440; c=relaxed/simple;
	bh=nNUXhW8Xxmxq3vr6XSRz1t0RR2gx7/8lAurR8Ziiqdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a+6IrWpC7DrfcgjV74jm+Bx+mxnLMjE0J9CGBVDXAYIgZWRaIZiSYwmSWDLlhOfszPBB1IQhJR3uCc517bSuxc0GygxIoD2UWUU66CXk8omH+nxC7lHzYOYoUEL8EkUahUcd/OISNfjJqaagP4kwRkZBNUwjRg0+iJAOZda7lcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3npjp2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3npjp2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A944C4CEF5;
	Wed,  3 Dec 2025 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776440;
	bh=nNUXhW8Xxmxq3vr6XSRz1t0RR2gx7/8lAurR8Ziiqdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3npjp2zEstbF2I2OGFrO8NAbQOFsVjYKUWlzdZv6HsTHr2NNOXim4EemuK3buC84
	 1cLJfLm8JE2cmk/J4BadVa06A5/NhwCYTh4RMNvVkRxiYahnQd6YbJsJpjZECqvXgZ
	 vgJ4E2INLAx7wUFj8wxy2m8wJjXBQ5/B8A4Uru3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/300] net/smc: fix mismatch between CLC header and proposal
Date: Wed,  3 Dec 2025 16:26:28 +0100
Message-ID: <20251203152407.445079793@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit ec33f2e5a2d0dbbfd71435209aee812fdc9369b8 ]

The current CLC proposal message construction uses a mix of
`ini->smc_type_v1/v2` and `pclc_base->hdr.typev1/v2` to decide whether
to include optional extensions (IPv6 prefix extension for v1, and v2
extension). This leads to a critical inconsistency: when
`smc_clc_prfx_set()` fails - for example, in IPv6-only environments with
only link-local addresses, or when the local IP address and the outgoing
interface’s network address are not in the same subnet.

As a result, the proposal message is assembled using the stale
`ini->smc_type_v1` value—causing the IPv6 prefix extension to be
included even though the header indicates v1 is not supported.
The peer then receives a malformed CLC proposal where the header type
does not match the payload, and immediately resets the connection.

The fix ensures consistency between the CLC header flags and the actual
payload by synchronizing `ini->smc_type_v1` with `pclc_base->hdr.typev1`
when prefix setup fails.

Fixes: 8c3dca341aea ("net/smc: build and send V2 CLC proposal")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20251107024029.88753-1-alibuda@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 2aa69e29fa1d5..dca448c98c9de 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -529,6 +529,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 				return SMC_CLC_DECL_CNFERR;
 			}
 			pclc_base->hdr.typev1 = SMC_TYPE_N;
+			ini->smc_type_v1 = SMC_TYPE_N;
 		} else {
 			pclc_base->iparea_offset = htons(sizeof(*pclc_smcd));
 			plen += sizeof(*pclc_prfx) +
-- 
2.51.0



