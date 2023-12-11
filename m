Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44916C8C8;
	Mon, 11 Dec 2023 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhMSRXfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC92DC433C7;
	Mon, 11 Dec 2023 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319587;
	bh=jQ5klFC1N14Yl218qZ03ECHodtWZNQkBIIBTkd70xCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhMSRXfd0cgbrHpPru312wUUfD95cXbBRtUqBFrlJvzxD8Es/SEYdTzk3If6GTQAa
	 3dHrGfsNV79baJMx7uo3TrPyT92acvzcZaU6VM169ErZAxK77lw9EaJ2/3q+ehhGo4
	 2m7qzAczwu+E4YieEX4Fx2b6ZPzWMFiMsuRNGhFg=
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
Subject: [PATCH 6.6 160/244] packet: Move reference count in packet_sock to atomic_long_t
Date: Mon, 11 Dec 2023 19:20:53 +0100
Message-ID: <20231211182053.026701701@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4300,7 +4300,7 @@ static void packet_mm_open(struct vm_are
 	struct sock *sk = sock->sk;
 
 	if (sk)
-		atomic_inc(&pkt_sk(sk)->mapped);
+		atomic_long_inc(&pkt_sk(sk)->mapped);
 }
 
 static void packet_mm_close(struct vm_area_struct *vma)
@@ -4310,7 +4310,7 @@ static void packet_mm_close(struct vm_ar
 	struct sock *sk = sock->sk;
 
 	if (sk)
-		atomic_dec(&pkt_sk(sk)->mapped);
+		atomic_long_dec(&pkt_sk(sk)->mapped);
 }
 
 static const struct vm_operations_struct packet_mmap_ops = {
@@ -4405,7 +4405,7 @@ static int packet_set_ring(struct sock *
 
 	err = -EBUSY;
 	if (!closing) {
-		if (atomic_read(&po->mapped))
+		if (atomic_long_read(&po->mapped))
 			goto out;
 		if (packet_read_pending(rb))
 			goto out;
@@ -4508,7 +4508,7 @@ static int packet_set_ring(struct sock *
 
 	err = -EBUSY;
 	mutex_lock(&po->pg_vec_lock);
-	if (closing || atomic_read(&po->mapped) == 0) {
+	if (closing || atomic_long_read(&po->mapped) == 0) {
 		err = 0;
 		spin_lock_bh(&rb_queue->lock);
 		swap(rb->pg_vec, pg_vec);
@@ -4526,9 +4526,9 @@ static int packet_set_ring(struct sock *
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
 
@@ -4606,7 +4606,7 @@ static int packet_mmap(struct file *file
 		}
 	}
 
-	atomic_inc(&po->mapped);
+	atomic_long_inc(&po->mapped);
 	vma->vm_ops = &packet_mmap_ops;
 	err = 0;
 
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -122,7 +122,7 @@ struct packet_sock {
 	__be16			num;
 	struct packet_rollover	*rollover;
 	struct packet_mclist	*mclist;
-	atomic_t		mapped;
+	atomic_long_t		mapped;
 	enum tpacket_versions	tp_version;
 	unsigned int		tp_hdrlen;
 	unsigned int		tp_reserve;


