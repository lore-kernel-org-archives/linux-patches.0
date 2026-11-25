Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623961;
	b=f+BQzzEo7BvsGsFfNXq0tg/PZ02hxbrZx1nX37tn1Ac7ySUdkrpe4d6pAb3mnVzHSvjI
	 VseTW8OPzdkR0bToyz7J75KYdpc8ZOC+rJlESXuN+fsphWSTM/s47dIIJjmOxWxRQa9Kn
	 ULvbOx8vXF0l1MEKq3nAxW/+HImPGfWb3bxNGrDijFFFJZaUmbrhgzJcGJuoTWjjn1OeG
	 m5K262GZ89fHTKIaDwaB5VJJRDyKApWBaBF3OhcJ4mFmk2fMhxjcSvWk+yj5pjEYAzpBw
	 Zfj/wSOYUI7LYEtmmE0LEP2Sykzdtwemf3IgqNl+nsLRq+KlaXRwn9uXfn07HeGQvUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4XgjSFZYqfrUpi8lkasnAOsoZcn9PNX7WSp8781d2ow=;
	b=qddDMmC2wPhqMSO7Mm598Mji6sepvOT8DiN2dbYvRCTt34y8R491zAvtpVPSCYIXUTS/
	 /yDcmOBwWIHlwaVQaXw3aqdLoTnFD/2jeveCuVryAGtUZM/Ln8q5q1bRXqc1y2+1mBjQn
	 7KhpIbrGrx6pbXPDqI6Fjq9KE086EAj/CP77snwdyMiYAAxjPLE4VToNP9ISYjzBUXv0K
	 34L+jET9vod6I35JFsSBBX7oYZnSa9ETNjvJM5JDjOVC9nQDgnRNIQd7ZOf5vvmR4E2wr
	 Mtt+IJQ3Pps1MjQ4BVx/pXB4HVOaEya8EbEX+jgEB3P5HWIKcDQpkiRgrbqeEqac4Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGBhVfoO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DE9606A321;
	Wed, 25 Nov 2026 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGBhVfoO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C151F000C6;
	Wed, 25 Nov 2026 16:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623961;
	bh=4XgjSFZYqfrUpi8lkasnAOsoZcn9PNX7WSp8781d2ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGBhVfoOHMVmCkgTEicmUBiLycip4EC7VR+wYPRuWBbGNMJifVU9PWQbsfBsbrHdL
	 mILVLuxR0Io+ytE9dQeEpUqmKMhChb5MdwdimZ1MVWrvhkAW592CiEXDI4y6U2GP/q
	 zn22vkDGJSMEcy7Tu9UXv5XZPHGwf3RSM8+FgoSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/816] bpqether: keep a bpq device in step with its Ethernet device
Date: Wed, 25 Nov 2026 15:26:30 +0100
Message-ID: <20261125143850.196207452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When the Ethernet device goes down, bpq_device_event() closes the bpq
device on top of it. Two things are left over:

 - bpq_open() does not look at the Ethernet device, so the bpq device
   can be brought up again while the Ethernet device is still down.
   Every frame sent then counts in the bpq device's tx_packets while
   the Ethernet device drops it.

 - when the Ethernet device comes back up, the bpq device stays down
   and the AX.25 port has to be brought up again by hand.

Refuse to open a bpq device whose Ethernet device is not running, with
-ENETDOWN. Remember that a bpq device was closed because its Ethernet
device went down, and open it again on NETDEV_UP. A bpq device that
was already down, e.g. closed by the administrator, is left alone.

Tested in a QEMU guest (6.12.94, KASAN) with e1000 ports:
 - bpq2 brought up with eth2 down: accepted before, and 5 frames
   counted in tx_packets of bpq2 while eth2 dropped them; -ENETDOWN
   after, nothing counted;
 - eth3 down then up: bpq3 stayed down before, is up again after;
 - bpq1 closed by hand, then eth1 down and up: bpq1 stays down,
   before and after.
No kernel report in either case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 888935e9c7aa8d8de66dd76111ef0875f8c90663)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 4a04c3b4bdb93..41b145693ff93 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -103,6 +103,7 @@ struct bpqdev {
 	struct net_device *axdev;	/* bpq device (bpq#) */
 	char   dest_addr[6];		/* ether destination address */
 	char   acpt_addr[6];		/* accept ether frames from this address only */
+	bool   reopen;			/* closed because the ether device went down */
 };
 
 static LIST_HEAD(bpq_devices);
@@ -358,6 +359,11 @@ static int bpq_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
  */
 static int bpq_open(struct net_device *dev)
 {
+	struct bpqdev *bpq = netdev_priv(dev);
+
+	if (!netif_running(bpq->ethdev))
+		return -ENETDOWN;
+
 	netif_start_queue(dev);
 	return 0;
 }
@@ -532,6 +538,8 @@ static int bpq_device_event(struct notifier_block *this,
 			    unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net_device *axdev;
+	struct bpqdev *bpq;
 
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
@@ -540,14 +548,27 @@ static int bpq_device_event(struct notifier_block *this,
 		return NOTIFY_DONE;
 
 	switch (event) {
-	case NETDEV_UP:		/* new ethernet device -> new BPQ interface */
-		if (bpq_get_ax25_dev(dev) == NULL)
+	case NETDEV_UP:
+		axdev = bpq_get_ax25_dev(dev);
+		if (!axdev) {		/* new ethernet device -> new BPQ interface */
 			bpq_new_device(dev);
+			break;
+		}
+		/* reopen a BPQ interface closed when the device went down */
+		bpq = netdev_priv(axdev);
+		if (bpq->reopen) {
+			bpq->reopen = false;
+			dev_open(axdev, NULL);
+		}
 		break;
 
 	case NETDEV_DOWN:	/* ethernet device closed -> close BPQ interface */
-		if ((dev = bpq_get_ax25_dev(dev)) != NULL)
-			dev_close(dev);
+		axdev = bpq_get_ax25_dev(dev);
+		if (axdev && netif_running(axdev)) {
+			dev_close(axdev);
+			bpq = netdev_priv(axdev);
+			bpq->reopen = true;
+		}
 		break;
 
 	case NETDEV_UNREGISTER:	/* ethernet device removed -> free BPQ interface */
-- 
2.53.0



