Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831758;
	b=KwF1eu/JF34J3jI/xGtw8TNiaLNqFJ9nRhRoi2d+U34CqaSPlWkejX5yOkvQKTgJkSQq
	 KoZklRSt9LgrErYfjlXpfXoeoPHSJUmjw8I8b/9wVCV5y/JLZjo11K5C2UkUnrRLs9HpS
	 UliXFu3/vLGppTNijO/gBlmARwRp1GsiyqJ30mDRP1C+DTzXRMXTXVZj01dXgY8gaPYt0
	 Ze2zerrM07VRbwVGuHliwx6pnG4KdMSLAtz0QkbWHasmIZ5tr45XvB9NXpoRwEhZupLr/
	 5eoUtHmPWQpBSR85VPk0izcG3YD7FO/StZ7pb3eMrPzIsYoprOn53SC4e3lfmMRfzWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kjq0812RXnLyvNPmI+xmztdpbjyULsRoj6QEwiCgDPo=;
	b=25dkTlKSdZFlhTqh1CUtJRD8DtRXoRDHcgO5II2A12Rirmbjmvpgix8aEouU1q5H33bF
	 LL4OvXiM2PIg1kn4cgj6xRFJo5PB52YceUKCPIWv3RfGOHU6Dh80fK0DS5cfy1KA5Ip63
	 K17vQ+ZbilDj+XVRY2p2V8AoHhmJVqZp2KRMsK1zfqyIyJSKEmBdLINTKMyyBDfsMaK6u
	 gQI2Lfo1IrgDXpwld4piCj3yajlgM9/uwlZAPVo6KJ7/8gBp+s+doaLRRmNVSTkTVXFCG
	 h5iIm26rj9p/wJ6PSBiTQ6PScGA+o5Cfe0TkUE6m1DaqLxQz0fUj6/FEd1MdDKzHJAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfJGlAad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443FF606A31B;
	Wed,  4 Nov 2026 22:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfJGlAad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31ED1F00A02;
	Wed,  4 Nov 2026 22:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831758;
	bh=Kjq0812RXnLyvNPmI+xmztdpbjyULsRoj6QEwiCgDPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfJGlAadJLvfRwNdrcIMRbpvyZPMl2VsD56tUCNs0CyZg1Xy7bC7YD/6AV57/o/db
	 m21TEzv/ds+mhVQNpmCkrsY55Cxjhvp/4FAkIKPdCldjbySZie372gjKjQd3u5n2P/
	 MQyrFE0ZSyC8CDK9f3rTqYpRi/KfNrWrUXcqK5Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0894/1005] NFSD: Fix out-of-bounds read in the rpc_status dump
Date: Wed,  4 Nov 2026 16:10:27 -0500
Message-ID: <20261104211108.254893137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit cbea14890783fead76f878caf0775a62a42049bf upstream.

nfsd_nl_rpc_status_get_dumpit() loads args->opcnt and
args->ops separately, then walks ops[] before rechecking
rq_status_counter. A COMPOUND that completes between the two loads
runs nfsd4_release_compoundargs(), which zeroes opcnt and points ops
back at the eight-entry inline array. A dump that already sampled an
opcnt of 200 clamps it to the sixteen slots in rq_opnum, then indexes
iops[0..15]. iops is the last member of struct nfsd4_compoundargs and
rq_argp is allocated at exactly that size, so the walk runs off the
end of the allocation. The trailing recheck discards the sampled data,
but the read has already happened. NFSD_CMD_RPC_STATUS_GET carries
no GENL_ADMIN_PERM, so an unprivileged local user can repeat the dump
against a busy server until it lands in the window.

Sample opcnt and ops into locals, then finish the counter recheck
before dereferencing ops. An unchanged counter means both came from the
same COMPOUND, where opcnt cannot exceed what ops holds.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Reported-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Closes: https://lore.kernel.org/linux-nfs/20260823113255.3417-1-prabhakar.pujeri@dell.com/
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260824-nfsd-posix-acl-ownership-v1-1-090fffc608ec@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1576,14 +1576,29 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 			    rqstp->rq_proc == NFSPROC4_COMPOUND) {
 				/* NFSv4 compound */
 				struct nfsd4_compoundargs *args;
+				struct nfsd4_op *ops;
+				u32 opcnt;
 				int j;
 
 				args = rqstp->rq_argp;
-				genl_rqstp.rq_opcnt = min_t(u32, args->opcnt,
+				opcnt = READ_ONCE(args->opcnt);
+				ops = READ_ONCE(args->ops);
+
+				/*
+				 * Finish the seqcount retry before
+				 * dereferencing ops. An unchanged counter means
+				 * opcnt and ops came from the same COMPOUND,
+				 * where opcnt cannot exceed what ops holds.
+				 */
+				smp_rmb();
+				if (READ_ONCE(rqstp->rq_status_counter) !=
+				    status_counter)
+					continue;
+
+				genl_rqstp.rq_opcnt = min_t(u32, opcnt,
 							    ARRAY_SIZE(genl_rqstp.rq_opnum));
 				for (j = 0; j < genl_rqstp.rq_opcnt; j++)
-					genl_rqstp.rq_opnum[j] =
-						args->ops[j].opnum;
+					genl_rqstp.rq_opnum[j] = ops[j].opnum;
 			}
 #endif /* CONFIG_NFSD_V4 */
 


