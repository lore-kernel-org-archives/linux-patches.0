Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9207509EF1;
	Wed, 30 Sep 2026 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791027; cv=none; b=uhFv931N3sfHaXqf7e5EgpM+oTfnWf1L6FohWHmUrLovAlWfStothLgb3iMGDZzBJm0Yj3MhYGnEKdFgQpFMq9ZoqwCL2MYEejHY11CGfgLnsltq7mwMEgFTXFIhP3lY3kQc52VkMjKsaEv9cbSVrl+O31YzFuttJMQY1bHDpGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791027; c=relaxed/simple;
	bh=rD93wHfnkYNoD66omtkL0Zc2xFgkPzTFIO7n/Y2+KuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/u/I8i1UmGeyFMHx9t5eH3admGluD4Vr0YgnN99s+oIXj7ojTeMnJjqq3b+ZDmF6LKSePH2YtTQECHDDLICO+SXkS9NNfplsGAos+B/4mZACXx7i2Ad3jW13Qur710/w5C57s5cL9T8ZKRVGzZ/Tzwv1IQ5QSE9nmqAV4G5nl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlSbE4XA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlSbE4XA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6621F000FF;
	Wed, 30 Sep 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791025;
	bh=2fgSo5v6mwhpHa4u6HLySxlye3h4l6CVPwkNoAj2VRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlSbE4XAk+0pcshMvnDE5Bn5D7Txh2JYluGp7UObZ+5w/l1QguyUfDhHGSe89nas1
	 CZknRslJMTk6UWAScpWjRINeCIY1b4g7HSowxuNvomDk8LRa2Tn06iHI2An311p0tW
	 Dn36jMGuZ7z1Nrg2361ZHVH0q3kMHJ+KwFpr2dUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/752] net: ibm: emac: mal: fix potential system hang in mal_remove()
Date: Wed, 30 Sep 2026 17:20:01 +0200
Message-ID: <20260930152401.014068425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 7c5d41f87f079990bf241359e3c1332d8d10fe87 ]

napi_disable() is not idempotent and calling it on an already-disabled
or unenabled NAPI context will cause the kernel to spin indefinitely
waiting for the NAPI_STATE_SCHED bit to clear.

In mal_remove(), napi_disable() is called unconditionally. If no MACs were
registered, NAPI was never enabled. Also, if they were registered but
subsequently unregistered, NAPI was already disabled in
mal_unregister_commac(). In either case, calling napi_disable() causes
the kernel to hang upon module removal.

Fix this by only calling napi_disable() in mal_remove() if the commac list
is not empty (which implies NAPI is enabled).

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260603230821.5619-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index b095d5057b5eb..34d9e03f631c0 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -716,13 +716,13 @@ static int mal_remove(struct platform_device *ofdev)
 	MAL_DBG(mal, "remove" NL);
 
 	/* Synchronize with scheduled polling */
-	napi_disable(&mal->napi);
-
-	if (!list_empty(&mal->list))
+	if (!list_empty(&mal->list)) {
+		napi_disable(&mal->napi);
 		/* This is *very* bad */
 		WARN(1, KERN_EMERG
 		       "mal%d: commac list is not empty on remove!\n",
 		       mal->index);
+	}
 
 	free_irq(mal->serr_irq, mal);
 	free_irq(mal->txde_irq, mal);
-- 
2.53.0



