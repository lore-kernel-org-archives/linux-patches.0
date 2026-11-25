Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620691;
	b=s7bhQHlOQ/JPMGspLzG7e0Yt2hbj8NCAZnUURWExd2bOzmxNv5QKjYU+W1kDGX6sKQjc
	 NZ56+a/1sb3GbXQx51oWqNUttnjJk7aMMpfgFO9D8edECOUQqwPPgRKMOhcbOorgwL358
	 uTqnlXnnWzABZBr+nZ1sD0eb66h6WV3OVyZ2fVZfqOXIWG2+nyK7EsPtCLMxKS+R55G1Y
	 +BfWkwcRN1ALfgo2iygZ2ssLpP6qH/FOd3wymsrJ53pvmWEkiDzgucpcgqp2kTB65SEVG
	 9wtrYRPB5Ec2E8Modau32joOp9EBaWSDgyTfNZZbCOoHYdmkeQnbCre9oApfya4WQag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nfYJ+zcM3pH48PiJY7fdh79klnQVozc6JGlt3a203JU=;
	b=TxTAaDnuVGDG5jJ+b1FI8whON8UlfY0/D275XENH8udThzmqT5yY4QYjWpYo8tKNTNsA
	 DNFCPjvIYa/gqmme11xyJzoc4IA8WCwEeRt8zae3wIoZ+ZamwCCbK/2JTdjYrpD6yDWOS
	 eb4sGC52t5t6iDQI6AD4fpXZrmtw7FAjdI6I5KMUeo96uWAnC9Y3VYHOGolk9bqSkDvyd
	 o/bMJ2XHhSsK+shtFSrYByW7RwLHrd3e7Aka0mOUTW5TfnXc6WNd/ElK3GMIBUjeILjeo
	 tEDl302THQvpBjwY5IbASNdjegd+frhNlqpYTQ2fhf3m7CNgZMSRH+S2kWMuX734GSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2LRvQlqf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1FE606A31E;
	Wed, 25 Nov 2026 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2LRvQlqf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3E01F000C6;
	Wed, 25 Nov 2026 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620691;
	bh=nfYJ+zcM3pH48PiJY7fdh79klnQVozc6JGlt3a203JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2LRvQlqfRuKgHkMerkSSU9bdw9KbguGY1XQs/Pcf/wPqqf3ji9cM/t71psAkRnCaK
	 lmnsXeUOc6BjMfMZGUlfPme6WJ8vXpy3OlzC1yOcAnG1uRKsHbXY2TwCn5cFs9wLGv
	 26qAVTNu1mgUTv4O6nZ8++c/TiJSNhyvDDioFUuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Tofigh <mt4022@columbia.edu>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.3 1001/1005] nvme: fix deadlock on nvme_subsystems_lock in nvme_init_subsystem()
Date: Wed, 25 Nov 2026 15:38:59 +0100
Message-ID: <20261125143845.101763436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mani Tofigh <mt4022@columbia.edu>

commit ba1213be15c613a1c03db69ea6480ca140a6ca00 upstream.

Connecting a controller to a new subsystem deadlocks when
sysfs_create_link() fails in nvme_init_subsystem(), e.g., on an
allocation failure.  The error path drops the last subsystem reference
with nvme_subsystems_lock held and nvme_destroy_subsystem() takes the
same lock again:

  nvme nvme0: failed to create sysfs link from subsystem.
  ============================================
  WARNING: possible recursive locking detected
  ...
  nvmesubsys/95 is trying to acquire lock:
  (nvme_subsystems_lock){+.+.}-{4:4}, at: nvme_destroy_subsystem+0x1b/0x1e0

  but task is already holding lock:
  (nvme_subsystems_lock){+.+.}-{4:4}, at: nvme_init_identify+0x81e/0x34b0
  ...
  Call Trace:
   __mutex_lock+0x1a2/0x26e0
   nvme_destroy_subsystem+0x1b/0x1e0
   nvme_init_identify.cold+0x3bc/0x56f
   nvme_init_ctrl_finish+0x1bc/0x7a0
   nvme_loop_configure_admin_queue+0x205/0x2b0
   nvme_loop_create_ctrl+0x480/0xd10
   nvmf_dev_write+0x365/0x650
   vfs_write+0x1e3/0x1250
   ksys_write+0xfa/0x200
   do_syscall_64+0xfb/0x590
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  ...
  INFO: task nvmesubsys:95 blocked for more than 20 seconds.
  INFO: task nvmesubsys:95 is blocked on a mutex likely owned by task nvmesubsys:95.

Every later controller setup or removal then waits for the lock too.
The nvme_validate_cntlid() error path for an existing subsystem does the
same put, and deadlocks the same way if the other references go away in
between.

Drop the lock before the put.  For a new subsystem, take it off the list
first so another controller can't find it in between.  With the fix,
the connect fails and the next connect works.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 30s.

Fixes: 32fd90c40768 ("nvme: change locking for the per-subsystem controller list")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3399,7 +3399,11 @@ static int nvme_init_subsystem(struct nv
 	return 0;
 
 out_put_subsystem:
+	if (!found)
+		list_del_init(&subsys->entry);
+	mutex_unlock(&nvme_subsystems_lock);
 	nvme_put_subsystem(subsys);
+	return ret;
 out_unlock:
 	mutex_unlock(&nvme_subsystems_lock);
 	return ret;


