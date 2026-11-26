Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704743;
	b=3KQ9YbEBS4X5c2F41vMSp0+GTK3w0u9Md7xFMgFXQc3d2VGqoQ72RUaWzwGgIgP0+bOR
	 d97z1PHX+Z1QYeLgebmTFAMxm+sDHTMjKGFOZfBGj+qNaBci+hfoxHiZsZFZ9ZekABa2v
	 7T9USFodZ6pVYOU8cZ1maiRShyc69b3Okd8XJO8SE97H5rCwTxXJjG8UU8wnJdqKZop+J
	 4viTW0EgBRPCYpSa/jI3FMq6DrJBm+40xCZ+leeWypy0MyCBhwKnrQJnSyP+QPciiejY0
	 fTxZupB/ENGcd7Ngtls9s+fot9zRSPttY5VLCEDyqhR/VzT1I4AeWvFV/41QzfLUZAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qx47N03bJDl9+aZnfF1vvxY+bRrOUVxVOJCZK0tmFAY=;
	b=ogZ22e68eoKvUjyVByjfx4BIfDPQrGAxKVYanOL8LxTWtTkg8m/8mLqHvJ3uBCEMUbv+
	 8B7CL+KmmeuSnz0HNfn/XDcfrEj/66DYaVJ/KRoKnn068VAUZF1usIU26HTvfIjx/ojdy
	 X53mtDlzlCa0AepoWX/v4teUvuQRNaVY6k8rC+o64RW25dBfq9aBbp8yKGZmHaQBzGjI8
	 j0Rn3sYcEid8MNBB/fKOjbZkqo2l/LqPLK6SRY3rbXilAVBwFtsmsLD45xoFRspN2d8P7
	 gxqRhz8k/f4h8gcgQ/S9nkCqv7LNF9iwYN4Q9n6+VqkS5QaUBCEQIN7kD/45aHzwabA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWwUB5+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF90606A31C;
	Thu, 26 Nov 2026 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWwUB5+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85991F000D0;
	Thu, 26 Nov 2026 14:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704742;
	bh=qx47N03bJDl9+aZnfF1vvxY+bRrOUVxVOJCZK0tmFAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWwUB5+j+5bdkJiCcvFnMzEVPqthnmV9jLw5er6NVFKw010Cq2IChGIFw2Exc7mht
	 QryAbUhi0QIQSw2/jWxtBC2BhcAEF5/WRdCP8fNXDopuN5yrgkBJQ6uXn0BdsSVOcR
	 4TKWa2/5Xk3c0i6PDxuei/ruBUrrhGear1HOc6Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.10 227/265] w1: dont hold list_mutex while a slave is torn down
Date: Thu, 26 Nov 2026 15:39:17 +0100
Message-ID: <20261126143621.131578433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -783,16 +783,24 @@ int w1_unref_slave(struct w1_slave *sl)
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
@@ -806,7 +814,6 @@ int w1_unref_slave(struct w1_slave *sl)
 		kfree(sl);
 	}
 	atomic_dec(&dev->refcnt);
-	mutex_unlock(&dev->list_mutex);
 	return refcnt;
 }
 


