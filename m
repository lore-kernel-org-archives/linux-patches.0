Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623741;
	b=rC5Q9rfnwZsXUW45H7Z/3q2D9NeD1jOhE6RUBLKEKlQkJooxUAp6I9ZsjnD7MJj06B9R
	 cvVAxQfLKpcV7oHOdkwqMqqZvPIv6iHqM7t7KmIuBdnPekPa/uXG1vfX+c5BSmITBkSBN
	 W7QmC44Z7RCNzXltNkkRN7T4kGOpBb2LNdlFjTqA9Fy7LD6HIhA4w7UBqGcEClVRwnxu6
	 w8vgogsGLwarWDAWzh6bl4KX+CCLUq1rbN6wa8YGMgzfxEnfPYXBJGNj+YNV7Y3BKLiRF
	 r1DerUw2mE97m4vtSQh7ayTcEKTdcUW6WmMUR3Lz+xt/1ntvcLxF+gyBwXd/a7fw8nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jj+HooBI/YHWnKQgaCXghjL+rFFbzxs0fkLtf/BmWiI=;
	b=4gsIFpDdaMt6YupbLKn/Kg0pt2MwVmabE8xQNP2OmP9gz9+Z6E3Aa6IIzhKn/41nyFir
	 uQxztPzj3mmyNA9ejXz/CTte8by9+YMwO4qxEPVKXfqYNIoSq48JvDID6MmMuFDt+ftA5
	 NmxkTCEYhETHZxDH709ZNm6DJLOia1DQIjfW/ChmrDIpPnhQO6WDXxZFzFfiZ+7NccFI2
	 Bl/gjwqAr5fvWPOhH9wzDD1VFiFKAQyRvvZwdiSgoZeFQ8Wx3Tiw/6OGENOuj88cG+my6
	 79U4ogygnBN7MVOlzsb2m9dyfEnCzqx7UIlMIxNRqL2YGGhvWtJonbzIO4UqqZka8Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2cu7VBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9734606A321;
	Wed, 25 Nov 2026 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2cu7VBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029521F0093C;
	Wed, 25 Nov 2026 16:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623741;
	bh=jj+HooBI/YHWnKQgaCXghjL+rFFbzxs0fkLtf/BmWiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2cu7VBalSym/rFhnH0uVuhtNu6UduQAyB8yIFkKVRX0S2ctJgKmJfV5U8hxWo7ep
	 CYHfcV8bvBJ3By383qnnUqUa4RbxVL/s4rVkGlA4GEJpMQiAYguglA7QlG6Sgt4bfJ
	 yLgD43DMNy1hejli8M1kunxiwpzAOGqIAo5ZeNGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.18 929/990] w1: use the bus mutex for the "rw" file
Date: Wed, 25 Nov 2026 15:38:16 +0100
Message-ID: <20261125143843.758944592@linuxfoundation.org>
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

commit 8599e08648c0b4913ea7b202511f1294d176e793 upstream.

Commit b02f8bede217 ("W1: split master mutex to avoid deadlocks.") gave
the bus a mutex of its own, because the lock which protects the list of
slaves is held while a slave is removed, which waits for the sysfs
callbacks of the slave, so these must not take it.  It converted all the
slave drivers, but not the "rw" file of the default family in w1.c,
which still takes the mutex of the master to talk on the bus.  That has
two consequences:

- A deadlock.  w1_process() holds the mutex of the master while it
  searches the bus and detaches the slaves which have gone:

    w1_process()                        read() of .../rw
      mutex_lock(&dev->mutex)             kernfs active reference
      w1_search_process()                 rw_read()
        w1_slave_detach()                   mutex_lock(&master->mutex)
          w1_unref_slave()                    waits
            device_unregister()
              waits for the reference

  The file is readable for everybody.

- The accesses through this file are not serialised with those of the
  slave drivers, which take bus_mutex, so that two transactions can get
  mixed up on the wire.

Take bus_mutex here as well.  It also excludes the search, which takes it
for every pass.

Fixes: b02f8bede217 ("W1: split master mutex to avoid deadlocks.")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-1-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -116,7 +116,7 @@ static ssize_t rw_write(struct file *fil
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	if (w1_reset_select_slave(sl)) {
 		count = 0;
 		goto out_up;
@@ -125,7 +125,7 @@ static ssize_t rw_write(struct file *fil
 	w1_write_block(sl->master, buf, count);
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return count;
 }
 
@@ -135,9 +135,9 @@ static ssize_t rw_read(struct file *filp
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	w1_read_block(sl->master, buf, count);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return count;
 }
 


