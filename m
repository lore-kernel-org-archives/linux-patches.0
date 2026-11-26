Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704757;
	b=sKfSYr5eyABfv+jNEzymMPWNGvqXUnsH5feVapahXP5rtGDSARMntVWo3ZO1URrNyJ8o
	 uFrjGg2njhIJig24EmRXUmJjHdaJMEYGxEvqXpIpAP5+tUuWkGgHZdUyXim850Xhc2FtU
	 jvZX/yxad41OUjEjt4dK7/svKsxEQ1acoB2uxGt8aeKWUncQrEhMcN9ZC4K7BOzikT5gK
	 WOh5Tb11KmHBHW/HK8fvpH9hk/FhS01vv7EXXb0osZaJ7WWjifAKNTbtsKC7ba/tFLbEc
	 eO6vLAT6MXAB534n4OQn8MNH34QtKs9ViMs0j8fi5iBNL7qNBsR0v2X+PozM7zgVLCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iX/7fGu5xUYohKiyp+CAIF18wnKcvUZJjI7uNIj7xEo=;
	b=VFprku9BeBKZGZp6rVOKGlcihEhWrJKCXfb6wdNBA15qTT7TXYMF3GSC4JOhqo5iaifo
	 kkMfGq1jqBFmGCZ9odM5MI5PVj6iSW65kC+SEmJNmoJ/1yjk/+yaQ2ZUnHxmKq9Knbx+q
	 F3clemvXl0uxhx8BQgqGZ5KaOm2r9uybm8swWnULKgNC03QjR/cVgNsyor3Xa8aJN6RHZ
	 dCRM/D2rxJGwg4K/KxLop/JKQW/JsqU2NUr0wcx1gRRYlKZ+1k5XzytwSHIyGJZ4nM8os
	 T7vRvrZyGBwr7+fIZ1mNmWp+j4+6/RZP9Ns01SRO+UUKWlPoMgh9G0ELZEQPClLUB3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzQaC0u0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5C1606A31C;
	Thu, 26 Nov 2026 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzQaC0u0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CE11F000EB;
	Thu, 26 Nov 2026 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704757;
	bh=iX/7fGu5xUYohKiyp+CAIF18wnKcvUZJjI7uNIj7xEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzQaC0u0ZkohuaJNf9HgzEu4kHCbmI/pj5wcUb+uqVqLPS03w1T9yGJAATOBuSXt9
	 HUUnj5I6K8MvDBegNVNohsqsvSEQmcPDeL78iDZj05clSomrr2qHaygfWxr/Co7eH+
	 J8RRpwVpgXIgXELmNUYp3BD0P02QYaW5JizZJvoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.10 231/265] w1: netlink: drop the slave after the bus is unlocked
Date: Thu, 26 Nov 2026 15:39:21 +0100
Message-ID: <20261126143621.410591666@linuxfoundation.org>
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


