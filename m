Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7359D2EFD81;
	Thu,  3 Jul 2025 15:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556296; cv=none; b=Yx4YZO/8k41zDfvSAlX4gJuHGtPWJnm1YQ3gqIQ5oWOxXty1jcsFWjoRp8ftwN4Bs4b0CIxJ7JcOwljclxTtklbfJGti1GapfCifJlAVwkuHupsau7SWhhaOpVhcpJZ2Ba3v+YBIDpdmjA+OfF6QkL4RFNNRz9exR6ra+vyUvXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556296; c=relaxed/simple;
	bh=fo4HwQu/2dWH6kghTtuvZTNxAPChhAs9JfcnQCmxeDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sF7UvzRBO5WpEg0eQ5V8oQYO+Xn8sdmxk409LVFMJfVQAVVKhZSojOUS6mlU+0VVueeDA5hkOwlggmr9wZOQkzEdmqa5L2I8EuHMZ1tABA3Wq0OJxUJj9i3Prilzwh/bbzh+jSTVAQPVEFLxJ9/Y5wYH8InRPuHtM1dDWZDkWr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2gpRoHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2gpRoHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF5BC4CEED;
	Thu,  3 Jul 2025 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556296;
	bh=fo4HwQu/2dWH6kghTtuvZTNxAPChhAs9JfcnQCmxeDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2gpRoHlMfW0jWenDZ8g0B6aQZhFS8v9yMArYGcS7kU49O33bht8bt3kkh7CTY9Ri
	 FKfN03mD+jj/Y4LHsfdBAFQuz/PzB8bLhp26vN2SfJqL3MqpkIVXp1z4po/NKkY7Bd
	 cqtwIn8YcsRX90UIDvn5Rx3/gCAITsYnUNfpjBfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 128/132] nvme: always punt polled uring_cmd end_io work to task_work
Date: Thu,  3 Jul 2025 16:43:37 +0200
Message-ID: <20250703143944.415114175@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/nvme/host/ioctl.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -438,7 +438,6 @@ static enum rq_end_io_ret nvme_uring_cmd
 {
 	struct io_uring_cmd *ioucmd = req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-	void *cookie = READ_ONCE(ioucmd->cookie);
 
 	req->bio = pdu->bio;
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED) {
@@ -451,14 +450,14 @@ static enum rq_end_io_ret nvme_uring_cmd
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
-	if (cookie != NULL && blk_rq_is_poll(req))
-		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
-	else
-		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
-
+	io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 	return RQ_END_IO_FREE;
 }
 


