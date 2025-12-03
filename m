Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C7E349B16;
	Wed,  3 Dec 2025 16:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777653; cv=none; b=DwcuKq0u2WyoQMC4GfRQ2U6XAZrdsdl0wLCSLucdd3vF4qFbo87XcJFDmQRjcwPQo0/Y7QKuF1C51K0dyNUyMs2MeFSdODGSvHcDJpDgntd5Mw2tT61MZwJwhkgcqt/uGQhyM0HzukpOOgLl+zEc0HPS7B860+xYwAndUiXp2vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777653; c=relaxed/simple;
	bh=g4ZwT9Whjkm3YzGbPapMq14gA85aQBSp8UaqBQSZ/sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFBI+vICmVKXCtgptl6UINrmvTd6nOrPSuHj/stV87nWAk9eV3kAOX41X8i6QtpLv5IEAG9sfqVFpJIm6V6fjT3GJpMXWxKHfYclSCelgK83/cELrpqLFSt7bIiAWtR0/e6KFkmDUs9l4gCXjf/qSaOrKXfKkQJQGo1YsLCMlcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEqrI7rt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEqrI7rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393D0C4CEF5;
	Wed,  3 Dec 2025 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777653;
	bh=g4ZwT9Whjkm3YzGbPapMq14gA85aQBSp8UaqBQSZ/sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEqrI7rt9Sa3gQrNyhBXZ91/w2TaAO5RN/Cu+quz2JonPUIIWDfO+EatqKX8iTscj
	 j10gclBfAGYIEjLU6XojyUI6OxMpswrxYVFvauycpWnfGUt82rgqvQuHN+p5EuFCZ1
	 5hB6muXdIKL5J8dv6OggFA3IfRerEL/gAu3olacM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/392] bridge: Redirect to backup port when port is administratively down
Date: Wed,  3 Dec 2025 16:24:15 +0100
Message-ID: <20251203152417.963554452@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 3d05b24429e1de7a17c8fdccb04a04dbc8ad297b ]

If a backup port is configured for a bridge port, the bridge will
redirect known unicast traffic towards the backup port when the primary
port is administratively up but without a carrier. This is useful, for
example, in MLAG configurations where a system is connected to two
switches and there is a peer link between both switches. The peer link
serves as the backup port in case one of the switches loses its
connection to the multi-homed system.

In order to avoid flooding when the primary port loses its carrier, the
bridge does not flush dynamic FDB entries pointing to the port upon STP
disablement, if the port has a backup port.

The above means that known unicast traffic destined to the primary port
will be blackholed when the port is put administratively down, until the
FDB entries pointing to it are aged-out.

Given that the current behavior is quite weird and unlikely to be
depended on by anyone, amend the bridge to redirect to the backup port
also when the primary port is administratively down and not only when it
does not have a carrier.

The change is motivated by a report from a user who expected traffic to
be redirected to the backup port when the primary port was put
administratively down while debugging a network issue.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250812080213.325298-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 1b66c276118a3..aec5ab772a69d 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -148,7 +148,8 @@ void br_forward(const struct net_bridge_port *to,
 		goto out;
 
 	/* redirect to backup link if the destination port is down */
-	if (rcu_access_pointer(to->backup_port) && !netif_carrier_ok(to->dev)) {
+	if (rcu_access_pointer(to->backup_port) &&
+	    (!netif_carrier_ok(to->dev) || !netif_running(to->dev))) {
 		struct net_bridge_port *backup_port;
 
 		backup_port = rcu_dereference(to->backup_port);
-- 
2.51.0



