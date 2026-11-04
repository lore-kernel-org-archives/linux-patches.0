Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829711;
	b=HO3JggDkiQoQK2EpxnSDb9fqr+NBd5CwkZ+Ho8bjsWmbu2+ihjFtJWkkz9S9+Ht/Zqmc
	 yarYjx5Xu3tia+7b55HUYRh/Zi706BBPtacwJmOzPGPdnzMaHyPKDAG/8RrPB3Kig24Cj
	 OrwPhXv39Uvt8lOjeaj1RYNXRAauXxMzdC+N+/pcAVLfVJ9FCtylCf6COyt10r4JPY6p4
	 mqPJbmK0sIJExaGUtiyr1DakWrsCdAINlRiCvJ5/P7rEiQYcFujiFmnRR3P4oAXPh1bmY
	 TFN+k4ofwb4bFFKNQO1Ou60m11a2jpKzK9gEn4qJUEc8vp6O13lOMVBf1AByHFpV8Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eg06lRv5edHO6+xulTpe/owfvC9Wf3FNBFFEbMCTr2Q=;
	b=rCTvejjt+QeRF09EbGzYFSx9bQoWNlhEHy2HmsYmRk0OhMQ0GQR5xmTBlennztedCeRH
	 6zpBBPqFseGHbFWvbQo2SzF01K35V35hq7MzX+oOO4lXhPei/gwwwj4ixUVW5NFBYjs48
	 CUog8Fs0BKyd82wLClvwhbx9hX8TeWSFaJoAGE50e7KQCkWBp9jq+zfG4A2CvoK/4pUEe
	 isUZhUR9/69XocPjCRSUHxNeAk1Jzlv1MSnmnmpmMxuJjiu0C6On5qIAdlT/YireKaHJh
	 b6MWqfr8b83K6wzI2DM2ZiuyyaO48ONCbD4n2KjfMSmMVDonLvhaz5iYeDDmTsgt5CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ouTe22r+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46113606BA3C;
	Wed,  4 Nov 2026 22:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ouTe22r+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7D51F000C1;
	Wed,  4 Nov 2026 22:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829711;
	bh=Eg06lRv5edHO6+xulTpe/owfvC9Wf3FNBFFEbMCTr2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouTe22r+r3jS6bacpHMNIr5QRfIU7DjeIz1jH2IE4OTY5qfuLDrNhanjE3Cpc6Ek/
	 KXbdVh/TzsCiq7zrS43YNXkuiit+IE34CyU61kVfDt+H6/LUJh9ARMXIBpRpCXoG74
	 LpFHtXiVRDu3Bt+8dMvpcAoW/erxdhQKNyoE5yis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0294/1005] virtio_console: take a kref in find_port_by_vq() to fix port UAF
Date: Wed,  4 Nov 2026 16:00:27 -0500
Message-ID: <20261104211052.148013353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 76f934b5d84be..750c15966d00e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -304,6 +304,12 @@ static struct port *find_port_by_id(struct ports_device *portdev, u32 id)
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
@@ -312,8 +318,10 @@ static struct port *find_port_by_vq(struct ports_device *portdev,
 
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
@@ -1706,6 +1714,7 @@ static void out_intr(struct virtqueue *vq)
 	}
 
 	wake_up_interruptible(&port->waitqueue);
+	kref_put(&port->kref, remove_port);
 }
 
 static void in_intr(struct virtqueue *vq)
@@ -1751,6 +1760,8 @@ static void in_intr(struct virtqueue *vq)
 
 	if (is_console_port(port) && hvc_poll(port->cons.hvc))
 		hvc_kick();
+
+	kref_put(&port->kref, remove_port);
 }
 
 static void control_intr(struct virtqueue *vq)
-- 
2.53.0



