Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1255C267F57;
	Tue,  8 Apr 2025 12:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114832; cv=none; b=fOW4Spgmj0jQ0/aNAMg5evBZwjLXt1WSobtzMhuCutVujTc1sXVTAE/UfIoJibYllaBUgUgrTwPzpIaGAYNddvC5KhSO2a2CmSFPeX9DGhhx0VXxLnzBjHqzFbh8Fgd9dL/xiY+SVW2HUH0lwkUPuiQA7K8xY6SzBbVMtJu83Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114832; c=relaxed/simple;
	bh=mVRiIu7rATxF2RmHwJ8fSHPxCt0VP0raxLgmIGjw708=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jryj5FLiCffy3s+yoBtOQs+RNnR2kDzvNZL8ocYFGuX7m3SUC9LRGSEW9eQutNO2j3oNIKfc/j5URiKngoDtKHD+urbblaqSY+eIuQsInzuPmxlcBgusRTJg006PMtUAqM39PFgsXfOYLKRYaAX0js8dR4ucIM1X6GbmoYCt+8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPttrLXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPttrLXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BB6C4CEE5;
	Tue,  8 Apr 2025 12:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114831;
	bh=mVRiIu7rATxF2RmHwJ8fSHPxCt0VP0raxLgmIGjw708=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPttrLXtUiyy9g2uwcvWyRu1HDako/1/FafBBPnvcszQTICbOV4F2fMTObH9OnDw0
	 H6incGHEB+MS7KVxvRlzG/64GdcXr+NxQv3XFAIodW0VezS7hJst3r7fgwt+t7jzPv
	 Fbyt8Nm9/ZNmjAseErBwS+CYi/P7G8kOaQ4x5xeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.com>,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 249/499] NFS: fix open_owner_id_maxsz and related fields.
Date: Tue,  8 Apr 2025 12:47:41 +0200
Message-ID: <20250408104857.424606435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 43502f6e8d1e767d6736ea0676cc784025cf6eeb ]

A recent change increased the size of an NFSv4 open owner, but didn't
increase the corresponding max_sz defines.  This is not know to have
caused failure, but should be fixed.

This patch also fixes some relates _maxsz fields that are wrong.

Note that the XXX_owner_id_maxsz values now are only the size of the id
and do NOT include the len field that will always preceed the id in xdr
encoding.  I think this is clearer.

Reported-by: David Disseldorp <ddiss@suse.com>
Fixes: d98f72272500 ("nfs: simplify and guarantee owner uniqueness.")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index e8ac3f615f932..71f45cc0ca74d 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -82,9 +82,8 @@ static int decode_layoutget(struct xdr_stream *xdr, struct rpc_rqst *req,
  * we currently use size 2 (u64) out of (NFS4_OPAQUE_LIMIT  >> 2)
  */
 #define pagepad_maxsz		(1)
-#define open_owner_id_maxsz	(1 + 2 + 1 + 1 + 2)
-#define lock_owner_id_maxsz	(1 + 1 + 4)
-#define decode_lockowner_maxsz	(1 + XDR_QUADLEN(IDMAP_NAMESZ))
+#define open_owner_id_maxsz	(2 + 1 + 2 + 2)
+#define lock_owner_id_maxsz	(2 + 1 + 2)
 #define compound_encode_hdr_maxsz	(3 + (NFS4_MAXTAGLEN >> 2))
 #define compound_decode_hdr_maxsz	(3 + (NFS4_MAXTAGLEN >> 2))
 #define op_encode_hdr_maxsz	(1)
@@ -185,7 +184,7 @@ static int decode_layoutget(struct xdr_stream *xdr, struct rpc_rqst *req,
 #define encode_claim_null_maxsz	(1 + nfs4_name_maxsz)
 #define encode_open_maxsz	(op_encode_hdr_maxsz + \
 				2 + encode_share_access_maxsz + 2 + \
-				open_owner_id_maxsz + \
+				1 + open_owner_id_maxsz + \
 				encode_opentype_maxsz + \
 				encode_claim_null_maxsz)
 #define decode_space_limit_maxsz	(3)
@@ -255,13 +254,14 @@ static int decode_layoutget(struct xdr_stream *xdr, struct rpc_rqst *req,
 #define encode_link_maxsz	(op_encode_hdr_maxsz + \
 				nfs4_name_maxsz)
 #define decode_link_maxsz	(op_decode_hdr_maxsz + decode_change_info_maxsz)
-#define encode_lockowner_maxsz	(7)
+#define encode_lockowner_maxsz	(2 + 1 + lock_owner_id_maxsz)
+
 #define encode_lock_maxsz	(op_encode_hdr_maxsz + \
 				 7 + \
 				 1 + encode_stateid_maxsz + 1 + \
 				 encode_lockowner_maxsz)
 #define decode_lock_denied_maxsz \
-				(8 + decode_lockowner_maxsz)
+				(2 + 2 + 1 + 2 + 1 + lock_owner_id_maxsz)
 #define decode_lock_maxsz	(op_decode_hdr_maxsz + \
 				 decode_lock_denied_maxsz)
 #define encode_lockt_maxsz	(op_encode_hdr_maxsz + 5 + \
@@ -617,7 +617,7 @@ static int decode_layoutget(struct xdr_stream *xdr, struct rpc_rqst *req,
 				 encode_lockowner_maxsz)
 #define NFS4_dec_release_lockowner_sz \
 				(compound_decode_hdr_maxsz + \
-				 decode_lockowner_maxsz)
+				 decode_release_lockowner_maxsz)
 #define NFS4_enc_access_sz	(compound_encode_hdr_maxsz + \
 				encode_sequence_maxsz + \
 				encode_putfh_maxsz + \
@@ -1412,7 +1412,7 @@ static inline void encode_openhdr(struct xdr_stream *xdr, const struct nfs_opena
 	__be32 *p;
  /*
  * opcode 4, seqid 4, share_access 4, share_deny 4, clientid 8, ownerlen 4,
- * owner 4 = 32
+ * owner 28
  */
 	encode_nfs4_seqid(xdr, arg->seqid);
 	encode_share_access(xdr, arg->share_access);
@@ -5077,7 +5077,7 @@ static int decode_link(struct xdr_stream *xdr, struct nfs4_change_info *cinfo)
 /*
  * We create the owner, so we know a proper owner.id length is 4.
  */
-static int decode_lock_denied (struct xdr_stream *xdr, struct file_lock *fl)
+static int decode_lock_denied(struct xdr_stream *xdr, struct file_lock *fl)
 {
 	uint64_t offset, length, clientid;
 	__be32 *p;
-- 
2.39.5



