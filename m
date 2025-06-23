Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2C8B676;
	Mon, 23 Jun 2025 22:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717072; cv=none; b=YsAbXrObtVBhJIOJVH5aatqOgSMBZuATHUESMSZR+gQ5DtWw9dMGleqdEdA2QmDkRS1BTUcJIidYpf10nSMTKRsDj5MSR8i2VDwsxd2BLVW1NBMzzEASbY55p/z2PJtccm3KUto2NY1OdAUzfc9lnUTrATQVn+yBJ1V5IFhrboE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717072; c=relaxed/simple;
	bh=Oj6tc0XrxoYpet6jmEotqFPC1jf+qTOpk5a0W2rpsl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfrWyD4jO/EQ3nHhWsLQ62TnBWQZaMr0oHMb2VFK/KqdtCjkAamP1FvPQl4VBTLjXUjIDWAgbsz5N/1ChdKLPbFz6J2entlDaOlBAFOUar5Cot1qTM9SFJTrv5BXiSbIH9ws/eXlTFk+9LbZYkJolcR0XFueQn84bOGDhMOJfyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16fHXXdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16fHXXdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269CFC4CEEA;
	Mon, 23 Jun 2025 22:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717072;
	bh=Oj6tc0XrxoYpet6jmEotqFPC1jf+qTOpk5a0W2rpsl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16fHXXdv1SpggsAcCGyL8ty6cqEsD+o1+GlVNKlIRt4e75WF7XCKTA5FLdEK/9WIs
	 cVdzuDRnQeoQTc4xARM7h7ad42je9q//2CAAdyyUPgHL6cnuREPWaAdvUJqa4ngplr
	 Acf7ysRCGnIjFosIJtKOKlgCbb+lxeLFOsX/a99M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 312/414] nvme: always punt polled uring_cmd end_io work to task_work
Date: Mon, 23 Jun 2025 15:07:29 +0200
Message-ID: <20250623130649.801288567@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jens Axboe <axboe@kernel.dk>

commit 9ce6c9875f3e995be5fd720b65835291f8a609b1 upstream.

Currently NVMe uring_cmd completions will complete locally, if they are
polled. This is done because those completions are always invoked from
task context. And while that is true, there's no guarantee that it's
invoked under the right ring context, or even task. If someone does
NVMe passthrough via multiple threads and with a limited number of
poll queues, then ringA may find completions from ringB. For that case,
completing the request may not be sound.

Always just punt the passthrough completions via task_work, which will
redirect the completion, if needed.

Cc: stable@vger.kernel.org
Fixes: 585079b6e425 ("nvme: wire up async polling for io passthrough commands")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/ioctl.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -442,21 +442,14 @@ static enum rq_end_io_ret nvme_uring_cmd
 	pdu->result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/*
-	 * For iopoll, complete it directly. Note that using the uring_cmd
-	 * helper for this is safe only because we check blk_rq_is_poll().
-	 * As that returns false if we're NOT on a polled queue, then it's
-	 * safe to use the polled completion helper.
-	 *
-	 * Otherwise, move the completion to task work.
+	 * IOPOLL could potentially complete this request directly, but
+	 * if multiple rings are polling on the same queue, then it's possible
+	 * for one ring to find completions for another ring. Punting the
+	 * completion via task_work will always direct it to the right
+	 * location, rather than potentially complete requests for ringA
+	 * under iopoll invocations from ringB.
 	 */
-	if (blk_rq_is_poll(req)) {
-		if (pdu->bio)
-			blk_rq_unmap_user(pdu->bio);
-		io_uring_cmd_iopoll_done(ioucmd, pdu->result, pdu->status);
-	} else {
-		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
-	}
-
+	io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
 	return RQ_END_IO_FREE;
 }
 


