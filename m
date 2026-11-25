Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622815;
	b=vYl2eoFsfFygmW9OUo/+r0ynWQV4cSRTPRp8YvZs7qkJRq0EISXcedKUGH9bCGs663cZ
	 jT7wiRiGJGFRafXMn6NzN1Fp/xZpSss6XWPh+/BGEkVDucA8qAz4LTXabJuYIgGrq/EPR
	 ubvxfNTyFA2FDwRgK0RU2aPtIVUBmhEg55dj6p6CH2/+3ZcNlPo5p9eCaiGkjim7DGEMp
	 41nzJi3KHtA2mY2iYUc7BxjK5K7tuJ4gKdWx8rdr/43pMcSOQem0cVQCKBWefOxq7DeCr
	 Du5G827jJuDyxXkVTxTMe5ZjuJwA+e+TR/YjGjbLzFX+PBqs3nlhLxzytEsA+qA3hww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yKfqOEBKKEaTXw6cZr1Kf6Xtc1eEXKqV/bzPQ+lUe9M=;
	b=dRGATNOSZsEUqD0nLn7S3RSATeOgAbD/X3FIhgentICoOztMki66YAhDamBqn1TgZir/
	 5axF16WvPl9V8nF3IrEpYlj3XsFi8+1aVEuis0tEUN0tM9uWv4koHAYJLN23oN7xAyHdf
	 HMnprWBYcIp7MXDsICLkemz3pcb2+yjExLIG3j6x5D9yE7EuykVm/O0BO+y3/PUFzSWp1
	 5ncqPC260KS7dfLdYOgIcby5yRYoKxitcAehj1asRhDni5DILRf9cWZ2cxxF9o5F2sxcG
	 rtSmDyo/zMjWC/Nt3atiPSgaZNLmqgx625MNnyPpCsO8K7N8h5qbkVLpqTfwhNHFixw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ls+wYXON;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39056606A33B;
	Wed, 25 Nov 2026 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ls+wYXON
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C931F000C6;
	Wed, 25 Nov 2026 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622815;
	bh=yKfqOEBKKEaTXw6cZr1Kf6Xtc1eEXKqV/bzPQ+lUe9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ls+wYXONqy78opqse3C+FHdFR7Ws02mwAgCyvxnx0Bx769VEu2+GtHvZxZzM0c6fE
	 +60Q7yhuJVrVs7T3kag6GwDSf4KI37MyiTWJjnJNUTKKWs6T/PogNgY5vguFVvGWQz
	 GVxpe5ui2vhYkh7hKSBPD8dtu6DW7KoewewlAeSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 659/990] kprobes: Validate re-registration earlier in register_kretprobe()
Date: Wed, 25 Nov 2026 15:33:46 +0100
Message-ID: <20261125143837.527295087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a553b499f22bf054964d4fd16d136f3d4f836c23 upstream.

register_kretprobe() only checked for re-registration if rp->kp.addr was
specified, skipping the check when rp was registered with symbol_name
and rp->kp.addr was NULL. In that scenario, register_kretprobe()
proceeded to allocate a new rethook (or kretprobe holder), and when
register_kprobe(&rp->kp) subsequently failed due to re-registration, the
error path freed and NULL-ed rp->rh (or rp->rph) on the still-active
kretprobe, leading to NULL pointer dereferences when the active probe
was hit.

Resolve the target address via _kprobe_addr() up-front and check whether
the probe is already registered at that address via
check_kprobe_rereg_at() before allocating any resources, and drop the
WARN_ON_ONCE() in the re-registration check now that re-registration is
gracefully detected and rejected.

Link: https://lore.kernel.org/all/179375032568.247640.17429793187163536192.stgit@devnote2/

Fixes: 0188b87899ff ("kretprobe: Avoid re-registration of the same kretprobe earlier")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |   72 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 32 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1478,52 +1478,61 @@ _kprobe_addr(kprobe_opcode_t *addr, cons
 	return addr;
 }
 
