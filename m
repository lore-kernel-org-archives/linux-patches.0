Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704763;
	b=mCst+hAB9oOcY9+A1VYTfl0vYd2NoZuwhLHzexC5XxoJKvu/s0HqMSgs3ifKk5y6uJoo
	 cmunwLWzisKC7GXq/5EQGMzlVJtw+4+AcDNI4Y2yghx7kW932dGsm6G0Xf9iAjNM4tcEw
	 QyGmumdtAKuKuix5fNt1NL8N88CMcGBXr/h5BxzSHErIYpjwnwkBdfnz5jiZddOU3V5yz
	 gJK06M08UGOHOj478Dy+3LK0Mv0D7tgtFI6qUAhgstm2R0vd3XRurb1AP9Mgl7Hg2fuZJ
	 4vqijwmm4XldcykKwogzBZFoOThO5YM2uIinAgZSkQFbbc4fPoc+HYw37QO3cdPD36Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9KbVYD1tVvRjqxC0D8py8wPK3GAtaVCCxAy0LC9+UAc=;
	b=a16l24ii9UsVgN3f964ggLZ7kB4KHghjP2EBbqcfOioN1ZrhqdXnB6xg55L/4ErbNFH3
	 z0/wY3413oGClaCmExr93/Dwrm8sgZgmaK8okvnoPgIFMRt1eNe69vXbKpeS76wQsQ4i7
	 WsUmHIucxJdQRz5X+k60kSJAB/jOh/Cir/6xldiy8/Cctn/EFRUrbXcTNJt7fd9U5yW+R
	 yzxwkSuNbqSwpr1ZgeNrYGkvHZOdnMgGYt4KFK4fGF2TK/U9IpSduTxoyd58BPWuFLsJM
	 Lw5DrDbd45nNX2LWL5lgBdC86ZhGMbRXjHx08M44VFZ5YSNk6HxQwWYX9X0kJy79zNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPo79KBS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B749E606A321;
	Thu, 26 Nov 2026 14:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPo79KBS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E461C1F0093E;
	Thu, 26 Nov 2026 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704763;
	bh=9KbVYD1tVvRjqxC0D8py8wPK3GAtaVCCxAy0LC9+UAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPo79KBS7kdTms5xZLen9kPEOuDr8l0/4oO5Ln3aRqTjRkAt8HUsvE+/iuskAmZ1f
	 AC4Qb7wySWwmnGE2vTBVq9SkKlltP2dI73LJILsUawH5kkVB2+Bi5ULEYOdYTLEXFd
	 TkDWzu7vNOopLss+gmd0lAK/zYhBBjrmeM8jSMYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.10 233/265] w1: use the bus mutex for the "rw" file
Date: Thu, 26 Nov 2026 15:39:23 +0100
Message-ID: <20261126143621.545366615@linuxfoundation.org>
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
@@ -119,7 +119,7 @@ static ssize_t rw_write(struct file *fil
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	if (w1_reset_select_slave(sl)) {
 		count = 0;
 		goto out_up;
@@ -128,7 +128,7 @@ static ssize_t rw_write(struct file *fil
 	w1_write_block(sl->master, buf, count);
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return count;
 }
 
@@ -138,9 +138,9 @@ static ssize_t rw_read(struct file *filp
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	w1_read_block(sl->master, buf, count);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return count;
 }
 


