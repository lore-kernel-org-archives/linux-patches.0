Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A459320CAD;
	Sat, 30 May 2026 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163836; cv=none; b=uxG//CJkaM+aamf2o2P+7/3KXG5XkF0J4g8t36ndEaUg5vBQNHpXTsgeiqUzpKPBiPzkf+fDDoD08ENIyW2MonR9exU9XnV2rBh1uhRHBe/+4UGZAjsNnGob41PEQNSGLS+q7KQpjfcKqsC2XiGn7REv4GYxtv+G2cGxQ1N1eXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163836; c=relaxed/simple;
	bh=lOrTRytc/JyO8CJhQ9K+M5EfZltPqQGQ4og6MzUPLBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=An4TUybqumG8bn93yzJFpSqfkecWoM1ZMIhfi2DxKPSRSxT0fEW+SmTSVxfjJ1aPUZy4hk79uotbA2jFHaUqkFRtpFbO3SmO+UZZB5WFVD72910sW/HCnBcNmZ0ATGD4afSdDkuDS0ME+bCWQK3Qzpmru2MmCDBO1we1EgGDgnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNb2QHBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNb2QHBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FCC1F00893;
	Sat, 30 May 2026 17:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163835;
	bh=7na267rn0YpjKccYbukGkjwC3vivoAz7x4AYG/eoChw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNb2QHBVRbUkkAf1m2Nd9Xl+Ea0x1RQOYzp+0pZeTsfRy3chJHI7ovjKprONdPPJW
	 4chPood/qqM7R6dtNznJUEgjV1kGn172gym2TDQJ7+O+NkliXl6NTMJZSp608KRm23
	 P5/0VKIeKbpEkD63/QUb67A2HlGtMbKupE1iuFYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 377/776] batman-adv: bla: prevent use-after-free when deleting claims
Date: Sat, 30 May 2026 18:01:31 +0200
Message-ID: <20260530160250.270477879@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 4ae1709a314060a196981b344610d023ea841e57 upstream.

When batadv_bla_del_backbone_claims() removes all claims for a backbone, it
does this by dropping the link entry in the hash list. This list entry
itself was one of the references which need to be dropped at the same time
via batadv_claim_put().

But the batadv_claim_put() must not be done before the last access to the
claim object in this function. Otherwise the claim might be freed already
by the batadv_claim_release() function before the list entry was dropped.

Cc: stable@kernel.org
Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -317,8 +317,8 @@ batadv_bla_del_backbone_claims(struct ba
 			if (claim->backbone_gw != backbone_gw)
 				continue;
 
-			batadv_claim_put(claim);
 			hlist_del_rcu(&claim->hash_entry);
+			batadv_claim_put(claim);
 		}
 		spin_unlock_bh(list_lock);
 	}


