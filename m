Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719063FD950;
	Fri, 15 May 2026 16:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862186; cv=none; b=DUzbqlcvZ1OXsMA6BfeuOYTlXvJHgpmtKqp7j7WS9CooZLm2Fkbe9R7KINkq0JL4cPTHkGKSCnxJUtXWUEe5iOl2Ww2X4IWM/6gFH7tfeUCSyGuSOh7vU5xQlvtLrqLQd//XbAj5EnwR5szknsgckn5keXAXNx9K1Ru7QXzZSY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862186; c=relaxed/simple;
	bh=RUQDEA9EZy6x7vXoPeh6SZzhWV5aeFYr2nJojgEHJgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp3alZYOt3BZSt9C/9fOpShgT4ne6uvBDHGfpkhK5d4iKeEDAuG9UJbyg8vhVW1p0sIfo1RfdeWMOnCWUCm1pft0ko26QnQdGPqTziTMHHkvodC+kCd4wDHWSn91nhpkyLcyWCrJc83I8U9xTXVfOeCDJGAKnlmPj2mH6fE41AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnZSzaej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnZSzaej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B288FC2BCB0;
	Fri, 15 May 2026 16:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862186;
	bh=RUQDEA9EZy6x7vXoPeh6SZzhWV5aeFYr2nJojgEHJgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnZSzaej9ciycPtUVz+FpGRNJv6qtIeBHlCbm0ozu7tHjCe9QGcxoYwvDLtBjxbTT
	 yoUxp5IrCj6pR0NWkK1A0/tbjKyUWOalL46zO9bZHYwTPx4RqA6GX3V1Nf/Bh4sRiy
	 kaNGRviuDxp945BblZcWvETxt1IQpyxkHZQwQox0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 140/188] batman-adv: bla: prevent use-after-free when deleting claims
Date: Fri, 15 May 2026 17:49:17 +0200
Message-ID: <20260515154700.362957953@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
@@ -319,8 +319,8 @@ batadv_bla_del_backbone_claims(struct ba
 			if (claim->backbone_gw != backbone_gw)
 				continue;
 
-			batadv_claim_put(claim);
 			hlist_del_rcu(&claim->hash_entry);
+			batadv_claim_put(claim);
 		}
 		spin_unlock_bh(list_lock);
 	}


