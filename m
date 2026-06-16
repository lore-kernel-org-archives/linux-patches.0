Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2B747AF68;
	Tue, 16 Jun 2026 18:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635919; cv=none; b=s1P63yzRget6hZa7rxysj960/EYFFjwjkVxxGaksJx+nGf90aWfU5dEQwWI9e1J26GBCTjfbXoCW+Z/GKOWPvgIOFgPqs8rdzphCv/ffSimF0LjBXb9DtQCvzKCXuQn/JPNs1xmINEQjMGffzeSn6V02G1pshfFLysHk6pKYo3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635919; c=relaxed/simple;
	bh=zbM/peYECVqRW3z9KyWPYXxCl0fZYuzKBEFksSNIODg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIoyAi86858sS9QDDSgldcaOIIRwOzX3U9nhKN5L9XHYG/Ww50zJlEzbsQVXihh7aY/lJlzECQfIA8CI6guyhJIH8qyV8b7iDZC7m0qNlTH/QKUpAsIgHwHIpaNAXcJ8SJ7xwUWvRcmfrs+C7Vzamp2GkqBLxi13GlB0T2X/Hnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cocwMOVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cocwMOVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B831F000E9;
	Tue, 16 Jun 2026 18:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635918;
	bh=+8eBlrKf0j5Zi1r4R01TyoBvcUM0trGaWSfiCUhoQHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cocwMOVDOCRqgttz+cUtYOziNYLbZYzY6Whu68Y60E7KheYsrTknB1xxrF0I54YTZ
	 fPOydrEqsUjS+Ra7ZAQ2dr0LF+1K4hfh1goKeBoxPnh9iZ4lOXtk730lkAEPqpXfk+
	 Ti0U8ag2l88gQ30QR26sbGouuzFfvNYHDbzyPav8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Oscar Maes <oscmaes92@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/342] pcnet32: stop holding device spin lock during napi_complete_done
Date: Tue, 16 Jun 2026 20:27:17 +0530
Message-ID: <20260616145054.753242649@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f78daba60b35c0..ce5b8e6aa976f9 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1399,8 +1399,10 @@ static int pcnet32_poll(struct napi_struct *napi, int budget)
 		pcnet32_restart(dev, CSR0_START);
 		netif_wake_queue(dev);
 	}
+	spin_unlock_irqrestore(&lp->lock, flags);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		spin_lock_irqsave(&lp->lock, flags);
 		/* clear interrupt masks */
 		val = lp->a->read_csr(ioaddr, CSR3);
 		val &= 0x00ff;
@@ -1408,9 +1410,9 @@ static int pcnet32_poll(struct napi_struct *napi, int budget)
 
 		/* Set interrupt enable. */
 		lp->a->write_csr(ioaddr, CSR0, CSR0_INTEN);
+		spin_unlock_irqrestore(&lp->lock, flags);
 	}
 
-	spin_unlock_irqrestore(&lp->lock, flags);
 	return work_done;
 }
 
-- 
2.53.0



