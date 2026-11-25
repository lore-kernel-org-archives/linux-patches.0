Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626183;
	b=C3kWl+rgt6ftM5gjFxNVahjkKwKe0NVvV6o5LZzLKpRhYYAJ/Sh5fIs9Hrvd3wBVS9kA
	 3lngVyChbA/JlqWdT5dzPMOJdpb1r/clmqznkw7Dd3OdAVqMz6/f7fj5DCWe7+zBwnhxK
	 0Nz4iO7QSn10UsMKnV/QhoIqBKjwP2nU3Ra9+7M3edghWD5QOM7e9ds7XTmHibXfb6mY5
	 LOb1i82CDxOnj9Rgi2J3zPdTxaYAvsy2zhx2SkljbDQOVX8IgeMGPZ3vmEAu9C4D1gZJ+
	 ZIk9jzeGvas2gtPBBii7bUHllhfepi6UvVprsW14aFzTIRZq1UIcFc858t0AjNE5QHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qtN7bAZE/OYvCCW86N8zmVbRo9x5hym6G80F3CB3tD4=;
	b=qv3IFyCIZmcTz7XfRkY69F3VuPWHEET/vfFP/X0IPnc2nf8ejuXTHu7wP4HD/Kx7YwAb
	 wFUs4gLvGNEIhNqeKOd/5jHRq8n45lvZ1GZ2FSHCClOeCUKLrKp1I61uYJa/XLucaqXun
	 TG74+OPH7YzNYaxaN5ombFPOmNCK3QADhHfuhhkuFABwX+k6KZDvwtyZiGwIL8GgVwg94
	 zAFcknUMqYvl8lOVXtJWw9+NKhZJSYQos4LoFiZ1NJ1T0lXSFso1mT59oNM7rdbcj0+oD
	 e3wZUjRnd7vzlkYdXKwgavkoGibg8ZvvO6p6p51TXpTglZ3AzLMy3W3AYFVriPKI/nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xanhrt6V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDAF606A31E;
	Wed, 25 Nov 2026 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xanhrt6V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460F41F000C4;
	Wed, 25 Nov 2026 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626182;
	bh=qtN7bAZE/OYvCCW86N8zmVbRo9x5hym6G80F3CB3tD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xanhrt6Vx/F8YfErg+sDI0xuXxIBuHUdE5tb2QL3jcLSCZBmzyQBT4q++sigLM1L3
	 0ADbn6Zb0LqjMETYqo53VxvX0eZrQzhLv86p0JKiY+dgtLc/zOxZNwfeRIS7Me2TeQ
	 ZWazkH2cPUem1grqJJVUb/TfJMWhgZ4YP3DBsCr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.12 760/816] w1: dont hold list_mutex while a slave is torn down
Date: Wed, 25 Nov 2026 15:38:28 +0100
Message-ID: <20261125143906.764930243@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 7ef382cb0ae0b2d6df4fbc5c822cd80394308839 upstream.

When the last reference to a slave is dropped, w1_unref_slave() holds
list_mutex of the master until the slave has been freed.  In between it
calls the ->remove_slave() callback of the family driver and
device_unregister().  Both wait for others: for the sysfs callbacks
which are running, and in the case of w1_therm also for the file
therm_bulk_read of the master and for everybody who is talking to the
sensor.  None of those can therefore take list_mutex, although the
callbacks of therm_bulk_read walk the list which it protects.

The mutex is only needed to make the decrement of the reference count and
the removal from the list one step for w1_search_slave() and
w1_slave_search_device(), which look the slave up in the list and, in the
first case, take a reference.  Once the slave is off the list, nobody can
find it any more.  Drop the mutex at that point.

The callers which hold the mutex of the master, which serialises
attaching and detaching, are not affected.  The one which does not is
w1_process_cb(), when it drops the last reference to a slave which has
been detached while a netlink command for it was queued.  Somebody who
attaches a slave with the same ID through sysfs or netlink at that very
moment used to wait until the old device was gone.  Now the registration
of the new device may fail because the name is still in use.

This is a preparation for "w1: w1_therm: lock the list of slaves for the
bulk read".

Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-7-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -776,16 +776,24 @@ int w1_unref_slave(struct w1_slave *sl)
 {
 	struct w1_master *dev = sl->master;
 	int refcnt;
+
+	/*
+	 * Once it is off the list nobody can find the slave and take a new
+	 * reference.  The lock must not be held any longer than that: the rest
+	 * waits for sysfs callbacks and for users of the family data.
+	 */
 	mutex_lock(&dev->list_mutex);
 	refcnt = atomic_sub_return(1, &sl->refcnt);
+	if (refcnt == 0)
+		list_del(&sl->w1_slave_entry);
+	mutex_unlock(&dev->list_mutex);
+
 	if (refcnt == 0) {
 		struct w1_netlink_msg msg;
 
 		dev_dbg(&sl->dev, "%s: detaching %s [%p].\n", __func__,
 			sl->name, sl);
 
-		list_del(&sl->w1_slave_entry);
-
 		memset(&msg, 0, sizeof(msg));
 		memcpy(msg.id.id, &sl->reg_num, sizeof(msg.id));
 		msg.type = W1_SLAVE_REMOVE;
@@ -799,7 +807,6 @@ int w1_unref_slave(struct w1_slave *sl)
 		kfree(sl);
 	}
 	atomic_dec(&dev->refcnt);
-	mutex_unlock(&dev->list_mutex);
 	return refcnt;
 }
 


