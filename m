Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974C13368AE;
	Tue, 17 Mar 2026 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768535; cv=none; b=bFvyfgqYaBTuNUkzXRyK0vu18Ovk1EFnFnFG+DRYZhvsHfM2gWbfJlk288/jcaw5wWDov24IShSqVQreJ4liETL7A+YbjT53aCQQaZnBoxzu0L49jCd5/KLXHPDSatdW116Zco9dCMYJkbGkkWijxW1hMSMJe77k6fLxWrXDGqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768535; c=relaxed/simple;
	bh=HIoGqXYkmGd1YhxQ7UuzB7MRFbdD0To6as+5s3Ccp2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h41C8kUPg7gMaWq8m2BFEeDzy8O1VjXKveThOQE5FF6kxZXdU/jrbSLq0JoHMV0qynDinMDRVbdYlG+Ow1tPLcWaw9j9hivupBFDWoIPnvIpJi4crmGDe/9kdAcS4m1hxMLkF16stW3kxnOwMRddTgYF3zpeimsftoBcx0h+Lbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwCzk9CU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwCzk9CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB367C19424;
	Tue, 17 Mar 2026 17:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768535;
	bh=HIoGqXYkmGd1YhxQ7UuzB7MRFbdD0To6as+5s3Ccp2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwCzk9CUjU1XerflVvGQbjApsVZaClxFmCPvboI1xwR1OLWoi3b6rGecrRjmKshjZ
	 U+EaK5hqgn4JrPbtX5OJJjgIFdzH8nr2qMQWYH51BF1OcEK+UJstZvU0/MyFG0gEs0
	 mkyodDFpAlZlMTLHdYSGs/c+CuCK6/XJQ+vw+6H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 333/333] mm/damon/core: disallow non-power of two min_region_sz
Date: Tue, 17 Mar 2026 17:36:02 +0100
Message-ID: <20260317163011.756447728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

[ Upstream commit c80f46ac228b48403866d65391ad09bdf0e8562a ]

DAMON core uses min_region_sz parameter value as the DAMON region
alignment.  The alignment is made using ALIGN() and ALIGN_DOWN(), which
support only the power of two alignments.  But DAMON core API callers can
set min_region_sz to an arbitrary number.  Users can also set it
indirectly, using addr_unit.

When the alignment is not properly set, DAMON behavior becomes difficult
to expect and understand, makes it effectively broken.  It doesn't cause a
kernel crash-like significant issue, though.

Fix the issue by disallowing min_region_sz input that is not a power of
two.  Add the check to damon_commit_ctx(), as all DAMON API callers who
set min_region_sz uses the function.

This can be a sort of behavioral change, but it does not break users, for
the following reasons.  As the symptom is making DAMON effectively broken,
it is not reasonable to believe there are real use cases of non-power of
two min_region_sz.  There is no known use case or issue reports from the
setup, either.

In future, if we find real use cases of non-power of two alignments and we
can support it with low enough overhead, we can consider moving the
restriction.  But, for now, simply disallowing the corner case should be
good enough as a hot fix.

Link: https://lkml.kernel.org/r/20260214214124.87689-1-sj@kernel.org
Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org>	[6.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ min_region_sz => min_sz_region ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1236,6 +1236,9 @@ int damon_commit_ctx(struct damon_ctx *d
 {
 	int err;
 
+	if (!is_power_of_2(src->min_sz_region))
+		return -EINVAL;
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;


