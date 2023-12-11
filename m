Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B616D5102A;
	Mon, 11 Dec 2023 18:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySsrNzKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B054C433C8;
	Mon, 11 Dec 2023 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320593;
	bh=oOOS8CirhJokhL4MdEGpSAVwkAinhR9gPEaQWbWT50k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySsrNzKAajEYCxyyY6uPpnvbBx2gcWSBquriD5wQb3OQ+eLJ3AdCbXFphKcfqQo1d
	 uRwNgPMC9iqC1W5tI1Yn7iRSkmoqcY7yMdhkAyJPkUAC+Nww4pB93385kwbqhXTe3t
	 i8iNO55JAHLNdnS50uceDgLzq3lyNShsVsWLu624=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"The UKs National Cyber Security Centre (NCSC)" <security@ncsc.gov.uk>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	stable@kernel.org,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 119/194] packet: Move reference count in packet_sock to atomic_long_t
Date: Mon, 11 Dec 2023 19:21:49 +0100
Message-ID: <20231211182041.831658751@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

commit db3fadacaf0c817b222090290d06ca2a338422d0 upstream.

In some potential instances the reference count on struct packet_sock
could be saturated and cause overflows which gets the kernel a bit
confused. To prevent this, move to a 64-bit atomic reference count on
64-bit architectures to prevent the possibility of this type to overflow.

Because we can not handle saturation, using refcount_t is not possible
in this place. Maybe someday in the future if it changes it could be
used. Also, instead of using plain atomic64_t, use atomic_long_t instead.
32-bit machines tend to be memory-limited (i.e. anything that increases
a reference uses so much memory that you can't actually get to 2**32
references). 32-bit architectures also tend to have serious problems
with 64-bit atomics. Hence, atomic_long_t is the more natural solution.

Reported-by: "The UK's National Cyber Security Centre (NCSC)" <security@ncsc.gov.uk>
Co-developed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20231201131021.19999-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   16 ++++++++--------
 net/packet/internal.h  |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4275,7 +4275,7 @@ static void packet_mm_open(struct vm_are
 	struct sock *sk = sock->sk;
 
 	if (sk)
-		atomic_inc(&pkt_sk(sk)->mapped);
+		atomic_long_inc(&pkt_sk(sk)->mapped);
 }
 
 static void packet_mm_close(struct vm_area_struct *vma)
@@ -4285,7 +4285,7 @@ static void packet_mm_close(struct vm_ar
 	struct sock *sk = sock->sk;
 
 	if (sk)
-		atomic_dec(&pkt_sk(sk)->mapped);
+		atomic_long_dec(&pkt_sk(sk)->mapped);
 }
 
 static const struct vm_operations_struct packet_mmap_ops = {
@@ -4380,7 +4380,7 @@ static int packet_set_ring(struct sock *
 
 	err = -EBUSY;
 	if (!closing) {
-		if (atomic_read(&po->mapped))
+		if (atomic_long_read(&po->mapped))
 			goto out;
 		if (packet_read_pending(rb))
 			goto out;
@@ -4483,7 +4483,7 @@ static int packet_set_ring(struct sock *
 
 	err = -EBUSY;
 	mutex_lock(&po->pg_vec_lock);
-	if (closing || atomic_read(&po->mapped) == 0) {
+	if (closing || atomic_long_read(&po->mapped) == 0) {
 		err = 0;
 		spin_lock_bh(&rb_queue->lock);
 		swap(rb->pg_vec, pg_vec);
@@ -4501,9 +4501,9 @@ static int packet_set_ring(struct sock *
 		po->prot_hook.func = (po->rx_ring.pg_vec) ?
 						tpacket_rcv : packet_rcv;
 		skb_queue_purge(rb_queue);
-		if (atomic_read(&po->mapped))
-			pr_err("packet_mmap: vma is busy: %d\n",
-			       atomic_read(&po->mapped));
+		if (atomic_long_read(&po->mapped))
+			pr_err("packet_mmap: vma is busy: %ld\n",
+			       atomic_long_read(&po->mapped));
 	}
 	mutex_unlock(&po->pg_vec_lock);
 
@@ -4581,7 +4581,7 @@ static int packet_mmap(struct file *file
 		}
 	}
 
-	atomic_inc(&po->mapped);
+	atomic_long_inc(&po->mapped);
 	vma->vm_ops = &packet_mmap_ops;
 	err = 0;
 
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -126,7 +126,7 @@ struct packet_sock {
 	__be16			num;
 	struct packet_rollover	*rollover;
 	struct packet_mclist	*mclist;
-	atomic_t		mapped;
+	atomic_long_t		mapped;
 	enum tpacket_versions	tp_version;
 	unsigned int		tp_hdrlen;
 	unsigned int		tp_reserve;


