Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214746;
	b=sZg2XZbexv1zUn6FMSXMfw4Q1RwnTU9o+p9Ga4RJeD2+WrQG5qtNT2MrZLp4DQMM6bTi
	 BfZkApetrhjRS26m95/K0IXP5fyLY4hdXDzntcYdjejMqHDUtQqi1B1F5ddXJBwtdo4Rk
	 KcGRgjHAKO11vIDx328mHmSPi83jM0iyq7paeNXVfj8iOPyaw2I4tBpvWOELV3hUuuXMe
	 McxNB+wIQX8Trrlta6c3fL9iuWDV0R1oAekMkKIrhrgOLC9n2gVbw4meu855IOyO9myOh
	 9//SxXiBelHakMDiPokU7HAYNgV6JKgsQICxNa75qQ/8eLxv/HeDuUEmx2hevqguB0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MpIA9dj78fyGSOx47QLbC7t/AmgDmOhFLWhgCtQ+i1A=;
	b=cOoMxDO/TA/3F+X+FjNJ1nwzN4MecagZPN3Ar2dKa6lZ3wmR2gEr8sOrVzF+jSir1j/5
	 Gc/ffZYVNz93NIJUExHksfJAG4ihavMnGIctyS5cNmQE6VbekDpiLT1FYwhhlT78OoWZU
	 /ueH1Ljr8JetGkdC9vmYp+S9j/MYsif62gSEAT7Vya11vvPAIqmFwi0g1niiibs28Hhar
	 nVCpwjf6hArfiGqSogObypuFs3+g/bVwFOv9dHIb8ZSqtfd0J/9r55in1gHE1SPr2IXhI
	 7msF4Y/kRsluCkh0CFJ93/mE9EYhQs6VnkBVYq3NRdNSmDqQGG7T67VYXMtMbup5n5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZUAwY22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A802960A262A;
	Wed, 28 Oct 2026 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZUAwY22
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064F81F01825;
	Wed, 28 Oct 2026 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214745;
	bh=MpIA9dj78fyGSOx47QLbC7t/AmgDmOhFLWhgCtQ+i1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZUAwY22EhJPSxFVX0GFw1DQDnERaulath2/xQK6kHEm0VSUz1nwVSI+0FInwlbhc
	 eN1jYEtbvVCPMZB7OJBQEsM8m2sehAhDvLByHwH6nAoujsjgVTDxEohheIaWsQPHpR
	 XLMv1PdD16xQbdHnEUF9R8bCypS7lfZj12vUIMok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuen-Han Tsai <khtsai@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0967/1887] usb: gadget: f_ecm: Fix net_device lifecycle with device_move
Date: Wed, 28 Oct 2026 17:51:03 +0100
Message-ID: <20261028170521.414093112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

[ Upstream commit b2cc4fae67a51f60d81d6af2678696accb07c656 ]

The net_device is allocated during function instance creation and
registered during the bind phase with the gadget device as its sysfs
parent. When the function unbinds, the parent device is destroyed, but
the net_device survives, resulting in dangling sysfs symlinks:

  console:/ # ls -l /sys/class/net/usb0
  lrwxrwxrwx ... /sys/class/net/usb0 ->
  /sys/devices/platform/.../gadget.0/net/usb0
  console:/ # ls -l /sys/devices/platform/.../gadget.0/net/usb0
  ls: .../gadget.0/net/usb0: No such file or directory

Use device_move() to reparent the net_device between the gadget device
tree and /sys/devices/virtual across bind and unbind cycles. During the
final unbind, calling device_move(NULL) moves the net_device to the
virtual device tree before the gadget device is destroyed. On rebinding,
device_move() reparents the device back under the new gadget, ensuring
proper sysfs topology and power management ordering.

To maintain compatibility with legacy composite drivers (e.g., multi.c),
the bound flag is used to indicate whether the network device is shared
and pre-registered during the legacy driver's bind phase.

Fixes: fee562a6450b ("usb: gadget: f_ecm: convert to new function interface with backward compatibility")
Cc: stable@vger.kernel.org
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Link: https://patch.msgid.link/20260320-usb-net-lifecycle-v1-4-4886b578161b@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_ecm.c | 41 +++++++++++++++++------------
 drivers/usb/gadget/function/u_ecm.h | 21 ++++++++++-----
 2 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/gadget/function/f_ecm.c b/drivers/usb/gadget/function/f_ecm.c
index 35ec50685b499..4ea8787734f97 100644
--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -692,6 +692,7 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 	struct usb_ep		*ep;
 
 	struct f_ecm_opts	*ecm_opts;
+	struct net_device	*net __free(detach_gadget) = NULL;
 	struct usb_request	*request __free(free_usb_request) = NULL;
 
 	if (!can_support_ecm(cdev->gadget))
