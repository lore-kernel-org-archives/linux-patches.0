Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051297;
	b=kwwLv3LH3xIRwjs3kU68b90FjKD0l0lcHvmsir/ziUGqjZvnrU0LmYuaZYjsYbVwgVWQ
	 BsYckeiuXkbDae/oKhSRAimjcNkpl2g1JcyebZioAq+gdesEc1Vq47lH0syKKkU4F2DKu
	 72Hz+gzH7es5KMU3OfO5usRRqnjheiv5YUSMiUXBP478Nt5UUSMxje9gLjXbwu6xH4iaF
	 d3dWbGxVZ2d4lzyZJpNFeHKr3pWDGI+X5jC2pSO2cNwtsrOroR26GABy5uIMuFcVSKHfc
	 5/wSQmyyY94G4VJTXm4svVj/Gcw24kD1q2vj8+HPMWmNtk6RHa6sNliPS8QCwtPwlug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hTEYb+LyUGpDNKLYVwCXuzf1RbreIpQlgUH3xGCpTEY=;
	b=5NvRs6iHoft7M+RGH06vhAwCZYzMNL7WWkHGzGGU7z/mipREevMqpUiiheWGAb94xeL9
	 g+SSQtYlQPzCqIUP/az2d9WS15cmIG+EKETGrgWO2v/3FUvAuKeAZ/X3T6mR6JX+nRn+o
	 iKOTkp39oWxAA/HRu8zlnivgq8NCiVQ3aAH9AvXFpDbZh4Qg3eER6JyU3UfC+kGJuMP0g
	 R9HRpXDP/PJwOyE1cb2vEWipxAKBBLNb/eRVHYCefqOaDwPeU71vhUXPZ5xv2GSniqKcp
	 q1BIPSq5UV09DT3Mm+Qbc7uiXhDPM8uwkt+JyRGVFX0Tk1VpU8WbLphJ+RlhK9HxzgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cB5mQB/s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B034606A325;
	Thu, 19 Nov 2026 01:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cB5mQB/s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6311F000C4;
	Thu, 19 Nov 2026 01:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051297;
	bh=hTEYb+LyUGpDNKLYVwCXuzf1RbreIpQlgUH3xGCpTEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cB5mQB/sdqtwhYg7w5dSvOrtskfNQU4ENjso9C3vDWDTvoKtOKhI6RgTBn/6rDgda
	 pHXliTe7DWmwUiq+T1wjrmCTbhOza6P2u/He2VPYLzN8JQUsPSJLpSFliRX6Esislf
	 gU2tGJ3sd8X9DhxstZORkeHm9SPncxO0MLA75o/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0157/2214] virtio_console: take a kref in find_port_by_vq() to fix port UAF
Date: Wed, 18 Nov 2026 15:30:33 +0100
Message-ID: <20261118150016.414615906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dadd31a5dbf99..de71c60f175c0 100644
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
@@ -1745,6 +1753,7 @@ static void out_intr(struct virtqueue *vq)
 	}
 
 	wake_up_interruptible(&port->waitqueue);
+	kref_put(&port->kref, remove_port);
 }
 
 static void in_intr(struct virtqueue *vq)
@@ -1790,6 +1799,8 @@ static void in_intr(struct virtqueue *vq)
 
 	if (is_console_port(port) && hvc_poll(port->cons.hvc))
 		hvc_kick();
+
+	kref_put(&port->kref, remove_port);
 }
 
 static void control_intr(struct virtqueue *vq)
-- 
2.53.0



