Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036483;
	b=185vFRfgTZepMkT7O3hUy++B3kwCmOYWEZpjhMWeSlQx20rjMu36nUUQU6L0FAyr7hVH
	 BFND+tsKEQRH8PoKk6uoddkHDb6MQfc6hohLLd9B4Wv81X8gGLx0PbcDhnRa3LfrhTUNL
	 Se/avVb/C/hpiYT+6EZeyDP1IUhTGX5PTrVjPK/z7Wizo551tItamT08rhol+yEfQZpDu
	 EprT5GnBY4dCt+sk3uytbhoB3vCngbNfwrhMsbyz1cvcvwFJy8L+/Gtn62PuRk/fQGsT6
	 rvnGAC7NA16/ZUg0Pe5TvQFC7iwYCJOyNZcDws8RJu5l60jFdxdWvy4GgeZ9Z68qB4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F1u6g0qmfbV/CsmoDPM9agq5DLLn6vIh2rjKiNvq38I=;
	b=oqdCVT0iMpYSUnRiQsBpTRCLZVNr5k2qtaiSFpADMHPoUo7YSTaV45aFZlwbLTlpPF6q
	 1FddXaGOeS4P2TJNvOj53GgljTwB91WROk80DZh0SaJ+vHn4l0AHPXpyxJ1WrU/YaXMgg
	 ZdYHRfCpzI0WyVegR1eoEnYeeE4wBiwPhJhDgAUQfGuggcVLCBfBN3MBxJRE81H93DS3X
	 0oSQDabuxCpewKYrtxuWKxgXiqqW93h/KYIW2nOBXfsquUm7cFJqRaDx2AM6SpWxRC0ER
	 ZYBrEuKAh65awLVjSmkqLDqXKTx+tKzxLezuw21cFlP9hXLS/Ce8Fs/VsaUiocRByhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lf5jVped;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A01C606A325;
	Wed, 18 Nov 2026 21:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lf5jVped
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D758F1F000C4;
	Wed, 18 Nov 2026 21:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036483;
	bh=F1u6g0qmfbV/CsmoDPM9agq5DLLn6vIh2rjKiNvq38I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lf5jVped3bPnS0nNT6Tgs6wq3OtJsqXaGbnl3Z1UvlI3g7MrVolkhgoIDGEORrOxO
	 lgVEQ7sNsrkGoS0LBLmtA9/klWM2JS5aDjPGro4YRsfLjL4oUMHB1fLcxMHweCGyfd
	 MmZQS5YvbT3JLzqKeVAmJIMVp1wjtuWRxTdDaoHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1077/3318] mm/damon/core: charge only the part of a region the filter left
Date: Wed, 18 Nov 2026 15:28:19 +0100
Message-ID: <20261118150352.279916417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 4ff3b4a54a32142497fb44b79d0920aa6ba3393d ]

Patch series "mm/damon/core: fix the size charged for a filter-trimmed
region", v2.

An address range DAMOS filter that partially overlaps a monitoring region
splits it, so the scheme action reaches only one side of the boundary.
damos_apply_scheme() reads the region size before that split and never
re-reads it, so the quota charge and schemes/<S>/stats/sz_tried account
for the whole original region.

Patch 1 re-reads the size after the core filters have run.  Patch 2 adds
KUnit coverage for what the function charges and reports, for the trimmed
cases and for the cases that must not change.

This patch (of 2):

An address range DAMOS filter that partially overlaps a monitoring region
splits the region at the filter boundary, so the scheme action is applied
to only one side of it.  damos_apply_scheme() reads the region size once
on entry, before damos_core_filter_out() performs that split.

The quota charge and the statistics update therefore account for the
region as it was before the trim.  schemes/<S>/stats/sz_tried counts
memory the filter excluded, which Documentation/mm/damon/design.rst says
is not counted as tried, and with quotas/bytes set the excluded part is
charged against the budget, throttling the scheme to a fraction of what
was configured.

User impact is that DAMOS could unexpectedly slowly run, due to
over-charged quota.  DAMOS stat could also be confusing.  No critical
events such as crashes or leask happen.

Re-read the region size after the core filters have run.

Link: https://lore.kernel.org/20260921152443.80132-1-sj@kernel.org
Link: https://lore.kernel.org/20260921152443.80132-2-sj@kernel.org
Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b5b6d00d7a3b5..c106219d33dd9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1008,6 +1008,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		}
 		if (damos_filter_out(c, t, r, s))
 			return;
+		sz = damon_sz_region(r);
 		ktime_get_coarse_ts64(&begin);
 		if (c->callback.before_damos_apply)
 			err = c->callback.before_damos_apply(c, t, r, s);
-- 
2.53.0



