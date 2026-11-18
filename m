Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057455;
	b=QL55UUzqFtkzo5OvhUl7yApVwAOnYy9xCww0ExRPJHBdllsnmjMZ2gt+6VA9d4paho+4
	 yxPzK6qH5isnYsjAeG0Dv3gAr8iCxeDgJvzqYZ+3OkP4Ufv/ir5Sy3jk7lSqlPUQJItGv
	 PMHFrkz59QuUZEEELxy3jooxtP2oFA7qa2NRxKaPqzThYYhmxPwb2mOYZrs/+nXYNGTwB
	 1hhknUciIz8PSlkwBSMnfpmg3FM9r9ZRkzX4rfvj1bYh1eDGZhqRH6wiD84zkmqmLHVpI
	 CKHiOlheNr66szeAcf+LXWRL0NYZJxBFIx9XlyH5fJxhz91Ct6iGd8QqRrmJ4+vy3tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CjlE1dV4380eTk+3rzgjgbh+B04m7mEKuZ6ZS+pBoUk=;
	b=uDS8k2ILPVUTQFr8lrW2V3wODu3KpWOOu1hrMDKP3FB+VhWHsKaeygl9QTzjTPInxLP2
	 J2uCoLKpbuYmnug26RbotkBS8NeW6+8DQzyXGGYcPeCtYLVQkw1O2oBbPShRB6jP/rvT/
	 IHhlODFLkJNbLZvnjXUBgxECD221huMhVhrKpAg0f+M//uwGpnr+m8GdvN3z/83QKqx6i
	 fQkJQYiS3455ZXZ2PlGVBxoSNMHqjuBSHdOgwmHM4m5BfVtGBGcxr7YdpqIwmCExBQAJE
	 VB1DRu7u5Vb3PatT+hZFk3XRkI4V4PrQUu2fvLaifj3LTdyWu8EM92yN87iwAjnY+kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2cNMNSi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32AF606A33A;
	Thu, 19 Nov 2026 03:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2cNMNSi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4060A1F000C6;
	Thu, 19 Nov 2026 03:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057454;
	bh=CjlE1dV4380eTk+3rzgjgbh+B04m7mEKuZ6ZS+pBoUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2cNMNSi4imEdiV2uTdrGshgeDbIF6IcGN+jWhPkbzz/Ez1/Gmn3Pw4ybgW0sMRMC
	 YNIyUGqAMBp2rNFCCYP+MU8IKsCyzLzBXo2Fv3a5o/fV1RJQlMz3rR3he4Cv5UOm1l
	 omZwnV01X73OZOh92q9jRcHxQSCsIxMoENwNpHmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0134/1848] virtio_console: take a kref in find_port_by_vq() to fix port UAF
Date: Wed, 18 Nov 2026 15:36:12 +0100
Message-ID: <20261118145916.801103409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5131bc5e36753..fec32f3c80540 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -312,6 +312,12 @@ static struct port *find_port_by_id(struct ports_device *portdev, u32 id)
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
@@ -320,8 +326,10 @@ static struct port *find_port_by_vq(struct ports_device *portdev,
 
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
@@ -1748,6 +1756,7 @@ static void out_intr(struct virtqueue *vq)
 	}
 
 	wake_up_interruptible(&port->waitqueue);
+	kref_put(&port->kref, remove_port);
 }
 
 static void in_intr(struct virtqueue *vq)
@@ -1793,6 +1802,8 @@ static void in_intr(struct virtqueue *vq)
 
 	if (is_console_port(port) && hvc_poll(port->cons.hvc))
 		hvc_kick();
+
+	kref_put(&port->kref, remove_port);
 }
 
 static void control_intr(struct virtqueue *vq)
-- 
2.53.0



