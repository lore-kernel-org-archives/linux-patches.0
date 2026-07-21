Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC50E436BC6;
	Tue, 21 Jul 2026 20:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664075; cv=none; b=c/d0GzZr3qZ9ctx8GxGBZu6xsA2xXLOHvwM+Of74MlLs5tLz3O32QiQYe8K2A0Kjjmu2uiWKQEmhhtZS/aPe2Ulb8VX76m7uKCQZS7F+aBI6RXWlI3uP8buDy7djGHXRsUnDxrNZELo5QS5OW4V0Mms+1Kz55WgrGfFuJpZpuTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664075; c=relaxed/simple;
	bh=HAqRGEcdU/R+uqW0fDn0Vs/tXCwqsMJJnJtZT1AUo+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLEOsS7SFhixCqPk4ZPmGZzX+clj/mBACX1+5Tcz+3LHxHbD2wv52QD9VCECynR4haJe68QSv0qXhdh7hqYUVgMgKTzRsb/gOin4pSH6S+wCSpXMODQe5JKUZdcDLs9DYmyGALdc/CDVaVSojOPIQbEUILw+2Lp0yudZacVqAiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=An6vF9VA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="An6vF9VA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496401F000E9;
	Tue, 21 Jul 2026 20:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664074;
	bh=AVBUuxSL2P7/L5ZwodFtJjSN0P8WG4EAiLQS44EPpGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=An6vF9VAgtf+hwlxFxF+pFEEvGE/ZTGQK/XWiS4BmHaLQR4hv/LsbytI23Vk8oHl5
	 K+obnb07lJ3lGvP8djdcW4tgBKbp55xVZ9jz+0dp4bT9IR79KyZuVFR0dkzzoG66ar
	 VjWOWCTZQQ9WY9TeYZMJOqoJ3kv8Jif8fUMdeP5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 1019/1276] scsi: xen: scsiback: Free the command tag on the TMR submit-failure path
Date: Tue, 21 Jul 2026 17:24:22 +0200
Message-ID: <20260721152508.803543039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 66aefc277ebb796ec285d550305535dc3fc0179f upstream.

scsiback_device_action() obtains a command tag in
scsiback_get_pend_req() and submits a task-management request with
target_submit_tmr(). When target_submit_tmr() fails it returns < 0 and
scsiback jumps to the err: label, which sends a response but frees
nothing, leaking the tag.

Impact: a pvSCSI guest can leak the command tags of a LUN's session,
stopping the LUN, by issuing VSCSIIF_ACT_SCSI_ABORT or RESET requests
whenever target_submit_tmr() fails.

transport_generic_free_cmd() cannot be used here. By the time
target_submit_tmr() returns an error it has already run
__target_init_cmd() (so se_cmd->cmd_kref is one, not zero), and on its
target_get_sess_cmd() error path it has freed se_cmd->se_tmr_req via
core_tmr_release_req() while leaving SCF_SCSI_TMR_CDB set and the
pointer dangling. Letting the command release run target_free_cmd_mem()
would then double-free se_tmr_req.

Use the same helper, which returns just the tag, on this path too.

Fixes: 2dbcdf33dbf6 ("xen-scsiback: Convert to percpu_ida tag allocation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260611123046.2323342-3-michael.bommarito@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-scsiback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -640,7 +640,7 @@ static void scsiback_device_action(struc
 	return;
 
 err:
-	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
+	scsiback_resp_and_free(pending_req, err);
 }
 
 /*


