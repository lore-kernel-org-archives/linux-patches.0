Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE66351C2F;
	Sat, 30 May 2026 18:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166266; cv=none; b=nc9dVOIIG7nweF3jMYZJFHh+nbafSme2MIRaw8/RoFFK6vtn4J/7ViP81ZN+ZBSljeIVrnmr+NwrnjnyEmF8+/J/5Z97x2WFsujJTYnzPLbJ/txCHKMW0nZ2OjQBdsylRzye94bNlJmWkskt7pVIMFPu6leUypC2VXYTarZ7owY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166266; c=relaxed/simple;
	bh=VskPk6ANNaTqDUn8T4hUAC7g9AWMtfjXlLs92elAzVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjxWYxUKBlJKAKzFosLqPRMNXwyxOvi+YBCMAgk/GajI4UOA/ddpSsTQr+oN+PtLhqK2XzF8qhsKiQsCwjK7CSIzHXu4Ocff9dTOdAaVBONBaPF0MXLUZ5c+QZHzaI9kz3iyIT4z+Rqk5MPdKcHAOKzvZLOCHXz26eGMdtidQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqV/9i/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqV/9i/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2B91F00893;
	Sat, 30 May 2026 18:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166265;
	bh=V2TQnAnX3UK4ZvoKFwRRMnxhBJeTZLo5nPivHxgf+EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqV/9i/+dznQ9RQhwgLZ+hdkWRFz+sKa9bMWnuII9Py6L+S0T/0++aq5Z3bz9RZjY
	 9D3xcytLr1zAY0+738OA3dUBJ0Z+ATfpRXVS6CGagiBBH9ca1SqE0IRUjDMdUbIHub
	 kDNRC/xqOl8SreeV/G0VZIEnQ+PXAzOlbewj+TEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 284/589] batman-adv: bla: prevent use-after-free when deleting claims
Date: Sat, 30 May 2026 18:02:45 +0200
Message-ID: <20260530160232.416368032@linuxfoundation.org>
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


