Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1406332AAB7;
	Wed,  3 Dec 2025 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778209; cv=none; b=GzywS1RoqbEk5/h45S3GJ8SH7LGd/NWaR4xfcbif/AV6zkGVuskP+u7ayxUeI0pUsko3cqi/p/Gkz57T4/CK/Yse5XjXqw8vIvhJKP97Sh4bJoAn0U24QSEgelcFiRZxr0fEWRYjbEUH7WlPuXhmzBVw+pqaOvAJNEmbfQqe2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778209; c=relaxed/simple;
	bh=Q6a4IL5e19d3UMPPnUMS+WurZb0GJqEOmexKATmppFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MAhKqhODXxwpH+8pnd+oz/8BO2lneIQxc7nKECX5yhqpqEhU1FSEYFUARQTjcN0QaQp0oS3POUBJZ6MOJa4RtF292y8xwyvdSatjQpfqTdaHu2kfPcQ/BI54oxDN6Deohe4eqx6E7IDYXs7P2W0+ONEFGAaqGwZYFbUsF5a0EzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOEaRKkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOEaRKkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89226C4CEF5;
	Wed,  3 Dec 2025 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778208;
	bh=Q6a4IL5e19d3UMPPnUMS+WurZb0GJqEOmexKATmppFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOEaRKkn+dDioLhZtN27uZjVzwdUIXaLq8NqM1o0GFnbBzSuBV1kTX9SHqRj092Ej
	 lF8AFVTUZ2HGV29oWXl65XJgHIo4VNt1YIZ/FU+QWlcg+F4Us2S4yXpKu5N6XIP9k7
	 HJjW56o1TE8CaQ5TUyrvyPhTiT5kuX4MOgCi+qjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/392] net/smc: fix mismatch between CLC header and proposal
Date: Wed,  3 Dec 2025 16:26:33 +0100
Message-ID: <20251203152423.116878043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 52a0ba939c91c..ec8c4cfdb1471 100644
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



