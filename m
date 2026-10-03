Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F42F9C0;
	Sat,  3 Oct 2026 01:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790992162; cv=none; b=kdD+Va6GCDs2r1pV6QIu9hlc9XVckhLa7ohQhco/BGqLZ0X4sTp20uGq5OS2znGn7yPe9h1/u1McGpntsurjvYBl2og/k8YHGESk63YjyBxLjLhQy+/H24U4bJNy3Ia+g3AFFCKlzZAcAL8H/oFwFb/Wp3uqaGyhgTWgoWRn/hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790992162; c=relaxed/simple;
	bh=A5xRH1DhJS58dUCp13fVbwL4DzWMqqvIsFSS9STbCQQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Bs8RcnmJgSQfzIEBUy2CK5ymDgHhUj1/ds/8GnxzzB93lL8NmP+EBRelkp7VjbObbvt4/Dkj1BeGLs4h0TlWqcpxIpeDheeZ+408l+0CsarJMKTl5GZi1xF+pjZK2paC9DLWJUXQfNUO3N/kzD+TbE9vB7ymIOJM/q2dfs2jPew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ov/VSFsh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ov/VSFsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135D11F000FF;
	Sat,  3 Oct 2026 01:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790992160;
	bh=h02Cr7uOkyfHEVe10byLfdQQ49dXDSjwDkwY45pV7k4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ov/VSFshzIlYtKx/U6AplrllHu6BLgyj4anzj4iPG1tXSkvEod9noqRaQnRnkpTpz
	 rQHkU1qHrU2ICOe7kK3RENkYDlJg5MeU6KKDb0MVGgl4UMN0BwO9V3oyD1vpHnizkm
	 9wq3PIi4EMjTpMX9+Y6K8t/dLKkNxB3C2P/9UcQLfVK8wSpu/dsQPNtqcUOuPO/2Nc
	 aQMUJ7tKVbJZv5wB344QgcWrBh1Xfuu5ukgYoKYZparF/eEz21rNr1TlBXw2aPalVL
	 aOEl2mSI0qflEY4IUC9ElP6QX2/+BW1705i8EWDD+Qlh/yhTDcFAkv/lZlYrqJqX9k
	 gUNqDtjzvNQmA==
Message-ID: <1ac115b1c242dfd76302189df13752367247b159.camel@kernel.org>
Subject: Re: [PATCH 5.15 064/752] rds: filter RDS_INFO_* getsockopt by
 callers netns
From: Allison Henderson <achender@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Simon Horman <horms@kernel.org>, Praveen
 Kakkolangara <praveen.kakkolangara@aumovio.com>, Maoyi Xie
 <maoyixie.tju@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Sasha Levin
 <sashal@kernel.org>
Date: Fri, 02 Oct 2026 18:49:19 -0700
In-Reply-To: <051245f8-42ee-4046-bff9-5fd2dbeaf807@oracle.com>
References: <20260930152358.131179731@linuxfoundation.org>
	 <20260930152359.544074072@linuxfoundation.org>
	 <051245f8-42ee-4046-bff9-5fd2dbeaf807@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2026-10-03 at 02:52 +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
