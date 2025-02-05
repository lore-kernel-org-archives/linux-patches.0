Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD32F1779AE;
	Wed,  5 Feb 2025 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766635; cv=none; b=X+DwzPKq6kH7sLhaN+ofW7ZVEn30nHKIhAQGXsYBJEHB5abtezCdUN7j3QZIxAUP6hYg5/yS+k/MH/5y8YGJ7phfv2pJhWsOP2Z4EqNAe9H6o6SBLYu6mNRo008TiUgSCtgdI5tT0ZjDer7TerwiLC5JUh74jBLzR6qEXE+Bkto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766635; c=relaxed/simple;
	bh=MsTJ0EG+HnCfUE9NvV410ZGAW5WnWUeVaugNduBm7Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vzuo6eMvbYGoXjkmS/NByR88nVvFeYbWcFZ3t2H5HXyq84AGn84VYTDfTjjJs0EXoBdtbU75+vtEiiWD2KJ+Q4V9+47DHHxbu3DTJd5PNSimDmH8UW09Xji8AajLFinoBQt2xinogUXZpb8d4g31DxatZDnLH/jmZ1VIhkb7Xc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlTGZlWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlTGZlWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49051C4CED1;
	Wed,  5 Feb 2025 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766635;
	bh=MsTJ0EG+HnCfUE9NvV410ZGAW5WnWUeVaugNduBm7Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlTGZlWcYuB1lLAsH96M5FZq2nOF+oigigCEd+xtvLu3all1Uum06ugRw8I3Oq/2H
	 qd3SRvZ2kOChXKpb9rwRXOw2y0+hhi6hRI4rXSkpzoFbhTOsys+Y/DkklLNtQ4OtBa
	 PODaYzCdkQafz3dxLi4wzqHoC6zsDTnT/sas2P6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 276/623] rhashtable: Fix potential deadlock by moving schedule_work outside lock
Date: Wed,  5 Feb 2025 14:40:18 +0100
Message-ID: <20250205134506.790342194@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit e1d3422c95f003eba241c176adfe593c33e8a8f6 ]

Move the hash table growth check and work scheduling outside the
rht lock to prevent a possible circular locking dependency.

The original implementation could trigger a lockdep warning due to
a potential deadlock scenario involving nested locks between
rhashtable bucket, rq lock, and dsq lock. By relocating the
growth check and work scheduling after releasing the rth lock, we break
this potential deadlock chain.

This change expands the flexibility of rhashtable by removing
restrictive locking that previously limited its use in scheduler
and workqueue contexts.

Import to say that this calls rht_grow_above_75(), which reads from
struct rhashtable without holding the lock, if this is a problem, we can
move the check to the lock, and schedule the workqueue after the lock.

Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>

Modified so that atomic_inc is also moved outside of the bucket
lock along with the growth above 75% check.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/rhashtable.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6c902639728b7..bf956b85455ab 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -584,10 +584,6 @@ static struct bucket_table *rhashtable_insert_one(
 	 */
 	rht_assign_locked(bkt, obj);
 
-	atomic_inc(&ht->nelems);
-	if (rht_grow_above_75(ht, tbl))
-		schedule_work(&ht->run_work);
-
 	return NULL;
 }
 
@@ -624,6 +620,12 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 				data = ERR_CAST(new_tbl);
 
 			rht_unlock(tbl, bkt, flags);
+
+			if (PTR_ERR(data) == -ENOENT && !new_tbl) {
+				atomic_inc(&ht->nelems);
+				if (rht_grow_above_75(ht, tbl))
+					schedule_work(&ht->run_work);
+			}
 		}
 	} while (!IS_ERR_OR_NULL(new_tbl));
 
-- 
2.39.5



