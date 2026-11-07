Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063246;
	b=L8FhxWASm8m6YqPQQ0khhMZ10SOGKWYwHOccrwrCjetdUuL+8mqD+fQqFmbfqisFsaUG
	 EJ7gYVQSwqO8EBazjPQo0nAmApYx8IXBu4AvlCj8O+560tyYp5OHdrRoidBbRWs2rL99t
	 0cFSw89JzGwUhr7fIsI2FZx+ob5pbvHk1d1Xk+/Bcrc7FFJJxwyhhGv2oEDmaazvxJuwP
	 l3JcapsRekTdugcnqqZV8em7xDG7yvCnbp2n9bd+ubP8VUS2vQzq5OfDX+60KW/Ak9Cvh
	 GAmBhzsE3OTeDFzqx8NV97w6GA9NFN1/rX/5LTSPk3oPq9be8WRotZQQrgJVPs+Aecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=toREthKeR/BMLpFefXbyjYO5UoDj9BnxZlQa4l2dZG0=;
	b=bEE5B57aB+DsjxwC053+bK4uTwnD4sjQXgj8SLErXumC6MLjqb1mVlNtNJYvpEBkMwZr
	 H1BhSppmcBA/wkZZr4tvOY3NBJG1FxOr6BPKa4sULgUTNDuWWj+fRiDHsa6CGifxmL96t
	 sjm8rREJZ3ekNGGX/fKcCaE4dBaNPuN6znzhOVxANo5de6oC/tOihtjT6yXFT5YQ0EF0F
	 s6P5ELKsU0ZDUFgVPUZsfAJgfVTkX6i3gdebP+pXgqrcAlzQQ50zKSoiLRFI1cw3mt4s+
	 ajz+i3P13nthE3IhV2+pjQ+JaHifb+hdT/2tcClmk4CfAoZmbmDIKnL67Y9iDuWkFyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ic62R6VZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC9C606A32E;
	Sat,  7 Nov 2026 14:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ic62R6VZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12721F0089F;
	Sat,  7 Nov 2026 14:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063245;
	bh=toREthKeR/BMLpFefXbyjYO5UoDj9BnxZlQa4l2dZG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ic62R6VZGOhPib3c4R1kSg92X1Ha3Ygj5D9LNtMM1THcBK+FgAhb/nQXOv8KDW32E
	 HfOIVJVhEg79Mdw4PQpT9yAfYQGcGAfSH3sIsdqCzQjhmrhWj7l6K/CjB0e2NiMvoX
	 chXJx8llKVknU/8i7yChS/5yxk2F7wMi31BWA+Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 450/869] xen-blkfront: Fix IO race during unplug
Date: Sat,  7 Nov 2026 08:52:12 -0500
Message-ID: <20261107134908.980682466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 61b6d1df1d6234c38a6ea7e4f58e7da035ef6ab4 ]

During unplug, blkfront stops the hw queues and marks the disk as dead,
then later during removal calls del_gendisk(). However, IO issued after
the hw queues are stopped but before the call to del_gendisk() will be
queued but never handled. This causes del_gendisk() to hang forever
waiting for the queue refcount to drop to zero.

This can be reproduced by issuing IO during an artificial delay after
stopping the hw queues.

Fix this by simply not stopping the hw queues directly. Marking the disk
as dead already freezes the queue which prevents new requests being
added and it synchronously runs the hw queues to clear anything pending.
If the hw queues are stopped when calling blk_mark_disk_dead(), running
the hw queues is a no-op and can leave queued requests unprocessed.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261006163411.2583538-1-ross.lagerwall@citrix.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index f37290fd3c5db..79fe0b107887c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2133,10 +2133,8 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	if (info->rq && info->gd) {
-		blk_mq_stop_hw_queues(info->rq);
+	if (info->gd)
 		blk_mark_disk_dead(info->gd);
-	}
 
 	for_each_rinfo(info, rinfo, i) {
 		/* No more gnttab callback work. */
-- 
2.53.0



