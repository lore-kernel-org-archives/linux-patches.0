Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060857;
	b=nbHdoFEDa5vybwOfObhJh4540MoHb6r+nm5a4RtRccDSCkOO7omwMidiKJ1ddNpEiJ9y
	 IB+sAGkmKGeZtCGOlxTGbHqpfZu2nQ93lsnBrdW0Nvv46Bv8sv+RJcCJB6dDYs7YnX8tS
	 wc8NbbJNGSeCQbzeflI5yBpwh3j3j4SRf4zXaiY+QgjnPkLQP869mTwK1XDjSLeoN/Bye
	 RxQ51DmDbDKkYyMYnkCmoSAWpjmln0Wb1HgY22K3ujxxTmKG1dd44PGGmkVt2oDskKVzz
	 8w13qkPcgU1EbbVQf3LvNRUghI0q1JOtO5mTQd5SDuDDWKRUvLqYmwZc++9qulhTiKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X7uuoQFJMj9L1T9xmmtJ22GHV3lwukAnMHLjBZYYfwE=;
	b=qqPWwbgratSPP5llTwenOfbo2zxa4l3eieYgqqNCXsYAecZ1IczU+oGfp9bp2ShdwLIl
	 QzVru1fq1VcWZYwU5attqg0yp2a2t6/ipZK4R0yx/ySPsC9s8mawFKWM9HRJ7ADNnjEfM
	 hBwWZN4BNByxYRgu2rvIYfQhW7VqaENoBhc5KBjucDIEoSEdobXDNpwvFWZQGnozApjsc
	 /czSUQEx4oe4HmKaBJwGqEs70Km8KO5b2HvT7ZVvL95aqaprB5bqANaarELW71c2jwgpJ
	 +62oSWpVUbFucmSL8U/hJGqDgrOXIUW8Tgcf0LCQN0g1Z28JVpcN9V7Gh73elOVs7Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxd6SoKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966AB606A330;
	Sat,  7 Nov 2026 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxd6SoKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFBE1F008A1;
	Sat,  7 Nov 2026 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060857;
	bh=X7uuoQFJMj9L1T9xmmtJ22GHV3lwukAnMHLjBZYYfwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxd6SoKpLDorjLv0Ahn4vI5FhvqXGvwkg0KoaOiZirM2PvovOYFlr6eKSAyyC3iB0
	 OLYGAJpyW4ixmPm/wCvhZJN32qZqg5q2RaXT+iaR0PJBYJzxQj3fhIpYAkNP5KrG4v
	 JZ9EPN9FPcRl5+NgJ3VYJamAliF8DXBILdtG5ZXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0241/1536] virtio_console: take a kref in find_port_by_vq() to fix port UAF
Date: Sat,  7 Nov 2026 08:37:37 -0500
Message-ID: <20261107135004.446306609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 18dd0b4e489e4f0e3b748cf36ccb909c75a3efab ]

find_port_by_vq() returns a raw struct port pointer without taking a
reference on it, unlike find_port_by_devt_in_portdev() which does.
find_port_by_vq()'s only two callers, in_intr() and out_intr(), run as
virtqueue interrupt callbacks, entirely independent of and possibly
concurrently with unplug_port(), which itself runs from a workqueue when
the host sends a VIRTIO_CONSOLE_PORT_REMOVE control message.

unplug_port() removes the port from portdev->ports under ports_lock,
then later drops its last reference with kref_put(), freeing it via
remove_port(). find_port_by_vq() also walks portdev->ports under
ports_lock, so if it finds the port still on the list, the list removal,
and therefore the eventual kref_put(), has not happened yet, and taking
a reference at that point is always safe. Without doing so,
in_intr()/out_intr() can be left holding a pointer to a port that
unplug_port() frees on another core before they are done using it.

Both triggers are host-controlled as the host decides when to send the
PORT_REMOVE control message and when to kick the port's data vq. So a
malicious backend could race the two on purpose, without any guest side
cooperation. The freed object is a generic kmalloc allocation containing
a wait_queue_head_t, which in_intr()/out_intr() pass to
wake_up_interruptible() after touching the stale pointer.
wake_up_interruptible() invokes a function pointer read out of the wait
queue's entries. If the freed slab slot is reclaimed with attacker
influenced content before that call, then this is an arbitrary function
call primitive rather than just undefined behaviour.

Take a reference in find_port_by_vq() while still holding ports_lock,
matching find_port_by_devt_in_portdev(), and release it in in_intr() and
out_intr() once they are done with the port.

Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Link: https://patch.msgid.link/20260717150622.23636-1-harimishal1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 75ba23fa2187b..7559ecb9b4d90 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -303,6 +303,12 @@ static struct port *find_port_by_id(struct ports_device *portdev, u32 id)
 	return port;
 }
 
+/*
+ * Finds a port by the virtqueue and returns a pointer to struct port
+ * with the reference count incremented.
+ *
+ * Callers MUST decrement it when finished.
+ */
 static struct port *find_port_by_vq(struct ports_device *portdev,
 				    struct virtqueue *vq)
 {
@@ -311,8 +317,10 @@ static struct port *find_port_by_vq(struct ports_device *portdev,
 
 	spin_lock_irqsave(&portdev->ports_lock, flags);
 	list_for_each_entry(port, &portdev->ports, list)
-		if (port->in_vq == vq || port->out_vq == vq)
+		if (port->in_vq == vq || port->out_vq == vq) {
+			kref_get(&port->kref);
 			goto out;
+		}
 	port = NULL;
 out:
 	spin_unlock_irqrestore(&portdev->ports_lock, flags);
@@ -1709,6 +1717,7 @@ static void out_intr(struct virtqueue *vq)
 	}
 
 	wake_up_interruptible(&port->waitqueue);
+	kref_put(&port->kref, remove_port);
 }
 
 static void in_intr(struct virtqueue *vq)
@@ -1754,6 +1763,8 @@ static void in_intr(struct virtqueue *vq)
 
 	if (is_console_port(port) && hvc_poll(port->cons.hvc))
 		hvc_kick();
+
+	kref_put(&port->kref, remove_port);
 }
 
 static void control_intr(struct virtqueue *vq)
-- 
2.53.0



