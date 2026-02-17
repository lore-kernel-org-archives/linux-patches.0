Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234F3284B3B;
	Tue, 17 Feb 2026 20:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361413; cv=none; b=VXaX7DJplUYYYWWnOUrRuyki3pVwABAkqX18ZJgVEkijufQz58yAd3lSzM4t0adcQCvpflQ3XhAkpadoY9gvxcTNZr695vZT4Xlc/AtLDmMKSVfJNoahF/qR6AfVXbD5PJAPn4fKVGyuI1mXnerWviHkXzadvfbBGrPFr03r+Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361413; c=relaxed/simple;
	bh=98jNaeX6WtI0E9SUA/uZX45wHWx4sKEZthzPgXjE5l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc5qbEGwdnQRx8OcbGCc1jElU1ieSlMuWWcmlrPy1LAR5FUM97Jv+UkTM4+1zS/SfANEG0ScqOYOHTbQMcyVffPc8289R1D8fWW0COvfyBUEm3Lk+7io7hZuHLS2QHmivNzXmoD5w5d4DUkBO8cCpo+V2yNOh7LLkIKQiKediO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkTE0RvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkTE0RvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F21DC19421;
	Tue, 17 Feb 2026 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361413;
	bh=98jNaeX6WtI0E9SUA/uZX45wHWx4sKEZthzPgXjE5l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkTE0RvKKQxQaM+pgI06FkUH2HEUDDZkwvp6594FT22e+Ly6+xtYdcu2OhnLMKCqa
	 jQ8pejYx2yRsuncozW0W9+fK32y14XW0wq8gK1U0J6aeaq9Xm1bRAKV00OrTjDGZyK
	 Et5k5266KwnN1dJnIkxCJeW7CzERXzO4V8GaLwOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Gurumurthy <agurumurthy@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 01/43] scsi: qla2xxx: Fix bsg_done() causing double free
Date: Tue, 17 Feb 2026 21:31:41 +0100
Message-ID: <20260217200006.528683692@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

From: Anil Gurumurthy <agurumurthy@marvell.com>

commit c2c68225b1456f4d0d393b5a8778d51bb0d5b1d0 upstream.

Kernel panic observed on system,

[5353358.825191] BUG: unable to handle page fault for address: ff5f5e897b024000
[5353358.825194] #PF: supervisor write access in kernel mode
[5353358.825195] #PF: error_code(0x0002) - not-present page
[5353358.825196] PGD 100006067 P4D 0
[5353358.825198] Oops: 0002 [#1] PREEMPT SMP NOPTI
[5353358.825200] CPU: 5 PID: 2132085 Comm: qlafwupdate.sub Kdump: loaded Tainted: G        W    L    -------  ---  5.14.0-503.34.1.el9_5.x86_64 #1
[5353358.825203] Hardware name: HPE ProLiant DL360 Gen11/ProLiant DL360 Gen11, BIOS 2.44 01/17/2025
[5353358.825204] RIP: 0010:memcpy_erms+0x6/0x10
[5353358.825211] RSP: 0018:ff591da8f4f6b710 EFLAGS: 00010246
[5353358.825212] RAX: ff5f5e897b024000 RBX: 0000000000007090 RCX: 0000000000001000
[5353358.825213] RDX: 0000000000001000 RSI: ff591da8f4fed090 RDI: ff5f5e897b024000
[5353358.825214] RBP: 0000000000010000 R08: ff5f5e897b024000 R09: 0000000000000000
[5353358.825215] R10: ff46cf8c40517000 R11: 0000000000000001 R12: 0000000000008090
[5353358.825216] R13: ff591da8f4f6b720 R14: 0000000000001000 R15: 0000000000000000
[5353358.825218] FS:  00007f1e88d47740(0000) GS:ff46cf935f940000(0000) knlGS:0000000000000000
[5353358.825219] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[5353358.825220] CR2: ff5f5e897b024000 CR3: 0000000231532004 CR4: 0000000000771ef0
[5353358.825221] PKRU: 55555554
[5353358.825222] Call Trace:
[5353358.825223]  <TASK>
[5353358.825224]  ? show_trace_log_lvl+0x1c4/0x2df
[5353358.825229]  ? show_trace_log_lvl+0x1c4/0x2df
[5353358.825232]  ? sg_copy_buffer+0xc8/0x110
[5353358.825236]  ? __die_body.cold+0x8/0xd
[5353358.825238]  ? page_fault_oops+0x134/0x170
[5353358.825242]  ? kernelmode_fixup_or_oops+0x84/0x110
[5353358.825244]  ? exc_page_fault+0xa8/0x150
[5353358.825247]  ? asm_exc_page_fault+0x22/0x30
[5353358.825252]  ? memcpy_erms+0x6/0x10
[5353358.825253]  sg_copy_buffer+0xc8/0x110
[5353358.825259]  qla2x00_process_vendor_specific+0x652/0x1320 [qla2xxx]
[5353358.825317]  qla24xx_bsg_request+0x1b2/0x2d0 [qla2xxx]

Most routines in qla_bsg.c call bsg_done() only for success cases.
However a few invoke it for failure case as well leading to a double
free. Validate before calling bsg_done().

Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20251210101604.431868-12-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1546,8 +1546,9 @@ qla2x00_update_optrom(struct bsg_job *bs
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
 	mutex_unlock(&ha->optrom_mutex);
-	bsg_job_done(bsg_job, bsg_reply->result,
-		       bsg_reply->reply_payload_rcv_len);
+	if (!rval)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 	return rval;
 }
 
@@ -2612,8 +2613,9 @@ qla2x00_manage_host_stats(struct bsg_job
 				    sizeof(struct ql_vnd_mng_host_stats_resp));
 
 	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
-		     bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	return ret;
 }
@@ -2702,8 +2704,9 @@ qla2x00_get_host_stats(struct bsg_job *b
 							       bsg_job->reply_payload.sg_cnt,
 							       data, response_len);
 	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
-		     bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	kfree(data);
 host_stat_out:
@@ -2802,8 +2805,9 @@ reply:
 				    bsg_job->reply_payload.sg_cnt, data,
 				    response_len);
 	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
-		     bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 tgt_stat_out:
 	kfree(data);
@@ -2864,8 +2868,9 @@ qla2x00_manage_host_port(struct bsg_job
 				    bsg_job->reply_payload.sg_cnt, &rsp_data,
 				    sizeof(struct ql_vnd_mng_host_port_resp));
 	bsg_reply->result = DID_OK;
-	bsg_job_done(bsg_job, bsg_reply->result,
-		     bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
 
 	return ret;
 }
@@ -3240,7 +3245,8 @@ int qla2x00_mailbox_passthru(struct bsg_
 
 	bsg_job->reply_len = sizeof(*bsg_job->reply);
 	bsg_reply->result = DID_OK << 16;
-	bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
+	if (!ret)
+		bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
 
 	kfree(req_data);
 


