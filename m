Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2016E176AD7;
	Thu, 15 Aug 2024 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731221; cv=none; b=gbfMJM3HKJ+oKDrwdNOjbnC77khAwn/sCPIDWXUAt3nCJJmn/nYsty6RDlTYPvgxxe3y9YMrS57QxHBeioZr/DgJEyfSONh3Q+iiK47cEs7suFsOpNAeml0nb3LVouOU3NM4K8/g3tw2ZPZm8S95W5SDAw649cvL9u9x60xZwo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731221; c=relaxed/simple;
	bh=kAU7IqNFO9G4g2XaPreZ2SXOi8/oNHi2B0xdLNt5P1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OW/uUUv2rLlLxSSNt28TOWH+6w7acuk1NPcN2mDLqDs/wTinF0oJ4ypG1QC/tFvUossmLINICpwdEYUN+t3c8s+oa09VZuzlUgnhHcwUZCGODwyaapuxfJENY4wYWRAK1KT9h8XT3IVLWNQPvREfEomap//RejCcf8jK0smSRAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzgxqhIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzgxqhIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E6DC32786;
	Thu, 15 Aug 2024 14:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731221;
	bh=kAU7IqNFO9G4g2XaPreZ2SXOi8/oNHi2B0xdLNt5P1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzgxqhITfbOt05VuKq/N03QoC+5WGawAOkT7JfpHEc/kFofhhSoytIcN+IoHh9DoX
	 a7dn8v3RG3Pg0LDcM3gzf+Eqh7UNW0rESD+tSyF0Ik7wbp07NB2EnCEc80v9T+HHFV
	 oLDJFUQ9jSYMP7TAvHja+C/8b2OCCBxbUebB1LBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/259] perf report: Fix condition in sort__sym_cmp()
Date: Thu, 15 Aug 2024 15:23:12 +0200
Message-ID: <20240815131905.089640790@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit cb39d05e67dc24985ff9f5150e71040fa4d60ab8 ]

It's expected that both hist entries are in the same hists when
comparing two.  But the current code in the function checks one without
dso sort key and other with the key.  This would make the condition true
in any case.

I guess the intention of the original commit was to add '!' for the
right side too.  But as it should be the same, let's just remove it.

Fixes: 69849fc5d2119 ("perf hists: Move sort__has_dso into struct perf_hpp_list")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240621170528.608772-2-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index baf73ca66a2bd..d2d149966acc8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -269,7 +269,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	 * comparing symbol address alone is not enough since it's a
 	 * relative address within a dso.
 	 */
-	if (!hists__has(left->hists, dso) || hists__has(right->hists, dso)) {
+	if (!hists__has(left->hists, dso)) {
 		ret = sort__dso_cmp(left, right);
 		if (ret != 0)
 			return ret;
-- 
2.43.0



