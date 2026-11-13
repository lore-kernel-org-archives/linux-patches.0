Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590819;
	b=ok8eg+Iw7fym1FBkUggqOz4IuZYlVuNcZNob0pzfWI+YFkXsybzIASKXNKWyqfFTSwF9
	 loAFGJLRZlDBCbQnsVlsMgznfjYS2KKtkUNOqs8te54y+xiPV50AEtU4Vr2mc0A1Q8UHX
	 /dN8unSr+MOHKjONnCmKLgWBQk0hcMnRSA8CSfhjzMQCwj5OCxjhwx/YzPA0asvi+GGys
	 JuPVM3v8PxJichGeWUqpy+TopmR8lhCIbNWsi3gsRf6LQZSrasaYtMZ73KHQ9yZN+GiWG
	 UkcWnngIYmoRWZ1IKpMDTZbWdOUioDH+2humaCzZfyZdXtoAVU9S9aRB2Xohpvan34A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=12xgtE920Pdn7kWBiGnnbogY/j0jrjOldkkrUFSXb54=;
	b=sFA+9oisY0DDlg1B6NqgTMl3XaELQYSUdjMMEKnwhdr0Jqy4ujlV2L1vv83EPaFEr252
	 6KXb2b7ZcrOTrl8fBTwvSmH0JzgjlqTUEKV3MCRr5AkK+5L/F4LA0Z9FEYsqw7bfD/5x2
	 d1I1AErZR8bzRoqAoKV1x1lUxPM1UC5ViG6D4J/eVb17cMwO250JimEGfySKOngRtdfwE
	 8Vt9QR1a6a8f2mm37vyIhXtVPX5bV8IVlhXng64fRPeek+uhp7z2KNsn54bRm8mMVbFQe
	 1yEHllbibiEf3xY3n8DMWN1JKzslT2sMkglg0dDKRhhTDXNfQVGGZ+hRRSqRZ5e+b3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kejmDNY1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41D4607E053;
	Fri, 13 Nov 2026 17:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kejmDNY1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6661F000C4;
	Fri, 13 Nov 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590819;
	bh=12xgtE920Pdn7kWBiGnnbogY/j0jrjOldkkrUFSXb54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kejmDNY1LHF9D5t8XQ499VBsax+ADq+Ss5TSB/UgydzFMMHFOPEXMkTtCQLRVdVIy
	 RF3h8q425ky4crkas4Namaupe8R1y/QaF+YTZSvnBxdJulKoVZfwnyQw3e0nszK7xN
	 3YDU8o/E6Qdz6KJDnKoMyG7dmlqyOC1V3fc43yqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/670] SUNRPC: report local rpcbind calls that get no answer
Date: Fri, 13 Nov 2026 10:43:11 -0500
Message-ID: <20261113153812.100922361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 202a557d0c8e65c7fd7fcff2ad2756468d1ab711 ]

A caller that creates many listeners in one operation calls svc_register()
once for each of them. Every call waits for the local rpcbind on its own,
so a rpcbind that never answers costs the caller one timeout per listener.
The caller has no way to learn that the first call already failed.

Split rpcb_register_call() failures by whether rpcbind answered:

 - answered: a FALSE reply, or an RPC-level rejection that
   rpc_decode_header() derives from the reply. -EACCES (FALSE reply or
   AUTH_ERROR), -EPROTONOSUPPORT, -EPFNOSUPPORT, -EOPNOTSUPP.
 - never sent: -ENOMEM, -EMSGSIZE, -ERESTARTSYS.
 - no answer: everything else, i.e. transport errors.

Any no-answer error gets represented by -EIO, which is already what the
RPC layer reports for most of it: rpc_check_timeout() returns -EIO for a
soft timeout without RPC_TASK_TIMEOUT, and call_status() documents -EIO
as "shutdown or soft timeout".

