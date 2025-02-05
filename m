Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2B61519AF;
	Wed,  5 Feb 2025 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765817; cv=none; b=smPzbGAEm/DYGymRr2f9ghS9NmlTQelJGP44nDDu4B1ir0Z+Wizp6D8U7uW8TjmRolVVhS9Z8FMSNvTIl/u05pR019TUk1rN9RuRozAV1eArXNzFacEeCqa9UEwZ8an012AWu33aq6fXPv7vEvSR/whcTVNUYgakvIPlnOQoT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765817; c=relaxed/simple;
	bh=1j6mDns2GoaBzU4vCJOmYgZh3AInNrWQxXJDPqjRaP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6c5HPojNvveXN132/eSwLwv2T6bbpjqjPGRl1u06LXk/Zoy1rarr5KwjKqJ/DPSzkJP4gBGkOiOUhEN7HXm1nbHk9SkbiWdW4l+FlN/fti5o404php270V/HCGMNyiMh7xsSq4pA9r7sB9dcqbNRmqRnrf/3a0M0xCMPm01eRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/l58/pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/l58/pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF532C4CED1;
	Wed,  5 Feb 2025 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765817;
	bh=1j6mDns2GoaBzU4vCJOmYgZh3AInNrWQxXJDPqjRaP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/l58/pQFOc4dWgENSDmAz1cR7TnbeGepS2dkEN690I2HpEHmEgQssm+ZFMJSr0SE
	 d5gHn3WKYRe3PiSsWxEZH4wfoxdMPYiHElgObaG6STrm8ZfLI969DiN4kgYKlJvNtE
	 l5RRN63z8WXKZHZmJ778sPlDaK2ZqaCvqdeMmEcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/590] rhashtable: Fix potential deadlock by moving schedule_work outside lock
Date: Wed,  5 Feb 2025 14:40:13 +0100
Message-ID: <20250205134505.149929023@linuxfoundation.org>
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



