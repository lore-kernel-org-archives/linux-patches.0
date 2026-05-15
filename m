Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3FD3BB12D;
	Fri, 15 May 2026 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862844; cv=none; b=bm3ukt9jZDdqXGWLYfZ9sL7CP475lCkPlQpsRS6j15HbD28NtdL1R+QJLt28/UjE7ttXQF64Upw4fMh4LR6I9qK2G7w5PN+OhfhN7m/omWN/eulomTq90dceBfYON34Pesqrxgwb8IzWvLuggAU1xHGiZ65WUmzAXVcX4aM/cq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862844; c=relaxed/simple;
	bh=VbOA71JAfxhD2Pg5DLsYLtKhOClfE8pQNZVwTFoQrDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCaITvgW6aXM+efn2PMXgJF3QIf60VXomyjYbT2AsUtUlu3zwY7UixATJlEwA4Q8aWpmlpbb0KoObSMmWjGE90KJqJpTBroAV2f7+oAN+RomT2yy6cwB2CFQwoFlTZBIpZ273Ixg5DH0bVTrf16RyMwM1SpAJA2JyGkjOv7bUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLcZ3ePp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLcZ3ePp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7DAC2BCB0;
	Fri, 15 May 2026 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862844;
	bh=VbOA71JAfxhD2Pg5DLsYLtKhOClfE8pQNZVwTFoQrDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLcZ3ePpMI6MEI46lPgbhGyAvrNo5pVq4PS11DQBDlnlXxFzo/VWqAT1KkWgb7QgW
	 dEY0QvFKAKFXBbdeVpfM8dp5TXc9rsaMJoJVhXtBqeFEvULL81EXFqa5spwCTxyesG
	 TEd42Bgw2qvwb5X+yhui/3mILUtifl0LB7pzRdTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 178/201] batman-adv: bla: prevent use-after-free when deleting claims
Date: Fri, 15 May 2026 17:49:56 +0200
Message-ID: <20260515154702.434250002@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


