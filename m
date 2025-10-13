Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8A930DD2A;
	Mon, 13 Oct 2025 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369981; cv=none; b=ST3jUwGZ4H37/q2syb21KL7FuNpkKe5eM6wJoCriR04ewmHHGdhgxIJidQeJ8NXkJyIeCx8zImXhtzBczHR2t6xaOpPmKMSUDU89S3H0ugZ+TETXh2Ujvs1CcPWGkyFuOyE1/INpveMWpgPVpjjw5FLe7gFSfp9/Iyrtxxv/qXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369981; c=relaxed/simple;
	bh=hYIVyuM1TJoUe8kAUS33/9M0JTpF8Naw/U1RIRVGeJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6jRhULojDqdz1Js1Q/iRwkpBpJBcZwkoJpiEs+4KO86v/msYtwUXguDyQXGYNFq9KcDDBBN5KYu+5W3SJ9TzKxePytD/fVzfZDbRfZvs38I6O+3r7VdTVBXl02s45FQKg0UtuMnbyp5crC2NBT+mN5Mtuqmbb8Pu3miiGapSig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxJwK7RV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxJwK7RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC09C4CEE7;
	Mon, 13 Oct 2025 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369981;
	bh=hYIVyuM1TJoUe8kAUS33/9M0JTpF8Naw/U1RIRVGeJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxJwK7RV7Ot41a441oJ8ttgLpJk8lFwHXq+F1qn3V3uItW6bSo6FfRAi4T29oBnu3
	 GpXFUbNFPv3thBmueu6v5uw/Knv2BIb79DA5tA8NwzGA9iPxpQPaPgr0HxBmK1bReh
	 HfxfRtcmI3wrsLwIdNp6bTpIUTV9CT1ZBZAC7c2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Slavin Liu <slavin452@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 436/563] ipvs: Defer ip_vs_ftp unregister during netns cleanup
Date: Mon, 13 Oct 2025 16:44:57 +0200
Message-ID: <20251013144427.078297438@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <slavin452@gmail.com>

[ Upstream commit 134121bfd99a06d44ef5ba15a9beb075297c0821 ]

On the netns cleanup path, __ip_vs_ftp_exit() may unregister ip_vs_ftp
before connections with valid cp->app pointers are flushed, leading to a
use-after-free.

Fix this by introducing a global `exiting_module` flag, set to true in
ip_vs_ftp_exit() before unregistering the pernet subsystem. In
__ip_vs_ftp_exit(), skip ip_vs_ftp unregister if called during netns
cleanup (when exiting_module is false) and defer it to
__ip_vs_cleanup_batch(), which unregisters all apps after all connections
are flushed. If called during module exit, unregister ip_vs_ftp
immediately.

Fixes: 61b1ab4583e2 ("IPVS: netns, add basic init per netns.")
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Slavin Liu <slavin452@gmail.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index d8a284999544b..206c6700e2006 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -53,6 +53,7 @@ enum {
 	IP_VS_FTP_EPSV,
 };
 
+static bool exiting_module;
 /*
  * List of ports (up to IP_VS_APP_MAX_PORTS) to be handled by helper
  * First port is set to the default port.
@@ -605,7 +606,7 @@ static void __ip_vs_ftp_exit(struct net *net)
 {
 	struct netns_ipvs *ipvs = net_ipvs(net);
 
-	if (!ipvs)
+	if (!ipvs || !exiting_module)
 		return;
 
 	unregister_ip_vs_app(ipvs, &ip_vs_ftp);
@@ -627,6 +628,7 @@ static int __init ip_vs_ftp_init(void)
  */
 static void __exit ip_vs_ftp_exit(void)
 {
+	exiting_module = true;
 	unregister_pernet_subsys(&ip_vs_ftp_ops);
 	/* rcu_barrier() is called by netns */
 }
-- 
2.51.0



