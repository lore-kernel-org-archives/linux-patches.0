Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636083FF1DD;
	Fri, 15 May 2026 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860464; cv=none; b=J1vbgLd4+0Y8I0BhW7hu/9VGIysJJ94phsfvc568iczmCWmdeRTAaSdce+y0fsuxRWyWgHgJ8DyBSXYIob03azm5bIFuMFXhlYjlvZIjlGgEppCexlVRy6SffGvAEV1fUL7G2HB8cCAKH/4yCACU5T6VzunaxbFcAdqe4vO7Vx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860464; c=relaxed/simple;
	bh=CZLuGdEo3ekkcGMrDLtfUhMb/S+XUmVeDofQ9sBpE/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hnw4CiwP6vL7apWWMyOLWafGDhbwu5QTb/GEqZF1aXh4ohuEYUei56Oxwz7P4wwBUUkQAHM+IYseiJRoUC4VzizUTzqpJk2WGC96RajmOtgAkr3FeTYs0qR3VuHhv5VBwRb8hr/TiXpIBP7PGwD8VqysXMJCFV1xuIqyW4hctzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoiyrUnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoiyrUnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB0CC2BCB0;
	Fri, 15 May 2026 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860464;
	bh=CZLuGdEo3ekkcGMrDLtfUhMb/S+XUmVeDofQ9sBpE/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoiyrUnRBOVrUEYpCfICJpbKWolA119+bDOE4sj/RL1RRLUiX1T3Av8NAJqSm0Wse
	 c9YEwbPrh20e0AXgBkE88pKCnqGC9Sv0YWMRnRzTsAiUhd1PhQsloPZdQHVqpWC60G
	 HxSI0Ecj9FvIfiaEtq3yRTDTksilgI9K7fhYmJLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 098/144] batman-adv: bla: prevent use-after-free when deleting claims
Date: Fri, 15 May 2026 17:48:44 +0200
Message-ID: <20260515154655.777525459@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


