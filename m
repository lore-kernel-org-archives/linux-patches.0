Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625987;
	b=2bFJkx2Cdf+yzkIO0YAm0TYiYST5Al0KkaYZm9JUcWLCKNhoLloJVKkcsusM/GcPh5rq
	 JrCja6txOOc8sNZhsLfwV8t55KCT5uLrO19a27MsaPwtwZfAONBO77TBgAhGcgSbigCCx
	 HvNFG4zrhGl25CG0tp43iQDz0yOEqDOq5xfqhfyuIGOxsS0cbNgfEs6IznrSgEIDbwl0W
	 eB3omaSB+E2M4aTWMGpludZdDeYK8HApGWVeL8/Wyj69ip7THwp9+5oQxMsjfagljsWmF
	 qhTD4q/l7r1mYKp3jM9FQ8crssaxoFt56/4hP6p6JoPh3Xi6QK61tRffdH6yTnNQqfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LkeSC22xEi8qpDK3njgre/MIqA8BoklvkNYHz75b1cw=;
	b=dVev/3Zk8+dETVm/NttsJ4J8yLn09GZ5bIKDi/50wXxd0SUobhNAmBUwhcSZMBpEfazB
	 MGB47KpKD8fnTY/MD0gR3cf8E1QszTBppmetFFisSwmaxbUkUV+0ZQUWgTKqzCHKqa7wQ
	 7TOoFKCKjFVqwaih+wmu6gWWJt1cYo5WE88lALbAMGQq3ogM8qXuEf4XppBfKIHrUnIG5
	 l3R0gUHxCq52tAWrQLKBwDIsEkqrTumx0Pmxj/B4fNqaZ7+fgA0kUcNtoKx/rWU3qzDMt
	 CwWy8jzVdv0yqkXYj5xIVXzjk9AiJ7qOVD8a4jcx1I/NDGeznR/BfxWDh7zo/R8pjXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfEFlDUR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABB9606A31E;
	Wed, 25 Nov 2026 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfEFlDUR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF081F000D1;
	Wed, 25 Nov 2026 16:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625987;
	bh=LkeSC22xEi8qpDK3njgre/MIqA8BoklvkNYHz75b1cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfEFlDURp9KiqVjSgi3GJxZqn++WW2sRMpKlhxnds0erV3s8yIw+cC23EemerzY3o
	 tVgPwz5DiBegMVdcmQxiFVzc/4LPFkgCV3cVmaTMFaEB0pZ1qldTFGOBWwBR9xzlU2
	 TjM4aWS63BXKPSTCDCIBvJBHvaiV1ghmi4x6l1SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5307e3bcacec2ce4c2f0@syzkaller.appspotmail.com,
	Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 693/816] dm: Reject table setup after queue or disk teardown
Date: Wed, 25 Nov 2026 15:37:21 +0100
Message-ID: <20261125143905.225999256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>

commit ae310e4ad872a42f4707a596e66417f2aaa52826 upstream.

A failed table load can leave a mapped device in a state where its
queue has already been initialized or its disk has been removed, while
md->type is still DM_TYPE_NONE. A later table load then calls
blk_mq_init_allocated_queue() on the same queue. If del_gendisk() exited
the old hardware contexts, blk_mq_exit_hctx() dereferences their cleared
flush queue pointer.

Reject setup attempts after queue initialization or disk removal. A
failed request queue initialization still leaves md->tag_set NULL and
can be retried. Set the request-based disk operations only after that
initialization succeeds, so an unsuccessful attempt cannot leave a
bio-based retry with request-based operations.

Reported-by: syzbot+5307e3bcacec2ce4c2f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5307e3bcacec2ce4c2f0
Cc: stable@vger.kernel.org
Signed-off-by: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2595,13 +2595,17 @@ int dm_setup_md_queue(struct mapped_devi
 
 	WARN_ON_ONCE(type == DM_TYPE_NONE);
 
+	/* A failed setup may have left the queue initialized or the disk dead. */
+	if (md->tag_set || test_bit(GD_DEAD, &md->disk->state))
+		return -ENODEV;
+
 	if (type == DM_TYPE_REQUEST_BASED) {
-		md->disk->fops = &dm_rq_blk_dops;
 		r = dm_mq_init_request_queue(md, t);
 		if (r) {
 			DMERR("Cannot initialize queue for request-based dm mapped device");
 			return r;
 		}
+		md->disk->fops = &dm_rq_blk_dops;
 	}
 
 	r = dm_calculate_queue_limits(t, &limits);


