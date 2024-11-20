Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18391A9B37;
	Wed, 20 Nov 2024 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107631; cv=none; b=UktunxLPn6GUOfvYauVEEmGAemh1oDYivMd9KE1/6Q0ap+6DJbusz/L2j/jjjfdskj3dro2EnhAlNDucjpqfVgC1iz9/U8F6/Gii9Jjr5lXX+9GR63aGhSqHEsZuFLdd/1IdZI6uBC3DnIhluxRWPTi44ghSN5AEZSKmF0gQEe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107631; c=relaxed/simple;
	bh=UDyghqrUPnJLOVpoA/KDgncdBicZtioYZUwQfv/jrcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pp/O+Zq5gplclw2MTUBhQ1cnVhFbazMUQcmGymSos0pNIEMRAB02gWpPIJ73l+XSJDswV/5pPp2Ioi1RYEenyfIYxDj42vUyL5gtH3m1eKgM1HWOcaWf0nOciR65Y6gFOlDiJ8DiPMhQS//AIYKogd1E63w7A9XkEOVGey5HPU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BszirPZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BszirPZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AF3C4CECD;
	Wed, 20 Nov 2024 13:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107630;
	bh=UDyghqrUPnJLOVpoA/KDgncdBicZtioYZUwQfv/jrcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BszirPZlGtDLvSlrVmZPqwyOYEFRQNyWwnfMAKuhzEkoOI8AIKYZbWd4CpgSg6OMR
	 YPpOsESjGv+My1tmiBlN/idbtwa0Y8bUx9Nd+wGhhE6xUT0GbalqbghsNJZxvZjFb5
	 W056G9zA0x99IXKjaDYenMic/6/J5KPoIU40wQLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 81/82] mm/damon/core: handle zero schemes apply interval
Date: Wed, 20 Nov 2024 13:57:31 +0100
Message-ID: <20241120125631.443556240@linuxfoundation.org>
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

commit 8e7bde615f634a82a44b1f3d293c049fd3ef9ca9 upstream.

DAMON's logics to determine if this is the time to apply damos schemes
assumes next_apply_sis is always set larger than current
passed_sample_intervals.  And therefore assume continuously incrementing
passed_sample_intervals will make it reaches to the next_apply_sis in
future.  The logic hence does apply the scheme and update next_apply_sis
only if passed_sample_intervals is same to next_apply_sis.

If Schemes apply interval is set as zero, however, next_apply_sis is set
same to current passed_sample_intervals, respectively.  And
passed_sample_intervals is incremented before doing the next_apply_sis
check.  Hence, next_apply_sis becomes larger than next_apply_sis, and the
logic says it is not the time to apply schemes and update next_apply_sis.
In other words, DAMON stops applying schemes until passed_sample_intervals
overflows.

Based on the documents and the common sense, a reasonable behavior for
such inputs would be applying the schemes for every sampling interval.
Handle the case by removing the assumption.

Link: https://lkml.kernel.org/r/20241031183757.49610-3-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -989,7 +989,7 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 
 		if (!s->wmarks.activated)
@@ -1089,7 +1089,7 @@ static void kdamond_apply_schemes(struct
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
 
 		if (!s->wmarks.activated)
@@ -1109,9 +1109,9 @@ static void kdamond_apply_schemes(struct
 	}
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals != s->next_apply_sis)
+		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
-		s->next_apply_sis +=
+		s->next_apply_sis = c->passed_sample_intervals +
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
 	}


