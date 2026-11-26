Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705692;
	b=AUk39Y5hk7oDTYnGBdMeOjzz5TKSkKncmwNbpkqq6Q/2sci69l4bK5PKsU0d7PpY2QZ+
	 mRm/bUe+sh3RmpgfRnnone1eKvr32xw6TOsyHiJK4c9Sh+7yStnU/fxVS+77CkGLd+gbl
	 21tICtZz2yNbdgvGv1uMBMT50bObLL25EqWKkeB+6sLwJD32AGnxIgyPvwU8FFN2IQvRg
	 GR8GOL96eJIlmA/vbQNyMDR4xdWPny4h9jlFp3bAxWn7t71P3VUQKSUxqHVpc/cSnqiPq
	 pryQnHGUqN2O+52/AFMRGvV31IGwJr0x5oKZJMHioHn06YcdzejNhHs9iaPRYK8Ks3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mo4J2PAb5sGwzN6qKMJZI671ID6z9WEgQevXzbJavGQ=;
	b=AgqL0TgNqDeStmsPC6+iMmL1dkjMOw8ci8+TvFy3dyRtFt7HnN3eydW9jid5F8TWC2Zm
	 4fYoCCjIMKAvFHRFoscBBTjZC0fJ6OYvzviD32w3rn3AD40rki9X59GA0yxxVE1lbuf/k
	 L0Vq4ztnikYJs2u7jD1t8ZsQTJUR1P7oTqHFBo0JfB+ALlLU1zEC4vPQr+uMZONKyd1hi
	 YfCD0OMeguHSnlkozyDRMgvduMV3B+Fflp6P3wFpYC31MK6ra20VJtKRcoa5+ceQFM4IC
	 0Gk5qhCg0zN/EykStEXqsvx5RVoQSkI+IQaKtP9ZZ1+lGS69gEU45Ms4NQe0D5z2Psw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z88m5SLK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FEF606A321;
	Thu, 26 Nov 2026 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z88m5SLK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302441F000CF;
	Thu, 26 Nov 2026 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705691;
	bh=Mo4J2PAb5sGwzN6qKMJZI671ID6z9WEgQevXzbJavGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z88m5SLKlb60PaxAeePgent8z5EWs2mCZVoS+r+8ZnUf9HuSlej0CtpEhF+YZcR2w
	 PN14Yi+rYteJ+OKMfo7LlOmxHKdAHmQYhU0TGnUobinGX/VqUZQZ9vcTEtzO6eGY52
	 c3jX5Gve6Z3zqTjTE2D7XD0DWZ7JyDpQL3r/MWt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.15 284/319] w1: netlink: drop the slave after the bus is unlocked
Date: Thu, 26 Nov 2026 15:40:52 +0100
Message-ID: <20261126144013.166859613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 847fa880a3e1b2fdbbf72d89e830566108457637 upstream.

w1_process_cb() executes the commands of a netlink message with bus_mutex
held, and drops the reference to the slave which the message was
addressed to before it unlocks the mutex.  If the slave has been detached
in the meantime, this is the last reference, and w1_unref_slave() tears
the slave down on the spot.  That waits

- in device_unregister(), for the sysfs callbacks of the slave which are
  running, and

- in w1_therm_remove_slave(), for the readers which have taken a
  reference to the family data,

and both kinds take bus_mutex to talk to the slave.  Whoever is waiting
for the mutex at that moment is never going to finish, and neither is the
thread of the bus master.

Unlock the bus first.  The reference keeps the slave, and with it the
master, alive until then.

Fixes: d3a8a9dbb903 ("w1: hold bus_mutex in netlink and search")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-6-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1_netlink.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -478,15 +478,17 @@ static void w1_process_cb(struct w1_mast
 	if (!cmd || err)
 		w1_netlink_queue_status(node->block, node->msg, cmd, err);
 
+	dev->priv = NULL;
+	mutex_unlock(&dev->bus_mutex);
+
 	/* ref taken in w1_search_slave or w1_search_master_id when building
-	 * the block
+	 * the block.  If it is the last one, the slave is removed, which waits
+	 * for users of the bus.
 	 */
 	if (sl)
 		w1_unref_slave(sl);
 	else
 		atomic_dec(&dev->refcnt);
-	dev->priv = NULL;
-	mutex_unlock(&dev->bus_mutex);
 
 	mutex_lock(&dev->list_mutex);
 	list_del(&async_cmd->async_entry);


