Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B464BEE22;
	Sat, 12 Sep 2026 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220549; cv=none; b=Thmq/MMMzlXlCty4yMrRZ5EHHzBzCy6O7FRj13klutDEs2M21SG8bfgvWDDig0b9Qr0iTuyms8rl/Addmg+RiBvzot6+do3nc17cooYg9xRYh4KzMjE6ztfbPxbPmylo8z8jD55OOg/4uxcWNgXRTUjF3guJmkTXoOOUMRne9CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220549; c=relaxed/simple;
	bh=0sSqiWt4vL7U2KOeEiBCRi7gtrMj7mvkj/HBeGEMHYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHduicZcrY4sKtgd6YCUTNKPNRIaFw/rhwOJRmBfzPw8ccxqeN9YRF7pGRJoK7j09lHjbR8VPB6ibrkSDeDaG2V2NdTBp03JYZE+Ky4pW82OwkpKcIVeOHKPqkbqljSae+FA3XdYjUB5hv7a2wGh6V79uPuBfvyCnzSrAnuI8Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oM/Xwjr3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oM/Xwjr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438D81F000FF;
	Sat, 12 Sep 2026 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220548;
	bh=8T+ikJ75rnCowzjVdQ63EXBolNMN/XGz6NtIVsTU7sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oM/Xwjr38iSdVtDMHfAui5nVttderUCGuBOmOa+tl9rDuEXTU7WIPgEdB04nTeGMl
	 1lX/Ln/Z9ciWxbwFvkn3Vz6N/NEz14MM5bFmAajfGNPIjnxXrwUnVK+tTEhUj4VFL+
	 dYxhmmVHw7iFlE3bEIQG+llIk2C8fFAZIOZeWC18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 0199/1424] nvme-tcp: fix host memory disclosure on R2T for a read command
Date: Sat, 12 Sep 2026 08:43:51 +0200
Message-ID: <20260912065611.748480481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 6efbc52237facda35d2d874fe1765bb4839275d8 upstream.

nvme_tcp_handle_r2t() does not check the direction of the request the
R2T refers to. A malicious controller can send an R2T for a READ and
the host will answer it: nvme_tcp_setup_h2c_data_pdu() builds the
H2CData header and nvme_tcp_try_send_data() sends the request's data
buffer. That buffer is the READ destination, so its contents go to the
controller.

The command then completes normally and nothing is logged.

Against a test controller that answers every READ with an R2T, a 4096
byte buffered read returned all 4096 bytes, split over two R2Ts. The
pages contained stale kernel data, including an array of struct page
pointers.

Reject an R2T for a request that is not a write.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -677,6 +677,13 @@ static int nvme_tcp_handle_r2t(struct nv
 	}
 	req = blk_mq_rq_to_pdu(rq);
 
+	if (unlikely(rq_data_dir(rq) != WRITE)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d unexpected r2t for a non-write command\n",
+			rq->tag);
+		return -EPROTO;
+	}
+
 	if (unlikely(!r2t_length)) {
 		dev_err(queue->ctrl->ctrl.device,
 			"req %d r2t len is %u, probably a bug...\n",


