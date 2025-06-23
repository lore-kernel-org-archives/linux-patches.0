Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C9C219A7A;
	Mon, 23 Jun 2025 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715210; cv=none; b=r5AYBZlczSJI7V3DWtW2LKDbigtYfSO77N9QS1eb2W8B+UorZXdRKYbLgUVLVP7L7lR9AhVIx1pHIn2D2YngFlBP6iDJSEbYnVIefEkU2wt7RqswW4DjZK6FiwzjK0f7JJYpW+66DkyhdumPnJrbz+D2kNnBpo2XAC4FkvVJg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715210; c=relaxed/simple;
	bh=omYwGHGT28UP6nhq3cH47ZYkNenkgjjBgqklWBz8tb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnGemTURRfcK2VqLsbLo2AY9XS0F/9nJAFHeUoWLn5yPHGYLgmyvMkJsQm4YyzpRmpRf495TBuxYQwN4DtWft7VCk4lxep5GCr7rYt7xG39JYUF80LCnRfYtj8XmS/Ep29JqL+tZY071MLfUOt0awy8vOrdUdLSEbNqcPlptZWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRAjdAdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRAjdAdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627DCC4CEEA;
	Mon, 23 Jun 2025 21:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715210;
	bh=omYwGHGT28UP6nhq3cH47ZYkNenkgjjBgqklWBz8tb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRAjdAdd36Xu5H5jsxh/H55lwUgNOeAQpeuEhmDkfUgjnLtT2NtglGMm5vwTkMA+8
	 Vxgb+cyCjkBTAcHViDJcfQqrZxxt7HwMUYNz8Qh5ZuXL9eqbOtpfvOEp6FC8qksaEK
	 dAIVm4GGdNWw9AkIt56/YAjq/FzzBfujfZJ6mytk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 465/592] nvme: always punt polled uring_cmd end_io work to task_work
Date: Mon, 23 Jun 2025 15:07:03 +0200
Message-ID: <20250623130711.489438767@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -429,21 +429,14 @@ static enum rq_end_io_ret nvme_uring_cmd
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
 


