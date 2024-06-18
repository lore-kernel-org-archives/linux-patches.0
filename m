Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730111552E4;
	Tue, 18 Jun 2024 12:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715366; cv=none; b=AKAjkwmXbJ60uJcHyBkl5cSvGMqWCYD1eF/5nOYGvOx1Zkjz+Rh3UtyvesIvV51I4cBx4ZqwG9TkcoPVDNg3Vh7B1ZtCZrRyVBVn+rHoPH0+BTp4lOdqO1CpvZpbTTW5kz8LFmek1JpcnyeXpn+uzbeLxMMGp4s1S+VXfO7yDaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715366; c=relaxed/simple;
	bh=ZErftV/QM+4BxCM07WXsxB/BQnc2r1LtU+jgM4lK7Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAbk85GOgrcp0lht1UGj8S4b/m1iloBm7wk3rNbw//cTGKtlSlUkv/kNv+37t2CsqGN4lK0Xu4p7746WOOZ56NQrkGM6zKruSkgMsT6e5SuXof/NkTwrgSeohf1Hm99FNXEqiIn+kYKKI0hxOn4cDLlQdptlu9rmuPX/GR/eyGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQbyPHA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQbyPHA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9407C3277B;
	Tue, 18 Jun 2024 12:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715366;
	bh=ZErftV/QM+4BxCM07WXsxB/BQnc2r1LtU+jgM4lK7Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQbyPHA2PiV46n+PiULqx6KwXLX494KL3wRM3UjyEbOAmGtRFecRrYHdPSGXJKOry
	 DCER7eqy566t4VYrFDYszjh6LtSPy2RNDr8Nku4WWxUKO5UWa6EXOLO859HjU89+Zz
	 UJHTHrn65B99m8sUCJpXvpz7osKvfCsyRhUvS+xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Olga Kornievskaia <kolga@netapp.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/770] NFSD: Add an nfsd_cb_offload tracepoint
Date: Tue, 18 Jun 2024 14:32:18 +0200
Message-ID: <20240618123418.265336664@linuxfoundation.org>
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

[ Upstream commit 87512386e951ee28ba2e7ef32b843ac97621d371 ]

Record the arguments of CB_OFFLOAD callbacks so we can better
observe asynchronous copy-offload behavior. For example:

nfsd-995   [008]  7721.934222: nfsd_cb_offload:
        addr=192.168.2.51:0 client 6092a47c:35a43fc1 fh_hash=0x8739113a
        count=116528 status=0

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Olga Kornievskaia <kolga@netapp.com>
Cc: Dai Ngo <Dai.Ngo@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c |  2 ++
 fs/nfsd/trace.h    | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index f85958f81a266..dfce9c432a5ee 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1489,6 +1489,8 @@ static int nfsd4_do_async_copy(void *data)
 	memcpy(&cb_copy->fh, &copy->fh, sizeof(copy->fh));
 	nfsd4_init_cb(&cb_copy->cp_cb, cb_copy->cp_clp,
 			&nfsd4_cb_offload_ops, NFSPROC4_CLNT_CB_OFFLOAD);
+	trace_nfsd_cb_offload(copy->cp_clp, &copy->cp_res.cb_stateid,
+			      &copy->fh, copy->cp_count, copy->nfserr);
 	nfsd4_run_cb(&cb_copy->cp_cb);
 out:
 	if (!copy->cp_intra)
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index bed7d5d49fee4..fe32dfe1e55af 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1053,6 +1053,42 @@ TRACE_EVENT(nfsd_cb_notify_lock,
 		__entry->fh_hash)
 );
 
+TRACE_EVENT(nfsd_cb_offload,
+	TP_PROTO(
+		const struct nfs4_client *clp,
+		const stateid_t *stp,
+		const struct knfsd_fh *fh,
+		u64 count,
+		__be32 status
+	),
+	TP_ARGS(clp, stp, fh, count, status),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(u32, si_id)
+		__field(u32, si_generation)
+		__field(u32, fh_hash)
+		__field(int, status)
+		__field(u64, count)
+		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+	),
+	TP_fast_assign(
+		__entry->cl_boot = stp->si_opaque.so_clid.cl_boot;
+		__entry->cl_id = stp->si_opaque.so_clid.cl_id;
+		__entry->si_id = stp->si_opaque.so_id;
+		__entry->si_generation = stp->si_generation;
+		__entry->fh_hash = knfsd_fh_hash(fh);
+		__entry->status = be32_to_cpu(status);
+		__entry->count = count;
+		memcpy(__entry->addr, &clp->cl_cb_conn.cb_addr,
+			sizeof(struct sockaddr_in6));
+	),
+	TP_printk("addr=%pISpc client %08x:%08x stateid %08x:%08x fh_hash=0x%08x count=%llu status=%d",
+		__entry->addr, __entry->cl_boot, __entry->cl_id,
+		__entry->si_id, __entry->si_generation,
+		__entry->fh_hash, __entry->count, __entry->status)
+);
+
 #endif /* _NFSD_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.43.0



