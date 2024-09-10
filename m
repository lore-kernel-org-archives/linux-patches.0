Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103F414B06C;
	Tue, 10 Sep 2024 10:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964294; cv=none; b=iWKAJuoMSzRevsPU2z88QxFY2AGD6mdOjh5aZFSEzUDVCg/E8TvaM4tqkOJXpUGMyv/7J2o2LjIVHyoCkbbrqnhT5+F4PzbleEtuFCEOLFE7+ikRSItWU6PdVM0CyZg+siL/ncf1s0Y5zKUx95EH6p73sqMaXgRaYjZ41uqpDnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964294; c=relaxed/simple;
	bh=TQGW3Sn5da86LoJ5oRpUfyag5VXjrouVFZheRIg3bcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSDOPyjI7coJjWQdkcMhsdo/x6SzpcDYBd2AVxazAXbdNr9Zckm4r245DElFWYPWkdJFKtBij9kJSmR8JYWB3UwuEl0JJGxL+WjbDJcE81kT2Y1d/qdx/srXK0C0aoageQEITcU6FFFAXZuCI3tfUKyOnOcqTw7d7QEXaX+jqec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXa1g1U/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXa1g1U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE65C4CEC3;
	Tue, 10 Sep 2024 10:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964293;
	bh=TQGW3Sn5da86LoJ5oRpUfyag5VXjrouVFZheRIg3bcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXa1g1U//glvuQYBGTZwkHK/a0KqWLPJbyvNfLElKFN7UO5/G6uMxx4U7E0BcQ08D
	 q2HEwWcP9xwQVbH2VjXtlwTUbrUfn7+ovjqWO5aVnGVBsNrXfsaf6wg+uD59Nn83MO
	 AEWH4amP+YWE4Ifjh2ipYo1I0sQwA+Gr6oirZA94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@bisdn.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/269] net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN
Date: Tue, 10 Sep 2024 11:32:01 +0200
Message-ID: <20240910092612.983230101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@bisdn.de>

[ Upstream commit bee2ef946d3184e99077be526567d791c473036f ]

When userspace wants to take over a fdb entry by setting it as
EXTERN_LEARNED, we set both flags BR_FDB_ADDED_BY_EXT_LEARN and
BR_FDB_ADDED_BY_USER in br_fdb_external_learn_add().

If the bridge updates the entry later because its port changed, we clear
the BR_FDB_ADDED_BY_EXT_LEARN flag, but leave the BR_FDB_ADDED_BY_USER
flag set.

If userspace then wants to take over the entry again,
br_fdb_external_learn_add() sees that BR_FDB_ADDED_BY_USER and skips
setting the BR_FDB_ADDED_BY_EXT_LEARN flags, thus silently ignores the
update.

Fix this by always allowing to set BR_FDB_ADDED_BY_EXT_LEARN regardless
if this was a user fdb entry or not.

Fixes: 710ae7287737 ("net: bridge: Mark FDB entries that were added by user as such")
Signed-off-by: Jonas Gorski <jonas.gorski@bisdn.de>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20240903081958.29951-1-jonas.gorski@bisdn.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_fdb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e69a872bfc1d..a6d8cd9a5807 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1425,12 +1425,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			modified = true;
 		}
 
-		if (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags)) {
+		if (test_and_set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags)) {
 			/* Refresh entry */
 			fdb->used = jiffies;
-		} else if (!test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags)) {
-			/* Take over SW learned entry */
-			set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags);
+		} else {
 			modified = true;
 		}
 
-- 
2.43.0



