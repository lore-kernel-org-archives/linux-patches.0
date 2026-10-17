Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4173A3E97;
	Sat, 17 Oct 2026 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253228; cv=none; b=FAJZJkofhFOh6XwqqUsbt76NXVBSIPafLaO70O+MLiHTASLj3GSVpFmYUrqiDeWZAq1984/JhEqLo5+oVWhCcHMfNmvgmPssu2f+7mxhvvbosEfNmHnL7zWeGbv/Xuvn6u19+eKY+J3hUarmQ9nonrJ92BKHNRcsLPtNZg0XAOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253228; c=relaxed/simple;
	bh=qJL2mE2uRtiZdjDJCLTGfAwlnqUqeoyqBGQax8eRfU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVL3SvxBftP/Xx8QcbC5TvLUI7CQfTB50m29IfI+vsBpTnHjeByFSF8vYAVYHzRe3Doz76yszMSWACaZ9rf3vNZR7LYJLOZ1WXkhkVEH4/itpzeNB9bQeiqE89AOJISCARFW6x9QPqw2SqM9utMARNw7KHskUbVZTocEMzs9F5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMjNGt1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMjNGt1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCDA1F000C6;
	Sat, 17 Oct 2026 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253226;
	bh=w+VtYDqG4tgbRZsFY3DQeaQImlU/IhWyj9xXbixlPYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMjNGt1mJPF2mOlhcGNT3ZRhKUpjjIFLzRgcxJXCTNcI4TBb5tszY+0llZjuPJcGl
	 BypYnhdERQuvebIeWX33hBGaPHCJypirPA7wxmOhSsFLhmqJ2u4Zv5QKpTdMkBubvz
	 LWulqWShyj296b30Kcd7N/uEcBmz0ZivVdLUdl8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 049/869] smb: client: improve compound padding in encryption
Date: Sat, 17 Oct 2026 17:48:10 +0200
Message-ID: <20261017160038.275406344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit bc925c1216f0848da96ac642fba3cb92ae1f4e06 upstream.

After commit f7f291e14dde ("cifs: fix oops during encryption"), the
encryption layer can handle vmalloc'd buffers as well as kmalloc'd
buffers, so there is no need to inefficiently squash request iovs
into a single one to handle padding in compound requests.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h  |    4 ++--
 fs/smb/client/smb2ops.c   |   37 +++----------------------------------
 fs/smb/client/transport.c |   40 +++++++++++++---------------------------
 3 files changed, 18 insertions(+), 63 deletions(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2195,7 +2195,7 @@ static inline int cifs_get_num_sgs(const
 			struct kvec *iov = &rqst[i].rq_iov[j];
 
 			addr = (unsigned long)iov->iov_base + skip;
-			if (unlikely(is_vmalloc_addr((void *)addr))) {
+			if (is_vmalloc_or_module_addr((void *)addr)) {
 				len = iov->iov_len - skip;
 				nents += DIV_ROUND_UP(offset_in_page(addr) + len,
 						      PAGE_SIZE);
@@ -2222,7 +2222,7 @@ static inline void cifs_sg_set_buf(struc
 	unsigned int off = offset_in_page(addr);
 
 	addr &= PAGE_MASK;
-	if (unlikely(is_vmalloc_addr((void *)addr))) {
+	if (is_vmalloc_or_module_addr((void *)addr)) {
 		do {
 			unsigned int len = min_t(unsigned int, buflen, PAGE_SIZE - off);
 
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2842,7 +2842,7 @@ smb2_set_next_command(struct cifs_tcon *
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = ses->server;
 	unsigned long len = smb_rqst_len(server, rqst);
-	int i, num_padding;
+	int num_padding;
 
 	shdr = (struct smb2_hdr *)(rqst->rq_iov[0].iov_base);
 	if (shdr == NULL) {
@@ -2851,44 +2851,13 @@ smb2_set_next_command(struct cifs_tcon *
 	}
 
 	/* SMB headers in a compound are 8 byte aligned. */
-
-	/* No padding needed */
-	if (!(len & 7))
-		goto finished;
-
-	num_padding = 8 - (len & 7);
-	if (!smb3_encryption_required(tcon)) {
-		/*
-		 * If we do not have encryption then we can just add an extra
-		 * iov for the padding.
-		 */
+	if (!IS_ALIGNED(len, 8)) {
+		num_padding = 8 - (len & 7);
 		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
 		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
 		rqst->rq_nvec++;
 		len += num_padding;
-	} else {
-		/*
-		 * We can not add a small padding iov for the encryption case
-		 * because the encryption framework can not handle the padding
-		 * iovs.
-		 * We have to flatten this into a single buffer and add
-		 * the padding to it.
-		 */
-		for (i = 1; i < rqst->rq_nvec; i++) {
-			memcpy(rqst->rq_iov[0].iov_base +
-			       rqst->rq_iov[0].iov_len,
-			       rqst->rq_iov[i].iov_base,
-			       rqst->rq_iov[i].iov_len);
-			rqst->rq_iov[0].iov_len += rqst->rq_iov[i].iov_len;
-		}
-		memset(rqst->rq_iov[0].iov_base + rqst->rq_iov[0].iov_len,
-		       0, num_padding);
-		rqst->rq_iov[0].iov_len += num_padding;
-		len += num_padding;
-		rqst->rq_nvec = 1;
 	}
-
- finished:
 	shdr->NextCommand = cpu_to_le32(len);
 }
 
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -425,19 +425,16 @@ out:
 	return rc;
 }
 
-struct send_req_vars {
-	struct smb2_transform_hdr tr_hdr;
-	struct smb_rqst rqst[MAX_COMPOUND];
-	struct kvec iov;
-};
-
 static int
 smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	      struct smb_rqst *rqst, int flags)
 {
-	struct send_req_vars *vars;
-	struct smb_rqst *cur_rqst;
-	struct kvec *iov;
+	struct smb2_transform_hdr tr_hdr;
+	struct smb_rqst new_rqst[MAX_COMPOUND] = {};
+	struct kvec iov = {
+		.iov_base = &tr_hdr,
+		.iov_len = sizeof(tr_hdr),
+	};
 	int rc;
 
 	if (flags & CIFS_COMPRESS_REQ)
@@ -454,26 +451,15 @@ smb_send_rqst(struct TCP_Server_Info *se
 		return -EIO;
 	}
 
-	vars = kzalloc(sizeof(*vars), GFP_NOFS);
-	if (!vars)
-		return -ENOMEM;
-	cur_rqst = vars->rqst;
-	iov = &vars->iov;
-
-	iov->iov_base = &vars->tr_hdr;
-	iov->iov_len = sizeof(vars->tr_hdr);
-	cur_rqst[0].rq_iov = iov;
-	cur_rqst[0].rq_nvec = 1;
+	new_rqst[0].rq_iov = &iov;
+	new_rqst[0].rq_nvec = 1;
 
 	rc = server->ops->init_transform_rq(server, num_rqst + 1,
-					    &cur_rqst[0], rqst);
-	if (rc)
-		goto out;
-
-	rc = __smb_send_rqst(server, num_rqst + 1, &cur_rqst[0]);
-	smb3_free_compound_rqst(num_rqst, &cur_rqst[1]);
-out:
-	kfree(vars);
+					    new_rqst, rqst);
+	if (!rc) {
+		rc = __smb_send_rqst(server, num_rqst + 1, new_rqst);
+		smb3_free_compound_rqst(num_rqst, &new_rqst[1]);
+	}
 	return rc;
 }
 


