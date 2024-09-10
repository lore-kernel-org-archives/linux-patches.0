Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C82197556;
	Tue, 10 Sep 2024 10:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962952; cv=none; b=cehrQvFLXqDXY1Eg5LHNVT4ZSEAUhPe50CWiXr/SBPs3no+huBg/UDUDaGMR0rY+fmaXgVmBkMgiqLOObHtZOUyJcWEJuAeXW4d1ASgzZQEqEWUGQubjnmt+gZSiERvF7dW3yr5OXPaVkJEJCc+6m1/4I1QwjU85sUcw4gf38ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962952; c=relaxed/simple;
	bh=njQjSleoxhCzJ4VBasWhVvqI5xlHSqeG7wEE5kyrTME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiVp5emiaLE8hHP0SwNdOvzhrcZnzlWNn5Zof1BiMhN8wb5HDYujI+LsqaKFtIv5J78V+ZrJ+4b+Y7Ri+S+75u2wambMB+IFTeh0FtT/uXyXsAW4A9ECBnPVKK1dlBxxLLMR8KaHbW2AFx1pwVyj2j3KZ7kvvyvo+HsoRLPpdxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJeEltvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJeEltvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817A1C4CEC3;
	Tue, 10 Sep 2024 10:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962951;
	bh=njQjSleoxhCzJ4VBasWhVvqI5xlHSqeG7wEE5kyrTME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJeEltvyBx1REDFuwg2aF38bQOZs6AEYick6T7eTJtsb8xz/zWWAr0B2SNTZjir9L
	 4xK+CkNUVY2+fi3acOvNxqMITZdw0jtOGtRW/NZkLORecI6F0cxO9mZWAkUaoeOLGO
	 qeYRLd592XY3CppUMXLzsVk8haZbCfhU8vTAXPpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@bisdn.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/192] net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN
Date: Tue, 10 Sep 2024 11:31:50 +0200
Message-ID: <20240910092601.531120832@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e7f4fccb6adb..882b6a67e11f 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1388,12 +1388,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
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



