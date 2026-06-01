Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEE8346E6C;
	Mon,  1 Jun 2026 11:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780313694; cv=none; b=kVuVBchV0+5vM27GGtrcKsyEy4kS9XFitcXqA0GvNEUN6Q0DUe8IP7VrP1OUdU0oHJNUsuBaFE4CBnXV5o6h5UuCo82PJD43/wr7rZHXGD7x6XwEv+85PfeGelEFDY5BHIw6PpBTpI/YwblOFLK966I1ElYp6Q/fEwEX83LRiAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780313694; c=relaxed/simple;
	bh=EO1RRd+05ZYASXl/TawX6FjkPRcq/IWCAitYl0V0QeU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GgMrfL5lKov65S25H5MiYwlZ6NdgkFpol1n/D6uebcm+Ob9Dolesr3isniq+cT9SKE6gvtb164WV8qj0Y/5sjFvNNmq/oct3bvVifMEc13fU6KHqlZ4I060caqzfW4c5jNULEIFBPEym3R3FclY4PAmUjBgIN/jXkCcxvJxHd7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU0uw-000V5x-2F;
	Mon, 01 Jun 2026 11:34:50 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU0uv-0000000Fa7e-2GEC;
	Mon, 01 Jun 2026 13:34:49 +0200
Message-ID: <7e870e1219db98c9e19777eedfa3b0eb41f41235.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 211/589] net/sched: sch_red: Replace direct dequeue
 call with peek and qdisc_dequeue_peeked
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
  Jamal Hadi Salim	 <jhs@mojatatu.com>, Victor Nogueria <victor@mojatatu.com>
Cc: patches@lists.linux.dev, Manas <ghandatmanas@gmail.com>, Rakshit Awasthi
	 <rakshitawasthi17@gmail.com>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>
Date: Mon, 01 Jun 2026 13:34:44 +0200
In-Reply-To: <20260530160230.510336558@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160230.510336558@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dNRy7ekohfVgaFV2YxZi"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-dNRy7ekohfVgaFV2YxZi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Jamal Hadi Salim <jhs@mojatatu.com>
>=20
> commit 458d5615272d3de535748342eb68ca492343048c upstream.
>=20
> When red qdisc has children (eg qfq qdisc) whose peek() callback is
> qdisc_peek_dequeued(), we could get a kernel panic. When the parent of su=
ch
> qdiscs (eg illustrated in patch #3 as tbf) wants to retrieve an skb from
> its child (red in this case), it will do the following:

The same bug exists in sch_sfb and was fixed by commit 1b9bc71153b0
"net/sched: sch_sfb: Replace direct dequeue call with peek and
qdisc_dequeue_peeked", so please also pick that for stable.

(From a very brief scan it seems like sch_multiq and sch_taprio might
also have this bug, but perhaps they have restrictions that make this
impossible.)

Ben.

>  1a. do a peek() - and when sensing there's an skb the child can offer, t=
hen
>      - the child in this case(red) calls its child's (qfq) peek.
>         qfq does the right thing and will return the gso_skb queue packet=
.
>         Note: if there wasnt a gso_skb entry then qfq will store it there=
.
>  1b. invoke a dequeue() on the child (red). And herein lies the problem.
>      - red will call the child's dequeue() which will essentially just
>        try to grab something of qfq's queue.
>=20
> [   78.667668][  T363] KASAN: null-ptr-deref in range [0x0000000000000048=
-0x000000000000004f]
> [   78.667927][  T363] CPU: 1 UID: 0 PID: 363 Comm: ping Not tainted 7.1.=
0-rc1-00033-g46f74a3f7d57-dirty #790 PREEMPT(full)
> [   78.668263][  T363] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   78.668486][  T363] RIP: 0010:qfq_dequeue+0x446/0xc90 [sch_qfq]
> [   78.668718][  T363] Code: 54 c0 e8 dd 90 00 f1 48 c7 c7 e0 03 54 c0 48=
 89 de e8 ce 90 00 f1 48 8d 7b 48 b8 ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1=
 ea 03 <80> 3c 02 00 74 05 e8 ef a1 e1 f1 48 8b 7b 48 48 8d 54 24 58 48 8d
