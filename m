Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480F81AAE33;
	Wed, 20 Nov 2024 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107630; cv=none; b=eRpJPhxXOiW8e2MBEaz6T6fyuumF4/II40WrwsbKKhaOh3OTnBhaftSmn+ztvwbpM8eQIKwIKIttdpW+jSoQkX2Xfk6R23/3pngjk8pBQLOfGPPn4d6UKULv6oN79nH6f1bt4YexgekBR55GJ7LPl2xe9Cu4yrAayapV0QzbGqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107630; c=relaxed/simple;
	bh=n+Z4ZdYsA2bGGlPb4f+8CVbtljwFDlQ07sL+wBHxz0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7WG33CWukhKiR3znz9qQ3EURe6tRPW1FPfv0Lf/0ARlFFmyPqPL7pXIOgrDke8hy7VnU9mo3TpzZXhvXSDVY6FTO35cl9Fd9+zNP36NSwcBY/pSxIo7nfk1BiFqrk+GC1FmZSCHrkJ1z/Sp+WmxVG3gDR//OVKsw84zFxpbIAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMksnAFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMksnAFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EE3C4CECD;
	Wed, 20 Nov 2024 13:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107630;
	bh=n+Z4ZdYsA2bGGlPb4f+8CVbtljwFDlQ07sL+wBHxz0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMksnAFkIijCzWe9md1dF6CCuC2ZOQhvz+Clkwbi+tCUwquJ68S2Rk9uK6YPxtBxO
	 S+/jT+HwnK+B2N3KgWtffZ146HEPebsD3kaE2aZ+0qsc7ga07awVzOosRzhkxsfAHX
	 MdqH05eeU9XSUPhw/3mnET/8wIwV4zHVnYKoFD9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 80/82] mm/damon/core: check apply interval in damon_do_apply_schemes()
Date: Wed, 20 Nov 2024 13:57:30 +0100
Message-ID: <20241120125631.417580830@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit e9e3db69966d5e9e6f7e7d017b407c0025180fe5 upstream.

kdamond_apply_schemes() checks apply intervals of schemes and avoid
further applying any schemes if no scheme passed its apply interval.
However, the following schemes applying function, damon_do_apply_schemes()
iterates all schemes without the apply interval check.  As a result, the
shortest apply interval is applied to all schemes.  Fix the problem by
checking the apply interval in damon_do_apply_schemes().

Link: https://lkml.kernel.org/r/20240205201306.88562-1-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -989,6 +989,9 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
+		if (c->passed_sample_intervals != s->next_apply_sis)
+			continue;
+
 		if (!s->wmarks.activated)
 			continue;
 
@@ -1089,10 +1092,6 @@ static void kdamond_apply_schemes(struct
 		if (c->passed_sample_intervals != s->next_apply_sis)
 			continue;
 
-		s->next_apply_sis +=
-			(s->apply_interval_us ? s->apply_interval_us :
-			 c->attrs.aggr_interval) / sample_interval;
-
 		if (!s->wmarks.activated)
 			continue;
 
@@ -1108,6 +1107,14 @@ static void kdamond_apply_schemes(struct
 		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
+
+	damon_for_each_scheme(s, c) {
+		if (c->passed_sample_intervals != s->next_apply_sis)
+			continue;
+		s->next_apply_sis +=
+			(s->apply_interval_us ? s->apply_interval_us :
+			 c->attrs.aggr_interval) / sample_interval;
+	}
 }
 
 /*


