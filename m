Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD602367AE;
	Mon,  2 Jun 2025 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872982; cv=none; b=NeXi3l94/+UJyu8GG0OsN9elHOvCWEkunUbXbvyexID1SwukOuzGNYa3a05g6Rr+tjt+mqCJcEt0GiAH73Xlm4DJLrD6znZHYtRbGm6BSVip+Fm4nDLl3yi+cRJWflaJ0AiJ1MRBosQyNe4uJxEvY7pIhjrfKMBpJj9E+XARXec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872982; c=relaxed/simple;
	bh=/0sFe3mMu6CltangikJA5Im9FD8yuQuXydrw/umU1NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlwjay/Wpm5EH+olISt4kqED1Zsy0sIzIjKTdjIF28VX4swnavJEuGuF8p8tkm5GnmFI/HmzT8SOCjwrkJqilkN99cvTbz3qsKuzAkgPLZWCvO/Q4NqY7oGO0W6OCXjYutx91X5H0W6wA9Wl4dtH5HPzhHSbFEAShw4rSM9/2po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBlh3C3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBlh3C3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1891CC4CEEB;
	Mon,  2 Jun 2025 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872982;
	bh=/0sFe3mMu6CltangikJA5Im9FD8yuQuXydrw/umU1NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBlh3C3WIbziIpby8fsNsnAoT4apCnjqHXeqH+vu4r2O8jhFdkGlBC9j+ijOpYVSG
	 PqZsvLzF6ejfJNerOoYSiL8rEW7+kFDbT2zYhYO/s0bHyGg6hcmkN89noAw4ukkpWm
	 Dfiqrg0jjxpAPMr3im1Op6V9Z2Tx1/XxG4GW4DzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Savino Dicanosa <savy@syst3mfailure.io>,
	William Liu <will@willsroot.io>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 29/55] net_sched: hfsc: Address reentrant enqueue adding class to eltree twice
Date: Mon,  2 Jun 2025 15:47:46 +0200
Message-ID: <20250602134239.425325059@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

commit ac9fe7dd8e730a103ae4481147395cc73492d786 upstream.

Savino says:
    "We are writing to report that this recent patch
    (141d34391abbb315d68556b7c67ad97885407547) [1]
    can be bypassed, and a UAF can still occur when HFSC is utilized with
    NETEM.

    The patch only checks the cl->cl_nactive field to determine whether
    it is the first insertion or not [2], but this field is only
    incremented by init_vf [3].

    By using HFSC_RSC (which uses init_ed) [4], it is possible to bypass the
    check and insert the class twice in the eltree.
    Under normal conditions, this would lead to an infinite loop in
    hfsc_dequeue for the reasons we already explained in this report [5].

    However, if TBF is added as root qdisc and it is configured with a
    very low rate,
    it can be utilized to prevent packets from being dequeued.
    This behavior can be exploited to perform subsequent insertions in the
    HFSC eltree and cause a UAF."

To fix both the UAF and the infinite loop, with netem as an hfsc child,
check explicitly in hfsc_enqueue whether the class is already in the eltree
whenever the HFSC_RSC flag is set.

[1] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=141d34391abbb315d68556b7c67ad97885407547
[2] https://elixir.bootlin.com/linux/v6.15-rc5/source/net/sched/sch_hfsc.c#L1572
[3] https://elixir.bootlin.com/linux/v6.15-rc5/source/net/sched/sch_hfsc.c#L677
[4] https://elixir.bootlin.com/linux/v6.15-rc5/source/net/sched/sch_hfsc.c#L1574
[5] https://lore.kernel.org/netdev/8DuRWwfqjoRDLDmBMlIfbrsZg9Gx50DHJc1ilxsEBNe2D6NMoigR_eIRIG0LOjMc3r10nUUZtArXx4oZBIdUfZQrwjcQhdinnMis_0G7VEk=@willsroot.io/T/#u

Fixes: 37d9cf1a3ce3 ("sched: Fix detection of empty queues in child qdiscs")
Reported-by: Savino Dicanosa <savy@syst3mfailure.io>
Reported-by: William Liu <will@willsroot.io>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://patch.msgid.link/20250522181448.1439717-2-pctammela@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_hfsc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -175,6 +175,11 @@ struct hfsc_sched {
 
 #define	HT_INFINITY	0xffffffffffffffffULL	/* infinite time value */
 
+static bool cl_in_el_or_vttree(struct hfsc_class *cl)
+{
+	return ((cl->cl_flags & HFSC_FSC) && cl->cl_nactive) ||
+		((cl->cl_flags & HFSC_RSC) && !RB_EMPTY_NODE(&cl->el_node));
+}
 
 /*
  * eligible tree holds backlogged classes being sorted by their eligible times.
@@ -1040,6 +1045,8 @@ hfsc_change_class(struct Qdisc *sch, u32
 	if (cl == NULL)
 		return -ENOBUFS;
 
+	RB_CLEAR_NODE(&cl->el_node);
+
 	err = tcf_block_get(&cl->block, &cl->filter_list, sch, extack);
 	if (err) {
 		kfree(cl);
@@ -1572,7 +1579,7 @@ hfsc_enqueue(struct sk_buff *skb, struct
 	sch->qstats.backlog += len;
 	sch->q.qlen++;
 
-	if (first && !cl->cl_nactive) {
+	if (first && !cl_in_el_or_vttree(cl)) {
 		if (cl->cl_flags & HFSC_RSC)
 			init_ed(cl, len);
 		if (cl->cl_flags & HFSC_FSC)


