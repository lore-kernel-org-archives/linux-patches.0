Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE113ADB9A;
	Sat, 17 Oct 2026 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255645; cv=none; b=na6R+rpkFrddt9ADKc10/iHvSVvFAy09A36SSBO/+G5fPNgNK1NfIrn3etCHgHbwuXHLalgJwNhnkqWv601F8ZS7NYfDmO6S7yGysp8JdaDdmAev+3uhep/mjTEeyDa1vo0zxIvNR2qPF/UzKmHA/VRRji4yIViLORs+aQdvAyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255645; c=relaxed/simple;
	bh=S1zdQ1+T54UgmFE+4OwRtRGMYsOFRRRAVjWTrQWqgh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AauurQe6M6fe7XWP8k8jNhlLaOrnTYu2rPYHWY0+xDWdbP+da4MLo1Rg9/9XWcgayY1bij6kPBMQbMgMgZXz2GzrKIujnQSG0BcDgLLav2xnasbJiZQea8IYP/SfyGTVQgyfAd3xm2XRW/Y1cWxssgqQYgbGUjI4VGLzxC5BfwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zR90p5zf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zR90p5zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6330D1F000C4;
	Sat, 17 Oct 2026 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255643;
	bh=NKSWL+BQJHvoBqaxFN8zVqTErcIIGzcNPCN0LNbgS8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zR90p5zfsPBgfhUYfAKYXorLtLws2lz1FuJsecHuil505T4FefYQXxrFP0lkbkQr2
	 VxoU/829MuP6T/KZDZ5ai2W7ZXofboK1KxxEHq5V4TixswKdQ0eSYxIwCUTNALiuiZ
	 ZK/bkIubElVznQVv0CxyaOuqIEBfnAD+Ld1xB3bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+74f338e09f1ef3ee6457@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 791/869] net: Remove conflicting altnames for dying netns in __dev_change_net_namespace().
Date: Sat, 17 Oct 2026 18:00:32 +0200
Message-ID: <20261017160057.188504670@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit debac3a20dec524a59625cf10fa2f18571127824 ]

syzbot reported the warning in cfg80211_pernet_exit(). [0]

The repro does the following:

  1. create two device in root netns and non-root netns
  2. assign the same altname for the two devices
  3. remove the non-root netns

Since commit 7663d522099e ("net: check for altname conflicts
when changing netdev's netns"), cfg80211_switch_netns() and
cfg802154_switch_netns() fail if init_net has a device with the
conflicting altname.

default_device_exit_net() had the same issue and commit d09486a04f5d
("net: fix removing a namespace with conflicting altnames") fixed it.

cfg80211_pernet_exit() and cfg802154_pernet_exit() need the same fix.

Let's generalise the fix by removing conflicting altnames for dying
netns in __dev_change_net_namespace().

[0]:
cfg80211_switch_netns(rdev, &init_net)
WARNING: net/wireless/core.c:1871 at cfg80211_pernet_exit+0xd5/0x120 net/wireless/core.c:1871, CPU#1: kworker/u8:9/1160
Modules linked in:
CPU: 1 UID: 0 PID: 1160 Comm: kworker/u8:9 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Workqueue: netns cleanup_net
RIP: 0010:cfg80211_pernet_exit+0xd5/0x120 net/wireless/core.c:1871
Code: e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 b4 ef 0e f7 4d 8b 36 49 81 fe 20 10 4a 90 74 12 e8 03 3d 9f f6 eb 85 e8 fc 3c 9f f6 90 <0f> 0b 90 eb cc e8 f1 3c 9f f6 eb 05 e8 ea 3c 9f f6 5b 41 5c 41 5e
RSP: 0018:ffffc900057a78f0 EFLAGS: 00010293
RAX: ffffffff8b287154 RBX: ffff88807ba72780 RCX: ffff8880213e8000
RDX: 0000000000000000 RSI: 00000000ffffffef RDI: 0000000000000000
RBP: 00000000ffffffef R08: ffffffff9024cc67 R09: 0000000000000000
R10: fffff52000af4eb0 R11: fffffbfff204998d R12: dffffc0000000000
R13: ffffffff904a1080 R14: ffff888144ed0008 R15: ffff888144ed0e20
FS:  0000000000000000(0000) GS:ffff888124de6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005642de0a8a70 CR3: 000000007a40c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ops_exit_list net/core/net_namespace.c:200 [inline]
 ops_undo_list+0x43d/0x8d0 net/core/net_namespace.c:253
 cleanup_net+0x572/0x810 net/core/net_namespace.c:706
 process_one_work kernel/workqueue.c:3387 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3470
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3551
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
Reported-by: syzbot+74f338e09f1ef3ee6457@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a96219e.04428c52.29b18.0001.GAE@google.com/T/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260901005550.2042357-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e6d907a685f64..397fd0f9cc7a2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11742,7 +11742,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 			       const char *pat, int new_ifindex,
 			       struct netlink_ext_ack *extack)
 {
-	struct netdev_name_node *name_node;
+	struct netdev_name_node *name_node, *tmp;
 	struct net *net_old = dev_net(dev);
 	char new_name[IFNAMSIZ] = {};
 	int err, new_nsid;
@@ -11788,13 +11788,19 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	}
 	/* Check that none of the altnames conflicts. */
 	err = -EEXIST;
-	netdev_for_each_altname(dev, name_node) {
-		if (netdev_name_in_use(net, name_node->name)) {
-			NL_SET_ERR_MSG_FMT(extack,
-					   "An interface with the altname %s exists in the target netns",
-					   name_node->name);
-			goto out;
+	netdev_for_each_altname_safe(dev, name_node, tmp) {
+		if (!netdev_name_in_use(net, name_node->name))
+			continue;
+
+		if (!check_net(net_old)) {
+			__netdev_name_node_alt_destroy(name_node);
+			continue;
 		}
+
+		NL_SET_ERR_MSG_FMT(extack,
+				   "An interface with the altname %s exists in the target netns",
+				   name_node->name);
+		goto out;
 	}
 
 	/* Check that new_ifindex isn't used yet. */
@@ -12232,7 +12238,6 @@ static struct pernet_operations __net_initdata netdev_net_ops = {
 
 static void __net_exit default_device_exit_net(struct net *net)
 {
-	struct netdev_name_node *name_node, *tmp;
 	struct net_device *dev, *aux;
 	/*
 	 * Push all migratable network devices back to the
@@ -12256,10 +12261,6 @@ static void __net_exit default_device_exit_net(struct net *net)
 		if (netdev_name_in_use(&init_net, fb_name))
 			snprintf(fb_name, IFNAMSIZ, "dev%%d");
 
-		netdev_for_each_altname_safe(dev, name_node, tmp)
-			if (netdev_name_in_use(&init_net, name_node->name))
-				__netdev_name_node_alt_destroy(name_node);
-
 		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
 			pr_emerg("%s: failed to move %s to init_net: %d\n",
-- 
2.53.0



