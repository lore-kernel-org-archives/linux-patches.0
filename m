Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5C15B5AB;
	Sat, 17 Oct 2026 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253688; cv=none; b=fNc0aybn6ASHR+prQwyIgdYzbph0Mg/x4+wawNm35aRXiGBVtbICBh63uZoPjyCmKj87ioXHhkrQK73YrrAyJl6tL0Zu44DBQMUsom7gHxOAT3Qd6vMVXy/dKWaz7ujt5ha9zfJKb1gpUbj0AH967jgYTi4Me7lSzZWS/vn4So0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253688; c=relaxed/simple;
	bh=f54oxjWJ7n5y5iqxLgAHWA9el5/aNthMaTg8m0rbFps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKD9ItI/jnqGH/6Ue1WmPaIuMVoSxdET257Hqx7GHxZYREZMnXz1MVJiqh0p3wOp3PAMIJmJNnt6fQ3YN//xe00i9Dl+qsgRtCk77os/YAF74KLH2ocQT7cz5MxxXH4A/Vz1xq4BqS6sdgOD2gyww67kOKkyUXwrRpJsHeuvxpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF34pxuA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF34pxuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B66E1F000C4;
	Sat, 17 Oct 2026 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253686;
	bh=0b+Zqx76zxF/FUxknlugAY85P8kmlzDWuC9kwgMuSu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YF34pxuA2GvJ51oe+rvnXBFobsYdL3NrhC4XsihkF4NBlmPkzGNyPpb2wIQ7tsush
	 1CJLdaoeVKf4i/4tmdO2rVQme5Cf0h7he7dzlCWvV5RGVLdzhD3BHjSAUqTmF7Iiy5
	 zyJ+K8Pfo/BBmu6iUvE37RY1+mZywvg+FXJAQFOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f2fbf7478a35a94c8b7c@syzkaller.appspotmail.com,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/869] wireguard: device: use exit_rtnl callback instead of manual rtnl_lock in pre_exit
Date: Sat, 17 Oct 2026 17:50:39 +0200
Message-ID: <20261017160042.134440648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

[ Upstream commit 60a25ef8dacb3566b1a8c4de00572a498e2a3bf9 ]

wg_netns_pre_exit() manually acquires rtnl_lock() inside the
pernet .pre_exit callback.  This causes a hung task when another
thread holds rtnl_mutex - the cleanup_net workqueue (or the
setup_net failure rollback path) blocks indefinitely in
wg_netns_pre_exit() waiting to acquire the lock.

Convert to .exit_rtnl, introduced in commit 7a60d91c690b ("net:
Add ->exit_rtnl() hook to struct pernet_operations."), where the
framework already holds RTNL and batches all callbacks under a
single rtnl_lock()/rtnl_unlock() pair, eliminating the contention
window.

The rcu_assign_pointer(wg->creating_net, NULL) is safe to move
from .pre_exit to .exit_rtnl (which runs after synchronize_rcu())
because all RCU readers of creating_net either use maybe_get_net()
- which returns NULL for a dying namespace with zero refcount - or
access net->user_ns which remains valid throughout the entire
ops_undo_list sequence.

Reported-by: syzbot+f2fbf7478a35a94c8b7c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=cb64c22a492202ca929e18262fdb8cb89e635c70
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
[ Jason: added __net_exit and __read_mostly annotations that were missing. ]
Fixes: 900575aa33a3 ("wireguard: device: avoid circular netns references")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20260414153944.2742252-5-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/device.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 45e9b908dbfb0..055ea38771568 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -406,12 +406,11 @@ static struct rtnl_link_ops link_ops __read_mostly = {
 	.newlink		= wg_newlink,
 };
 
-static void wg_netns_pre_exit(struct net *net)
+static void __net_exit wg_netns_exit_rtnl(struct net *net, struct list_head *dev_kill_list)
 {
 	struct wg_device *wg;
 	struct wg_peer *peer;
 
-	rtnl_lock();
 	list_for_each_entry(wg, &device_list, device_list) {
 		if (rcu_access_pointer(wg->creating_net) == net) {
 			pr_debug("%s: Creating namespace exiting\n", wg->dev->name);
@@ -424,11 +423,10 @@ static void wg_netns_pre_exit(struct net *net)
 			mutex_unlock(&wg->device_update_lock);
 		}
 	}
-	rtnl_unlock();
 }
 
-static struct pernet_operations pernet_ops = {
-	.pre_exit = wg_netns_pre_exit
+static struct pernet_operations pernet_ops __read_mostly = {
+	.exit_rtnl = wg_netns_exit_rtnl
 };
 
 int __init wg_device_init(void)
-- 
2.53.0



