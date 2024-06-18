Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ED71741F9;
	Tue, 18 Jun 2024 12:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715455; cv=none; b=RAzblrxba4Gse9xFKCMmRHSfChVP7fzsik80/lfuqD7lcGhpbQjUitKsVBPcRM49YVvbmbdzF7f4ce4STPQzcyJ/qZgJKtso3WmSzmPC60IiBQdy+FZFUCmZlINiNB7wJpv3Ev0YuHJfsO/9fp69rpBI8NAID8gKDKesf38QcNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715455; c=relaxed/simple;
	bh=vheLCoPg9PXPFNedS7izl9JVcO8eypVYRP++wdKMaAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRl5i/8trt7A2I2nn6zJJNlOVmKUcKfESvQ4TQx+db8YHsCf0+ojoSRynn1yAUzc6zOBu5+acD3iqEkbIS651hFyJgUefrPhtkDOPGhnPwK8+9KLf+cxBwmL5ii5yEqwt934m9BWOMMTGuLUvdUXY0yto3O2IFlkucfTOexnQzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i04pZg02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i04pZg02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D430FC3277B;
	Tue, 18 Jun 2024 12:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715455;
	bh=vheLCoPg9PXPFNedS7izl9JVcO8eypVYRP++wdKMaAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i04pZg02TGhSluQLYu6D67mBEucD/kcOaDyFj0pG4RS72IaF/+L6Ger1QZLdBKobU
	 bCcEulwd+nYnDJZ/rhAL5D8Ip8i4zvUuoc36zdQXY8ChuEVQ7CkXWzDaEhZxAFclEL
	 rHz7cX7fb0Xdg1h4Q+PniCYjThke+pBarSy1BfZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/770] NFSD: Enhance the nfsd_cb_setup tracepoint
Date: Tue, 18 Jun 2024 14:32:16 +0200
Message-ID: <20240618123418.189943039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9f57c6062bf3ce2c6ab9ba60040b34e8134ef259 ]

Display the transport protocol and authentication flavor so admins
can see what they might be getting wrong.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c |  3 ++-
 fs/nfsd/trace.h        | 27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 2a2eb6184bdae..fe1f36b70fa03 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -941,7 +941,8 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 		clp->cl_cb_conn.cb_xprt = conn->cb_xprt;
 	clp->cl_cb_client = client;
 	clp->cl_cb_cred = cred;
-	trace_nfsd_cb_setup(clp);
+	trace_nfsd_cb_setup(clp, rpc_peeraddr2str(client, RPC_DISPLAY_NETID),
+			    args.authflavor);
 	return 0;
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index afffb4912acbc..86e0656bdb779 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -910,7 +910,6 @@ DEFINE_EVENT(nfsd_cb_class, nfsd_cb_##name,		\
 	TP_PROTO(const struct nfs4_client *clp),	\
 	TP_ARGS(clp))
 
-DEFINE_NFSD_CB_EVENT(setup);
 DEFINE_NFSD_CB_EVENT(state);
 DEFINE_NFSD_CB_EVENT(lost);
 DEFINE_NFSD_CB_EVENT(shutdown);
@@ -931,6 +930,32 @@ TRACE_DEFINE_ENUM(RPC_AUTH_GSS_KRB5P);
 		{ RPC_AUTH_GSS_KRB5I,		"krb5i" },		\
 		{ RPC_AUTH_GSS_KRB5P,		"krb5p" })
 
+TRACE_EVENT(nfsd_cb_setup,
+	TP_PROTO(const struct nfs4_client *clp,
+		 const char *netid,
+		 rpc_authflavor_t authflavor
+	),
+	TP_ARGS(clp, netid, authflavor),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(unsigned long, authflavor)
+		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+		__array(unsigned char, netid, 8)
+	),
+	TP_fast_assign(
+		__entry->cl_boot = clp->cl_clientid.cl_boot;
+		__entry->cl_id = clp->cl_clientid.cl_id;
+		strlcpy(__entry->netid, netid, sizeof(__entry->netid));
+		__entry->authflavor = authflavor;
+		memcpy(__entry->addr, &clp->cl_cb_conn.cb_addr,
+			sizeof(struct sockaddr_in6));
+	),
+	TP_printk("addr=%pISpc client %08x:%08x proto=%s flavor=%s",
+		__entry->addr, __entry->cl_boot, __entry->cl_id,
+		__entry->netid, show_nfsd_authflavor(__entry->authflavor))
+);
+
 TRACE_EVENT(nfsd_cb_setup_err,
 	TP_PROTO(
 		const struct nfs4_client *clp,
-- 
2.43.0



