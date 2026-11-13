Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585343;
	b=UpHj4mIN0PalzybOfSHMjksUqQ0epwGoJhgzLVt0GTmLd6CZWx7aAS2WLJQ9xNC5nsrd
	 V4Z3p9NrPBEEqvUQNGWMBpPZA2tTNvBmwFjkGb9C0RG/VtZm+HVroeYpRDtDqVHF89ukN
	 e86e9hhSIsUkwpYNeDWBzUVRFlsop/ECag7Nra1Ehc78PnjrBvQbfn9Jn2Bq+8OU83JR/
	 Y9hCCIJ1/O1D0EysKLYkOCpUJWoPiOBwmcCtQWdahFPHZnz9UmVEptwimS8PYV47HWeZ1
	 k6aFELRAYfwsz/ethSs6wolG68UEUfRle9jlgY0sfX80QxSj3Ng9DQGwFbfXwyGLueA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GC0Wm2V4sx5N7XwhUdx5hEoRvAsPBprqNj4KUf2NaTk=;
	b=3NFIBQWIdKVblEUU+20zkSiPmHnZpgGsdbCgIe+BZGrgej/0Di/ydVSuDGP/SIo0ATSO
	 OiRgs5at9IlxpAfOTJY6JIZ9bA+868ePwZ0fHM64CxUy6mhqqISDo7q7O/+/WCuauKmOY
	 g33BPfQIVgP0layZXfbJhTlTRm+nGmr8Gxo+Z65Af86MCVJIKWgzapje/oEALgHMyGuye
	 JZfSizXBxL0mwQtaRSnQlc2E+AcZsQcUB4heo/f/8/QPZ6y8xTR2AemqC2lG42UWzCu+I
	 D/jSrwfSCh7LMdf7bMJsL3oP2ZUdFiDkZXQe0JcdnxxRV2pAUtBKEMGdc8hmu5kHymw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ac/UEWLI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C2E60A3809;
	Fri, 13 Nov 2026 15:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ac/UEWLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6F41F00937;
	Fri, 13 Nov 2026 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585343;
	bh=GC0Wm2V4sx5N7XwhUdx5hEoRvAsPBprqNj4KUf2NaTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ac/UEWLIMjCWdOSA5s71YYIMFA8jJJw87RyGKS0JmWVC3TWuTIDKiO84odNziOJMc
	 h1kGtqk8dRXa8hUiw/RNMtsVFgeGVb4s7mH2fcMbN9A47uNjACOPDY1dzrIOUp69gz
	 dK0J2+breCoZkLLHB3yDqNVVHeqME+dZ+6odT5DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 027/507] io_uring/poll: cancel all matching requests in one pass
Date: Fri, 13 Nov 2026 10:45:31 -0500
Message-ID: <20261113153754.294725374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Shang En Sim <sim@shangen.org>

Commit 9eff9c07e927dcd9c57150cd6fb3d4ec76f00480 upstream.

With IORING_ASYNC_CANCEL_ALL, __io_async_cancel() calls io_try_cancel()
until nothing is found, and io_poll_cancel() cancels one request per
call, starting each lookup at the beginning of the hash. A cancelled
request stays hashed until its task work runs, so every lookup walks
past the ones already cancelled. Cancelling K of N pending polls visits
about K*N/2 requests in one io_uring_enter(), with uring_lock held.

A single CANCEL_FD|ALL on 80000 polls on one eventfd takes 17.06s,
0.02s with this change. With voluntary preemption the soft lockup
watchdog fires:

  watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [repro:100]
  RIP: 0010:io_cancel_req_match+0x19/0xa0
   io_poll_cancel+0x73/0x170
   io_try_cancel+0x7b/0xf0
   __io_async_cancel+0x41/0x110

Walk the hash once and cancel every match, as io_cancel_remove() does
for futex and waitid. Cancel by user_data only needs its own bucket.
__io_async_cancel() still loops until nothing is found, so a request
that io-wq parks in the poll hash meanwhile is still cancelled.

A cancel that matches one request now walks the whole hash twice instead
of stopping at the match.

Cc: stable@vger.kernel.org
Fixes: 8e29da69fead ("io_uring: add support for IORING_ASYNC_CANCEL_ALL")
Signed-off-by: Shang En Sim <sim@shangen.org>
Link: https://patch.msgid.link/20261030050319.1448530-3-sim@shangen.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c |  2 +-
 io_uring/poll.c   | 39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index a34543cb423cd..6be224ab53dc9 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -198,7 +198,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 			break;
 		if (!all)
 			return ret;
-		/* futex and waitid return how many they cancelled */
+		/* poll, futex and waitid return how many they cancelled */
 		nr += max(ret, 1);
 	} while (1);
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 4f04bda42f7ff..9b73b0d88a0ee 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -827,12 +827,47 @@ static int io_poll_disarm(struct io_kiocb *req)
 	return 0;
 }
 
+/*
+ * Cancel every request matching @cd in one pass. Cancelled requests stay
+ * hashed until their task work runs, so finding them one at a time would
+ * walk past all the earlier ones on each lookup.
+ */
+static int io_poll_cancel_all(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
+{
+	unsigned int nr_buckets = 1U << ctx->cancel_table.hash_bits;
+	unsigned int i = 0;
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	int nr = 0;
+
+	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
+			   IORING_ASYNC_CANCEL_ANY))) {
+		/* keyed by user_data, so only one bucket can match */
+		i = hash_long(cd->data, ctx->cancel_table.hash_bits);
+		nr_buckets = i + 1;
+	}
+
+	for (; i < nr_buckets; i++) {
+		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
+
+		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
+			if (!io_cancel_req_match(req, cd))
+				continue;
+			io_poll_cancel_req(req);
+			nr++;
+		}
+	}
+	return nr ?: -ENOENT;
+}
+
 static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 {
 	struct io_kiocb *req;
 
-	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
-			 IORING_ASYNC_CANCEL_ANY))
+	if (cd->flags & (IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_ANY))
+		return io_poll_cancel_all(ctx, cd);
+
+	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP))
 		req = io_poll_file_find(ctx, cd);
 	else
 		req = io_poll_find(ctx, false, cd);
-- 
2.53.0



