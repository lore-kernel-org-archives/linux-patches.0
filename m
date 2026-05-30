Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4044320CAD;
	Sat, 30 May 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163842; cv=none; b=KsSCBMLPA4oczuS2poCIsk6PQK2/BObmyvH3DcUQfE6uBB9VsA2odBUvMaw0S0pf8ClPsoXAATu4CD+bdzX9lgv5GWwIMO1zeWPuF0FH0TAGtQB1UEdMzmvb4U00y2mh33ePl1KxKeISMs3TdWy+WSCnrfFVGqjtvyrS/+JSHKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163842; c=relaxed/simple;
	bh=XJvwSbSJ90F3e8vn0b5C8hSjngoDMxTOoX1ItGmLQ7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhwK1TJe0QD1tN9lAdM4+h8neksX7P2lwupD0rLVDJtq4UELBWrfWET3iUOqVTtSSToBJl72rNyAq84hDmHiZoqokX742L2wpOCMbefiuFmCSmaohcRqnVynms43UIa4bK5mQtxT0qVh+jEVrCN8A2R55fqaXS9ep7Uqa3Xd8IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Atv1bO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Atv1bO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060581F00893;
	Sat, 30 May 2026 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163841;
	bh=SEtebZvbyzFW6JNdCpufAYPbPRkCdODJTACic6QcLzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Atv1bO5Viar0Pxzj8UJ4jRoMn5cF2R8OxkQuJJNG7o0uM3sL1YIwOpj0amc+7clD
	 76IqLy0vsrvFGZdHAHOYVOZiTeyERN2pQUmKuRwH06ejkicFOz+z1LSp2zn69dEK3Q
	 MQt9qit5Z7ZFZeF78t41RZmGInSe7JS4swrio04c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 378/776] batman-adv: bla: only purge non-released claims
Date: Sat, 30 May 2026 18:01:32 +0200
Message-ID: <20260530160250.293614831@linuxfoundation.org>
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
@@ -1287,6 +1287,13 @@ static void batadv_bla_purge_claims(stru
 
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
@@ -1312,6 +1319,7 @@ purge_now:
 					      claim->addr, claim->vid);
 skip:
 			batadv_backbone_gw_put(backbone_gw);
+			batadv_claim_put(claim);
 		}
 		rcu_read_unlock();
 	}


