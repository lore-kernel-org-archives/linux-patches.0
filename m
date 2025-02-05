Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F3A151988;
	Wed,  5 Feb 2025 14:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766210; cv=none; b=MHMCYvzA/PLadnfvORDMXMF0ceAiyGePhIOL2vhQV2pUH+nrnRJ64AXk9+kTcCUHNViyOweQWPpZRbQW3fbowo92h+p4+QbJirztHkkcaxkSksKihlemM1HqTuyO/Nb6cmNuXVT19c4zPdvUh9K5RQ0pZUEGk5ocTAkP78dLib8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766210; c=relaxed/simple;
	bh=R6D7pGiWtKmiFN08p6/wsAVrCrjjxVXIkOB29p7ZLOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhDVOBIGy6Qj3XGzlVLveGDrR3HFffvH229qaUiFKIm06eTgQa9e26Sc/SfgqFPmO003ujPuGaTql2VqIm4GgEGTFo8I4wdJQo4jRQ8tNei5qGtnvisvzRhA+bH2YZMwSjapcoTJiE1wCg1EM5txhw81ntwRe8TgtdFTzXbph4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3AtRnGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3AtRnGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9DEC4CED1;
	Wed,  5 Feb 2025 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766210;
	bh=R6D7pGiWtKmiFN08p6/wsAVrCrjjxVXIkOB29p7ZLOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3AtRnGANvnKW3zbSZKiQW6RLcziW8hVr5gIU3LIZfxp5Vuh2Of7ryGooXeuuwOS+
	 QAdJkEp9wbGBoBY1DOrFM/WGRAWfmrJ2JYD5fcZJqS+tlJCRvzxtI4kwQPexii61po
	 BP7mjhMcjROe1CiiFnmQquTwhj7QtK3FXFUUmey8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Breno Leitao <leitao@debian.org>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/590] rhashtable: Fix rhashtable_try_insert test
Date: Wed,  5 Feb 2025 14:40:52 +0100
Message-ID: <20250205134506.639138979@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 9d4f8e54cef2c42e23ef258833dbd06a1eaff89b ]

The test on whether rhashtable_insert_one did an insertion relies
on the value returned by rhashtable_lookup_one.  Unfortunately that
value is overwritten after rhashtable_insert_one returns.  Fix this
by moving the test before data gets overwritten.

Simplify the test as only data == NULL matters.

Finally move atomic_inc back within the lock as otherwise it may
be reordered with the atomic_dec on the removal side, potentially
leading to an underflow.

Reported-by: Michael Kelley <mhklinux@outlook.com>
Fixes: e1d3422c95f0 ("rhashtable: Fix potential deadlock by moving schedule_work outside lock")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/rhashtable.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index bf956b85455ab..0e9a1d4cf89be 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -611,21 +611,23 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 			new_tbl = rht_dereference_rcu(tbl->future_tbl, ht);
 			data = ERR_PTR(-EAGAIN);
 		} else {
+			bool inserted;
+
 			flags = rht_lock(tbl, bkt);
 			data = rhashtable_lookup_one(ht, bkt, tbl,
 						     hash, key, obj);
 			new_tbl = rhashtable_insert_one(ht, bkt, tbl,
 							hash, obj, data);
+			inserted = data && !new_tbl;
+			if (inserted)
+				atomic_inc(&ht->nelems);
 			if (PTR_ERR(new_tbl) != -EEXIST)
 				data = ERR_CAST(new_tbl);
 
 			rht_unlock(tbl, bkt, flags);
 
-			if (PTR_ERR(data) == -ENOENT && !new_tbl) {
-				atomic_inc(&ht->nelems);
-				if (rht_grow_above_75(ht, tbl))
-					schedule_work(&ht->run_work);
-			}
+			if (inserted && rht_grow_above_75(ht, tbl))
+				schedule_work(&ht->run_work);
 		}
 	} while (!IS_ERR_OR_NULL(new_tbl));
 
-- 
2.39.5