>=20
> On 30/09/26 8:48 pm, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Maoyi Xie <maoyixie.tju@gmail.com>
> >=20
> > [ Upstream commit c96a5209dda666004b8ee1ed7f0d493d09a4f200 ]
> >=20
> > The RDS_INFO_* family of getsockopt(2) options reads several
> > file-scope global lists that are not per-netns:
> >=20
> >    rds_sock_info / rds6_sock_info,
> >    rds_sock_inc_info / rds6_sock_inc_info        -> rds_sock_list
> >    rds_tcp_tc_info / rds6_tcp_tc_info            -> rds_tcp_tc_list
> >    rds_conn_info / rds6_conn_info,
> >    rds_conn_message_info_cmn (for the *_SEND_MESSAGES and
> >    *_RETRANS_MESSAGES variants),
> >    rds_for_each_conn_info (for RDS_INFO_IB_CONNECTIONS)
> >                                                  -> rds_conn_hash[]
> >=20
> > The handlers do not filter by the caller's network namespace.
> > rds_info_getsockopt() has no netns or capable() check, and
> > rds_create() has no capable() check, so AF_RDS is reachable from
> > an unprivileged user namespace. As a result, an unprivileged
> > caller in a fresh user_ns plus netns can read the bound address
> > and sock inode of every RDS socket on the host, the peer address
> > of incoming messages on every RDS socket on the host, the peer
> > address and TCP sequence numbers of every rds-tcp connection on
> > the host, and the peer address and RDS sequence numbers of every
> > RDS connection on the host.
> >=20
> > The rds-tcp transport is reachable from a non-initial netns (see
> > rds_set_transport()), so a one-shot init_net gate at
> > rds_info_getsockopt() would deny legitimate per-netns visibility
> > to rds-tcp callers. Instead, filter at each handler by comparing
> > the netns of the caller's socket to the netns of the list entry,
> > or to rds_conn_net(conn) for connection paths. Only copy entries
> > whose netns matches the caller. Counters (RDS_INFO_COUNTERS) are
> > aggregate statistics and remain global.
> >=20
> > Reproducer (KASAN VM, rds and rds_tcp loaded): an AF_RDS socket
> > binds 127.0.0.1:4242 in init_net as root. A child process enters
> > a fresh user_ns plus netns and opens AF_RDS there, then calls
> > getsockopt(SOL_RDS, RDS_INFO_SOCKETS). Before this change, the
> > child sees the init_net socket. After this change, the child
> > sees zero entries.
> >=20
>=20
>=20
>=20
> An AI assisted review flagged the RDS namespace-filter backport. The
> filters match, but the upstream socket-publication guarantee is missing.
>=20
> Upstream c96a5209dda6 initializes the socket before publishing the TCP
> entry under the list lock (net/rds/tcp.c:193):
>=20
>      spin_lock(&rds_tcp_tc_list_lock);
>      tc->t_sock =3D sock;
>      list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
>      spin_unlock(&rds_tcp_tc_list_lock);
>=20
> 5.15.y publishes and unlocks first, then assigns the socket
> (net/rds/tcp.c:235 and 243; intervening code omitted):
>=20
>      spin_lock(&rds_tcp_tc_list_lock);
>      list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
>      spin_unlock(&rds_tcp_tc_list_lock);
>      ...
>      tc->t_sock =3D sock;
>      tc->t_cpath =3D cp;
>=20
> A list reader can see tc before t_sock is assigned and dereference NULL.
> The new size check accepts buffers sized for the caller's namespace
> that the old global-count check rejected. With an unpublished socket on
> a visible entry and another namespace's entries in the list, the copy
> path can now reach the NULL socket with such a buffer.
>=20
> I think 5.15.y should take d2bfdbb69cf87676981b1043010b6224d84c6d3a
> ("rds_tcp: close NULL deref window in rds_tcp_set_callbacks"), adapting
> the counter context and retaining the namespace filters; thoughts?
>=20
> thanks,
> Harshit

Hi Harshit,

Thanks for catching this.  Yes, d2bfdbb69cf8 should come before
c96a5209dda6. The netns filter was developed on top of it, so it's
effectively a prerequisite even it the dependency isn't called out.

I also checked the other stable branches. c96a5209dda6 is in the
current review round for 5.10.y, 5.15.y, 6.1.y, 6.6.y, but I dont
see d2bfdbb69cf8 queued, and 6.12.y (6.12.111) and 6.18.y (6.18.54)
already released without it.

d2bfdbb69cf8 doesn't cherry-pick cleanly to stable, but I'll follow
up with a 6.18.y backport.  The same patch should apply to the other
branches as well.

Thanks,
Allison

