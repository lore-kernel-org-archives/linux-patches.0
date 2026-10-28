Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207343;
	b=e9CCS5aQNpbOfhOsfR+Xi4t5rEoXNp2Brc3E4LascHqbjnYgTLaL9xUCbRomWEA63MPu
	 EOEgvED2Y2VYqcI7eT3eVG/sIk589hzTVNZ3M2YSQZ5yoMDde1HvhSjts/6IGb+Rxo2z9
	 0WmV7KchQRd6XKLhVvZg+PctiHGnfGW+oHmuBBBH8JpZirj8LM77y0Rf1qp3TkVYDJZdF
	 9hbn44pbMztLTESb2xkMYcZgzRZkE49e/DyOKOtGsuvL1eiqin+W4kDB2LY/wkewBL680
	 30PIRU437OdQhCSvhV4B61lOQJ2bA30E18yknM6X1fXYIs9t5tvyx8sjTAPpdJKsmTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hPRPrCYg/mFN0b3J9m1QKaUI8q7FjyVDhQhN2tv+lRQ=;
	b=uPXPCUnIpc/mUMFM+bhTTxVIfReORb5D9GzF1soaLa6qIPzU7qheh579VxnZjF45Tcad
	 p1/FbYVX1u5t7UdCuR0zKiMGilkIFSRE2t7z9C59hBITKTPv1Aj+Ta+/JC3GVmDGb9idA
	 yY+RmBpD1003hmJtTWstm3OoQhP+MMkCMCC5sm67hEiTCbrjBWei7BzojAj5mUvbgb3mM
	 7DI1Nr4HAOZ23V81DXaLwtW9weshPHFcX3+rNi1BV58quERpMg+acCMNZ9Xo8Cdanh0uF
	 ORmG/8HNwN5armTETsY4jR0iHrueJ8Lb/tDXExOhxlVCN858zl8m8hvjrzUr19fcM3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CMGL10G4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1C7606A31C;
	Wed, 28 Oct 2026 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CMGL10G4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01951F01829;
	Wed, 28 Oct 2026 17:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207343;
	bh=hPRPrCYg/mFN0b3J9m1QKaUI8q7FjyVDhQhN2tv+lRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMGL10G4BXmoDOEiul8oy6m+jfZcclESmLPXofDNS3KIRgfi80dhTjmj4GgE1JTmK
	 7FI3Qw797UBUJhBi/H8MPWpE2u3oVqm5UXEwD9dpiGmn6QJVwnrXf8aCpX8qgRR5HY
	 hQOyZnoovR+0DS36bWJtOa8ZVMcICTZJhWp7NPpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 18/88] io_uring/cmd: dont leave list poison in ->hash_node
Date: Wed, 28 Oct 2026 17:59:26 +0100
Message-ID: <20261028165942.543851789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 4c83e39f4d1944d7146fd06094f2c8053238d55c upstream.

io_uring_cmd_del_cancelable() uses hlist_del() to take a command off
->cancelable_uring_cmd, which leaves LIST_POISON1/2 behind in
->hash_node. Requests are recycled through the request cache without
being reinitialised, and not every user of ->hash_node sets it up before
it is used:

If a vectored futex wait is woken while futex_wait_multiple_setup() is
still queueing the futexes, io_futexv_wait() doesn't add the request to
->futex_list, and leaves the completion to the task_work queued by the
wake up. io_futexv_complete() ends in __io_futex_complete(), whose
hlist_del_init() is fine for a request that is unhashed, which is how all
other users of the node leave it. If the request was a cancelable
uring_cmd in its previous life, e.g. a ublk FETCH_REQ, it writes through
LIST_POISON2:

  Oops: general protection fault, probably for non-canonical address
  KASAN: maybe wild-memory-access in range [0xdead000000000120-...]
  RIP: 0010:io_futexv_complete+0x219/0x420
  Call Trace:
   tctx_task_work_run+0x804/0x950
   tctx_task_work+0x71/0xa0
   task_work_run+0x118/0x200

Leave the node unhashed.

Fixes: 93b8cc60c37b ("io_uring: cancelable uring_cmd")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-2-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -87,7 +87,7 @@ static void io_uring_cmd_del_cancelable(
 
 	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
 	io_ring_submit_lock(ctx, issue_flags);
-	hlist_del(&req->hash_node);
+	hlist_del_init(&req->hash_node);
 	io_ring_submit_unlock(ctx, issue_flags);
 }
 


