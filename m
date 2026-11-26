Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705701;
	b=3YhDDHr3dy4wUZljiBankSB/xPI0LAMsnlYXbUYatKErkr1Yoe89oX431HUSpSGQ5zPJ
	 H3PGwRlMCEjgZ9mGtfXyaWOtIxNrwAXBU2Xws6rx9VfFgRYJKg6gv47GG3OcS/3zXo8fH
	 x9x1U9VnKcZIvSGHHnZrqNCVhsg1+97H0LTumJ6dgjetJMWcKA0A9vA6u/REiic2UcJ1T
	 CCkAenMWa6mjVhUhTZm+segac4kqOMMUeiS2KtX/e7NGOPe/hleJb9DBxVp3rwxcUALtK
	 bDZLTi4hTCnFJk2I23zw4dG9Pr4o21WBPiSHVq9d5eD8KkNfH8aFlhkn4xzM/Cj+fVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WRvNX3NjH3QgC/HGFA6+IuzBMEX6ymEa7o1kc5DLZ5s=;
	b=xNRrw0aoI5d7bLPrqt3ePp3Y3sBsj6mswdTDHY1k5cDlt/bBu+Mopc/nErWmuD6LmKKp
	 2OoFqUokM20kfoL1X6+GUXIq5i1ahTp7iCvPdqIrjcKasOJC7nZVKcYb1z8old3Hwvw1T
	 1hdnREbVC9+CiX4o/i1bgfgcMyo1fZZhb+YSQotXPY5JI5/jTNDw41XaSypemw95Cu/XL
	 ZRNCEtzAatQSB5Lq+Jmf0uBizs+qFBbZnWodaMtfGAjXiLsWfUTnHUX4Bv+CcpKKYPwEw
	 gV75bwg/igS+Jug+IjSskL03fUcdcYNEsuFTDWN9HWyeuuMbRVT+gG7UHH+Q2Fzp1Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYCYEYZF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2467606A33B;
	Thu, 26 Nov 2026 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYCYEYZF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88021F000C6;
	Thu, 26 Nov 2026 15:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705701;
	bh=WRvNX3NjH3QgC/HGFA6+IuzBMEX6ymEa7o1kc5DLZ5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYCYEYZFoAb/QTbOQ94eJKoHfmSrjZOJZwsnB2LqJMoD7v6IffRby42TvFte1r9pa
	 61clAibJDAAUXw4NSYFSgeqkUICtKw43qaOQpbf9FPxNJdyqGxxMvJ+or+2jH2+A06
	 z5GwzqU47smOChzGVivx4N2HSVwn0qujUUWN+2iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.15 286/319] w1: use the bus mutex for the "rw" file
Date: Thu, 26 Nov 2026 15:40:54 +0100
Message-ID: <20261126144013.212901254@linuxfoundation.org>
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
@@ -121,7 +121,7 @@ static ssize_t rw_write(struct file *fil
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	if (w1_reset_select_slave(sl)) {
 		count = 0;
 		goto out_up;
@@ -130,7 +130,7 @@ static ssize_t rw_write(struct file *fil
 	w1_write_block(sl->master, buf, count);
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return count;
 }
 
@@ -140,9 +140,9 @@ static ssize_t rw_read(struct file *filp
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	w1_read_block(sl->master, buf, count);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return count;
 }
 


