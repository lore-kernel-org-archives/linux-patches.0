Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D113B2B4;
	Tue, 27 Feb 2024 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043658; cv=none; b=IWC1ntQJ/ufchAaNNt00uOuJ3l3Pp0OPsedA91uUI9/RYh5UyDHZPZzAo/yifYgEZd/oSvBxCaI2qEOmHCnNYRV7E66N04tcMsM/8vr2jMMM6MGyy+C34RQCeaScHiedIy20xeKpQI69P9yxsyHm+s9K2vP3wKj23ie1yiZJzdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043658; c=relaxed/simple;
	bh=ZmMJJIFA6UX1zwNUNX9CTZ/joB47QhafLSgbPOR08Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1a7BK8iivkmGlFjSJn0/mFvwVa3bifEY4dWuGoQ8oIUXtdMHBMF6XpXwfYrtYZUgRtXTW4fB2DhaXTSfTHRwEBGErpJvqOg0ESq06ifQs3ATbTWRkU1bNoZTjp+L6cQJL2U1BUIpS61hoVU0b3AQR6vr3FcoQ7tYIX0FWI5Emo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ6o42LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ6o42LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8FAC433F1;
	Tue, 27 Feb 2024 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043658;
	bh=ZmMJJIFA6UX1zwNUNX9CTZ/joB47QhafLSgbPOR08Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZ6o42LUVJm0H+9MnrfZdLDCXWR++8GLGMUqEzD/B+2SSvDNFX12dlpn3nKNlgiw2
	 E1244jSV0kjakXYtx36VpMFjyMt+pKhVp78vq5ze0B23uULgLCI+5dZqOmEPy7HB6S
	 sAgqnanB/fzhI4dDeDtranEu1Bgs0BimTIeetc64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 187/195] mm/damon/reclaim: fix quota stauts loss due to online tunings
Date: Tue, 27 Feb 2024 14:27:28 +0100
Message-ID: <20240227131616.573533752@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 1b0ca4e4ff10a2c8402e2cf70132c683e1c772e4 upstream.

Patch series "mm/damon: fix quota status loss due to online tunings".

DAMON_RECLAIM and DAMON_LRU_SORT is not preserving internal quota status
when applying new user parameters, and hence could cause temporal quota
accuracy degradation.  Fix it by preserving the status.


This patch (of 2):

For online parameters change, DAMON_RECLAIM creates new scheme based on
latest values of the parameters and replaces the old scheme with the new
one.  When creating it, the internal status of the quota of the old
scheme is not preserved.  As a result, charging of the quota starts from
zero after the online tuning.  The data that collected to estimate the
throughput of the scheme's action is also reset, and therefore the
estimation should start from the scratch again.  Because the throughput
estimation is being used to convert the time quota to the effective size
quota, this could result in temporal time quota inaccuracy.  It would be
recovered over time, though.  In short, the quota accuracy could be
temporarily degraded after online parameters update.

Fix the problem by checking the case and copying the internal fields for
the status.

Link: https://lkml.kernel.org/r/20240216194025.9207-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240216194025.9207-2-sj@kernel.org
Fixes: e035c280f6df ("mm/damon/reclaim: support online inputs update")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/reclaim.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -141,9 +141,20 @@ static struct damos *damon_reclaim_new_s
 			&damon_reclaim_wmarks);
 }
 
+static void damon_reclaim_copy_quota_status(struct damos_quota *dst,
+		struct damos_quota *src)
+{
+	dst->total_charged_sz = src->total_charged_sz;
+	dst->total_charged_ns = src->total_charged_ns;
+	dst->charged_sz = src->charged_sz;
+	dst->charged_from = src->charged_from;
+	dst->charge_target_from = src->charge_target_from;
+	dst->charge_addr_from = src->charge_addr_from;
+}
+
 static int damon_reclaim_apply_parameters(void)
 {
-	struct damos *scheme;
+	struct damos *scheme, *old_scheme;
 	int err = 0;
 
 	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
@@ -154,6 +165,11 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		return -ENOMEM;
+	if (!list_empty(&ctx->schemes)) {
+		damon_for_each_scheme(old_scheme, ctx)
+			damon_reclaim_copy_quota_status(&scheme->quota,
+					&old_scheme->quota);
+	}
 	damon_set_schemes(ctx, &scheme, 1);
 
 	return damon_set_region_biggest_system_ram_default(target,


