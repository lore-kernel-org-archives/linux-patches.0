Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F740587A;
	Tue, 21 Jul 2026 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654890; cv=none; b=oC4XM1dqKS90E+RoFS4YQ5UskV1ahFPavVZZ4YXRu5gxYev8YAvnwpqEjR/Lxbnv/nDKyC4anvIQDJk//U1xy9QsuIOP3LXWhdvJkfc7Fb6fxwHEkDjAdMFizrgoXLCIgL0l+No/l2KGulsaHjp2rejsaCJSPVkcPRK51Kn2Pw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654890; c=relaxed/simple;
	bh=M1vcq/uTkk/5/WxzUD4kxIU39rrJyU2qgYWQVP1TBmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdG3HvXj1AF/2Ap8EkBDrEWzlpIG1ts+CxlSAI158D1hA5Pa9HXn9cFPDoKy9aQ75QVOa8LyTC79TulWLy6+Ui1PXpWRL8k/qVCtrSDJrDlY/lOB3XBZOMAGKd4eTSbe1i4+c3k9xTsup4Zb9TTcN082RTy0oqpPSGQBFCMIFT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY46b+Kj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY46b+Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A661F000E9;
	Tue, 21 Jul 2026 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654886;
	bh=N9lY/9B1wQkyfARyUTiU72i4HP1d9u81006QauUjxLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QY46b+Kjmu1kDrT9fkxtuOrXAx65P4Ni2aGU0B0CWjd3+SnJGWUmicz9EXpBXCn1h
	 JReeVXeXj3vFXPUPr8GwinXLJyks0sWlQrUGuAhvIVt8BUHgIsHJaGkt0V81C1MdxB
	 HE/ABX0B1m86w1hGmOOIxkYzTKgAAwgShZuV/nsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.1 1874/2077] scsi: xen: scsiback: Free unsubmitted command instead of double-putting it
Date: Tue, 21 Jul 2026 17:25:47 +0200
Message-ID: <20260721152636.932984543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit ca978f8a93d4d36841839bf2847d29b88c2591d6 upstream.

scsiback_get_pend_req() obtains a command tag and returns a vscsibk_pend
whose embedded se_cmd has only been memset to 0, so its cmd_kref is 0;
the se_cmd is initialised (kref_init() via target_init_cmd()) only
later, in scsiback_cmd_exec(), on the successful VSCSIIF_ACT_SCSI_CDB
path. The two error paths in scsiback_do_cmd_fn() taken before the
command is submitted -- a failed scsiback_gnttab_data_map() and an
unknown ring_req.act -- call
transport_generic_free_cmd(&pending_req->se_cmd, 0), which kref_put()s a
refcount of 0. That underflows it ("refcount_t: underflow;
use-after-free") and, as the release function is not run, leaks the
command tag.

Impact: a pvSCSI guest can leak every command tag of a LUN's session,
stopping the LUN, by submitting requests with a bad grant reference or
an unknown request type; under panic_on_warn the refcount underflow
panics the host.

Add a helper that just returns the tag with target_free_tag() and sends
the error response. It frees the tag while the v2p reference still pins
the session, and snapshots the response fields beforehand because
freeing the tag can let another ring reuse the pending_req slot.

Fixes: 2dbcdf33dbf6 ("xen-scsiback: Convert to percpu_ida tag allocation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260611123046.2323342-2-michael.bommarito@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-scsiback.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -611,6 +611,25 @@ static void scsiback_disconnect(struct v
 	xenbus_unmap_ring_vfree(info->dev, info->ring.sring);
 }
 
+/*
+ * Send the error response for a request that did not reach the target core
+ * and return its tag.  Free the tag before the response drops the v2p
+ * reference that keeps the session alive, and snapshot what the response
+ * needs since returning the tag can let the slot be reused.
+ */
+static void scsiback_resp_and_free(struct vscsibk_pend *pending_req,
+				   int32_t result)
+{
+	struct vscsibk_info *info = pending_req->info;
+	struct v2p_entry *v2p = pending_req->v2p;
+	struct se_session *se_sess = v2p->tpg->tpg_nexus->tvn_se_sess;
+	u16 rqid = pending_req->rqid;
+
+	target_free_tag(se_sess, &pending_req->se_cmd);
+	scsiback_send_response(info, NULL, result, 0, rqid);
+	kref_put(&v2p->kref, scsiback_free_translation_entry);
+}
+
 static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	enum tcm_tmreq_table act, int tag)
 {
@@ -792,9 +811,8 @@ static int scsiback_do_cmd_fn(struct vsc
 		case VSCSIIF_ACT_SCSI_CDB:
 			if (scsiback_gnttab_data_map(&ring_req, pending_req)) {
 				scsiback_fast_flush_area(pending_req);
-				scsiback_do_resp_with_sense(NULL,
-						DID_ERROR << 16, 0, pending_req);
-				transport_generic_free_cmd(&pending_req->se_cmd, 0);
+				scsiback_resp_and_free(pending_req,
+						       DID_ERROR << 16);
 			} else {
 				scsiback_cmd_exec(pending_req);
 			}
@@ -808,9 +826,7 @@ static int scsiback_do_cmd_fn(struct vsc
 			break;
 		default:
 			pr_err_ratelimited("invalid request\n");
-			scsiback_do_resp_with_sense(NULL, DID_ERROR << 16, 0,
-						    pending_req);
-			transport_generic_free_cmd(&pending_req->se_cmd, 0);
+			scsiback_resp_and_free(pending_req, DID_ERROR << 16);
 			break;
 		}
 