-static kprobe_opcode_t *kprobe_addr(struct kprobe *p)
-{
-	bool on_func_entry;
-
-	return _kprobe_addr(p->addr, p->symbol_name, p->offset, &on_func_entry);
-}
-
 /*
  * Check the 'p' is valid and return the aggregator kprobe
  * at the same address.
  */
-static struct kprobe *__get_valid_kprobe(struct kprobe *p)
+static struct kprobe *__get_valid_kprobe_at(struct kprobe *p, kprobe_opcode_t *addr)
 {
+	struct hlist_head *head;
 	struct kprobe *ap, *list_p;
 
 	lockdep_assert_held(&kprobe_mutex);
 
-	ap = get_kprobe(p->addr);
-	if (unlikely(!ap))
+	if (unlikely(!addr))
 		return NULL;
 
-	if (p == ap)
-		return ap;
-
-	list_for_each_entry(list_p, &ap->list, list)
-		if (list_p == p)
-		/* kprobe p is a valid probe */
+	head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
+	hlist_for_each_entry_rcu(ap, head, hlist,
+				 lockdep_is_held(&kprobe_mutex)) {
+		if (ap == p) {
+			p->addr = addr;
 			return ap;
+		}
+		if (ap->addr == addr && kprobe_aggrprobe(ap)) {
+			list_for_each_entry(list_p, &ap->list, list) {
+				if (list_p == p) {
+					p->addr = addr;
+					return ap;
+				}
+			}
+		}
+	}
 
 	return NULL;
 }
 
-/*
- * Warn and return error if the kprobe is being re-registered since
- * there must be a software bug.
- */
-static inline int warn_kprobe_rereg(struct kprobe *p)
+static inline struct kprobe *__get_valid_kprobe(struct kprobe *p)
+{
+	return __get_valid_kprobe_at(p, p->addr);
+}
+
+/* Return error if the kprobe is being re-registered */
+static inline int check_kprobe_rereg_at(struct kprobe *p, kprobe_opcode_t *addr)
 {
 	guard(mutex)(&kprobe_mutex);
 
-	if (WARN_ON_ONCE(__get_valid_kprobe(p)))
+	if (__get_valid_kprobe_at(p, addr))
 		return -EINVAL;
 
 	return 0;
 }
 
+static inline int check_kprobe_rereg(struct kprobe *p)
+{
+	return check_kprobe_rereg_at(p, p->addr);
+}
+
 static int check_ftrace_location(struct kprobe *p)
 {
 	unsigned long addr = (unsigned long)p->addr;
@@ -1654,7 +1663,7 @@ int register_kprobe(struct kprobe *p)
 		return PTR_ERR(addr);
 	p->addr = addr;
 
-	ret = warn_kprobe_rereg(p);
+	ret = check_kprobe_rereg(p);
 	if (ret)
 		return ret;
 
@@ -2190,20 +2199,19 @@ int register_kretprobe(struct kretprobe
 	int ret;
 	int i;
 	void *addr;
+	bool on_func_entry;
 
-	ret = kprobe_on_func_entry(rp->kp.addr, rp->kp.symbol_name, rp->kp.offset);
-	if (ret)
-		return ret;
+	addr = _kprobe_addr(rp->kp.addr, rp->kp.symbol_name, rp->kp.offset, &on_func_entry);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+
+	if (!on_func_entry)
+		return -EINVAL;
 
-	/* If only 'rp->kp.addr' is specified, check reregistering kprobes */
-	if (rp->kp.addr && warn_kprobe_rereg(&rp->kp))
+	if (check_kprobe_rereg_at(&rp->kp, addr))
 		return -EINVAL;
 
 	if (kretprobe_blacklist_size) {
-		addr = kprobe_addr(&rp->kp);
-		if (IS_ERR(addr))
-			return PTR_ERR(addr);
-
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
 			if (kretprobe_blacklist[i].addr == addr)
 				return -EINVAL;


