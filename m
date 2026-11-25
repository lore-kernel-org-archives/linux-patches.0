Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623672;
	b=qCZiD4gE+e91XyJqClr9XIFO7itbaqrDXTgGlctBUFLsUUDQ6iGXwMFfClwhTrA4+j39
	 T+OJcySLGZ2mhs87MUZrQ1OuWJI6qzVbit5RKj/r8gnhpRaVIhMnvCYJRikHuUmuhF3dD
	 a5zcDdF+tmrIf1qRR4wuyBu5daQd75Gb+2z37h6LOQnIXZ3KqJP14dqqhf9FEypwykiM3
	 2B5DK5zwKj5nhjaflxYg42FfURexmjfbnooQaQDT4VI31K1yJUVeyAdH1XYBTs6cBm0Of
	 5wC5W5WW2WkkYQc07YtsNZGqYj5MW9Y2J4ZJ90zsWUikToo97DaTCaSqP4d8+XyegLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K5g0LB6ZB29jgqV2n88gRKWSezP3jMeOV1ZGjhVwy5o=;
	b=I91tVr20fr8a+r1FyBGFYLhVzl63HzsQzCURLaR25f9HpzbdTldcowlJS1f4X0uki8em
	 Ak1ZJRxFas9S8jT/mz0EL/R12w9YPAKo7JvtXbb1ALQHtT7wgHuYz6HwySUESHXa+oGkx
	 gBcXXleBbG6HIX5BI/XqQMLQANHPVt40xFWFtdEEOThAIn4jHJ5pX0ehvGCHN5hC4kHFI
	 jiuqxIJqZlhiT0QEi5+k/53zUSuyvVzj9JOVfPI9RPRMgd00NRt3RfmV7iKUc4JD2Ke6B
	 gxxmVPmqPPTRPPwTspefCxnZIu13ZqZ+VUiJroQH0N4MmZNxJYS+6im8nxyeixlbwEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yezauRCe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70523606A680;
	Wed, 25 Nov 2026 16:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yezauRCe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3EB1F000C6;
	Wed, 25 Nov 2026 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623672;
	bh=K5g0LB6ZB29jgqV2n88gRKWSezP3jMeOV1ZGjhVwy5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yezauRCeuwUqQ/cbpCJwXCvkbQi9evSuzlNECa7pRteDUFWl73m5oGxkLxXHi6CmG
	 oXVfLeTSUAXVL3Ybn0IgAE9xpb2CnzcxLFHG3W57QJa62Pkc6ctPfsNf1iFCJGuTlO
	 RefvmXTJdtxPEI8kp8U5qkgP2qiRQLGL9t5cnE1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.18 927/990] w1: netlink: drop the slave after the bus is unlocked
Date: Wed, 25 Nov 2026 15:38:14 +0100
Message-ID: <20261125143843.713530161@linuxfoundation.org>
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


