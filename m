Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644463DC4D5;
	Mon,  4 May 2026 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903349; cv=none; b=UbZlo/V6OM6+qaZREm6t/x/Rn6wRmP6fO+sqTFa55Q6CKVbyC6tat3Em9ZS+Gz5uf+MWw+Ii5WkkdE/jAYIUZEoKjjCzbl1nX+axLXCbBnXQQTi8GtqZhKeA06PVDi/dp9LTAXlwrDnDwt5P6t+rtMM0qrutgoGbcEfrP8IvC3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903349; c=relaxed/simple;
	bh=hubszamThfgzugtqr01j8oeEuQreQrAMdQpqpCAV2r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYF9mmWhN/5iXNiMse/Sp5TbHHvtkszo5o3HQtAi3vPIFHpzWtkeRIGvj2zw6LVpehXVqMk48TJrDdOLPcMGlsMf2v//eVouPAKzpz2nneGsAOwrJ5qn7I23StnxVs5TWKW/Ho20i/Q6eTiQvdcEiyLUcC9nfdsryWcqsJPdVVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/aaKjQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/aaKjQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E0BC2BCB8;
	Mon,  4 May 2026 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903349;
	bh=hubszamThfgzugtqr01j8oeEuQreQrAMdQpqpCAV2r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/aaKjQ0jTNF0PGoO0dJIRQ51aVG+zCa48IFycN0TvmBGNIFa8YbadazYKRraHLij
	 olpmm2hwbC8sgvMMDjHABomB949o0LH96/7Sfj6UEiSSzlrfw2sxe56v4epJwsuPNE
	 KOvI01z1evNO8YTmeZnpUd86GWgGpDTjmkJnakOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 198/307] mm/damon/core: disallow non-power of two min_region_sz on damon_start()
Date: Mon,  4 May 2026 15:51:23 +0200
Message-ID: <20260504135150.333182529@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 95093e5cb4c5b50a5b1a4b79f2942b62744bd66a upstream.

Commit d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region") introduced
a bug that allows unaligned DAMON region address ranges.  Commit
c80f46ac228b ("mm/damon/core: disallow non-power of two min_region_sz")
fixed it, but only for damon_commit_ctx() use case.  Still, DAMON sysfs
interface can emit non-power of two min_region_sz via damon_start().  Fix
the path by adding the is_power_of_2() check on damon_start().

The issue was discovered by sashiko [1].

Link: https://lore.kernel.org/20260411213638.77768-1-sj@kernel.org
Link: https://lore.kernel.org/20260403155530.64647-1-sj@kernel.org [1]
Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1368,6 +1368,11 @@ int damon_start(struct damon_ctx **ctxs,
 	int i;
 	int err = 0;
 
+	for (i = 0; i < nr_ctxs; i++) {
+		if (!is_power_of_2(ctxs[i]->min_region_sz))
+			return -EINVAL;
+	}
+
 	mutex_lock(&damon_lock);
 	if ((exclusive && nr_running_ctxs) ||
 			(!exclusive && running_exclusive_ctxs)) {


