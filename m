Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A042690D5;
	Sat, 30 May 2026 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160730; cv=none; b=ASqRxrvCBuEENTy6hCJ8T3mmifm8CRaB5RPR2nBaIGV8T1KF+SndaowAhb9M2HvQA3WOrBk9G7UnXBDYNPjhL/Y80yasQAD67kKJD+Hj5bWWBENJvizx6ceG8Vw7ONKUvuytHgNKs5S3yJQO3h02WjtdtbM26bObODajUPiZzug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160730; c=relaxed/simple;
	bh=euWPhgmuy+a/6GnvU8059hwV+4OPJpXuA4lKmLDHAPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjL8Hk9Hn48MVFoGgcE6VfQ6h8ZkzXxg7OoBk4xCvYK+EYLjSESaqgsVdjLZDpaHxIZ+JvGO35bIWU2e6wp9CDNFRPuDPL5chOHRv3rka51XE2mJFXBwY+r8GOiA6zcq8Bi2KwM2fUw4lcvfsiBAQ0XSGEfkZ5F3BkBK98Tjbeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBUz/fsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBUz/fsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162511F00893;
	Sat, 30 May 2026 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160729;
	bh=KdDT6HFsSup8NyHhQYE0+hAaI5SEqm6/0nO5XcExtFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBUz/fsvGSF6mmSBzHrSGlyF6hXaG1fnQs233Iw7vHUb35tfb94bkD2dX+YJkaLBn
	 fbBgU1qvA/u2yoz/tvd6o5MRe4kzjQniAFczZbKm+lV4RHWxI8QdXZayIIXxYaXHnF
	 iDsZGe3m6JDQdOn1vPYNzm7+8F19RZiQXJ2wEqKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 419/969] batman-adv: bla: prevent use-after-free when deleting claims
Date: Sat, 30 May 2026 17:59:03 +0200
Message-ID: <20260530160311.839716976@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -318,8 +318,8 @@ batadv_bla_del_backbone_claims(struct ba
 			if (claim->backbone_gw != backbone_gw)
 				continue;
 
-			batadv_claim_put(claim);
 			hlist_del_rcu(&claim->hash_entry);
+			batadv_claim_put(claim);
 		}
 		spin_unlock_bh(list_lock);
 	}


