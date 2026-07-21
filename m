Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA0646D08C;
	Tue, 21 Jul 2026 19:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662844; cv=none; b=AcPCqk6zp6+/OYJgTlT0fdWm72GxoLV5VsPCBpTjGVDn4tIgqaBhqDcXkLOdSCqTHo37lg4j6MANsMMfvULl0hsbDECuqhqEQYJOpnjfMG6vE3qm9PRLGX2WVcYwmRnhbbBEoFDWZg1S2eZzsedLOb/tkhacAK7/NUkToo3jzhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662844; c=relaxed/simple;
	bh=qtx9la0PhEyKftqN4NGQ+TxBwvYQBj/nRYaenDSaagY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRhglrUEP/lsbiw3pz7vcl61nEfbmlFpmme1+exESV8G2NVEfzYNn+iZadRmRVPiZOlmwiePpHqS46Kn5Rq/x/nBeUs99Wi238ezJ3OMc+Ack08eFbAm3Eczj681kf5sj243jyYRmpH0FiJpapUjKTpV6Wg8D9Z6jBw/Bdb7cFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdK1XujH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdK1XujH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957F41F000E9;
	Tue, 21 Jul 2026 19:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662843;
	bh=Js4JsOLkwDvRl4E2R3IZcTEte+4enDLxiYkn3p5hhFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdK1XujHL+fnTKFxztmjJzYKUPHM9Oa31Kxfse5sLSt+MITvYFq9WRDTMw0SVdWW7
	 6xg4SOQE2w3RCWj1snJBOLjy7LLKYWmwtxBSrm4TXlpQMpR+oyXuUn0qNet6phfwRs
	 lwBUSeOY9jPbyvfZRFVAd4xoWanYMcD0+Dtc38EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0596/1276] netfilter: ipset: make sure gc is properly stopped
Date: Tue, 21 Jul 2026 17:17:19 +0200
Message-ID: <20260721152459.452103689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 4a597a87e2e2f608edb6be2c510dc826b4fdfb53 ]

Sashiko noticed that when destroying a set,
cancel_delayed_work_sync() was called while gc
calls queue_delayed_work() unconditionally which
can lead not to properly shutting down the gc.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 94f11c0a5f928d..0426d012185dbf 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -606,7 +606,7 @@ mtype_cancel_gc(struct ip_set *set)
 	struct htype *h = set->data;
 
 	if (SET_WITH_TIMEOUT(set))
-		cancel_delayed_work_sync(&h->gc.dwork);
+		disable_delayed_work_sync(&h->gc.dwork);
 }
 
 static int
-- 
2.53.0



