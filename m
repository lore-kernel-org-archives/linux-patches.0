Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B01265CA7;
	Mon,  1 Dec 2025 11:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588761; cv=none; b=tWpgHEwIlXRP/hF2CFVwHp7hAf4GXyVTBeYfUxd2S+UXsTs77eKFv+2qsrVUB/+fhXvOpoMrS5desdEL4gbiZByQBmD1o2VvFzJOpDdvAEnnalqZyqi9u7a1ivR8T6lSOwW1Fgo6A+ZS6+erqgWVZOY2aXAq7amKlWHFTslXNdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588761; c=relaxed/simple;
	bh=LrZKPhNuXyy3HUieFVgu8UCpOLlJAZHDezlywAfVH44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmCEqF4Rq00/N2n0KxrX/8eRzSbQ58rHdZY8VRgdrFY0IhMHemfvmlcIIwocxRR0Gdyo5rY3s15Rau9qDeXMO9DhIa76l3wD6F5JN2qbRAiJtUfGBIsy5RUb5ZoWdu0apci1LzmLdNhA2HkQNcFuBqsNqzFJR8tl8nFffqqMNKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwVHWfyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwVHWfyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EEDC4CEF1;
	Mon,  1 Dec 2025 11:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588760;
	bh=LrZKPhNuXyy3HUieFVgu8UCpOLlJAZHDezlywAfVH44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwVHWfyX94HElHKo3Sc+W1zuOVA303cHhlroNEEEmHAFK1ZNmZszlIJ7dmwqeS05H
	 N62pVqxQK5PgQlDrTG8ixpNeVjde9ohaEPJ2T2AXnFPfLoSP2xUOnnx8YB+TYGXkjZ
	 7byXDQswB+a44yMIzYOa54/jb28szzkr07KU1shc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c01f8e6e73f20459912e@syzkaller.appspotmail.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 162/187] scsi: sg: Do not sleep in atomic context
Date: Mon,  1 Dec 2025 12:24:30 +0100
Message-ID: <20251201112247.066489320@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2214,9 +2214,17 @@ sg_remove_sfp_usercontext(struct work_st
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
 


