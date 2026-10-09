Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B889847141D;
	Fri,  9 Oct 2026 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556261; cv=none; b=o+UfcVlEgVmzuFogdQfSWr3tZENdcCfUAsqA558UBNLCGsXeXTfD+8i5OGAj04qRhOxqAWCcxV+wUhBvE7YwTC5MWfZjRfl5NWQA/cB8ExGLACWpNxgpGThc4kuNcNIyVVieD5QVTlrMe4BhMgFBwUQlzBNJxvZt2S/jfOmEi20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556261; c=relaxed/simple;
	bh=KUV6YuYxYGXeMsRZRVMpuS28uLoTwQGU0BRyfF5aAIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8mDT6VJo+VEJMYvnmiEfOOowmLFE6sIJ/OfqGsV8zFSXxzVOiXpNlVlKpBpziZoD16Qux2+NnsAvs5HZTog/tb0MhKKe0GQuZu/bzG1eVt7NTJkArEVFplIR8+TQ2KqryxsmNm18l/flR239Hxra+pvMtH0mkN9ksQ7N47ZjeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmDcIr/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmDcIr/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97C31F000FF;
	Fri,  9 Oct 2026 14:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556260;
	bh=6zK7SnHydfrVK+hHnvdBaMlvQZCXgzLaXXdFUC/86dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmDcIr/PEtpIhOsEjBqaqtILAYvlkkcrotb6yeQ76lU+4cswViCkMBc7ggob4YkR5
	 BHFHJWVFK4fGInuTAd+Ntph4qcRHrNOWApzUUMHnOumDwP6o3Lx5XXRrRmNf/RriNe
	 zH9iYNv/uWx6g4T6AeOYPa/4kRVX8+TdogxWIRHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 148/428] ipvs: filter some flags received in the backup server
Date: Fri,  9 Oct 2026 16:08:05 +0200
Message-ID: <20261009140949.420142083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit f96e91748f6304668fe647e686d199d7207d36f1 ]

While the IPVS SYNC protocol is not secure by design
we can still protect the backup server from messages that
can wreak havoc.

This commit addresses problems from received connection flags
or their combinations. We now drop messages as follows:

1. the NO_CPORT+TEMPLATE combination allows lookups for normal
connections to hit template which can break in many ways.
While the master does not sync connections with NO_CPORT flag,
i.e. before they are established, we still accept NO_CPORT
without TEMPLATE.

2. ONE_PACKET: it is not sent by master, so we do not
expect it in backup. Before now it was ignored by
IP_VS_CONN_F_BACKUP_MASK for protocol v1 while protocol
v0 created connections that are not hashed and dropped
immediately. Better to apply the IP_VS_CONN_F_BACKUP_MASK
also to the flags from v0 messages for consistency with v1.

Fixes: 87375ab47cd0 ("[IPVS]: ip_vs_ftp breaks connections using persistence")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 5383aeafb0aed..69dc28153ec12 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -949,6 +949,21 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 	ip_vs_conn_put(cp);
 }
 
+/* Check for incompatible flags */
+static bool ip_vs_sync_validate_flags(u32 flags)
+{
+	/* We do not expect NO_CPORT, especially to allow lookups
+	 * to hit templates
+	 */
+	if (flags & IP_VS_CONN_F_NO_CPORT) {
+		if (flags & IP_VS_CONN_F_TEMPLATE)
+			return false;
+	}
+	if (flags & IP_VS_CONN_F_ONE_PACKET)
+		return false;
+	return true;
+}
+
 /*
  *  Process received multicast message for Version 0
  */
@@ -972,8 +987,7 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 			return;
 		}
 		s = (struct ip_vs_sync_conn_v0 *) p;
-		flags = ntohs(s->flags) | IP_VS_CONN_F_SYNC;
-		flags &= ~IP_VS_CONN_F_HASHED;
+		flags = ntohs(s->flags);
 		if (flags & IP_VS_CONN_F_SEQ_MASK) {
 			opt = (struct ip_vs_sync_conn_options *)&s[1];
 			p += FULL_CONN_SIZE;
@@ -986,6 +1000,13 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 			p += SIMPLE_CONN_SIZE;
 		}
 
+		if (!ip_vs_sync_validate_flags(flags)) {
+			IP_VS_DBG(2, "BACKUP v0, Invalid flags 0x%X\n", flags);
+			continue;
+		}
+		flags &= IP_VS_CONN_F_BACKUP_MASK;
+		flags |= IP_VS_CONN_F_SYNC;
+
 		state = ntohs(s->state);
 		if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
 			pp = ip_vs_proto_get(s->protocol);
@@ -1141,7 +1162,13 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 	}
 
 	/* Get flags and Mask off unsupported */
-	flags  = ntohl(s->v4.flags) & IP_VS_CONN_F_BACKUP_MASK;
+	flags = ntohl(s->v4.flags);
+	if (!ip_vs_sync_validate_flags(flags)) {
+		IP_VS_DBG(3, "BACKUP, Invalid flags 0x%X\n", flags);
+		retc = 25;
+		goto out;
+	}
+	flags &= IP_VS_CONN_F_BACKUP_MASK;
 	flags |= IP_VS_CONN_F_SYNC;
 	state = ntohs(s->v4.state);
 
-- 
2.53.0



