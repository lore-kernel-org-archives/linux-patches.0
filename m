Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A0F3E00A3;
	Fri, 15 May 2026 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862188; cv=none; b=CYe/KhkkbL7hPloZnlMmmjWQ75PvBZ+zSjz1GU88Jsehulnat/cLDD8gOy6igtoPaGlD4o6ZbkrlvKRqdiK+MZms0TsnhK7KlACRzFrDUQ8es5/34JIE/f4MZQiwim3QjCRkWt827n4Yl5X6zYk9A4mIFU9EcedU4htu5pNZvTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862188; c=relaxed/simple;
	bh=OSgglE8rJE/TvQXRO+YU4zuBwkkYm4QqRimD9HTj4mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ7LxJlBqyRywI4l34KxRFwsv29DX9Mp9wF9q80mQ/9cXL3VNnxG5wqrIih2fR5LkpmIuSsEFyliGa7tmeErEMsEjL5xmkVhWTlFFjcy/9KLHBevTuG8WpZUZ9P0B9HeOjvWnSWYzAl1ZajlPa7Tob/c6Bcygdqahq3kBJz/jlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzdzXHoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzdzXHoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4816DC2BCB3;
	Fri, 15 May 2026 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862188;
	bh=OSgglE8rJE/TvQXRO+YU4zuBwkkYm4QqRimD9HTj4mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzdzXHoXyZQKsgNDzg5mfg2WC2MdY83iY4BH228W6vNVM4pFgiApu98MNkD9F1Vbt
	 M+yrZTnsfSjJv28xsBrzRi1TFGUxqwwm6zVXWH5eEw1Xj46IEiAeE8X5tTbPjPyGJY
	 65nUD9eUaqwoZ83c2zixH/SmvF3oAaVqehUdT9Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 141/188] batman-adv: bla: only purge non-released claims
Date: Fri, 15 May 2026 17:49:18 +0200
Message-ID: <20260515154700.383878863@linuxfoundation.org>
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
@@ -1289,6 +1289,13 @@ static void batadv_bla_purge_claims(stru
 
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
@@ -1314,6 +1321,7 @@ purge_now:
 					      claim->addr, claim->vid);
 skip:
 			batadv_backbone_gw_put(backbone_gw);
+			batadv_claim_put(claim);
 		}
 		rcu_read_unlock();
 	}


