Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E924F7CBF;
	Wed, 30 Sep 2026 17:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787946; cv=none; b=PAapAaJJ9I4t6xOwDMoUiBGZDOk+yWaKIuNcWz+l/wDCgCvqRLbxZQX+yCZgvcMtkJsUv994NVnJd3SsGNEgvHgQ6nJeumsUD28yfxEEKkYZ21cvtSXWaZ5rBP66Vnej2PhVhKPaHGrp1DtE1UzZDicPNLjW0JTJTdHmQWgxtGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787946; c=relaxed/simple;
	bh=15Q+D3DQ7/vgpcTHNgXiyFy/aRSjtBmyugiPe5QnAxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVtT3nihJXIonTTUX+VsJ3GlVGhu3JGWz0JWn+zzSpffH5cWb7F3yV08YXZVS+57VVvfYItodc7ajbpttRzWjnpLRObN09inBZgqYm+F2ikC7FarTse+KxwPCz0YVlhHiWKFOmbmKPg4R693wMZTbcAgZHd0rQWkn/o1Gd79CYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuhVBG+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuhVBG+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011DE1F000FF;
	Wed, 30 Sep 2026 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787944;
	bh=kgsQdEitqbDNkvnk1CqDUUw67DKrv97RxnNPi7hUPGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuhVBG+x30K89SntgyWr0dOxX6KU1kK9lzO7an40rRRABcEVvr+HVur24p9LejMrP
	 U1W7lVsQe5FxjHZotOXMDWoiz7rB/UXhhX+MJUITZ3iEFhbl7LnlAcvc5Af9lpausI
	 WrgEDZV26mvIrkDwZhCdDbNsg6kYYlaca38CO6+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 410/457] smb: client: clean up failed cached directory opens
Date: Wed, 30 Sep 2026 17:28:35 +0200
Message-ID: <20260930152354.839454479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit d2ff5fb93ea83034025850266b5eed391f96b825 upstream.

open_cached_dir() sends CREATE and QUERY_INFO as a compound request. If
the CREATE succeeds but a later command returns an error, the function
must retain the CREATE FID so common cleanup can issue SMB2_close(). It
also must not treat a response error as a valid CREATE.

Validate the CREATE response before using its fields, record the FIDs, and
mark the handle open before handling errors from later compound commands.
Move the -EREMCHG reconnect handling before response validation so a
missing response does not hide the reconnect request. Count the handle
when it is marked open; confirmed close responses decrement the counter,
while existing close retry behavior remains best effort on transport
failures.

Fixes: b0f6df737a1c ("cifs: cache FILE_ALL_INFO for the shared root handle")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -8,6 +8,7 @@
 #include <linux/namei.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
+#include "../common/smb2status.h"
 #include "cifs_debug.h"
 #include "smb2proto.h"
 #include "cached_dir.h"
@@ -323,25 +324,37 @@ replay_again:
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
-	if (rc) {
-		if (rc == -EREMCHG) {
-			tcon->need_reconnect = true;
-			pr_warn_once("server share %s deleted\n",
-				     tcon->tree_name);
-		}
-		goto oshr_free;
+	if (rc == -EREMCHG) {
+		tcon->need_reconnect = true;
+		pr_warn_once("server share %s deleted\n",
+			     tcon->tree_name);
 	}
-	cfid->is_open = true;
 
-	spin_lock(&cfids->cfid_list_lock);
+	if (!rsp_iov[0].iov_base || rsp_iov[0].iov_len < sizeof(*o_rsp)) {
+		if (!rc)
+			rc = -EIO;
+		goto oshr_free;
+	}
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
+	if (o_rsp->hdr.Status != STATUS_SUCCESS) {
+		if (!rc)
+			rc = -EIO;
+		goto oshr_free;
+	}
+
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
+	cfid->is_open = true;
+	atomic_inc(&tcon->num_remote_opens);
 
+	if (rc)
+		goto oshr_free;
+
+	spin_lock(&cfids->cfid_list_lock);
 
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
 		spin_unlock(&cfids->cfid_list_lock);
@@ -408,7 +421,6 @@ out:
 		close_cached_dir(cfid);
 	} else {
 		*ret_cfid = cfid;
-		atomic_inc(&tcon->num_remote_opens);
 	}
 	kfree(utf16_path);
 