Keep a count of the number of rpcbind failures in the serv. Later
patches will use that to watch for hard rpcbind failures, and alter
their behavior accordingly.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-6-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Stable-dep-of: bf0f3a37e6cc ("NFSD: stop registering with rpcbind after a failure in listener_set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/clnt.h |  3 ++-
 include/linux/sunrpc/svc.h  |  7 +++++--
 net/sunrpc/rpcb_clnt.c      | 22 ++++++++++++++++---
 net/sunrpc/svc.c            | 42 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index bd6ac060450cb..acdb31039c35f 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -195,7 +195,8 @@ struct rpc_xprt	*rpc_task_get_xprt(struct rpc_clnt *clnt,
 
 int		rpcb_create_local(struct net *);
 void		rpcb_put_local(struct net *);
-int		rpcb_register(struct net *, u32, u32, int, unsigned short);
+int		rpcb_register(struct net *net, u32 prog, u32 vers, int prot,
+			      unsigned short port);
 int		rpcb_v4_register(struct net *net, const u32 program,
 				 const u32 version,
 				 const struct sockaddr *address,
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 79f3c5c1d0e9f..b7a61aafc2dd1 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -79,6 +79,7 @@ struct svc_serv {
 	unsigned int		sv_max_payload;	/* datagram payload size */
 	unsigned int		sv_max_mesg;	/* max_payload + 1 page for overheads */
 	unsigned int		sv_xdrsize;	/* XDR buffer size */
+	atomic_t		sv_rpcb_failures; /* unanswered rpcbind calls */
 	struct list_head	sv_permsocks;	/* all permanent sockets */
 	struct list_head	sv_tempsocks;	/* all temporary sockets */
 	int			sv_tmpcnt;	/* count of temporary "valid" sockets */
@@ -451,6 +452,7 @@ int sunrpc_set_pool_mode(const char *val);
 int sunrpc_get_pool_mode(char *val, size_t size);
 void svc_rpcb_cleanup(struct svc_serv *serv, struct net *net);
 int svc_bind(struct svc_serv *serv, struct net *net);
+unsigned int svc_rpcb_failure_count(struct svc_serv *serv);
 struct svc_serv *svc_create(struct svc_program *, unsigned int,
 			    int (*threadfn)(void *data));
 bool		   svc_rqst_replace_page(struct svc_rqst *rqstp,
@@ -466,8 +468,9 @@ int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
 int		   svc_pool_stats_open(struct svc_info *si, struct file *file);
 void		   svc_process(struct svc_rqst *rqstp);
 void		   svc_process_bc(struct rpc_rqst *req, struct svc_rqst *rqstp);
-int		   svc_register(const struct svc_serv *, struct net *, const int,
-				const unsigned short, const unsigned short);
+int		   svc_register(struct svc_serv *serv, struct net *net,
+				const int family, const unsigned short proto,
+				const unsigned short port);
 
 void		   svc_wake_up(struct svc_serv *);
 void		   svc_reserve(struct svc_rqst *rqstp, int space);
diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 2d74c660de666..9b90350820be4 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -400,7 +400,8 @@ static struct rpc_clnt *rpcb_create(struct net *net, const char *nodename,
 	return rpc_create(&args);
 }
 
-static int rpcb_register_call(struct sunrpc_net *sn, struct rpc_clnt *clnt, struct rpc_message *msg, bool is_set)
+static int rpcb_register_call(struct sunrpc_net *sn, struct rpc_clnt *clnt,
+			      struct rpc_message *msg, bool is_set)
 {
 	int flags = RPC_TASK_NOCONNECT;
 	int error, result = 0;
@@ -410,8 +411,23 @@ static int rpcb_register_call(struct sunrpc_net *sn, struct rpc_clnt *clnt, stru
 	msg->rpc_resp = &result;
 
 	error = rpc_call_sync(clnt, msg, flags);
-	if (error < 0)
-		return error;
+	if (error < 0) {
+		switch (error) {
+		/* rpcbind answered; the reply itself carries the error */
+		case -EPROTONOSUPPORT:
+		case -EPFNOSUPPORT:
+		case -EOPNOTSUPP:
+		case -EACCES:
+		/* the call never made it onto the wire */
+		case -ENOMEM:
+		case -EMSGSIZE:
+		/* the caller is going away; this says nothing about rpcbind */
+		case -ERESTARTSYS:
+			return error;
+		}
+		/* anything else, we assume that rpcbind isn't functional */
+		return -EIO;
+	}
 
 	if (!result)
 		return -EACCES;
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 4b4a2890a874a..6d43f479342da 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1204,10 +1204,40 @@ int svc_generic_rpcbind_set(struct net *net,
 	error = svc_rpcbind_set_version(net, progp, version,
 					family, proto, port);
 
+	/* -EIO means no answer, not a refusal, so vs_rpcb_optnl must keep it. */
+	if (error == -EIO)
+		return error;
+
 	return (vers->vs_rpcb_optnl) ? 0 : error;
 }
 EXPORT_SYMBOL_GPL(svc_generic_rpcbind_set);
 
+/**
+ * svc_rpcb_failure_count - local rpcbind calls for @serv that got no answer
+ * @serv: RPC service to query
+ *
+ * svc_register() adds one for each of its calls that got no answer. A reply
+ * that refuses one entry does not count, because rpcbind answered and the
+ * next entry may still succeed.
+ *
+ * The count is kept per serv rather than per net. The local rpcbind client
+ * is per-net and lockd shares it, but a count that another service can move
+ * says nothing about this serv's own calls.
+ *
+ * This is for callers that cannot see the svc_register() return, because a
+ * transport class sits in between. Such a caller reads the count before it
+ * starts and compares as it goes, so there is no state to reset between
+ * operations. The count never resets, and callers must not attach meaning
+ * to the value itself.
+ *
+ * Return: the number of unanswered calls since this serv was created.
+ */
+unsigned int svc_rpcb_failure_count(struct svc_serv *serv)
+{
+	return atomic_read(&serv->sv_rpcb_failures);
+}
+EXPORT_SYMBOL_GPL(svc_rpcb_failure_count);
+
 /**
  * svc_register - register an RPC service with the local portmapper
  * @serv: svc_serv struct for the service to register
@@ -1218,10 +1248,11 @@ EXPORT_SYMBOL_GPL(svc_generic_rpcbind_set);
  *
  * Service is registered for any address in the passed-in protocol family
  */
-int svc_register(const struct svc_serv *serv, struct net *net,
+int svc_register(struct svc_serv *serv, struct net *net,
 		 const int family, const unsigned short proto,
 		 const unsigned short port)
 {
+	bool			noanswer = false;
 	unsigned int		p, i;
 	int			error = 0;
 
@@ -1233,10 +1264,16 @@ int svc_register(const struct svc_serv *serv, struct net *net,
 		struct svc_program *progp = &serv->sv_programs[p];
 
 		for (i = 0; i < progp->pg_nvers; i++) {
+			const struct svc_version *vers = progp->pg_vers[i];
 			int ret;
 
 			ret = progp->pg_rpcbind_set(net, progp, i,
 					family, proto, port);
+			if (ret == -EIO) {
+				noanswer = true;
+				if (vers && vers->vs_rpcb_optnl)
+					ret = 0;
+			}
 			if (ret < 0) {
 				printk(KERN_WARNING "svc: failed to register "
 					"%sv%u RPC service (errno %d).\n",
@@ -1248,6 +1285,9 @@ int svc_register(const struct svc_serv *serv, struct net *net,
 		}
 	}
 
+	if (noanswer)
+		atomic_inc(&serv->sv_rpcb_failures);
+
 	return error;
 }
 
-- 
2.53.0



