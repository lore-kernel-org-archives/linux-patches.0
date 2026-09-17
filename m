Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363CB519DFB;
	Thu, 17 Sep 2026 17:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664688; cv=none; b=YdQ99OVeJTgQgtnjZ4zvVl9nSIAMuLZSr2egE1P0SPlz9wEgEjkUHprbtidh6d9I3WB8klBC15pPL4mgLI5AAd3UAg8KAJqStKbtANpNexPrHFOnQ/8nh4/2djPHDiD4hOgdYnywTxJjAuZXZOeumSO1v1MisHymYFdbZC5/uYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664688; c=relaxed/simple;
	bh=UASNFffjRwLjl5/kYoP8Wn0nLnz1a6X3yxKjNnldFsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj1X9o/zE3Gc2bwo8lhYOcSgvoQvi+rOIihK4YLm0Jdi1B3tqJWsRYAPE/1Ai5ojCgbFr2r8Qt+RaskvgyJlnDon6Esj64cgMVRUPP5OdY5nnE6rKuToiKOMxDQPCk7/Niy84wz89SKlmGcWHLRicYMdp17HfKFn1eVm5FJL+SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ng2h+y7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ng2h+y7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B87D1F000FF;
	Thu, 17 Sep 2026 17:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664687;
	bh=1PGobTEreD/R43SBnY49jG3qeMfZmCMMrCmrjuWvl8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ng2h+y7QXPt+Z7kYD383u1dIGfnpJYdpGfHV8IMXPsRfL2PRirco4SRThRvQOxHTe
	 1T9OwF18HUsMK+k3REdfrXDn8ddlHfkmSbQcbdf/6ipwtfFounmJ4IxxmFD5Pj63Fz
	 blUba6j5DbpYUxnzmfS6v8yeMXpjJceb+D2r0k3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0455/1250] ksmbd: validate SMB2 lease create contexts
Date: Thu, 17 Sep 2026 16:04:10 +0100
Message-ID: <20260917151604.319450869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit b69be2c58615950ee7353b61a21acdf8508c0cbb ]

Validate SMB2 lease context lengths, requested lease state bits, and v2
flags before using the context. Return errors via ERR_PTR so CREATE can
distinguish a missing lease context from a malformed one.

Also ignore lease v2 contexts for SMB 2.1, where they are not valid.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c  | 33 ++++++++++++++++++++++++++++-----
 fs/smb/server/smb2pdu.c | 24 +++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 711659156d06d..a98377f2a8030 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/moduleparam.h>
+#include <linux/err.h>
 
 #include "glob.h"
 #include "oplock.h"
@@ -19,6 +20,20 @@
 static LIST_HEAD(lease_table_list);
 static DEFINE_RWLOCK(lease_list_lock);
 
+#define SMB2_LEASE_STATE_MASK_LE	(SMB2_LEASE_READ_CACHING_LE | \
+					 SMB2_LEASE_HANDLE_CACHING_LE | \
+					 SMB2_LEASE_WRITE_CACHING_LE)
+
+static bool lease_state_valid(__le32 state)
+{
+	return !(state & ~SMB2_LEASE_STATE_MASK_LE);
+}
+
+static bool lease_v2_flags_valid(__le32 flags)
+{
+	return !(flags & ~SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE);
+}
+
 /**
  * alloc_opinfo() - allocate a new opinfo object for oplock info
  * @work:	smb work
@@ -1568,12 +1583,14 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 	struct lease_ctx_info *lreq;
 
 	cc = smb2_find_context_vals(req, SMB2_CREATE_REQUEST_LEASE, 4);
-	if (IS_ERR_OR_NULL(cc))
+	if (IS_ERR(cc))
+		return ERR_CAST(cc);
+	if (!cc)
 		return NULL;
 
 	lreq = kzalloc(sizeof(struct lease_ctx_info), KSMBD_DEFAULT_GFP);
 	if (!lreq)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
@@ -1587,11 +1604,14 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->epoch = lc->lcontext.Epoch;
 		lreq->duration = lc->lcontext.LeaseDuration;
+		if (!lease_state_valid(lreq->req_state) ||
+		    !lease_v2_flags_valid(lreq->flags))
+			goto err_out;
 		if (lreq->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
 			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
 			       SMB2_LEASE_KEY_SIZE);
 		lreq->version = 2;
-	} else {
+	} else if (sizeof(struct lease_context) == le32_to_cpu(cc->DataLength)) {
 		struct create_lease *lc = (struct create_lease *)cc;
 
 		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
@@ -1602,12 +1622,15 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->duration = lc->lcontext.LeaseDuration;
+		if (!lease_state_valid(lreq->req_state))
+			goto err_out;
 		lreq->version = 1;
-	}
+	} else
+		goto err_out;
 	return lreq;
 err_out:
 	kfree(lreq);
-	return NULL;
+	return ERR_PTR(-EINVAL);
 }
 
 /**
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 475aac9ffc778..e194957e2c6e4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3004,6 +3004,17 @@ int smb2_open(struct ksmbd_work *work)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE &&
 	    req->CreateContextsOffset) {
 		lc = parse_lease_state(req);
+		if (IS_ERR(lc)) {
+			rc = PTR_ERR(lc);
+			lc = NULL;
+			goto err_out2;
+		}
+		if (lc && lc->version == 2 && conn->dialect < SMB30_PROT_ID) {
+			kfree(lc);
+			lc = NULL;
+			if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
+				req_op_level = SMB2_OPLOCK_LEVEL_NONE;
+		}
 		rc = parse_durable_handle_context(work, req, lc, &dh_info);
 		if (rc) {
 			ksmbd_debug(SMB, "error parsing durable handle context\n");
@@ -3035,8 +3046,19 @@ int smb2_open(struct ksmbd_work *work)
 
 			goto reconnected_fp;
 		}
-	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
+	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
 		lc = parse_lease_state(req);
+		if (IS_ERR(lc)) {
+			rc = PTR_ERR(lc);
+			lc = NULL;
+			goto err_out2;
+		}
+		if (lc && lc->version == 2 && conn->dialect < SMB30_PROT_ID) {
+			kfree(lc);
+			lc = NULL;
+			req_op_level = SMB2_OPLOCK_LEVEL_NONE;
+		}
+	}
 
 	if (le32_to_cpu(req->ImpersonationLevel) > le32_to_cpu(IL_DELEGATE)) {
 		pr_err("Invalid impersonationlevel : 0x%x\n",
-- 
2.53.0



