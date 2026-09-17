Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7164ED1AF;
	Thu, 17 Sep 2026 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665978; cv=none; b=CkdNESWFrLsjVaAp4P3AoNpS9t/Ali4V78J43IqnPFLR2ZvjrPSshfwr/4rmIxAib481s6RXkBsw6Zk1ICnHs483ORjMTmBp8RWiUxdCdgSlR2nk5vGRlOV5DpxbBc6KGgAiggNVsRrTE5uptOG7BPPofHSVDt3nQIWsfY5qV/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665978; c=relaxed/simple;
	bh=cwB+u+isCcgZ16zsYNeGjyp3x2PYg/gGmkGRlyBb6jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNoyV6/gPdBYtqoRi1/WaKTsqBTAbw9TBCByjQXsCfaIBpGUQZwmaUIMnIwSZNz4fshnA17QFSSAJPwaKt2IMiOkCIAcUlYRGUjpSyYnG3+/7BYHpvewpMNeHUu4bI2ynl7Z16It6AhN1K6aoz9+YuxOq2EAqBQNn6Kdp1QJF7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTyhcQqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTyhcQqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69931F000FF;
	Thu, 17 Sep 2026 17:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665976;
	bh=M36xvXWUBCqVhbSBA4G+iD5saX3LFKxplZl9jiffegY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTyhcQqGqDPRtZF1/gBcXXtzscdkK++uMlPY+8KmbXfSIdA0Anjqu2qTTMUoG4XXU
	 eeyaHvEYaAABfIQ8aTwDxReIyt5DoHdjqC4Qa30GVlUq9bWaSu8W0ccXZD8uSZcFLQ
	 IwWDVSvTKyFQF22MSdiPgXVtrgRGzdaJRAxOFoAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6df45dd3d03e1a9aca96@syzkaller.appspotmail.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0883/1250] Bluetooth: hci_sysfs: Fix NULL pointer dereference in device_del()
Date: Thu, 17 Sep 2026 16:11:18 +0100
Message-ID: <20260917151615.916229411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

[ Upstream commit 9b851b09b392da68bd715601f10a5adb2d8d19b8 ]

A NULL pointer dereference in klist_put() occurs when a child device (such
as a BNEP network device in bnep_session) is concurrently being
unregistered while hci_conn_del_sysfs() reparents child devices.

This is caused by a race condition between hci_conn_del_sysfs() and
concurrent child device unregistration (e.g. bnep_session calling
unregister_netdev()). During device unregistration, device_del() snapshots
a non-NULL parent pointer. Concurrently, hci_conn_del_sysfs() finds the
child device using device_find_any_child() and calls device_move() to
reparent it to NULL, which removes the node from its parent's klist and
clears knode_parent. Subsequently, device_del() calls
klist_del(&dev->p->knode_parent) using the stale parent snapshot, causing
klist_put() to dereference knode_klist(n)->put on an already removed node,
resulting in a NULL pointer dereference.

This race was introduced by commit 27aabf27fd01 ("Bluetooth: fix
use-after-free in device_for_each_child()"), which replaced
device_find_child(..., __match_tty) with device_find_any_child() in
hci_conn_del_sysfs(). That change was intended to avoid a use-after-free
where conn->dev outlived its parent hdev->dev when child devices held
references to conn->dev, because conn->dev only held a reference to
hdev->dev while registered in sysfs.

Fix the issue properly by taking an explicit reference to the parent device
with get_device(&hdev->dev) in hci_conn_init_sysfs() and dropping it with
put_device(parent) in bt_link_release() when the conn device is freed. This
ensures that hdev->dev remains valid for the entire lifecycle of conn->dev,
resolving the underlying use-after-free. With the parent reference held
properly, restore the __match_tty filter in hci_conn_del_sysfs() so that
device_move() is only invoked on persistent RFCOMM TTY devices as
originally intended, eliminating the race condition with unregistering
network devices.

Fixes: 27aabf27fd01 ("Bluetooth: fix use-after-free in device_for_each_child()")
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+6df45dd3d03e1a9aca96@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6df45dd3d03e1a9aca96
Link: https://syzkaller.appspot.com/ai_job?id=f1c0e740-db21-40af-a9ff-84db0fd8b8bd
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sysfs.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 8957ce7c21b76..c2065abf753e0 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -13,7 +13,10 @@ static const struct class bt_class = {
 static void bt_link_release(struct device *dev)
 {
 	struct hci_conn *conn = to_hci_conn(dev);
+	struct device *parent = dev->parent;
+
 	kfree(conn);
+	put_device(parent);
 }
 
 static const struct device_type bt_link = {
@@ -21,6 +24,16 @@ static const struct device_type bt_link = {
 	.release = bt_link_release,
 };
 
+/*
+ * The rfcomm tty device will possibly retain even when conn
+ * is down, and sysfs doesn't support move zombie device,
+ * so we should move the device before conn device is destroyed.
+ */
+static int __match_tty(struct device *dev, const void *data)
+{
+	return !strncmp(dev_name(dev), "rfcomm", 6);
+}
+
 void hci_conn_init_sysfs(struct hci_conn *conn)
 {
 	struct hci_dev *hdev = conn->hdev;
@@ -29,7 +42,7 @@ void hci_conn_init_sysfs(struct hci_conn *conn)
 
 	conn->dev.type = &bt_link;
 	conn->dev.class = &bt_class;
-	conn->dev.parent = &hdev->dev;
+	conn->dev.parent = get_device(&hdev->dev);
 
 	device_initialize(&conn->dev);
 }
@@ -69,7 +82,7 @@ void hci_conn_del_sysfs(struct hci_conn *conn)
 	while (1) {
 		struct device *dev;
 
-		dev = device_find_any_child(&conn->dev);
+		dev = device_find_child(&conn->dev, NULL, __match_tty);
 		if (!dev)
 			break;
 		device_move(dev, NULL, DPM_ORDER_DEV_LAST);
-- 
2.53.0



