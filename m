Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF8D3BBA1C;
	Wed, 21 Jan 2026 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020488; cv=none; b=AkMzeruUtkvY1ZS0f0v1sRgbYeZ7kDqBVuRakKDs4XQ9AkMjrxyNcnsscg31e2NDNNCH7g2hnksV+1sradAMxaG27EIltfCx4pee1I6Y7+AYgW2EsmdZiPfwj6qgcErSM2fho1YCQFOOhypaEwXihREr58kwbhon0hwOoFIv/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020488; c=relaxed/simple;
	bh=vHEuC775ivhvC1MhgytT1Poij3J6NDmXm3xAPBw5VrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZXDgiDZkzftYifHadtTvGj+yGVAAvCYD30EdHJnVwLLPM0RGQurCkyQLC5IZwiQj7Qzv0YmAF7ReOgqoUX+0URwtkb0wPXk35jcGgARF7JvWrQbOgY1+/w/ym1yT7wrsjR+nT7P1Z5uglQVhHVjCsIa4hv4QKWE2twPjPGm1VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqpLI/6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqpLI/6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA6DC4CEF1;
	Wed, 21 Jan 2026 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020487;
	bh=vHEuC775ivhvC1MhgytT1Poij3J6NDmXm3xAPBw5VrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqpLI/6/4hJ0aTCzqH7akHSR4I3oopPgCVwXbIpSN9wwFvAq7kR6fWRjnJLXZmgYa
	 RfqtOyMIcpmDO2TroMV65tTBwkwJcm9fQdiujL6OSH8oev2BpuIZ6DrQq+98pTRI99
	 XFZa6taagC4/fzCKzBdYs6PuxtoZFgI5794XX5wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Butsykin <pbutsykin@cloudlinux.com>,
	SeongJae Park <sj@kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 140/198] mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
Date: Wed, 21 Jan 2026 19:16:08 +0100
Message-ID: <20260121181423.582986342@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Pavel Butsykin <pbutsykin@cloudlinux.com>

commit 590b13669b813d55844fecd9142c56abd567914d upstream.

crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
only for NULL and can pass an error pointer to crypto_free_acomp().  Use
IS_ERR_OR_NULL() to only free valid acomp instances.

Link: https://lkml.kernel.org/r/20251231074638.2564302-1-pbutsykin@cloudlinux.com
Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside the lock")
Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -787,7 +787,7 @@ static int zswap_cpu_comp_prepare(unsign
 	return 0;
 
 fail:
-	if (acomp)
+	if (!IS_ERR_OR_NULL(acomp))
 		crypto_free_acomp(acomp);
 	kfree(buffer);
 	return ret;


