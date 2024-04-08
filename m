Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA17C0AB;
	Mon,  8 Apr 2024 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583573; cv=none; b=ruOAJjS3LoOa2iW92V7ipHnGrlhUcEOFMkx6hcox14F+7I0MvUKGpdXwyy69NFjL071/MMgY8caaUD+DTGkAfMMTipOs0rmoJpjeOaLLi/fld81IO1p6Y+MT6IMfHtT0Qt22khHGI+KE7p2v/IGQgdr2OfmgWf8fFSVUYSJE6iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583573; c=relaxed/simple;
	bh=4iBco4EVv/oIERTY7nr/ZVEqdPSsFQ7fNstwuGSHc5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/7cIPA+ioVuLJQw4wPjB2Tp8iG7vsCTd1n8eOLK0RMR3EsgDXMPJRDLx2e+42WTHnZWAj/CtD7s8UEXQ1SWRRnKt42yaSIeKHog/8m7fZNi9BYBWnesA2I2SMetMv/QPOFY7jO5qGkRDXabJIMO/t0N8Mnv7r0R7cAdjHRwgl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFuj6wGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFuj6wGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3E8C433C7;
	Mon,  8 Apr 2024 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583573;
	bh=4iBco4EVv/oIERTY7nr/ZVEqdPSsFQ7fNstwuGSHc5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFuj6wGQWfTczXs0YmuBf81iDCD2AYavnKZsgsmcT/f3o+DGKvHWxaFWgtfTHO2/A
	 8cHZrJYmhzq1oRfjfgiNPmA5DvIPAW+/KBq3os8yiB2lBYEQSL5l8CTr+T5Mx2h5sr
	 vTiAmzSBSdw61reElyr3A3PA/4CYtTWLrg8cv/j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 261/690] NFSD: Clean up the nfsd_net::nfssvc_boot field
Date: Mon,  8 Apr 2024 14:52:07 +0200
Message-ID: <20240408125409.080146771@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 91d2e9b56cf5c80f9efc530d494968369a8a0e0d ]

There are two boot-time fields in struct nfsd_net: one called
boot_time and one called nfssvc_boot. The latter is used only to
form write verifiers, but its documenting comment declares:

        /* Time of server startup */

