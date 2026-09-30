Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6994FB9C3;
	Wed, 30 Sep 2026 17:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787798; cv=none; b=M22HHJw46xFVR5YX26dDSsRTY/e7StdE8S/CVFo7MCfhY8iRdtn7Y6o5JvhydjURWL8NnAoqf6IQulGIPdK+czTY6+zTuSRXmGldN8SHvuOLqQf6/tSx54PKsYG7eDzKSth9wHp/1e9B2i0K5+34U6peYye2dQzk7HAsAK8maOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787798; c=relaxed/simple;
	bh=K7Lv2Ziy13CTgH6ZbxyjcssYEoiSOQngtdFcvk0wBgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bC4pPWmy48TjyAQe1+iDm1IeRuHGjXXSDaViqaMCUF0BRSt9o1iYyHg0zHYpSKAo1fQ8WW2Y8r7BQEp6G+swwI3+hseyY61SCRN7HDgktTb+7rmEJBr8dVzhaQGbdq4UPIL8xBQ8ExqXbLPDQ4wtEnIauyNxirLk5N+1BoHOxfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enjOXIRn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enjOXIRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D471F000FF;
	Wed, 30 Sep 2026 17:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787797;
	bh=TmDu8sCchhwEwZvbaB0NqpSd01WRefBrl6SE3tat47o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enjOXIRnW1jGbOP9YpC2dX8/nZupHzOQ4OCs/S2ZbvMGtUAJ1k1XrAcPSgxPuDcRF
	 1qxtCkRqJi+YNGlpx0rB5kDCntPHfcGH+ek3O+AMy7/BSQcWmC7m9ajPbpO6485pv9
	 xqUpg5syGtuApuxoJGypmU/6gQztLRoG3a2YCpW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 358/457] scsi: ufs: core: Keep internal commands dispatchable during error handling
Date: Wed, 30 Sep 2026 17:27:43 +0200
Message-ID: <20260930152353.734449179@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

commit b52d695d062095327b944acf7daabbc816ab319b upstream.

Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
switched UFS internal commands to allocate requests on
hba->host->pseudo_sdev->request_queue, which shares the host tagset with
regular LUNs.

During error recovery, ufshcd_err_handling_prepare() calls
blk_mq_quiesce_tagset(&hba->host->tag_set), marking all queues in the
tagset as quiesced, including pseudo_sdev->request_queue. When
ufshcd_verify_dev_init() subsequently issues internal commands (e.g. NOP
OUT UPIU) via blk_execute_rq(), blk_mq_run_hw_queue() skips running the
quiesced queue, resulting in an unrecoverable circular wait deadlock.

Keep quiescing the tagset and unquiesce the pseudo SCSI device on top of
that, so internal commands stay dispatchable while the logical units remain
quiesced. Re-quiesce the pseudo device before unquiescing the tagset so
that quiesce_depth stays balanced.

Clock scaling and ufshcd_pause_command_processing() are unaffected: they
keep quiescing the whole tagset, internal commands included.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/6f78c4bd-a70b-402d-abfd-599091b67674@acm.org/
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260912131625.2301486-1-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6748,11 +6748,17 @@ static void ufshcd_err_handling_prepare(
 	}
 	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
 	blk_mq_quiesce_tagset(&hba->host->tag_set);
+	/*
+	 * Internal commands are submitted on the pseudo SCSI device. Let them
+	 * through so that the error handler can recover the link.
+	 */
+	blk_mq_unquiesce_queue(hba->host->pseudo_sdev->request_queue);
 	cancel_work_sync(&hba->eeh_work);
 }
 
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
+	blk_mq_quiesce_queue_nowait(hba->host->pseudo_sdev->request_queue);
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))


