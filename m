Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C42415F04;
	Tue, 21 Jul 2026 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658009; cv=none; b=f2MNS2MxxiujoXAGnTZa8ojGILG9uYZPOCvsZRaoVMik1PMx6fqTYAm2UhRdYeJwpqyCXaOokJVaGlXB0fEVa3cmWNllk35sUlnK02YK89Zkuvib588GlzwLxmBczzTSUsEuJDH9ADSNBw6bOe1dRhWwrxp4dutcp0jpiZwaCCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658009; c=relaxed/simple;
	bh=GCA5nPHOqLDusLrp8gBPtQtxTq0FyDoFaKRWilvQAtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsWbmNxpzx9Fy55KhgTEzDpfEUtMa6H/LvF0QfrtuuQ++7Qk9Q9AxjHOXY9DTN13B8FJ06LYmBIz6+pjJ02JgRPrZVWf9t1L4C3mmpXm9DYBNZQK1c2zMrAvsyAiGtti9bBrjsjE43yKbDAhogo21YytxgjslE+P/n/KWLysGWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgtxJTvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgtxJTvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19161F000E9;
	Tue, 21 Jul 2026 18:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658008;
	bh=GFLL58K1zqUonoFcUSnhJpHZ2WlZ8n/bFYtk0O2AcS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgtxJTviUNK5o6U2moKbznWNvPksP7/EX7tmvj7nEEf0QAaHhN3aUVjAqPlIhCUKB
	 zIeNmOw8J1U4B5fHFEUfeG3PAAduGvm2aTFAErif/vMSkN1V3GU5DNEgqQTxynaReV
	 pkSozUnfwPL4waLB/lEWWDfSAS/GSdZM/4yBjU5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noam Rathaus <noamr@ssd-disclosure.com>,
	Neil Young <contact@ssd-disclosure.com>,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0974/1611] bridge: stp: Fix a potential use-after-free when deleting a bridge
Date: Tue, 21 Jul 2026 17:18:10 +0200
Message-ID: <20260721152537.299554389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 2a00517db8de4be7df3d483b215c5544fb30a191 ]

The three STP timers are not supposed to be armed while the bridge is
administratively down. They are synchronously deactivated when the
bridge is put administratively down and the various call sites check for
'IFF_UP' before arming them.

This check is missing from br_topology_change_detection() and it is
possible to engineer a situation in which the topology change timer is
armed while the bridge is administratively down, resulting in a
use-after-free [1] when the bridge is deleted.

Fix by adding the missing check and for good measures synchronously
shutdown the three timers when the bridge is deleted.

[1]
ODEBUG: free active (active state 0) object: ffff88811662b9b0 object type: timer_list hint: br_topology_change_timer_expired (net/bridge/br_stp_timer.c:120)
WARNING: lib/debugobjects.c:629 at debug_print_object+0x1bc/0x450, CPU#9: ip/359

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Reported-by: Neil Young <contact@ssd-disclosure.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260629072117.497959-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_if.c  | 3 +++
 net/bridge/br_stp.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index ca3a637d7cca77..5bcd1acc5da9b6 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -391,6 +391,9 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
 
 	br_fdb_delete_by_port(br, NULL, 0, 1);
 
+	timer_shutdown_sync(&br->hello_timer);
+	timer_shutdown_sync(&br->topology_change_timer);
+	timer_shutdown_sync(&br->tcn_timer);
 	cancel_delayed_work_sync(&br->gc_work);
 
 	br_sysfs_delbr(br->dev);
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 024210f9546830..76a2df165ffc84 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -371,7 +371,8 @@ void br_topology_change_detection(struct net_bridge *br)
 {
 	int isroot = br_is_root_bridge(br);
 
-	if (br->stp_enabled != BR_KERNEL_STP)
+	if (br->stp_enabled != BR_KERNEL_STP ||
+	    !(br->dev->flags & IFF_UP))
 		return;
 
 	br_info(br, "topology change detected, %s\n",
-- 
2.53.0



