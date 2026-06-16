Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296583B840B;
	Tue, 16 Jun 2026 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624816; cv=none; b=cTrLsEdU+KzIGLNOW8sL45ciruLTlG0b5/Kv8QoRkiOJmsa9BLm1EAUV2cHKXnkKEKAQ8dc8zgYJwIigYMVcfhWMKg1xIQ0qmG0AIZCpo/FPtuhVlVM2gHg8+Tw1ThAR9+ia3oq9O4WDCYtLcbImR7GaOem8WZVUlHLyhocawuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624816; c=relaxed/simple;
	bh=wbC6nUXvKQLw1Ln9Xl1PP39QR5cFvmHKMHwL9RsSUpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNtjERaJX8aSlWUpdxTBOmRzecNdaJrfuCw1ap/3Guz81aPv6BkhjxYOz+oGd/N8Ap8Ltc78h0SDlXgbwbnfgbYmFN8fxNLmP57kacea1jZngKuWIOziuu1f7Dhc0cQfxyai5qnbIHZivgtuHajGO+okCsEtQw26SyOcx4H0eK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIO4EbdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIO4EbdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AF81F000E9;
	Tue, 16 Jun 2026 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624814;
	bh=BNm3TO0qovI4WxSWFUGbK/SRdKWNe/myx71hCOzDd7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIO4EbdXLt4sWiMBFZk0EhcvNdEDlWO4ory+xc4HYf7cakJ80q1gnPWXzTTZ1e+s1
	 1RanswLG8O4TkMtLBhukFqrhXuRDTJJtp0V+wPh9XAavL88+xV+Mm82ufOYV/GDpCg
	 /8FDsElz9VdtlqAigUPS4yFHS1ESEph0w27GNKps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Oscar Maes <oscmaes92@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/325] pcnet32: stop holding device spin lock during napi_complete_done
Date: Tue, 16 Jun 2026 20:27:10 +0530
Message-ID: <20260616145059.447544019@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Oscar Maes <oscmaes92@gmail.com>

[ Upstream commit 73bf3cca7de6a73f53b6a52dc3b1c82ae5667a4d ]

napi_complete_done may call gro_flush_normal (though not currently, as GRO
is unsupported at the moment), which may result in packet TX. This will
eventually result in calling pcnet32_start_xmit - resulting in a deadlock
while trying to re-acquire the already locked spin lock.

It is safe to split the spinlock block into two, because the hardware
registers are still protected from concurrent access, and the two blocks
perform unrelated operations that don't need to happen atomically.

Fixes: 5b2ec6f2be51 ("pcnet32: use napi_complete_done()")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Oscar Maes <oscmaes92@gmail.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260528140320.5556-1-oscmaes92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pcnet32.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 9eaefa0f5e80c5..b465bb77432194 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1407,8 +1407,10 @@ static int pcnet32_poll(struct napi_struct *napi, int budget)
 		pcnet32_restart(dev, CSR0_START);
 		netif_wake_queue(dev);
 	}
+	spin_unlock_irqrestore(&lp->lock, flags);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		spin_lock_irqsave(&lp->lock, flags);
 		/* clear interrupt masks */
 		val = lp->a->read_csr(ioaddr, CSR3);
 		val &= 0x00ff;
@@ -1416,9 +1418,9 @@ static int pcnet32_poll(struct napi_struct *napi, int budget)
 
 		/* Set interrupt enable. */
 		lp->a->write_csr(ioaddr, CSR0, CSR0_INTEN);
+		spin_unlock_irqrestore(&lp->lock, flags);
 	}
 
-	spin_unlock_irqrestore(&lp->lock, flags);
 	return work_done;
 }
 
-- 
2.53.0