Since commit 27c438f53e79 ("nfsd: Support the server resetting the
boot verifier"), this field can be reset at any time; it's no
longer tied to server restart. So that comment is stale.

Also, according to pahole, struct timespec64 is 16 bytes long on
x86_64. The nfssvc_boot field is used only to form a write verifier,
which is 8 bytes long.

Let's clarify this situation by manufacturing an 8-byte verifier
in nfs_reset_boot_verifier() and storing only that in struct
nfsd_net.

We're grabbing 128 bits of time, so compress all of those into a
64-bit verifier instead of throwing out the high-order bits.
In the future, the siphash_key can be re-used for other hashed
objects per-nfsd_net.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/netns.h  |  8 +++++---
 fs/nfsd/nfsctl.c |  3 ++-
 fs/nfsd/nfssvc.c | 51 ++++++++++++++++++++++++++++++++++++------------
 3 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 9e8b77d2a3a47..a6ed300259849 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -11,6 +11,7 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <linux/percpu_counter.h>
+#include <linux/siphash.h>
 
 /* Hash tables for nfs4_clientid state */
 #define CLIENT_HASH_BITS                 4
@@ -108,9 +109,8 @@ struct nfsd_net {
 	bool nfsd_net_up;
 	bool lockd_up;
 
-	/* Time of server startup */
-	struct timespec64 nfssvc_boot;
-	seqlock_t boot_lock;
+	seqlock_t writeverf_lock;
+	unsigned char writeverf[8];
 
 	/*
 	 * Max number of connections this nfsd container will allow. Defaults
@@ -187,6 +187,8 @@ struct nfsd_net {
 	char			nfsd_name[UNX_MAXNODENAME+1];
 
 	struct nfsd_fcache_disposal *fcache_disposal;
+
+	siphash_key_t		siphash_key;
 };
 
 /* Simple check to find out if a given net was properly initialized */
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 504b169d27881..68b020f2002b7 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1484,7 +1484,8 @@ static __net_init int nfsd_init_net(struct net *net)
 	nn->clientid_counter = nn->clientid_base + 1;
 	nn->s2s_cp_cl_id = nn->clientid_counter++;
 
-	seqlock_init(&nn->boot_lock);
+	get_random_bytes(&nn->siphash_key, sizeof(nn->siphash_key));
+	seqlock_init(&nn->writeverf_lock);
 
 	return 0;
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 4d1d8aa6d7f9d..5a60664695352 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/fs_struct.h>
 #include <linux/swap.h>
+#include <linux/siphash.h>
 
 #include <linux/sunrpc/stats.h>
 #include <linux/sunrpc/svcsock.h>
@@ -344,33 +345,57 @@ static bool nfsd_needs_lockd(struct nfsd_net *nn)
 	return nfsd_vers(nn, 2, NFSD_TEST) || nfsd_vers(nn, 3, NFSD_TEST);
 }
 
+/**
+ * nfsd_copy_boot_verifier - Atomically copy a write verifier
+ * @verf: buffer in which to receive the verifier cookie
+ * @nn: NFS net namespace
+ *
+ * This function provides a wait-free mechanism for copying the
+ * namespace's boot verifier without tearing it.
+ */
 void nfsd_copy_boot_verifier(__be32 verf[2], struct nfsd_net *nn)
 {
 	int seq = 0;
 
 	do {
-		read_seqbegin_or_lock(&nn->boot_lock, &seq);
-		/*
-		 * This is opaque to client, so no need to byte-swap. Use
-		 * __force to keep sparse happy. y2038 time_t overflow is
-		 * irrelevant in this usage
-		 */
-		verf[0] = (__force __be32)nn->nfssvc_boot.tv_sec;
-		verf[1] = (__force __be32)nn->nfssvc_boot.tv_nsec;
-	} while (need_seqretry(&nn->boot_lock, seq));
-	done_seqretry(&nn->boot_lock, seq);
+		read_seqbegin_or_lock(&nn->writeverf_lock, &seq);
+		memcpy(verf, nn->writeverf, sizeof(*verf));
+	} while (need_seqretry(&nn->writeverf_lock, seq));
+	done_seqretry(&nn->writeverf_lock, seq);
 }
 
 static void nfsd_reset_boot_verifier_locked(struct nfsd_net *nn)
 {
-	ktime_get_raw_ts64(&nn->nfssvc_boot);
+	struct timespec64 now;
+	u64 verf;
+
+	/*
+	 * Because the time value is hashed, y2038 time_t overflow
+	 * is irrelevant in this usage.
+	 */
+	ktime_get_raw_ts64(&now);
+	verf = siphash_2u64(now.tv_sec, now.tv_nsec, &nn->siphash_key);
+	memcpy(nn->writeverf, &verf, sizeof(nn->writeverf));
 }
 
+/**
+ * nfsd_reset_boot_verifier - Generate a new boot verifier
+ * @nn: NFS net namespace
+ *
+ * This function updates the ->writeverf field of @nn. This field
+ * contains an opaque cookie that, according to Section 18.32.3 of
+ * RFC 8881, "the client can use to determine whether a server has
+ * changed instance state (e.g., server restart) between a call to
+ * WRITE and a subsequent call to either WRITE or COMMIT.  This
+ * cookie MUST be unchanged during a single instance of the NFSv4.1
+ * server and MUST be unique between instances of the NFSv4.1
+ * server."
+ */
 void nfsd_reset_boot_verifier(struct nfsd_net *nn)
 {
-	write_seqlock(&nn->boot_lock);
+	write_seqlock(&nn->writeverf_lock);
 	nfsd_reset_boot_verifier_locked(nn);
-	write_sequnlock(&nn->boot_lock);
+	write_sequnlock(&nn->writeverf_lock);
 }
 
 static int nfsd_startup_net(struct net *net, const struct cred *cred)
-- 
2.43.0



