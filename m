Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E934F48F;
	Wed,  3 Dec 2025 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780047; cv=none; b=F4DuRsTHImxideTElYK2IrxDm/2MCXYHBBiYhen35nQsNrNrGSxWpsvzibTe2ZUEDATVN8Bfqvb0xnZa3BaJmrz1OYvaZ1fkqrdH4U1kpS09A8F6IA+cmFGwgtmgZ1Jcxh19XRAKVxTLgjKBzb1qHeaYeofCBSvU2Sj7iTjnbqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780047; c=relaxed/simple;
	bh=lLjooOKzKUgID5LEYGptglRdVBqT58O4YJTO72CEC6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejAHwZLVszMhSNoQSnS4L8buEV85cV4z/033OuVvw3YEXk8I9N0gbvCZLdqVjErWywiL9UoopTr+oRXnF6eTkhI2adigxwY/e48QDEC2GxYcIpbzEXsEei8oClotOw6yCxSrp0ch5iW4JZTt8C1rdTHKXYjWCzOTeOoIJdaLRvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFdJCIIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFdJCIIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDB2C4CEF5;
	Wed,  3 Dec 2025 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780046;
	bh=lLjooOKzKUgID5LEYGptglRdVBqT58O4YJTO72CEC6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFdJCIIG7bbvCTjkcaCC9zYhTGPmUstpl3vuoldKTM1igzyLSNhxDJ79Wwzootx2N
	 qu57KRQmEbs3yUnQdBAZkJ/0ttBR/o+A45S6p+65U65/YrlSOIxpXoNvcaCA1DdP9l
	 sD8Ddq7Qrbsx6Tl8GplpU1irmW4jBNz8s1TzH5cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c01f8e6e73f20459912e@syzkaller.appspotmail.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 440/568] scsi: sg: Do not sleep in atomic context
Date: Wed,  3 Dec 2025 16:27:22 +0100
Message-ID: <20251203152456.811044164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2204,9 +2204,17 @@ sg_remove_sfp_usercontext(struct work_st
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
 


