Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E14643F8AC;
	Tue, 21 Jul 2026 22:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672543; cv=none; b=qvjtrK2gvG2gboobUhvh4Bjtt0ogWWd5Wdjwok5b4hW1BQ8ubw0wH78RFC7AhyrlBj1IZWCiOwm94Y7AUiEZF1V4Jm8He/zGG8yxs/jTxPUf4bwTMDC4WzEgMdX7n7ulMHx79fOvyV1GKPtVDmZNn1S4uc9lUfLKSCyjv0wft78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672543; c=relaxed/simple;
	bh=YWg0PgpR8ef/FG/pg6CMCY28hgASs9OS0AAM+EM/ku8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yi3jqwP44EiWwhwOqr38AT/QLzUmly6mStycbpxJq057A204XytKoLHl2REMk9TpchHYj0YC5AvlnJryB7KIMcTbTSf5uhYfxIA5l9CfA+XcM3bx7iNPMFyGBUJOoZe4WbYiTqGU90OAHn5aI/Vz53QP2DZ8iKOCJaESCSIuHwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn8kBKJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn8kBKJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB3E1F000E9;
	Tue, 21 Jul 2026 22:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672542;
	bh=Ftah2L8oSbpyzsbTROPxzTo8FMxoR58wQ0rpke0ZmeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kn8kBKJ15fdbzfblKcne20UvrCtRO9kZc0Q+nmhmLIlVQVxEexiEJ7QKhrjS1LNDE
	 khFm9/b0kP1NYoWSQy89+SYAUcQfc8MVZyrbAsOvg58yTtYecc3AOy7+cCER7Pr/eZ
	 dqs8UrKIxL21p0Qq5aH3a5q8IYereh1ym62uv8C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 663/843] scsi: xen: scsiback: Free unsubmitted command instead of double-putting it
Date: Tue, 21 Jul 2026 17:24:58 +0200
Message-ID: <20260721152420.974622179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -548,6 +548,25 @@ static void scsiback_disconnect(struct v
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
@@ -729,9 +748,8 @@ static int scsiback_do_cmd_fn(struct vsc
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
@@ -745,9 +763,7 @@ static int scsiback_do_cmd_fn(struct vsc
 			break;
 		default:
 			pr_err_ratelimited("invalid request\n");
-			scsiback_do_resp_with_sense(NULL, DID_ERROR << 16, 0,
-						    pending_req);
-			transport_generic_free_cmd(&pending_req->se_cmd, 0);
+			scsiback_resp_and_free(pending_req, DID_ERROR << 16);
 			break;
 		}
 


