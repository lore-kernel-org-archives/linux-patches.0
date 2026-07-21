Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E11F47253D;
	Tue, 21 Jul 2026 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658677; cv=none; b=SLwMej6pMLGO08VWSX5UawITHMunDauoqfoeBVJ6s7tCB8drHWFxu4sB5ONRHZHqGVqonlfBbQn3U2YGBUFQ6z7pBRqlu7f+HUPROrXf3v8WeuR4ctFgEmVKAA9MkAJMqLYRKCzdx0dmLDmdrz6BZqaT9QCiA8HgvoS8nniu+gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658677; c=relaxed/simple;
	bh=HbRE/735HhlE/t0Bxk+rXF5ryPy8aqixreUOU2rWlZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPd7KkBOq83rxvln0sZOawQZdbB3pzSt8ahUjH2ApF209HIBGml/IzArlw8JnvKWU5LlV67w1rNElDXwQq+MTAXb5E+4X/FBc4C4MKlKgaALfi47e8gBKmF2IAzmyHzSNHLfhUEcOqbRrehYlxIPIVWgWmUt8K3g/rF5PhV1GM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wU7z87o2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wU7z87o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF51F000E9;
	Tue, 21 Jul 2026 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658676;
	bh=dHF4eoRDPXDjnzsQ2+u8VDg2LRuVe2cYIHKrsElArlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wU7z87o2O8RuUTkRzer1Dgssk1nqrg+G5Bvw4cmjW/sk74fJAz2rqUhaj38UtW+lD
	 dkIL7GeTgQZMy8bXptrQzwDU1He4lpoicbqgiljYCjSNqpTo76RvtLBtOr1VjoLW7s
	 jitjk8FM8mihed8fkctryhy/E/wKyZ22SaH4skuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1233/1611] mm/damon/core: make charge_addr_from aware of end-address exclusivity
Date: Tue, 21 Jul 2026 17:22:29 +0200
Message-ID: <20260721152543.174339898@linuxfoundation.org>
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
@@ -1950,7 +1950,7 @@ static void damos_apply_scheme(struct da
 		quota->charged_sz += sz;
 		if (quota->esz && quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
-			quota->charge_addr_from = r->ar.end + 1;
+			quota->charge_addr_from = r->ar.end;
 		}
 	}
 	if (s->action != DAMOS_STAT)


