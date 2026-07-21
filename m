Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA86F415F02;
	Tue, 21 Jul 2026 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657747; cv=none; b=H6RqszTNESdLu4HizgfNvgnSXOg2mjl116/13moz5/SaoHx0otgwAeD5+ri2LhlUsY9S9ybiZtdVuQWM0zRW96SNuvMfGu6GAMq1m3YGZsoSHP9QhFLk6EitV544DgtaI0UeOS7isdsTOZ5MBFhpgFeCihP5MXxOJH7+AAVPlaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657747; c=relaxed/simple;
	bh=ypmjZ9se3hcOXnbsu+swYM5tr6Gaog6UNwK3Oq1F8vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jimg3zQ7hbev65wljfhRPY0p/E/NfQLc5VkFXlxITTJ5wxsUXz0xL12MoKOM94VAEa8K8+IgTsT6cxkl7rJqT1wAvI1+2k3Dh6Fq+pPS82AGepxeD5SCbUsgrOEilqbvLqLWSm9rdcPd8C9ZWUhMnfUj28vUgEyV0C67Y3rH6Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlDVHOC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlDVHOC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E241F00A3A;
	Tue, 21 Jul 2026 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657746;
	bh=ViBnkxbW1/ojroLgY2pZxQg9XfSbymb79mai9lFulgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlDVHOC7+vXxjSTc4/eRKOAtGOgIX3GeCAIzIfT51gVhiv9ZrIS/UcVtBh2pO45IH
	 11rTvKVwPL3k/Gg2OZMSFuk3d2E5tVACYvdK0PGi35t3uwT/XE/irn6nGuvH+2fLT1
	 2urRCum43AgTJM+ITe+kgKLD+H34EXjWuMy/GIxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0840/1611] netfilter: ipset: make sure gc is properly stopped
Date: Tue, 21 Jul 2026 17:15:56 +0200
Message-ID: <20260721152534.281277070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



