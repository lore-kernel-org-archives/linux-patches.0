Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B6027A462;
	Thu, 15 Jan 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498789; cv=none; b=lAnMTG0tGALHvdiDnkaxLutg3us7BiUWSqJcLlL8ObORZpmwzuQ1pCJdVXvyDtDUW4VMndntI7xl0hN8AEWY4f/2jeI1Y65oTBHm+fDjj4E2a+8KJUSZv4PdWW1UJz2EShZG4HNGWMxhwQ4Dm75Ko0z3Sm2dsbVUNEocoeq6gJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498789; c=relaxed/simple;
	bh=LkvJHMO5tsJf5+1OUBz+rXAlfaVNh/jaAsPbPBAtxDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPu2A731iNWL06nHg7WU2Z2RECqWFHSjNrEQpJ/LGFOgfsNAS6dFO9RFxYujifhEgOpVG5VYux0s94/XUTZ5MI/9SEMkJXTZFHED2/F87HZ29Te2sWyIETOXmFHLfNrCcjbQCGb0xOREuTCP/eLzV4RmTQQ7P+wVTjtYN0LQCTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGczjbq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGczjbq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D11CC19422;
	Thu, 15 Jan 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498789;
	bh=LkvJHMO5tsJf5+1OUBz+rXAlfaVNh/jaAsPbPBAtxDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGczjbq0M4iFeswvSzJYV+S95/RwNdlwP2plC6iThCHljokY79I/qMeS62/n2RGN6
	 Hvq1aP1N9FXjm1zVyTx72hJSBcv/AxPuYhi05zsjBwtnyDQG76uaJiKDKnI6Hs0hD0
	 H+dz+rNHdf1qRHH36395FA14aOrRqAJrJ/HDmi4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20R=C3=A1bek?= <mrabek@redhat.com>,
	Tomas Henzl <thenzl@redhat.com>,
	Changhui Zhong <czhong@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 554/554] scsi: sg: Fix occasional bogus elapsed time that exceeds timeout
Date: Thu, 15 Jan 2026 17:50:20 +0100
Message-ID: <20260115164306.382356079@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Rábek <mrabek@redhat.com>

[ Upstream commit 0e1677654259a2f3ccf728de1edde922a3c4ba57 ]

A race condition was found in sg_proc_debug_helper(). It was observed on
a system using an IBM LTO-9 SAS Tape Drive (ULTRIUM-TD9) and monitoring
/proc/scsi/sg/debug every second. A very large elapsed time would
sometimes appear. This is caused by two race conditions.

We reproduced the issue with an IBM ULTRIUM-HH9 tape drive on an x86_64
architecture. A patched kernel was built, and the race condition could
not be observed anymore after the application of this patch. A
reproducer C program utilising the scsi_debug module was also built by
Changhui Zhong and can be viewed here:

https://github.com/MichaelRabek/linux-tests/blob/master/drivers/scsi/sg/sg_race_trigger.c

The first race happens between the reading of hp->duration in
sg_proc_debug_helper() and request completion in sg_rq_end_io().  The
hp->duration member variable may hold either of two types of
information:

 #1 - The start time of the request. This value is present while
      the request is not yet finished.

 #2 - The total execution time of the request (end_time - start_time).

If sg_proc_debug_helper() executes *after* the value of hp->duration was
changed from #1 to #2, but *before* srp->done is set to 1 in
sg_rq_end_io(), a fresh timestamp is taken in the else branch, and the
elapsed time (value type #2) is subtracted from a timestamp, which
cannot yield a valid elapsed time (which is a type #2 value as well).

To fix this issue, the value of hp->duration must change under the
protection of the sfp->rq_list_lock in sg_rq_end_io().  Since
sg_proc_debug_helper() takes this read lock, the change to srp->done and
srp->header.duration will happen atomically from the perspective of
sg_proc_debug_helper() and the race condition is thus eliminated.

The second race condition happens between sg_proc_debug_helper() and
sg_new_write(). Even though hp->duration is set to the current time
stamp in sg_add_request() under the write lock's protection, it gets
overwritten by a call to get_sg_io_hdr(), which calls copy_from_user()
to copy struct sg_io_hdr from userspace into kernel space. hp->duration
is set to the start time again in sg_common_write(). If
sg_proc_debug_helper() is called between these two calls, an arbitrary
value set by userspace (usually zero) is used to compute the elapsed
time.

To fix this issue, hp->duration must be set to the current timestamp
again after get_sg_io_hdr() returns successfully. A small race window
still exists between get_sg_io_hdr() and setting hp->duration, but this
window is only a few instructions wide and does not result in observable
issues in practice, as confirmed by testing.

Additionally, we fix the format specifier from %d to %u for printing
unsigned int values in sg_proc_debug_helper().

Signed-off-by: Michal Rábek <mrabek@redhat.com>
Suggested-by: Tomas Henzl <thenzl@redhat.com>
Tested-by: Changhui Zhong <czhong@redhat.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Link: https://patch.msgid.link/20251212160900.64924-1-mrabek@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4d54f2697bb4e..d74bb7b42de89 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -736,6 +736,8 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
+	hp->duration = jiffies_to_msecs(jiffies);
+
 	if (hp->interface_id != 'S') {
 		sg_remove_request(sfp, srp);
 		return -ENOSYS;
@@ -821,7 +823,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		return -ENODEV;
 	}
 
-	hp->duration = jiffies_to_msecs(jiffies);
 	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
 	    (SG_FLAG_Q_AT_TAIL & hp->flags))
 		at_head = 0;
@@ -1343,9 +1344,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 				      "sg_cmd_done: pack_id=%d, res=0x%x\n",
 				      srp->header.pack_id, result));
 	srp->header.resid = resid;
-	ms = jiffies_to_msecs(jiffies);
-	srp->header.duration = (ms > srp->header.duration) ?
-				(ms - srp->header.duration) : 0;
 	if (0 != result) {
 		struct scsi_sense_hdr sshdr;
 
@@ -1395,6 +1393,9 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			done = 0;
 	}
 	srp->done = done;
+	ms = jiffies_to_msecs(jiffies);
+	srp->header.duration = (ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (likely(done)) {
@@ -2523,6 +2524,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 	const sg_io_hdr_t *hp;
 	const char * cp;
 	unsigned int ms;
+	unsigned int duration;
 
 	k = 0;
 	list_for_each_entry(fp, &sdp->sfds, sfd_siblings) {
@@ -2560,13 +2562,17 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 			seq_printf(s, " id=%d blen=%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)
-				seq_printf(s, " dur=%d", hp->duration);
+				seq_printf(s, " dur=%u", hp->duration);
 			else {
 				ms = jiffies_to_msecs(jiffies);
-				seq_printf(s, " t_o/elap=%d/%d",
+				duration = READ_ONCE(hp->duration);
+				if (duration)
+					duration = (ms > duration ?
+						    ms - duration : 0);
+				seq_printf(s, " t_o/elap=%u/%u",
 					(new_interface ? hp->timeout :
 						  jiffies_to_msecs(fp->timeout)),
-					(ms > hp->duration ? ms - hp->duration : 0));
+					duration);
 			}
 			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
 				   (int) srp->data.cmd_opcode);
-- 
2.51.0



