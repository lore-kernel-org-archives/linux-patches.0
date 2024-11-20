Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81D21C9DF9;
	Wed, 20 Nov 2024 13:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107631; cv=none; b=ox+wP7nrMCfbnZSb0bDMkTZj4jCGZU7fEi1lxyyV1bUSQZoqAgOAWIkdMBZHzxOENp4GuC4tpvHe1ZXcE6GLukqgEcIPqfFhZkgB/1Bf2QBw4DT2NU7UBOSPSQ4Rc6zulCcoJrNA5aWgcppqo6vKBsegXtiQk/tKNMe1OwD7A4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107631; c=relaxed/simple;
	bh=epaCY/4Bu5kPewWLzPJ7HtM/xyfUO0cTSx2rR+9ZmLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+siWMFcJVgYc88Or5NS5Tt8SySA/g1+pDRIf9wnfQY0JA8hjmQOWEJnJ/nH4OP0OJzqM/1Fy8IVMesl5ZBGbe1k6fvPtsTVi5MoMeS30hRNnaKGsa5rxDT3FMtR/ruQogZ9hXdPrNo6oPuBNv5BOdNAIzWg8By1dbYdmaXhFCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ak9RqIQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ak9RqIQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985B8C4CECD;
	Wed, 20 Nov 2024 13:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107631;
	bh=epaCY/4Bu5kPewWLzPJ7HtM/xyfUO0cTSx2rR+9ZmLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak9RqIQYY2S7huwRcvM5gq8a0bFVmWO5594fzZ0tdx/k0cLVupQa/ubPX9q/lvz7w
	 1pkVJJUoLYC2U4h9mvK2VnachQD/eV7V+VULTCtqRR+I4yc6hp0SA9OCNzSaoik0Fe
	 kcAmHWvNe3xP/RK1ie5xkl6TVesM9/3axNv2BejM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 82/82] mm/damon/core: copy nr_accesses when splitting region
Date: Wed, 20 Nov 2024 13:57:32 +0100
Message-ID: <20241120125631.465852682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 1f3730fd9e8d4d77fb99c60d0e6ad4b1104e7e04 upstream.

Regions split function ('damon_split_region_at()') is called at the
beginning of an aggregation interval, and when DAMOS applying the actions
and charging quota.  Because 'nr_accesses' fields of all regions are reset
at the beginning of each aggregation interval, and DAMOS was applying the
action at the end of each aggregation interval, there was no need to copy
the 'nr_accesses' field to the split-out region.

However, commit 42f994b71404 ("mm/damon/core: implement scheme-specific
apply interval") made DAMOS applies action on its own timing interval.
Hence, 'nr_accesses' should also copied to split-out regions, but the
commit didn't.  Fix it by copying it.

Link: https://lkml.kernel.org/r/20231119171529.66863-1-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1215,6 +1215,7 @@ static void damon_split_region_at(struct
 
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
+	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }


