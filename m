Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C2331759;
	Fri, 24 Nov 2023 18:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A55l06gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED6AC433C7;
	Fri, 24 Nov 2023 18:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850980;
	bh=SKjSXncmoPJd8CKGNbSF1qApUz614JkRc8r6G2Ocm90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A55l06gDRiUwgrILkewtWZTGm7LWk0PycyzfVrndJOI70D5gHEG0s5af1DH2G1k3H
	 me1iivEvqnjdHY+KcetWvrFMy4Kd/U6JtPPP3vBgBAmYqnj1+/EKQod+7Jt5mNRBNz
	 V3ryyscSyaiG94aoqhoOL5Ugl6pIvfwCqnoF3To4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jakub Acs <acsjakub@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 265/491] mm/damon: implement a function for max nr_accesses safe calculation
Date: Fri, 24 Nov 2023 17:48:21 +0000
Message-ID: <20231124172032.525458608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 35f5d94187a6a3a8df2cba54beccca1c2379edb8 upstream.

Patch series "avoid divide-by-zero due to max_nr_accesses overflow".

The maximum nr_accesses of given DAMON context can be calculated by
dividing the aggregation interval by the sampling interval.  Some logics
in DAMON uses the maximum nr_accesses as a divisor.  Hence, the value
shouldn't be zero.  Such case is avoided since DAMON avoids setting the
agregation interval as samller than the sampling interval.  However, since
nr_accesses is unsigned int while the intervals are unsigned long, the
maximum nr_accesses could be zero while casting.

Avoid the divide-by-zero by implementing a function that handles the
corner case (first patch), and replaces the vulnerable direct max
nr_accesses calculations (remaining patches).

Note that the patches for the replacements are divided for broken commits,
to make backporting on required tres easier.  Especially, the last patch
is for a patch that not yet merged into the mainline but in mm tree.


This patch (of 4):

The maximum nr_accesses of given DAMON context can be calculated by
dividing the aggregation interval by the sampling interval.  Some logics
in DAMON uses the maximum nr_accesses as a divisor.  Hence, the value
shouldn't be zero.  Such case is avoided since DAMON avoids setting the
agregation interval as samller than the sampling interval.  However, since
nr_accesses is unsigned int while the intervals are unsigned long, the
maximum nr_accesses could be zero while casting.  Implement a function
that handles the corner case.

Note that this commit is not fixing the real issue since this is only
introducing the safe function that will replaces the problematic
divisions.  The replacements will be made by followup commits, to make
backporting on stable series easier.

Link: https://lkml.kernel.org/r/20231019194924.100347-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20231019194924.100347-2-sj@kernel.org
Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Jakub Acs <acsjakub@amazon.de>
Cc: <stable@vger.kernel.org>	[5.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/damon.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -626,6 +626,13 @@ static inline bool damon_target_has_pid(
 	return ctx->ops.id == DAMON_OPS_VADDR || ctx->ops.id == DAMON_OPS_FVADDR;
 }
 
+static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
+{
+	/* {aggr,sample}_interval are unsigned long, hence could overflow */
+	return min(attrs->aggr_interval / attrs->sample_interval,
+			(unsigned long)UINT_MAX);
+}
+
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);


