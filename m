Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043333;
	b=I3vZiexQ8Qus9GD/YRpHtg39IAcyp8oUADVEr9REzutYU+5p4exySKIhmknXPVR6RJ4I
	 Aia+he9bhjeTywDDmFWjjeZBXRfXGkZGE8K+1Eo9wgDhs1y9PHVf3bPw+6L+Y+HRKWdbr
	 FdxWIUv8sJkHwxR6qiHzzN37u15tk7oOdDbDEkMiwnB06RkQ9tgxiDVS8FaOwwZKd7FvQ
	 +hDKQSXNDjKw/QWQJoxxU8CN9iJx/Q2zG7h+7W1/NKZ3zy2ht2GgkP72JYcrjek3vEbl5
	 jJYqAEwKOTNejyxj3YtP9uQ2q91o7veaeXyBR1JVcZGo28mkEtDMOOOY+6wcyMUUR3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QT7jo38bJPOu8QxcAhxVNvzV7xJKsFIwHft/6mZ3zZ4=;
	b=Gpx/r9Vh8MaJ1ALJ8YA8wIy3L0S4yD66FYTe61CjuRh/KBp2+GNc5lZkD452HNYTJ6SY
	 +AqEk9LZFiXSvDJ3WaSVi4w9VZhbk7jgOFpgtF947mGbFQKlUHI04S7st4xvZA2PF1Js9
	 xajcQK7CNNHtfst3aRNFvg/fOM0hR5w5Juq8D+bWoUzZ51lobOYpC+6KY1iGGbCb7b/Vp
	 cA/uXmBSw95O7HiQ2b0FHLt9htKbUYE/9jB8Y2idIR58Wzy9BuYTCuguboKXG+aywKprY
	 X8DWWoveTnb+6l1Bb2P7SkiMnRajJfY5iJrpZSxeF9l8M9qwQXxeUmJhpAdeOtlw/2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrWGx4iw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ADB606A32F;
	Wed, 18 Nov 2026 23:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrWGx4iw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E408F1F000C4;
	Wed, 18 Nov 2026 23:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043333;
	bh=QT7jo38bJPOu8QxcAhxVNvzV7xJKsFIwHft/6mZ3zZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrWGx4iwlNv+OfAs6LwqToUC1irTJbr5hDhX1m7RUVmNA/zs697NU+Tyh1XyjDk2V
	 ca6SA3+/YK7QGFo7Ut9Q3HaJWnSuLYQzbHF/uWRvD0WlkeVggW7BoOJLmNFSHgBNDC
	 nYyXwENDgIFmvVaXqB0g5xB9X7EOh/nfBm9/s6vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0173/2857] virtio_console: take a kref in find_port_by_vq() to fix port UAF
Date: Wed, 18 Nov 2026 15:20:07 +0100
Message-ID: <20261118150207.581508193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4e790f6fe0c3f..2425a6ad5789f 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -313,6 +313,12 @@ static struct port *find_port_by_id(struct ports_device *portdev, u32 id)
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
@@ -321,8 +327,10 @@ static struct port *find_port_by_vq(struct ports_device *portdev,
 
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
@@ -1746,6 +1754,7 @@ static void out_intr(struct virtqueue *vq)
 	}
 
 	wake_up_interruptible(&port->waitqueue);
+	kref_put(&port->kref, remove_port);
 }
 
 static void in_intr(struct virtqueue *vq)
@@ -1791,6 +1800,8 @@ static void in_intr(struct virtqueue *vq)
 
 	if (is_console_port(port) && hvc_poll(port->cons.hvc))
 		hvc_kick();
+
+	kref_put(&port->kref, remove_port);
 }
 
 static void control_intr(struct virtqueue *vq)
-- 
2.53.0