@@ -699,22 +700,18 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 
 	ecm_opts = container_of(f->fi, struct f_ecm_opts, func_inst);
 
-	/*
-	 * in drivers/usb/gadget/configfs.c:configfs_composite_bind()
-	 * configurations are bound in sequence with list_for_each_entry,
-	 * in each configuration its functions are bound in sequence
-	 * with list_for_each_entry, so we assume no race condition
-	 * with regard to ecm_opts->bound access
-	 */
-	if (!ecm_opts->bound) {
-		mutex_lock(&ecm_opts->lock);
-		gether_set_gadget(ecm_opts->net, cdev->gadget);
-		status = gether_register_netdev(ecm_opts->net);
-		mutex_unlock(&ecm_opts->lock);
-		if (status)
-			return status;
-		ecm_opts->bound = true;
-	}
+	scoped_guard(mutex, &ecm_opts->lock)
+		if (ecm_opts->bind_count == 0 && !ecm_opts->bound) {
+			if (!device_is_registered(&ecm_opts->net->dev)) {
+				gether_set_gadget(ecm_opts->net, cdev->gadget);
+				status = gether_register_netdev(ecm_opts->net);
+			} else
+				status = gether_attach_gadget(ecm_opts->net, cdev->gadget);
+
+			if (status)
+				return status;
+			net = ecm_opts->net;
+		}
 
 	ecm_string_defs[1].s = ecm->ethaddr;
 
@@ -805,6 +802,9 @@ ecm_bind(struct usb_configuration *c, struct usb_function *f)
 
 	ecm->notify_req = no_free_ptr(request);
 
+	ecm_opts->bind_count++;
+	no_free_ptr(net);
+
 	DBG(cdev, "CDC Ethernet: %s speed IN/%s OUT/%s NOTIFY/%s\n",
 			gadget_is_superspeed(c->cdev->gadget) ? "super" :
 			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
@@ -853,7 +853,7 @@ static void ecm_free_inst(struct usb_function_instance *f)
 	struct f_ecm_opts *opts;
 
 	opts = container_of(f, struct f_ecm_opts, func_inst);
-	if (opts->bound)
+	if (device_is_registered(&opts->net->dev))
 		gether_cleanup(netdev_priv(opts->net));
 	else
 		free_netdev(opts->net);
@@ -897,9 +897,12 @@ static void ecm_free(struct usb_function *f)
 static void ecm_unbind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct f_ecm		*ecm = func_to_ecm(f);
+	struct f_ecm_opts	*ecm_opts;
 
 	DBG(c->cdev, "ecm unbind\n");
 
+	ecm_opts = container_of(f->fi, struct f_ecm_opts, func_inst);
+
 	usb_free_all_descriptors(f);
 
 	if (atomic_read(&ecm->notify_count)) {
@@ -909,6 +912,10 @@ static void ecm_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	kfree(ecm->notify_req->buf);
 	usb_ep_free_request(ecm->notify, ecm->notify_req);
+
+	ecm_opts->bind_count--;
+	if (ecm_opts->bind_count == 0 && !ecm_opts->bound)
+		gether_detach_gadget(ecm_opts->net);
 }
 
 static struct usb_function *ecm_alloc(struct usb_function_instance *fi)
diff --git a/drivers/usb/gadget/function/u_ecm.h b/drivers/usb/gadget/function/u_ecm.h
index 77cfb89932bea..7f666b9dea026 100644
--- a/drivers/usb/gadget/function/u_ecm.h
+++ b/drivers/usb/gadget/function/u_ecm.h
@@ -15,17 +15,26 @@
 
 #include <linux/usb/composite.h>
 
+/**
+ * struct f_ecm_opts - ECM function options
+ * @func_inst: USB function instance.
+ * @net: The net_device associated with the ECM function.
+ * @bound: True if the net_device is shared and pre-registered during the
+ *         legacy composite driver's bind phase (e.g., multi.c). If false,
+ *         the ECM function will register the net_device during its own
+ *         bind phase.
+ * @bind_count: Tracks the number of configurations the ECM function is
+ *              bound to, preventing double-registration of the @net device.
+ * @lock: Protects the data from concurrent access by configfs read/write
+ *        and create symlink/remove symlink operations.
+ * @refcnt: Reference counter for the function instance.
+ */
 struct f_ecm_opts {
 	struct usb_function_instance	func_inst;
 	struct net_device		*net;
 	bool				bound;
+	int				bind_count;
 
-	/*
-	 * Read/write access to configfs attributes is handled by configfs.
-	 *
-	 * This is to protect the data from concurrent access by read/write
-	 * and create symlink/remove symlink.
-	 */
 	struct mutex			lock;
 	int				refcnt;
 };
-- 
2.53.0



