Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100CB18C93C;
	Wed,  5 Feb 2025 14:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766901; cv=none; b=qCaqPvjtrXTdWpYCiCEayDQCBB9kqydJPYmQHAytcBk21bpLOcaDanYeK42g2uL2+ONKm0u6NIisLun8TEp9lBE1v2Plq+L7xm+Yq6P0k6XvU39L9N5JdF/TxxFx+sol68V7c+G8bYq1yJguKTx9f8e+mlrSoB/LktSZdRoSRiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766901; c=relaxed/simple;
	bh=OIsrpz956PQeG8+CsPMbm3+OArnI4oclnT3K5DsRw/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbBlN0fRLNhLSiI6GzMs68/R9Vpdlib22hRYz0GQ8KJTy/szlYO1Jz6eklSiSvD8hQsCFjMev1IH8X1cL0noSlwv/TAhJdqNxjru5rM4XtmlCOTzBwQijOWn7mUhJ5pRgdesjsMLJLPcpgB7usqUXSHSAGbS8sJSvr4nIoZ9LqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03Pibu8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03Pibu8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B98C4CED1;
	Wed,  5 Feb 2025 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766900;
	bh=OIsrpz956PQeG8+CsPMbm3+OArnI4oclnT3K5DsRw/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03Pibu8whMo11vn/pJHN2bZ+AaKDKUNyqoSb0A4DhJARxUOQL1LZgUBPy6kQc+e18
	 eEFt7dKTekpDUFhRIvnHMA+NGSjUoWiPCY1nSlPBAVIIpAmIsG9bmB5oJPE1UKJpBv
	 26bOw78lNm9FmTIrOu9vjEvyW93jbdkO+gQ1wvEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Breno Leitao <leitao@debian.org>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 326/623] rhashtable: Fix rhashtable_try_insert test
Date: Wed,  5 Feb 2025 14:41:08 +0100
Message-ID: <20250205134508.696221382@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



