Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B58A2F0035;
	Thu,  3 Jul 2025 15:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555878; cv=none; b=TAXQ1zY1zH++REGbEzt6MzYYwAufzxIrioFv5ztYmUxhwoBOgV5DZW/fab3yOmfngteRYdw7OU0i4Bzytw9j18fe7W9FvrX0HxlFOSNfDQRWRlwiqbbKH/ZA6FgSGMnhXiaKAm7W4BE87i/qXRKWNxklyPD+Trg3uxv89zRW26s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555878; c=relaxed/simple;
	bh=aPPhuRp9qLU2zp0HullSm1VvzIRUn2d7rtzM8x5BRmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VS8R0G71Rk4QO5i20BNZRjQtC6FPPjTG0QQtmGHSpZggcA7jiz8k7uJNugcBseGnZuE7PBC56iCs6J6/tOMdVfZjMkq+GAdbcHja8YT60QMqOobF4fOcQ4+fV/eYnaGEQMZteTYKPXJH/YoBWauAPKo/22cNedxsh8EwCIDX26k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usLCEkGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usLCEkGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EC3C4CEE3;
	Thu,  3 Jul 2025 15:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555878;
	bh=aPPhuRp9qLU2zp0HullSm1VvzIRUn2d7rtzM8x5BRmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usLCEkGPAXTiVsjRPFxoemRfnByE+uzKbTIYYVZk/c06hteJb+83cqKQsaO4DvXcN
	 NpSjGOszIedik/Q6S7ISN/6dAa0gwh1NOpEG/hWWPtZmyADB2CzJmX5alQ0X2ZXEN5
	 sM2srs1p3hHhwaDP8xpYSgrUBAs53kg1t8wrDI0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 137/139] nvme: always punt polled uring_cmd end_io work to task_work
Date: Thu,  3 Jul 2025 16:43:20 +0200
Message-ID: <20250703143946.536560966@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 9ce6c9875f3e995be5fd720b65835291f8a609b1 upstream.

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
 drivers/nvme/host/ioctl.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -526,16 +526,14 @@ static enum rq_end_io_ret nvme_uring_cmd
 	pdu->u.result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/*
-	 * For iopoll, complete it directly.
-	 * Otherwise, move the completion to task work.
+	 * IOPOLL could potentially complete this request directly, but
+	 * if multiple rings are polling on the same queue, then it's possible
+	 * for one ring to find completions for another ring. Punting the
+	 * completion via task_work will always direct it to the right
+	 * location, rather than potentially complete requests for ringA
+	 * under iopoll invocations from ringB.
 	 */
-	if (blk_rq_is_poll(req)) {
-		WRITE_ONCE(ioucmd->cookie, NULL);
-		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
-	} else {
-		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
-	}
-
+	io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
 	return RQ_END_IO_FREE;
 }
 


