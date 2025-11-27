Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5948D31281E;
	Thu, 27 Nov 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255592; cv=none; b=sOJY19Ks/GSjcZBihw/LWtxs69ijnn5JxhmsTXxtSMYJiFMWA2kcdxbGYraqAuWW5NSNFwx3IZLTnmGN+9NyZtmRUcnPxsbrM/nS2+oySDUXBgcG5bI70j3tdIHYH2kRAB36vpWfHkO1ThU4zzGOJsU7X32+woi/ER/1pxRWaXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255592; c=relaxed/simple;
	bh=Dy7v9SUh4hMk9m1oMIxEJKpj42JeNG+6y7u2LvYMuPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWQ3bvN4XOMyJoq+gTusR5mg5f6OnrEGpahRIyyx4qQnfj77iZFB5SkDBeQmhtlbZT+tEMLBHhqhntjUwo1/VYaZT89lpFaqrokyWlfQWtikx4dONZ2p6fhBOCXhIFq+cmYGtfV22k4QK67ZDdyKQLxy8QzTpXUWhAlm8mppivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAeYnm8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAeYnm8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D750EC4CEF8;
	Thu, 27 Nov 2025 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255592;
	bh=Dy7v9SUh4hMk9m1oMIxEJKpj42JeNG+6y7u2LvYMuPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAeYnm8Dzea8bwWOGOlOwrdc2ZL0ap8RD2rd7/qmS/OI2X2Vd2+O9wgjzbSJCFbwD
	 t0MrDmUv84hDKw0coVF9+Oq9X9Pk/YwKv788SdwIDsyYnu5zB5Kopjwe1DfuiaQ/9z
	 LRX2zRWSoOY8ZdyWhD1B/Bv70CxTYlN6DTJEN2zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c01f8e6e73f20459912e@syzkaller.appspotmail.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.17 046/175] scsi: sg: Do not sleep in atomic context
Date: Thu, 27 Nov 2025 15:44:59 +0100
Message-ID: <20251127144044.648583789@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 90449f2d1e1f020835cba5417234636937dd657e upstream.

sg_finish_rem_req() calls blk_rq_unmap_user(). The latter function may
sleep. Hence, call sg_finish_rem_req() with interrupts enabled instead
of disabled.

Reported-by: syzbot+c01f8e6e73f20459912e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-scsi/691560c4.a70a0220.3124cb.001a.GAE@google.com/
Cc: Hannes Reinecke <hare@suse.de>
Cc: stable@vger.kernel.org
Fixes: 97d27b0dd015 ("scsi: sg: close race condition in sg_remove_sfp_usercontext()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251113181643.1108973-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sg.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2209,9 +2209,17 @@ sg_remove_sfp_usercontext(struct work_st
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	while (!list_empty(&sfp->rq_list)) {
 		srp = list_first_entry(&sfp->rq_list, Sg_request, entry);
-		sg_finish_rem_req(srp);
 		list_del(&srp->entry);
+		write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+
+		sg_finish_rem_req(srp);
+		/*
+		 * sg_rq_end_io() uses srp->parentfp. Hence, only clear
+		 * srp->parentfp after blk_mq_free_request() has been called.
+		 */
 		srp->parentfp = NULL;
+
+		write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 


