Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928D6320A32;
	Mon, 27 Oct 2025 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593420; cv=none; b=V778zJJGg7c5r79b/gxgijLjE7TgqodbzYOmg6IiNTucE46V8e4ejjxaFard3Qt5PPAg9/TwkOBQ8m+4lZGhNQM8nfLtXA+4FqSyzO6R4wzb/ifryOWkojqB0KPrCBAlckbzysQKo+35rqQU7Q/GFXuSIY50bbNX3txhc5Y+WGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593420; c=relaxed/simple;
	bh=LNIftH30L7BDeZcAhu8og8X8hX/vRDGIn2ysU2GjeHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaH/J3rLspBL4CrFu5/1e2kzocPCaUKLTJX+w69KCJrYJTMWUhUsLbJPx8t5a/K+Q6wmWR3W51Hu5NNTZpfvGfQYtyEZr/HGL/+NWkpSG5y70SHWzgVag99HY01NxMTxPvJffh0jDkL0GXFaCyoVzX0oEad3UeXcO0s7MahUBiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tL5EjXdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tL5EjXdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B771C4CEF1;
	Mon, 27 Oct 2025 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593420;
	bh=LNIftH30L7BDeZcAhu8og8X8hX/vRDGIn2ysU2GjeHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL5EjXdUgmyjnlLcmEWUsUUwEFNPLBShWFMrVaqg6NVgZmX/aWOWadHGVGxk8idbG
	 cpbuWsmXYu/pZWNybqXZKozstC8lMoumakTwDaDYO7L6wn4g/SOylUYFIZBOIHICdy
	 TgKfvt0EcSn53UUmUw2ezVcO0KL9f+lz5yh/lYxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enze Li <lienze@kylinos.cn>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 111/184] mm/damon/core: fix potential memory leak by cleaning ops_filter in damon_destroy_scheme
Date: Mon, 27 Oct 2025 19:36:33 +0100
Message-ID: <20251027183517.917382127@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enze Li <lienze@kylinos.cn>

commit 7071537159be845a5c4ed5fb7d3db25aa4bd04a3 upstream.

Currently, damon_destroy_scheme() only cleans up the filter list but
leaves ops_filter untouched, which could lead to memory leaks when a
scheme is destroyed.

This patch ensures both filter and ops_filter are properly freed in
damon_destroy_scheme(), preventing potential memory leaks.

Link: https://lkml.kernel.org/r/20251014084225.313313-1-lienze@kylinos.cn
Fixes: ab82e57981d0 ("mm/damon/core: introduce damos->ops_filters")
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -451,6 +451,9 @@ void damon_destroy_scheme(struct damos *
 	damos_for_each_filter_safe(f, next, s)
 		damos_destroy_filter(f);
 
+	damos_for_each_ops_filter_safe(f, next, s)
+		damos_destroy_filter(f);
+
 	kfree(s->migrate_dests.node_id_arr);
 	kfree(s->migrate_dests.weight_arr);
 	damon_del_scheme(s);


