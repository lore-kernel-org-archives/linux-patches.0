Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6511509AE;
	Tue, 20 Feb 2024 21:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462882; cv=none; b=qY0S1UvYix2ZaxjhW0lkJpEdVhs+alf2uyPJJFHmVgi5pcHl/Z5/cR7PZOW64ioIZwlxvSM0fs/1zTObzZPLhJMOHDdPOo7YNsmOxmyKBDZtsA/jTamHgAKjtD3X992fNBJrVWv2wUrKQFJCvFNndpzSUCYemNgAL9tpkS1eplI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462882; c=relaxed/simple;
	bh=w8mU+z8oMjQTddqEpr1OmXDsFLqXlS91abmp/JyNmbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC7o6Sqz3/gFpfisUXUJz/VgwtbHCoFbmFJfE3q+ryqq1XImzA9rSxzmFHmXJihuF/7XWuqUQ5kcb9TcSDtvR4qi+e9UgdRnvMIwrwHuYaRikvuTxCIfUNg8aDiX1dhUcp61wUV7ssTvnoknGVFBFmKHRLE6CFkLHuqu2DX83z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qje/Qa9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qje/Qa9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451D2C433C7;
	Tue, 20 Feb 2024 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462881;
	bh=w8mU+z8oMjQTddqEpr1OmXDsFLqXlS91abmp/JyNmbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qje/Qa9xXexD4y1LB3dDFD1qw42uEVWbUbl8AN6wlw2zQ5TJWwBoxAbSwfzkIQpHr
	 RdDZDHUzjZp0eMwSioz6CE/to16pLAazgLLILH9gjAabIPHGoiRJCoAO1+wpUSc+J/
	 OXP+SbX2NMwFi5Kx1ZXtkoHYMaG6+W2l3Jg/tT70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 039/197] dm-crypt, dm-verity: disable tasklets
Date: Tue, 20 Feb 2024 21:49:58 +0100
Message-ID: <20240220204842.249151062@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0a9bab391e336489169b95cb0d4553d921302189 upstream.

Tasklets have an inherent problem with memory corruption. The function
tasklet_action_common calls tasklet_trylock, then it calls the tasklet
callback and then it calls tasklet_unlock. If the tasklet callback frees
the structure that contains the tasklet or if it calls some code that may
free it, tasklet_unlock will write into free memory.

The commits 8e14f610159d and d9a02e016aaf try to fix it for dm-crypt, but
it is not a sufficient fix and the data corruption can still happen [1].
There is no fix for dm-verity and dm-verity will write into free memory
with every tasklet-processed bio.

There will be atomic workqueues implemented in the kernel 6.9 [2]. They
will have better interface and they will not suffer from the memory
corruption problem.

But we need something that stops the memory corruption now and that can be
backported to the stable kernels. So, I'm proposing this commit that
disables tasklets in both dm-crypt and dm-verity. This commit doesn't
remove the tasklet support, because the tasklet code will be reused when
atomic workqueues will be implemented.

[1] https://lore.kernel.org/all/d390d7ee-f142-44d3-822a-87949e14608b@suse.de/T/
[2] https://lore.kernel.org/lkml/20240130091300.2968534-1-tj@kernel.org/

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 39d42fa96ba1b ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Fixes: 5721d4e5a9cdb ("dm verity: Add optional "try_verify_in_tasklet" feature")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c         |   37 ++-----------------------------------
 drivers/md/dm-verity-target.c |   26 ++------------------------
 drivers/md/dm-verity.h        |    1 -
 3 files changed, 4 insertions(+), 60 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -72,10 +72,8 @@ struct dm_crypt_io {
 	struct bio *base_bio;
 	u8 *integrity_metadata;
 	bool integrity_metadata_from_pool:1;
-	bool in_tasklet:1;
 
 	struct work_struct work;
-	struct tasklet_struct tasklet;
 
 	struct convert_context ctx;
 
@@ -1729,7 +1727,6 @@ static void crypt_io_init(struct dm_cryp
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
-	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1738,12 +1735,6 @@ static void crypt_inc_pending(struct dm_
 	atomic_inc(&io->io_pending);
 }
 
-static void kcryptd_io_bio_endio(struct work_struct *work)
-{
-	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
-	bio_endio(io->base_bio);
-}
-
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
@@ -1767,20 +1758,6 @@ static void crypt_dec_pending(struct dm_
 
 	base_bio->bi_status = error;
 
-	/*
-	 * If we are running this function from our tasklet,
-	 * we can't call bio_endio() here, because it will call
-	 * clone_endio() from dm.c, which in turn will
-	 * free the current struct dm_crypt_io structure with
-	 * our tasklet. In this case we need to delay bio_endio()
-	 * execution to after the tasklet is done and dequeued.
-	 */
-	if (io->in_tasklet) {
-		INIT_WORK(&io->work, kcryptd_io_bio_endio);
-		queue_work(cc->io_queue, &io->work);
-		return;
-	}
-
 	bio_endio(base_bio);
 }
 
@@ -2213,11 +2190,6 @@ static void kcryptd_crypt(struct work_st
 		kcryptd_crypt_write_convert(io);
 }
 
-static void kcryptd_crypt_tasklet(unsigned long work)
-{
-	kcryptd_crypt((struct work_struct *)work);
-}
-
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
@@ -2229,15 +2201,10 @@ static void kcryptd_queue_crypt(struct d
 		 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
 		 * it is being executed with irqs disabled.
 		 */
-		if (in_hardirq() || irqs_disabled()) {
-			io->in_tasklet = true;
-			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
-			tasklet_schedule(&io->tasklet);
+		if (!(in_hardirq() || irqs_disabled())) {
+			kcryptd_crypt(&io->work);
 			return;
 		}
-
-		kcryptd_crypt(&io->work);
-		return;
 	}
 
 	INIT_WORK(&io->work, kcryptd_crypt);
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -634,23 +634,6 @@ static void verity_work(struct work_stru
 	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
 }
 
-static void verity_tasklet(unsigned long data)
-{
-	struct dm_verity_io *io = (struct dm_verity_io *)data;
-	int err;
-
-	io->in_tasklet = true;
-	err = verity_verify_io(io);
-	if (err == -EAGAIN || err == -ENOMEM) {
-		/* fallback to retrying with work-queue */
-		INIT_WORK(&io->work, verity_work);
-		queue_work(io->v->verify_wq, &io->work);
-		return;
-	}
-
-	verity_finish_io(io, errno_to_blk_status(err));
-}
-
 static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
@@ -663,13 +646,8 @@ static void verity_end_io(struct bio *bi
 		return;
 	}
 
-	if (static_branch_unlikely(&use_tasklet_enabled) && io->v->use_tasklet) {
-		tasklet_init(&io->tasklet, verity_tasklet, (unsigned long)io);
-		tasklet_schedule(&io->tasklet);
-	} else {
-		INIT_WORK(&io->work, verity_work);
-		queue_work(io->v->verify_wq, &io->work);
-	}
+	INIT_WORK(&io->work, verity_work);
+	queue_work(io->v->verify_wq, &io->work);
 }
 
 /*
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -83,7 +83,6 @@ struct dm_verity_io {
 	struct bvec_iter iter;
 
 	struct work_struct work;
-	struct tasklet_struct tasklet;
 
 	/*
 	 * Three variably-size fields follow this struct:


