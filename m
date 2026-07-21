Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC56D46C4CA;
	Tue, 21 Jul 2026 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654887; cv=none; b=jdp65KQU+J0bxUDC8sUc+aJdPLSwiMX4RHR3Arqm90N4OhMPqgGVqGQ2IQ/INSv9jxeP7rLFcK6PJQQYxdOTfcUt3EwG1wB1NE8m8kEHzfb8ut6eVckuFSlneIuJYakU2IYWDvu9M3te6aZxwJaboclU7Lp12hT13tsDmVyLx10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654887; c=relaxed/simple;
	bh=HhdOUcUgRRpBAZWFND7DPCmmWgFjD/KsCvrqFBO9GtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCNbS1/WbTa9SYw4HpvqxyGEp5SL7Ru15ywO+r4KgGY192v29rnm0xAfNpguL/leoNKjLcYu3odpHD4Q300rncze1g1Ht55Ei6Uws8c3rtJ3WVFWvjnPBC8AYPlzttyZOqA36n+8u05plbBRXuqWbOMKz5U89gzq8V9Fptnrkx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1H50VQS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1H50VQS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6441F00A3A;
	Tue, 21 Jul 2026 17:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654883;
	bh=DoKA1VdfENCGPEE41tpS6/iNwjGSjRe6ataShmK2x4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1H50VQS6MbJepRIDtqyDWSGzLEF2mhXhwyvx6O2cgo+TXFwhnuw9Nttn4VHlAIPad
	 uxAknSv2L7fN5dsUDL2iDPzBCqS/EjjYnejNssEQ1ieJGxVgoOWfPp8tGM8JmP2J3V
	 BkFSo7GYSg6U+PSaUDzjjkJ/gDf2Uqv5Q/ZpGnSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.1 1873/2077] scsi: xen: scsiback: Free the command tag on the TMR submit-failure path
Date: Tue, 21 Jul 2026 17:25:46 +0200
Message-ID: <20260721152636.911142160@linuxfoundation.org>
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
@@ -639,7 +639,7 @@ static void scsiback_device_action(struc
 	return;
 
 err:
-	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
+	scsiback_resp_and_free(pending_req, err);
 }
 
 /*


