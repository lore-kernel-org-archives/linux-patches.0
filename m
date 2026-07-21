Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFE646D094;
	Tue, 21 Jul 2026 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659636; cv=none; b=AxVMrgi18EkjAp2ElDtZO4oBtnAfHWcwF05NrjmgUXayNO9CExQBegTSOIeMcWpU3xIAC1GZLXDAchw217FB2pkNJJGTkhxa3s1ipGCstLTC3oIwdq0FkEQCve4aSg8Kuapk5kTVKDv6Brlb2hZjbhGZVLN2bj8p3Z8ub33SYLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659636; c=relaxed/simple;
	bh=O6qkolcEAnDA0epzmymJroemPCIgvRccZsFu7TKiWGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NouJGoS4GwaNayGfgEcBKLjBymbYXVFw1xzzTNQvO54YWcmQtBYh6ebLzgw1Tp2CEOLViwm60RRs4cAZOXT03FuKsDGqy+na/yGniIGso36qNIjPyLqUtvPN1emwzOQ2ghKXKE8hHTSFPC5JLsKmmCLEivb3z4EWbGLNPVg3Wmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuSd/Odw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuSd/Odw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FBF1F00A3A;
	Tue, 21 Jul 2026 18:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659635;
	bh=sifapss5YoyboetmWL/mrRk55jSec/qY8A1ZP+ZyDhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuSd/OdwUVtf79mAvc75kWmmc26aGGyr7F1vxePsfOls8Mr7CcOeS7avWcQm3ZzUn
	 qCBnwX+3eH9wVHFVbFGtU4VyOaOaeDlh+SHiI5ygXF0FvPUdsYq18Wx3E57C6HtwXt
	 4pafLrv3lUO6Lb6h37KWg2Q8CDLqmIosaRL9lGUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1595/1611] mm/damon/core: trace esz at first setup
Date: Tue, 21 Jul 2026 17:28:31 +0200
Message-ID: <20260721152551.352781802@linuxfoundation.org>
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

commit 7e6cc35f5283eab81a14231a64ecd640b690c48c upstream.

DAMON traces effective size quota from the second update, only if a change
has been made by the update.  Tracing only changed updates was an
intentional decision to avoid unnecessary same value tracing.  Always
skipping the first value is just an unintended mistake.

The mistake makes the tracepoint based investigation incomplete, because
the first effective size quota is never traced.  It is not a big issue
when the 'consist' quota tuner is used, because it keeps changing the
quota in the usual setup.

However, when the 'temporal' tuner is used, the quota value is not changed
before the goal achievement status is completely changed.  For example, if
the DAMOS scheme is started with an under-achieved goal, the quota is set
to the maximum value, and kept the same value until the goal is achieved.
Because DAMON skips the first value, the user cannot know what effective
quota the current scheme is using.  Only after the goal is achieved, the
effective quota is changed to zero, and traced.

Unconditionally trace the initial quota value to fix this problem.

Note that the 'temporal' quota tuner was introduced by commit af738a6a00c1
("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL"), which was
added to 7.1-rc1.  But even with the 'consist' quota tuner, the tracing is
unintentionally incomplete.  Hence this commit marks the introduction of
the trace event as the broken commit.

Link: https://lore.kernel.org/20260520150311.80925-1-sj@kernel.org
Fixes: a86d695193bf ("mm/damon: add trace event for effective size quota")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2237,6 +2237,8 @@ static void damos_adjust_quota(struct da
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
 		damos_set_effective_quota(quota, c);
+		if (trace_damos_esz_enabled())
+			damos_trace_esz(c, s, quota);
 	}
 
 	/* New charge window starts */


