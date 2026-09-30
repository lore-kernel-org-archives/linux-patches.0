Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD7144F574;
	Wed, 30 Sep 2026 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787688; cv=none; b=OwTtNoK1+QbccXuRHLsrkMcVFyOdu8/FBuIAQ74SWDxnPWmm9fujRRcecqW0t6qnN+kcfhBvXg/RzIVBsjhptM6AZkjQgKy+Xfd1gqm8pCm2fuaxBUIyzI2iym8oZfUa/Jg4Mx+L7TWxxS9UJpDwpfgpS/4ErxmbjS3AWMp5d+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787688; c=relaxed/simple;
	bh=V1VaITbq6VMrMHyNDe4+r4UO1ZGV9H3qglIp1t14ZRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3tZAZ3/f0QejkFDXd6/e1EcWmzC9zrADpLJY3yKriHregTnOfyLu/wQ+1bFyAwtVKm+T526r1IAFjwn5Dw1gXj7LBJGwoxpXOpdT4MQbtiAhJMW5Kn0sALZR2+zoTwFRkYBsYE0d0QxyXokXiYDCTaITxi+G9O/us0JIjm75tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHu0I9ca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHu0I9ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEA31F000FF;
	Wed, 30 Sep 2026 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787687;
	bh=Syqr74s9uQZ76V7dt1E3E+UUoULRDyItABk+iN1kgz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHu0I9capt/vk3t3WvmV5ojvncsPsM/2vy7HUv8UajDdKDOnJdUaNm025X9WTROd4
	 mHS8Fj9lheDiK6PoIpE3/9heV+ulJOeF7uL1rKB800xP6QUhjvpwclJEmugsYHTBki
	 amKiDVMC9v3RG5kpYN2ZCkpmQIkoY3I9ZgFmY2GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH 7.2 318/457] mm/damon/core: reset invalid quota->charge_target_from
Date: Wed, 30 Sep 2026 17:27:03 +0200
Message-ID: <20260930152352.887555958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit eb64948249781bda35de04feab5a0acc36aa9051 upstream.

DAMOS can suddenly stop working if a target process that the quota is just
fully charged on is terminated.  Fix by catching and processing the corner
case.

When DAMOS quota is fully charged, the target and the region to continue
applying the action in the next round is saved in
damos_quota->charge_{target,addr}_from.  In the next round, DAMOS iterates
targets and regions from the beginning.  It skips applying the action to
the regions until it visits and skips the saved target/region.

Virtual address space targets become invalid if the process is terminated.
Trying to apply the scheme to invalid target is just a waste of time.
Hence commit 6e4930e33329 ("mm/damon/core: fix wasteful CPU calls by
skipping non-existent targets") made the logic to skip invalid targets.
However, it does skip before the charged target/region skipping/updating.

Let's suppose the user runs DAMOS for multiple virtual address spaces with
a quota.  The quota exceeded in the middle of a virtual address space.
And the process of the address space is terminated.  Then the
charge_target_from points to the invalid target.  The pointer update logic
is skipped for the invalid target, so the charge_target_from is never
updated.  DAMOS action to every target/region is skipped.  From the user's
perspective, it would look like suddenly DAMOS has stopped working.

No critical leak or crash can happen.  The user could reinstall the
scheme.  But this makes use of DAMOS under certain setups quite
unreliable.

When the invalid target is found, further check the corner case and reset
the pointer.

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260910142846.172957-1-sj@kernel.org
Link: https://lore.kernel.org/20260830064708.40CA61F000E9@smtp.kernel.org [1]
Fixes: 6e4930e33329 ("mm/damon/core: fix wasteful CPU calls by skipping non-existent targets")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3047,8 +3047,15 @@ static void kdamond_apply_schemes(struct
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
-		if (c->ops.target_valid && c->ops.target_valid(t) == false)
+		if (c->ops.target_valid && c->ops.target_valid(t) == false) {
+			damon_for_each_scheme(s, c) {
+				if (s->quota.charge_target_from != t)
+					continue;
+				s->quota.charge_target_from = NULL;
+				s->quota.charge_addr_from = 0;
+			}
 			continue;
+		}
 		damos_apply_target(c, t, max_region_sz);
 	}
 


