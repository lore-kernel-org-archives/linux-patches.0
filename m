Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623642;
	b=j6EYDUmjvU44geDK8a6Zw4OtA62zFuo5G5DmMQpSorW3agh9i1AOuw4ee03Hl0IhvXfh
	 fhLPO0/2rG+lKtp+rkk90kDNEIYCzHysRJvkPFoRKDaCm0ff8T5mDySUDHxwf2s34VFQM
	 e8QcL12CH+T2QfBHB4j5aHnOIFkvS9BKShgUgYwm+RcHc2/GCfhnXVM9YLR/dum2iFdrx
	 po8qAq6glebttCv+VnM4HTP6Y3u74Ixsro89sYe0DSiZc6MSKidSpdly6iC4j89xPNMZ/
	 RdIfqHrIIRVUiIY9lZrEtAAY7wo7VJIdWkOvE8L+uswIITkI7Q59tWw3Qek+EovQboQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rhZwtjQqme4RSlR9AhSFtK9kfEJBtrsn+heWgRbq4zs=;
	b=Cbrw7piR/aMoTLMkxLR4Q0Diew/bRfjub6IhKgEAqbnb5+Tb9tzITGJ3TCvbaFVPL7WJ
	 O2wAnb4yQaq8BVwfQigkFHQZM8WD+i2OzuHC0Y6ojd13FvsnihSSojwc+nLT8VMOanVYB
	 osFRca3GhO0KPE47adx4tVepnm4UBLoa5q21WqV5vpB8sBs0LjenXFC4TVF37CJmFRNtE
	 H8nsjGL3u5TNsg50CVeLfBRouYFZsEv9NcTT3qEFqJlmay80YcEOZ6yTfgUVgf4t6aKpj
	 pBbaJdJrXJ1iTEF426cmxORg+Wd+e2LV7NSgvS4TFtKQHMCg98PINeucfEgUstjy9Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dm5SJT+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B930606A32C;
	Wed, 25 Nov 2026 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dm5SJT+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CF81F000EC;
	Wed, 25 Nov 2026 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623642;
	bh=rhZwtjQqme4RSlR9AhSFtK9kfEJBtrsn+heWgRbq4zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dm5SJT+DlS2ImyHQsvSKBOCc/sQJo+JpKPlRc/Pyxc4rGX3v7b7YcmlByiHRJIZCc
	 pR8NoZ9ImKU51FuX/TPArNAud9957n/4pQZ1+LgaiyoKhyr3900F7XPhibGkS9sWEk
	 12XWhksriWrXH13Acr9b50Z5bGVL8xX1zVQuMt0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.18 923/990] w1: dont hold list_mutex while a slave is torn down
Date: Wed, 25 Nov 2026 15:38:10 +0100
Message-ID: <20261125143843.620107099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
 


