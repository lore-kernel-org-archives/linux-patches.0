Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032151;
	b=rZFMJZuBgoCvPgmdCcS3w6uywcLAYFEP6OywQ+RK0cp5zHvBNlZLDTX+GO/6SYpZx/dn
	 /5Vlh40NFpc6e5LOcWNpGs+mW+6q/L+enw8Uhybcyue/kHZ0S2PUHTulxP9PrVn+Ee881
	 qesK53ra11AuM6idYM8Hz83Od5vvIFxos2xEu85eFxIWTnRd2g7Tv0kKTCpaY1Wa1vj+w
	 XR3ZWMgbq5cGpinYN62wl1DQFwEVPBPPlB/BNW5x8cVQZg/OBLrZF0n+T5NFzigt5sLYv
	 mPtzDDX5dfmWO4sfIaZpqkYyorgTnXMkD2rgK66Wr5e3EOPumnsHhftj7icU4yhFQgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MPIq8Q9B8ESFOaQ/scTlETd33feUJJuAlQ3I1dqcGoM=;
	b=1tntzXnLfq3Lzdw/96pGRXZJyiIlpAqR1lJfpzgYHjrwg3nkxI5BMNGRhc+k0xjWQZ52
	 40UVOu6s+jOZVfx1ZTfNt+NbgqtXkwvmyNvKofbiQ7r4x61/gpmSbZF4paJ9CQUzYth3u
	 DP66GKmy8SN2dLToXO/Z+rgsFgOhP8pTXp6UL7eluv/3klPXoibC2ZcRDN8ji2delQNBg
	 kMU1hMAqRdbJe9cJ68zD/zeszPD0mw0NlUkCp+1xSIx4TZpdZT6LCtoRVQ5/r4lZbPIOw
	 klOJEjpag3wCa80vgtQd7BnSa6gyLOzGwLxkvOc2RsaEuMdcaAWKcpfAylYjyL7yOrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ts/kSueW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A393606A31C;
	Wed, 18 Nov 2026 20:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ts/kSueW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE251F000C4;
	Wed, 18 Nov 2026 20:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032151;
	bh=MPIq8Q9B8ESFOaQ/scTlETd33feUJJuAlQ3I1dqcGoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ts/kSueWt43JQVlttYI/lEvWpRjkxJVLas1cByC9NLHb1M/5BwSzU9OYhtrVFZTmc
	 PLYTBV0RryBsN3Z22tlT5miwgNzuTLV4KNQvohqnUeIlhcb7WOYgtHyQpWUe1Ccjum
	 q0tIwrp371lZ4osI9r8hIVCEUDvTrEHKkIwmRfwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1283/1756] IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
Date: Wed, 18 Nov 2026 15:56:50 +0100
Message-ID: <20261118150100.639652940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit dd36137b218ad6f18ed15e6279412d7fc160980c ]

If driver_f.qp_priv_init() fails, execution jumps to bail_rq_wq, which
bypasses bail_qpn. Because alloc_qpn() has already succeeded at this point,
the allocated QP number is left unreleased.

Jump to bail_qpn instead to ensure the QPN is properly freed via
rvt_free_qpn().

Fixes: 5190f052a3654 ("IB/hfi1: Allow the driver to initialize QP priv struct")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261015102518.15780-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 9cf139f0d0a18..320060b1c90b3 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1175,7 +1175,7 @@ int rvt_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 		if (rdi->driver_f.qp_priv_init) {
 			ret = rdi->driver_f.qp_priv_init(rdi, qp, init_attr);
 			if (ret)
-				goto bail_rq_wq;
+				goto bail_qpn;
 		}
 		break;
 
-- 
2.53.0



