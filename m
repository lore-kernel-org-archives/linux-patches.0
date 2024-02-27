Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2243013B790;
	Tue, 27 Feb 2024 13:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040975; cv=none; b=M9b0+lsG2n9zPSTBsv4kqYVEy/PXtgSNjHxcv8qhMJCJtktIETPC8Ci1HGTIY9PJ4s5vpr/dwJxMY97YYruoRwF3Nyei++VOeVb6JW1dwMffa5EdbGx3TBC05eHAgIl88/YXFxLZgKqFmCi4nOPPJUDAGNf3fdj2bKsOQdJ5LSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040975; c=relaxed/simple;
	bh=4Q4ov0xj+qFhZ461frBIHUUXCPQfseo+jzv/ieGsOtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amGH4a0xxbo5mEleCCVmH9LSKbT0X008FruLI4vT1/hjcxM/yFU6k1rXbIr1LFjPq1FQT5UFa4FwAqyq5dQ5EaCiQQoc8ibd1LcsIBQy93CQdenClKJf57bML0yt2oAEe/qTlwNRwijxJb4xacM5c6mbH71tSyLAMYN9ZIYfVMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHoPjuLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHoPjuLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D13C433F1;
	Tue, 27 Feb 2024 13:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040975;
	bh=4Q4ov0xj+qFhZ461frBIHUUXCPQfseo+jzv/ieGsOtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHoPjuLkKPcR4FgZmMdbKBXfz9hNHtx6kEvkZCgMRYsz19xbw3ZHtRRI21by9lu+U
	 JDHGx/gq47SkTw+jEhvzV2wkD3pnXo69zhONWMV+XsFIAxVlZbYyGT9g46QKHVYUSG
	 lmIl1NzYOtijYUkS0KWQzlbZ3eaybT8EKLFgm8To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 174/334] mm/damon/core: check apply interval in damon_do_apply_schemes()
Date: Tue, 27 Feb 2024 14:20:32 +0100
Message-ID: <20240227131636.160105212@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1026,6 +1026,9 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
+		if (c->passed_sample_intervals != s->next_apply_sis)
+			continue;
+
 		if (!s->wmarks.activated)
 			continue;
 
@@ -1126,10 +1129,6 @@ static void kdamond_apply_schemes(struct
 		if (c->passed_sample_intervals != s->next_apply_sis)
 			continue;
 
-		s->next_apply_sis +=
-			(s->apply_interval_us ? s->apply_interval_us :
-			 c->attrs.aggr_interval) / sample_interval;
-
 		if (!s->wmarks.activated)
 			continue;
 
@@ -1145,6 +1144,14 @@ static void kdamond_apply_schemes(struct
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


