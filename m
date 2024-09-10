Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89D017A589;
	Tue, 10 Sep 2024 10:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963661; cv=none; b=TVNm5fmv4QhQwlvv2reY6o0gR/+ds24VUMahiM4DYWEZPL9XzUE0hPK9e0Id+HYcPwh3lRbeMTvbcQ2FtvPzUSdyvd9TsfpXJNDf7N6wQIQ+NJNxUX88eWN1EG6EUGx6jJpR2CY5LO7msxTEgKAXvlktiCQmgnf76HW3IulEWEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963661; c=relaxed/simple;
	bh=ai5HHTH90gtrD6G74tFKM9Woahg0YhasIztoLCGIMq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leEona1HmUOzLv5MelZyZd1j/Xsc3RdgYsPvmaVuMVqeRiAyui9QOG2EbrvZZSHGzd+P/FcxmhjUlms4ozHhfl44Su2pc+beip9HbnyrXCFLPGXd5J9P2UJEnvUNr8WDimtF17KGyNBiglMuJSeqa/mVGlGmdZoJqQM9mau2MSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsHu7gSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsHu7gSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F174EC4CEC3;
	Tue, 10 Sep 2024 10:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963661;
	bh=ai5HHTH90gtrD6G74tFKM9Woahg0YhasIztoLCGIMq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsHu7gSy0L0TpnJOnkpGaIWB4uOkAkiicCDxGNVH7+Kc0kUTKxzXfWxlHJg67T2uT
	 Z0UzqUgYIb6PQBfGvdsjdfNi9/xG01pi9WcVBKwsfTzLw/vIxuUulN+KZZwJytrke0
	 /hmu/fIJykmvDpxuzY2JALhj9Ihg0umreqENxHx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@bisdn.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/214] net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN
Date: Tue, 10 Sep 2024 11:32:35 +0200
Message-ID: <20240910092604.189661937@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 46812b659710..83ec74b67340 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1299,12 +1299,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
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