>=20
> > Drop the rds_sock_count, rds_tcp_tc_count, and rds6_tcp_tc_count
> > globals. v2 used them for the size precheck and lens->nr; v3
> > replaced the precheck with a per-ns count from a first pass over
> > the list, so the globals have no remaining readers. The matching
> > increments and decrements in rds_create()/rds_destroy_sock() and
> > rds_tcp_set_callbacks()/rds_tcp_restore_callbacks() go away with
> > them. Reported by the kernel test robot under clang W=3D1.
> >=20
> > Suggested-by: Allison Henderson <achender@kernel.org>
> > Suggested-by: Simon Horman <horms@kernel.org>
> > Reviewed-by: Allison Henderson <achender@kernel.org>
> > Co-developed-by: Praveen Kakkolangara <praveen.kakkolangara@aumovio.com=
>
> > Signed-off-by: Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>
> > Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
> > Link: https://patch.msgid.link/20260520084236.2724349-1-maoyixie.tju@gm=
ail.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   net/rds/af_rds.c     | 59 ++++++++++++++++++++++++++++++++++-------
> >   net/rds/connection.c | 13 +++++++++
> >   net/rds/tcp.c        | 63 ++++++++++++++++++++++++++++---------------=
-
> >   3 files changed, 104 insertions(+), 31 deletions(-)
> >=20
> > diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> > index ca1b52372ab29..9165d054e8e35 100644
> > --- a/net/rds/af_rds.c
> > +++ b/net/rds/af_rds.c
> > @@ -43,7 +43,6 @@
> >  =20
> >   /* this is just used for stats gathering :/ */
> >   static DEFINE_SPINLOCK(rds_sock_lock);
> > -static unsigned long rds_sock_count;
> >   static LIST_HEAD(rds_sock_list);
> >   DECLARE_WAIT_QUEUE_HEAD(rds_poll_waitq);
> >  =20
> > @@ -82,7 +81,6 @@ static int rds_release(struct socket *sock)
> >  =20
> >   	spin_lock_bh(&rds_sock_lock);
> >   	list_del_init(&rs->rs_item);
> > -	rds_sock_count--;
> >   	spin_unlock_bh(&rds_sock_lock);
> >  =20
> >   	rds_trans_put(rs->rs_transport);
> > @@ -695,7 +693,6 @@ static int __rds_create(struct socket *sock, struct=
 sock *sk, int protocol)
