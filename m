Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BBF54FA5;
	Tue, 27 Feb 2024 13:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040977; cv=none; b=UvXFHdbnHH+AOEtHCPgkzRC6+ymFfXmwPDCfmZhvHYuzOg8GA1MsEkuymWXmEciwbevF18W3uigBXAYU6AlUKCqrTs/aQH5x7f42UuaF/E/D1qJKaraYQpvW1rEInzvOLcQSbOd1pXODV6HbjmFoVs+9CJMFMDRLa/G5LtYN7NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040977; c=relaxed/simple;
	bh=WtgOI4XETUdvn7lkHJk9+toO1LnURE+j2wEvLRvoBws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nwq7coAbqdNx3OV03OwQAd0TqlJbOvy0BV4TufsdxWKRPITtgZ2iL2Gqsk2QM5oaAR8AOu1HTk6LCsMFpmcfngEIsEOyjDWIm5iIeummK0ky2KsqgXjBnCWEdbQ7p2hh3GQIQ9hh7FBGF4bv0LMZWW7VDF5HrSaaiKz9WfUiZOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIxSkL/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIxSkL/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDBFC433F1;
	Tue, 27 Feb 2024 13:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040977;
	bh=WtgOI4XETUdvn7lkHJk9+toO1LnURE+j2wEvLRvoBws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIxSkL/jVJ4jBa0rO3UlTkJSAysH8MxwXzKUtN+Gss/xHJMn7KSMh+1uETovdZY67
	 TBUkli76BbyAMPKCb0IRIX5ltrqaOVPq2nSL0bfFzXtVVF38a76kFbeVF930SZ6uLt
	 1IS6l5V4CTuIynv2VLFDldJuhhwMPC6XI5r1IovU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 175/334] mm/damon/reclaim: fix quota stauts loss due to online tunings
Date: Tue, 27 Feb 2024 14:20:33 +0100
Message-ID: <20240227131636.208291226@linuxfoundation.org>
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
@@ -150,9 +150,20 @@ static struct damos *damon_reclaim_new_s
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
 	struct damos_filter *filter;
 	int err = 0;
 
@@ -164,6 +175,11 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		return -ENOMEM;
+	if (!list_empty(&ctx->schemes)) {
+		damon_for_each_scheme(old_scheme, ctx)
+			damon_reclaim_copy_quota_status(&scheme->quota,
+					&old_scheme->quota);
+	}
 	if (skip_anon) {
 		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
 		if (!filter) {