> [   78.669312][  T363] RSP: 0018:ffff88810de573e0 EFLAGS: 00010216
> [   78.669533][  T363] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0=
000000000000000
> [   78.669790][  T363] RDX: 0000000000000009 RSI: 0000000000000004 RDI: 0=
000000000000048
> [   78.670044][  T363] RBP: ffff888110dc4000 R08: ffffffffb1b0885a R09: f=
ffffbfff6ba9078
> [   78.670297][  T363] R10: 0000000000000003 R11: ffff888110e31c80 R12: 0=
000001880000000
> [   78.670560][  T363] R13: ffff888110dc4150 R14: ffff888110dc42b8 R15: 0=
000000000000200
> [   78.670814][  T363] FS:  00007f66a8f09c40(0000) GS:ffff888163428000(00=
00) knlGS:0000000000000000
> [   78.671110][  T363] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   78.671324][  T363] CR2: 000055db4c6a30a8 CR3: 000000010da67000 CR4: 0=
000000000750ef0
> [   78.671585][  T363] PKRU: 55555554
> [   78.671713][  T363] Call Trace:
> [   78.671843][  T363]  <TASK>
> [   78.671936][  T363]  ? __pfx_qfq_dequeue+0x10/0x10 [sch_qfq]
> [   78.672148][  T363]  ? __pfx__printk+0x10/0x10
> [   78.672322][  T363]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   78.672496][  T363]  ? lockdep_hardirqs_on_prepare+0xa8/0x1a0
> [   78.672706][  T363]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   78.672875][  T363]  ? trace_hardirqs_on+0x19/0x1a0
> [   78.673047][  T363]  red_dequeue+0x65/0x270 [sch_red]
> [   78.673217][  T363]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   78.673385][  T363]  tbf_dequeue.cold+0xb0/0x70c [sch_tbf]
> [   78.673566][  T363]  __qdisc_run+0x169/0x1900
>=20
> The right thing to do in #1b is to grab the skb off gso_skb queue.
> This patchset fixes that issue by changing #1b to use qdisc_dequeue_peeke=
d()
> method instead.
>=20
> Fixes: 77be155cba4e ("pkt_sched: Add peek emulation for non-work-conservi=
ng qdiscs.")
> Reported-by: Manas <ghandatmanas@gmail.com>
> Reported-by: Rakshit Awasthi <rakshitawasthi17@gmail.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Link: https://patch.msgid.link/20260430152957.194015-2-jhs@mojatatu.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/sched/sch_red.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/net/sched/sch_red.c
> +++ b/net/sched/sch_red.c
> @@ -153,7 +153,7 @@ static struct sk_buff *red_dequeue(struc
>  	struct red_sched_data *q =3D qdisc_priv(sch);
>  	struct Qdisc *child =3D q->qdisc;
> =20
> -	skb =3D child->dequeue(child);
> +	skb =3D qdisc_dequeue_peeked(child);
>  	if (skb) {
>  		qdisc_bstats_update(sch, skb);
>  		qdisc_qstats_backlog_dec(sch, skb);
>=20
>=20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-dNRy7ekohfVgaFV2YxZi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmodblUACgkQ57/I7JWG
EQkZ/g/6A9m6bzYRmFMV2+YsbS2sqtlxwFM17N1Mk0rwLWrerm/SHyVpPQ1dhebq
RPQTAaJ+MDSYBH9klWWq7qVl8FfbxyzB7/8k9rTJym1ICD3r2JU+1tMEBlsh6ecT
6fzantMDuwPf1M2Ud893QKlOxQpVZbyAUgc74RyEurXbZYU74n0VnvR/QYyDVzq6
echzomAVTchDde10IfYifaTH1AY70+v/nm7BgGWh8zVxBAO9lwfrVKPo2vjUncRc
IhiTfjHP3e22pprlrT4VZsEK+deGWIhQtgFlFL9uivPXnKKz+cKtx6pYI9lqIyzu
GkAsWRuMA1hlUhDlHoNee6PuBQHK+PW6NdRYk069Kd4zmFqHLkjRzDPm8eXRj84T
5jcf+PO4J99VE5awOuXU78Nxnf7ytqhw4dkiHYLW5QHeS984sxJ2plAjskmoqiAc
peoa5AANQOkjyIhZaCBXQ/wPhCG8lviZkQX6QirUv1K+zjko9zXQq/ORfr2Ltc8m
xykmNfCysGdrFUmlvciMAVI0zLSp0ayEXNqaGM0RZmd4B67vaBsijugGH4/In7bB
xUqZg5JcR3nVRJis0IB8g7pEUDjE9a+Zpd8b9KFWP/HA3WZCgL1SBskpfk++g5Sn
1LGPzEht3I6GpxhyL0802/VPZ7RM/dV+xML3XfxIATEZuTjYpU4=
=bH30
-----END PGP SIGNATURE-----

--=-dNRy7ekohfVgaFV2YxZi--
