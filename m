Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C95B3AE18D;
	Sat, 30 May 2026 18:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166270; cv=none; b=S5AbILaemZ3NOfkIRU49f7B8SZ5U0YYERRFYRc7aCNiOKE8C2XHvEWWxBltHCGLbpTC2SRMcYFuZuCT5WjxCKF5LxecX1NxTN0tHRSYfCpmvDWFzr32lH/ZXbOQDceos2T5O6KMRS1QuEdnfIQkWbgAsZkHplEjX574+2w/6zsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166270; c=relaxed/simple;
	bh=MkREfWV7dlmHt27KNr0T5Up68lDL+2gusEayWShlehI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KslupWdL8kTnVrfAbq75/rRUB2yc2pEbSKnVXcu5vwZQopOiiJOaQCXl5ObwNkGYWv64ENEXs6UeI62qRGH4oG3YvKol3gom5zLQpoTJeoGbjG+OOkUPW/a3+wEn2r0oNswbWX+qwlGWbA+yJI36NVnavsOnMLvA4Q2QQiWdVGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0ZErtGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0ZErtGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9805D1F00893;
	Sat, 30 May 2026 18:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166269;
	bh=RWHrVXpohlirdjFV1MgjdKMvo7TtWavlfax3BXO1E10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0ZErtGqo9z02Ws/rZTKE4UVRuuLYgmLiwpsluk6D9NPqWwsTPmoff5ctDUCrHcN8
	 yGxNVtQmJ2ufP7kn1iM+yatruYPD8xnIikyTO5NjsZFcofRl2AP6dFYhUSivtVqCSa
	 hnJ3dw+HyQOcUYEBQPO1JGhUsQAWrptQ4sW9c+qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 285/589] batman-adv: bla: only purge non-released claims
Date: Sat, 30 May 2026 18:02:46 +0200
Message-ID: <20260530160232.442475613@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit cf6b604011591865ae39ac82de8978c1120d17af upstream.

When batadv_bla_purge_claims() goes through the list of claims, it is only
traversing the hash list with an rcu_read_lock(). Due to a potential
parallel batadv_claim_put(), it can happen that it encounters a claim which
was actually in the process of being released+freed by
batadv_claim_release(). In this case, backbone_gw is set to NULL before the
delayed RCU kfree is started. Calling batadv_bla_claim_get_backbone_gw() is
then no longer allowed because it would cause a NULL-ptr derefence.

To avoid this, only claims with a valid reference counter must be purged.
All others are already taken care of.

Cc: stable@kernel.org
Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1293,6 +1293,13 @@ static void batadv_bla_purge_claims(stru
 
 		rcu_read_lock();
 		hlist_for_each_entry_rcu(claim, head, hash_entry) {
+			/* only purge claims not currently in the process of being released.
+			 * Such claims could otherwise have a NULL-ptr backbone_gw set because
+			 * they already went through batadv_claim_release()
+			 */
+			if (!kref_get_unless_zero(&claim->refcount))
+				continue;
+
 			backbone_gw = batadv_bla_claim_get_backbone_gw(claim);
 			if (now)
 				goto purge_now;
@@ -1318,6 +1325,7 @@ purge_now:
 					      claim->addr, claim->vid);
 skip:
 			batadv_backbone_gw_put(backbone_gw);
+			batadv_claim_put(claim);
 		}
 		rcu_read_unlock();
 	}