> >  =20
> >   	spin_lock_bh(&rds_sock_lock);
> >   	list_add_tail(&rs->rs_item, &rds_sock_list);
> > -	rds_sock_count++;
> >   	spin_unlock_bh(&rds_sock_lock);
> >  =20
> >   	return 0;
> > @@ -736,6 +733,7 @@ static void rds_sock_inc_info(struct socket *sock, =
unsigned int len,
> >   			      struct rds_info_iterator *iter,
> >   			      struct rds_info_lengths *lens)
> >   {
> > +	struct net *net =3D sock_net(sock->sk);
> >   	struct rds_sock *rs;
> >   	struct rds_incoming *inc;
> >   	unsigned int total =3D 0;
> > @@ -745,6 +743,9 @@ static void rds_sock_inc_info(struct socket *sock, =
unsigned int len,
> >   	spin_lock_bh(&rds_sock_lock);
> >  =20
> >   	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> > +		/* Only show sockets in the caller's netns. */
> > +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> > +			continue;
> >   		/* This option only supports IPv4 sockets. */
> >   		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
> >   			continue;
> > @@ -775,6 +776,7 @@ static void rds6_sock_inc_info(struct socket *sock,=
 unsigned int len,
> >   			       struct rds_info_iterator *iter,
> >   			       struct rds_info_lengths *lens)
> >   {
> > +	struct net *net =3D sock_net(sock->sk);
> >   	struct rds_incoming *inc;
> >   	unsigned int total =3D 0;
> >   	struct rds_sock *rs;
> > @@ -784,6 +786,9 @@ static void rds6_sock_inc_info(struct socket *sock,=
 unsigned int len,
> >   	spin_lock_bh(&rds_sock_lock);
> >  =20
> >   	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> > +		/* Only show sockets in the caller's netns. */
> > +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> > +			continue;
> >   		read_lock(&rs->rs_recv_lock);
> >  =20
> >   		list_for_each_entry(inc, &rs->rs_recv_queue, i_item) {
> > @@ -807,7 +812,9 @@ static void rds_sock_info(struct socket *sock, unsi=
gned int len,
> >   			  struct rds_info_iterator *iter,
> >   			  struct rds_info_lengths *lens)
> >   {
> > +	struct net *net =3D sock_net(sock->sk);
> >   	struct rds_info_socket sinfo;
> > +	unsigned int copied =3D 0;
> >   	unsigned int cnt =3D 0;
> >   	struct rds_sock *rs;
> >  =20
> > @@ -815,12 +822,24 @@ static void rds_sock_info(struct socket *sock, un=
signed int len,
> >  =20
> >   	spin_lock_bh(&rds_sock_lock);
> >  =20
> > -	if (len < rds_sock_count) {
> > -		cnt =3D rds_sock_count;
> > -		goto out;
> > +	/* First pass: count entries visible in the caller's netns. */
> > +	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> > +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> > +			continue;
> > +		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
> > +			continue;
> > +		cnt++;
> >   	}
> >  =20
> > +	if (len < cnt)
> > +		goto out;
> > +
> >   	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> > +		if (copied >=3D cnt)
> > +			break;
> > +		/* Only show sockets in the caller's netns. */
> > +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> > +			continue;
> >   		/* This option only supports IPv4 sockets. */
> >   		if (!ipv6_addr_v4mapped(&rs->rs_bound_addr))
> >   			continue;
> > @@ -833,8 +852,13 @@ static void rds_sock_info(struct socket *sock, uns=
igned int len,
> >   		sinfo.inum =3D sock_i_ino(rds_rs_to_sk(rs));
> >  =20
> >   		rds_info_copy(iter, &sinfo, sizeof(sinfo));
> > -		cnt++;
> > +		copied++;
> >   	}
> > +	/* A concurrent rds_bind() can change rs_bound_addr between the
> > +	 * two passes without holding rds_sock_lock, so copied may be
> > +	 * less than cnt. Report what was actually copied.
> > +	 */
> > +	cnt =3D copied;
> >  =20
> >   out:
> >   	lens->nr =3D cnt;
> > @@ -848,17 +872,32 @@ static void rds6_sock_info(struct socket *sock, u=
nsigned int len,
> >   			   struct rds_info_iterator *iter,
> >   			   struct rds_info_lengths *lens)
> >   {
> > +	struct net *net =3D sock_net(sock->sk);
> >   	struct rds6_info_socket sinfo6;
> > +	unsigned int copied =3D 0;
> > +	unsigned int cnt =3D 0;
> >   	struct rds_sock *rs;
> >  =20
> >   	len /=3D sizeof(struct rds6_info_socket);
> >  =20
> >   	spin_lock_bh(&rds_sock_lock);
> >  =20
> > -	if (len < rds_sock_count)
> > +	/* First pass: count entries visible in the caller's netns. */
> > +	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> > +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> > +			continue;
> > +		cnt++;
> > +	}
> > +
> > +	if (len < cnt)
> >   		goto out;
> >  =20
> >   	list_for_each_entry(rs, &rds_sock_list, rs_item) {
> > +		if (copied >=3D cnt)
> > +			break;
> > +		/* Only show sockets in the caller's netns. */
> > +		if (!net_eq(sock_net(rds_rs_to_sk(rs)), net))
> > +			continue;
> >   		sinfo6.sndbuf =3D rds_sk_sndbuf(rs);
> >   		sinfo6.rcvbuf =3D rds_sk_rcvbuf(rs);
> >   		sinfo6.bound_addr =3D rs->rs_bound_addr;
> > @@ -868,10 +907,12 @@ static void rds6_sock_info(struct socket *sock, u=
nsigned int len,
> >   		sinfo6.inum =3D sock_i_ino(rds_rs_to_sk(rs));
> >  =20
> >   		rds_info_copy(iter, &sinfo6, sizeof(sinfo6));
> > +		copied++;
> >   	}
> > +	cnt =3D copied;
> >  =20
> >    out:
> > -	lens->nr =3D rds_sock_count;
> > +	lens->nr =3D cnt;
> >   	lens->each =3D sizeof(struct rds6_info_socket);
> >  =20
> >   	spin_unlock_bh(&rds_sock_lock);
> > diff --git a/net/rds/connection.c b/net/rds/connection.c
> > index cd41f83863c89..beecd408e93ab 100644
> > --- a/net/rds/connection.c
> > +++ b/net/rds/connection.c
> > @@ -540,6 +540,7 @@ static void rds_conn_message_info_cmn(struct socket=
 *sock, unsigned int len,
> >   				      struct rds_info_lengths *lens,
> >   				      int want_send, bool isv6)
> >   {
> > +	struct net *net =3D sock_net(sock->sk);
> >   	struct hlist_head *head;
> >   	struct list_head *list;
> >   	struct rds_connection *conn;
> > @@ -562,6 +563,9 @@ static void rds_conn_message_info_cmn(struct socket=
 *sock, unsigned int len,
> >   			struct rds_conn_path *cp;
> >   			int npaths;
> >  =20
> > +			/* Only show connections in the caller's netns. */
> > +			if (!net_eq(rds_conn_net(conn), net))
> > +				continue;
> >   			if (!isv6 && conn->c_isv6)
> >   				continue;
> >  =20
> > @@ -660,6 +664,7 @@ void rds_for_each_conn_info(struct socket *sock, un=
signed int len,
> >   			  u64 *buffer,
> >   			  size_t item_len)
> >   {
> > +	struct net *net =3D sock_net(sock->sk);
> >   	struct hlist_head *head;
> >   	struct rds_connection *conn;
> >   	size_t i;
> > @@ -672,6 +677,9 @@ void rds_for_each_conn_info(struct socket *sock, un=
signed int len,
> >   	for (i =3D 0, head =3D rds_conn_hash; i < ARRAY_SIZE(rds_conn_hash);
> >   	     i++, head++) {
> >   		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
> > +			/* Only show connections in the caller's netns. */
> > +			if (!net_eq(rds_conn_net(conn), net))
> > +				continue;
> >  =20
> >   			/* Zero the per-item buffer before handing it to the
> >   			 * visitor so any field the visitor does not write -
> > @@ -705,6 +713,7 @@ static void rds_walk_conn_path_info(struct socket *=
sock, unsigned int len,
> >   				    u64 *buffer,
> >   				    size_t item_len)
> >   {
> > +	struct net *net =3D sock_net(sock->sk);
> >   	struct hlist_head *head;
> >   	struct rds_connection *conn;
> >   	size_t i;
> > @@ -719,6 +728,10 @@ static void rds_walk_conn_path_info(struct socket =
*sock, unsigned int len,
> >   		hlist_for_each_entry_rcu(conn, head, c_hash_node) {
> >   			struct rds_conn_path *cp;
> >  =20
> > +			/* Only show connections in the caller's netns. */
> > +			if (!net_eq(rds_conn_net(conn), net))
> > +				continue;
> > +
> >   			/* XXX We only copy the information from the first
> >   			 * path for now.  The problem is that if there are
> >   			 * more than one underlying paths, we cannot report
> > diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> > index f66cbf0b9895f..f6bbde2c34776 100644
> > --- a/net/rds/tcp.c
> > +++ b/net/rds/tcp.c
> > @@ -46,14 +46,6 @@
> >   static DEFINE_SPINLOCK(rds_tcp_tc_list_lock);
> >   static LIST_HEAD(rds_tcp_tc_list);
> >  =20
> > -/* rds_tcp_tc_count counts only IPv4 connections.
> > - * rds6_tcp_tc_count counts both IPv4 and IPv6 connections.
> > - */
> > -static unsigned int rds_tcp_tc_count;
> > -#if IS_ENABLED(CONFIG_IPV6)
> > -static unsigned int rds6_tcp_tc_count;
> > -#endif
> > -
> >   /* Track rds_tcp_connection structs so they can be cleaned up */
> >   static DEFINE_SPINLOCK(rds_tcp_conn_lock);
> >   static LIST_HEAD(rds_tcp_conn_list);
> > @@ -109,11 +101,6 @@ void rds_tcp_restore_callbacks(struct socket *sock=
,
> >   	/* done under the callback_lock to serialize with write_space */
> >   	spin_lock(&rds_tcp_tc_list_lock);
> >   	list_del_init(&tc->t_list_item);
> > -#if IS_ENABLED(CONFIG_IPV6)
> > -	rds6_tcp_tc_count--;
> > -#endif
> > -	if (!tc->t_cpath->cp_conn->c_isv6)
> > -		rds_tcp_tc_count--;
> >   	spin_unlock(&rds_tcp_tc_list_lock);
> >  =20
> >   	tc->t_sock =3D NULL;
> > @@ -200,11 +187,6 @@ void rds_tcp_set_callbacks(struct socket *sock, st=
ruct rds_conn_path *cp)
> >   	/* done under the callback_lock to serialize with write_space */
> >   	spin_lock(&rds_tcp_tc_list_lock);
> >   	list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
> > -#if IS_ENABLED(CONFIG_IPV6)
> > -	rds6_tcp_tc_count++;
> > -#endif
> > -	if (!tc->t_cpath->cp_conn->c_isv6)
> > -		rds_tcp_tc_count++;
> >   	spin_unlock(&rds_tcp_tc_list_lock);
> >  =20
> >   	/* accepted sockets need our listen data ready undone */
> > @@ -232,20 +214,37 @@ static void rds_tcp_tc_info(struct socket *rds_so=
ck, unsigned int len,
> >   			    struct rds_info_iterator *iter,
> >   			    struct rds_info_lengths *lens)
> >   {
> > +	struct net *net =3D sock_net(rds_sock->sk);
> >   	struct rds_info_tcp_socket tsinfo;
> >   	struct rds_tcp_connection *tc;
> > +	unsigned int copied =3D 0;
> > +	unsigned int cnt =3D 0;
> >   	unsigned long flags;
> >  =20
> >   	spin_lock_irqsave(&rds_tcp_tc_list_lock, flags);
> >  =20
> > -	if (len / sizeof(tsinfo) < rds_tcp_tc_count)
> > +	/* First pass: count entries visible in the caller's netns. */
> > +	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
> > +		if (tc->t_cpath->cp_conn->c_isv6)
> > +			continue;
> > +		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
> > +			continue;
> > +		cnt++;
> > +	}
> > +
> > +	if (len / sizeof(tsinfo) < cnt)
> >   		goto out;
> >  =20
> >   	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
> >   		struct inet_sock *inet =3D inet_sk(tc->t_sock->sk);
> >  =20
> > +		if (copied >=3D cnt)
> > +			break;
> >   		if (tc->t_cpath->cp_conn->c_isv6)
> >   			continue;
> > +		/* Only show connections in the caller's netns. */
> > +		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
> > +			continue;
> >  =20
> >   		tsinfo.local_addr =3D inet->inet_saddr;
> >   		tsinfo.local_port =3D inet->inet_sport;
> > @@ -260,10 +259,12 @@ static void rds_tcp_tc_info(struct socket *rds_so=
ck, unsigned int len,
> >   		tsinfo.tos =3D tc->t_cpath->cp_conn->c_tos;
> >  =20
> >   		rds_info_copy(iter, &tsinfo, sizeof(tsinfo));
> > +		copied++;
> >   	}
> > +	cnt =3D copied;
> >  =20
> >   out:
> > -	lens->nr =3D rds_tcp_tc_count;
> > +	lens->nr =3D cnt;
> >   	lens->each =3D sizeof(tsinfo);
> >  =20
> >   	spin_unlock_irqrestore(&rds_tcp_tc_list_lock, flags);
> > @@ -278,19 +279,35 @@ static void rds6_tcp_tc_info(struct socket *sock,=
 unsigned int len,
> >   			     struct rds_info_iterator *iter,
> >   			     struct rds_info_lengths *lens)
> >   {
> > +	struct net *net =3D sock_net(sock->sk);
> >   	struct rds6_info_tcp_socket tsinfo6;
> >   	struct rds_tcp_connection *tc;
> > +	unsigned int copied =3D 0;
> > +	unsigned int cnt =3D 0;
> >   	unsigned long flags;
> >  =20
> >   	spin_lock_irqsave(&rds_tcp_tc_list_lock, flags);
> >  =20
> > -	if (len / sizeof(tsinfo6) < rds6_tcp_tc_count)
> > +	/* First pass: count entries visible in the caller's netns. */
> > +	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
> > +		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
> > +			continue;
> > +		cnt++;
> > +	}
> > +
> > +	if (len / sizeof(tsinfo6) < cnt)
> >   		goto out;
> >  =20
> >   	list_for_each_entry(tc, &rds_tcp_tc_list, t_list_item) {
> >   		struct sock *sk =3D tc->t_sock->sk;
> >   		struct inet_sock *inet =3D inet_sk(sk);
> >  =20
> > +		if (copied >=3D cnt)
> > +			break;
> > +		/* Only show connections in the caller's netns. */
> > +		if (!net_eq(rds_conn_net(tc->t_cpath->cp_conn), net))
> > +			continue;
> > +
> >   		tsinfo6.local_addr =3D sk->sk_v6_rcv_saddr;
> >   		tsinfo6.local_port =3D inet->inet_sport;
> >   		tsinfo6.peer_addr =3D sk->sk_v6_daddr;
> > @@ -303,10 +320,12 @@ static void rds6_tcp_tc_info(struct socket *sock,=
 unsigned int len,
> >   		tsinfo6.last_seen_una =3D tc->t_last_seen_una;
> >  =20
> >   		rds_info_copy(iter, &tsinfo6, sizeof(tsinfo6));
> > +		copied++;
> >   	}
> > +	cnt =3D copied;
> >  =20
> >   out:
> > -	lens->nr =3D rds6_tcp_tc_count;
> > +	lens->nr =3D cnt;
> >   	lens->each =3D sizeof(tsinfo6);
> >  =20
> >   	spin_unlock_irqrestore(&rds_tcp_tc_list_lock, flags);
>=20

