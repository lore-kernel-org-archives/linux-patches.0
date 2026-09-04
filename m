Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B9C351C04;
	Fri,  4 Sep 2026 05:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499653; cv=none; b=jSLYQiJ/+d8p3i1nZUXHJWWDVZSQFII8yRdC9+wsOci9NMpkY4nX/QWUXd8EDFf+gTi9hlm0iCviqNVOdsMCxrhyHmF3lWgGAz+QQkvZSavyhb18x+EuDoL3ut5Ft/VdpFMW8P8JCTWDjgNQOfsUXlepK1MuEAZoA69l5nI4FqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499653; c=relaxed/simple;
	bh=koWUoF8H5Pc3V7zvxn/DpfOP+ZJ+EgBSu05nbEZ1BIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuAoQGKM91Aq/+G00gZIqZnqhveGreL3gsaGzexliIaN9jT52qkKZ5vL1piAvRPqsuh2I5LFpQ3833EJWXEbNmzdqiWK+N3ML47aSrf4SaZ5PW++Aq7jOuP7mIVFk1tf87/GnB4WgXkpZ0Bm6dTgovvsAV6AJw3Hz4L6kqc5lf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsvtgnf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsvtgnf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C591F00A3D;
	Fri,  4 Sep 2026 05:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499652;
	bh=ib7qs2nfmA1ACkIZxCV7TMPJ7OY2c/ReUB7xlw6WTUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qsvtgnf6f/FSq7pb6K0u0eO3BJFLHnDBfga/PZYMofI4AOlFAJSTy/BB7ATmZh2u+
	 wHyKRm8P2OLM3bz4b26yU7qwzZnLZSYTgfJ1s8Si9UcrU87bk2P4U6M+7guaWF+MHj
	 tEyvHmX5g0ZxnrtTnMVivAEAl4YR4y3n8X3Y2waI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 491/713] nvme-tcp: fix host memory disclosure on R2T for a read command
Date: Fri,  4 Sep 2026 06:57:39 +0200
Message-ID: <20260904045814.833369349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -750,6 +750,13 @@ static int nvme_tcp_handle_r2t(struct nv
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


