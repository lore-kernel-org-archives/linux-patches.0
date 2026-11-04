Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831041;
	b=4TQJpJXSak5d31wrZ9IBFEbNzH1kAWlsV4waWv21XGtJWpt2OX8w+xJyJtjtYl/7H+/A
	 Kfpm402Ug6tf72DsIufW0VmPU9di9IvNderj7n+OXVKNG9ClE17fuzqm5Lr8V8LxJUx/L
	 xU6IN2teiZ5/ZQpNAVA5346fUZnoun5XOsWsFHC0gXAYxTy8GYmCNCE8dyrV9tvkF/rrm
	 2TnT66xtgXO4DBnQZcl6yjxArf6I1LkPsf7O8hMgBTta4+cp7nuD7wJp8mnzY9XDOsaPT
	 GnWB0WcCvtiBodE7mTthfKfy1jiNHkbMbudbjSsxzr+5AHTOjT7Uprpg1qDJeupLMiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tRSo0rRKj2DhbIPR8FDltW00c3hlI3o+ffJ8ALdMl3c=;
	b=xgHSTYnl+a/ea+BDC5I59XGU20cu48+eYbZSxbkBD9JVh0OFphD6IRRfoa+71InR7s7D
	 IpbKzNJPtWouGr2FdS9D8TkarWIyCqcS7TBf7/OLjeKKV+UhIUN+2zjvunSZsS+dy1xAI
	 QUqpcL6DRZES5mN0dkp/giOEN1oT+VMunDqD+KANfE5G1X1rwMPMLM9S+wDYn5yfJo9Ht
	 IXEMGlYXOryMjFxsA+fxKxhx7ePC2RMad//IAEgRMzhIDY11G72h8iypWJwBy+vXw92FA
	 pfexF+q9GLGZyDeKTnbMHrJeIlvBLFaeKaRpxmTVO89f+R4vDAqF7c7mphgUz6jJbRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxn3Z60a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EC6606A843;
	Wed,  4 Nov 2026 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxn3Z60a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783FF1F000C1;
	Wed,  4 Nov 2026 22:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831040;
	bh=tRSo0rRKj2DhbIPR8FDltW00c3hlI3o+ffJ8ALdMl3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxn3Z60aOpmYWVZ3Di/lR4a3BfmhbborxqL/ljRwhRa0kq7ZGcfT/k4KN7X/RL/Tr
	 A3ciEygnprRhYpwwCfjwk8UIPrcc+C2TdvbTryGb1VN6Uwoazjs/48ZF8kGav+HmmJ
	 4saSnrlBatz4+LzMWPRcbpY6mMxH/X05bdgMhIhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Thomas Gleixner <tglx@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0475/1005] regmap: irq: Free the irqdomain we create
Date: Wed,  4 Nov 2026 16:03:28 -0500
Message-ID: <20261104211057.305926684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 2e42cade8ff1ff579e77976d9869db4df1feaf74 ]

When domain support was added to regmap-irq it was not possible to
remove domains, this was added later by 8ee99ada293b (irqdomain: Support
removal of IRQ domains.).  We did update the main removal path to free
the domain but forgot the error unwinding case during creation that is
now in regmap_add_irq_chip_fwnode() after some code motion, meaning that
errors during instantiation result in an unused irqchip being left
hanging around.  Add the missing irq_remove_domain() call where the
comment says it should be.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Reported-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260901-regmap-irq-deallocate-domain-v1-1-4bfed4aff559@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 6112d942499be..8c297156ea402 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -941,7 +941,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 	return 0;
 
 err_domain:
-	/* Should really dispose of the domain but... */
+	irq_domain_remove(d->domain);
 err_mutex:
 	mutex_destroy(&d->lock);
 	lockdep_unregister_key(&d->lock_key);
-- 
2.53.0



