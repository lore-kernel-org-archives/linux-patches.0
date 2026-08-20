Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF8F47D94B;
	Thu, 20 Aug 2026 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247242; cv=none; b=f+FO/fOaALKaTxWMTd8TUeEY61D0GjoaIW1iRvQCtLnOzxT4afS3AUCIamg7wRCBOSFYr1ELl8gtbYAeQmMgKyiIsI235z15SC4bGP2qKO5Phv+ieuTDA3dxe9Ileb9UPi92zhta7sh1GfLEtfFu9OmmZO5+0FI3UzI8ChRhXOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247242; c=relaxed/simple;
	bh=/RCulI9Yj/Sl1e+G35kzj5LYD4GqvC3CbwoVjC8o/XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9j5Wh5dBfa7JKFb6/XxU9c/0PLkTrgvoldaqTDcYHefkdySPSWq3bFC1rn2bke2+VcLKwxHc0tGLIQYXDcIpvxbWz/+JUshUk9kaUE3DviX2agNwIvf4hHA+EagWD5d/eJ/OPdFX6Bs3CTy0KNQvu4uVyXEV7dWzp/RPKE2E5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZYP3zeV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZYP3zeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFA71F000E9;
	Thu, 20 Aug 2026 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247241;
	bh=jFHkG0wDIC0/jyWVSmRKgwQxsOYlZky5dnsgiAKBFk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZYP3zeVeE5JVM9FEy4bTLps09gl7nH3Luak6lmPRCKi71HcuwktgWyYnAVnoAOOn
	 OnvlJhEC5oE9KpsVwl+wMMBrSbEINMRE1ep9pnE84hsD5Qh8x9UVW/x7opXm6OmW+c
	 8CnQzwnnj15J+CLlbWs773uEp5ag04x0Is86/AoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/220] netfilter: ipset: let destroy callbacks adjust ext mem size
Date: Thu, 20 Aug 2026 16:56:29 +0200
Message-ID: <20260820145229.492315368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 490937b88cb592cc0c5367758edd700fd5abd15c ]

For bitmap this change makes no difference, because destructors are
called synchronously.

List type however calls them via call_rcu() so accounting decrement can
happen after list_set_flush() set ext_size to 0.

'set->elements = 0' can be removed for the same reason in the list type
case, it calls 'set->elements--' for each element.

Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 net/netfilter/ipset/ip_set_list_set.c   | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index cf8468bf987db..e6a092cea011e 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -77,7 +77,7 @@ mtype_flush(struct ip_set *set)
 		mtype_ext_cleanup(set);
 	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(atomic64_read(&set->ext_size) > 0);
 }
 
 /* Calculate the actual memory size of the set data */
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index e417ab37b69c7..720f05340b477 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -423,8 +423,7 @@ list_set_flush(struct ip_set *set)
 
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
-	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(set->elements > 0);
 }
 
 static void
-- 
2.53.0



