Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F2B3B9930;
	Tue, 21 Jul 2026 21:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670734; cv=none; b=WKUUzJDer43iF3AD1FNUqzc/dyrKcPYHJ21L7R0n4wzHs1u4b+2EUFL5ZX+DZcru+Uf9YWFMpxPKdpWQPGFpcoyiRDPZ6nPqcntGkW3VmLumJZJVaw3Ix9dw8WLtIB4Q6X4jHrgW0+p4KORXQlcuuDPQKrVBPE9wETgcb28oIF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670734; c=relaxed/simple;
	bh=DnnXHIAaQYNowKzqtYrPvsqWiY8S+NV1RuC9ARITKN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hql4duBJ7Bn1tiMuQgGS78m78S1gB1QwSDTzF5hQ5DkBAIv/n6SvuXvtxb47p+z8ikEKLL79XMeVAve/WZnQT5P7n+OwZ/5K4WNwPWt5Lg5xEBV2uNGb34Z/w+/TvGjvGmSGfmHKc+JsrbejM8EhuthI+g3c+bw41hkxNgyvrjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIA1Y+9S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIA1Y+9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00F71F000E9;
	Tue, 21 Jul 2026 21:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670733;
	bh=A0/PN6tGA+OXvHyJ5tf/8W8mqPPYrljuX3EsI5xeV24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIA1Y+9SJCkhaoF5uQsJnJnHpxE0bcU4fV+YJ5TwlCsvGYMDggiGayfMTCgF044Fn
	 5Sf85ex6iXH6tkdN4YiIVe/3LHAmnWpIOrl0A85KS0DLLTL4hjjJGaJopD+OhxXpp8
	 g3FXLsQbXryTE89IzNS7EiJqveJerFmthI1k+6gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 1044/1067] mm/damon/core: make charge_addr_from aware of end-address exclusivity
Date: Tue, 21 Jul 2026 17:27:25 +0200
Message-ID: <20260721152447.946981229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 5a2d162e22bf33eb89d53e802d0fc1ec422e19b6 upstream.

DAMON region end address is exclusive one, but charge_addr_from is
assigned assuming the end address is inclusive.  As a result, DAMOS action
to next up to min_region_sz memory can be skipped.  This is quite
negligible user impact.  But, the bug is a bug that can be very simply
fixed.  Fix the wrong assignment to respect the exclusiveness of the
address.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260428042942.118230-1-sj@kernel.org
Link: https://lore.kernel.org/20260428032324.115663-1-sj@kernel.org [1]
Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -803,7 +803,7 @@ static void damon_do_apply_schemes(struc
 			quota->charged_sz += sz;
 			if (quota->esz && quota->charged_sz >= quota->esz) {
 				quota->charge_target_from = t;
-				quota->charge_addr_from = r->ar.end + 1;
+				quota->charge_addr_from = r->ar.end;
 			}
 		}
 		if (s->action != DAMOS_STAT)


