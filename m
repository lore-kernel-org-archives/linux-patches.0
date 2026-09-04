Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A68840BCD4;
	Fri,  4 Sep 2026 05:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501292; cv=none; b=EBmJuBBmiNQjfVl6XnYX9iX+bj113la5/qjnNin3czxC/sXIjiMgPIyHvhbzgp5WT4Bw5wh71qmQXm0wv0tvlQ68j21NOMzOKskCPCFgwL9huI+YhJaKAx59vxiTAL7swQopMtRYytkTtiYPJ077QROqExPrAPu9uVuXe+FCdZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501292; c=relaxed/simple;
	bh=dPDzRhygKH4wzLvck2yJuJn3YsUy2nAqSIK5R+BegS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL2qmd6jpD9mX2nlrzSYZotdXssrCWD9T40Q4fwpa6h26VcIdap8uYWTZYha5OBU/q+WTeJZCwwdDAXTAMsqcLtZWd3LqAfzmwwJOLyIzbAYnCdaOJ3nSZ4lxbKt3drL8dwXj8jVgxfuiiPQwwDn7EzD4ogJsb/Fa9WGXNubvu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVX/cx3q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVX/cx3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61061F00A3D;
	Fri,  4 Sep 2026 05:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501291;
	bh=Dmo7G/fKiXnrnZd4QaBOxgkhknqZXZnwc749is7g7Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVX/cx3qrViQs2oAKvR8uotGsLEN9Mo/u9l0E3P/643LqmEiv9ZEf+4eE3q+DHUXP
	 mjjGDYhkEVdwSbeRI8bup704lgqwLFRo6kuYzPq2z7Cm2lwcsApGnR/9gMaLp5AudL
	 ce/Yw6amYT/Uv2rq/A3VLu4xvs6Ukbz+8sWMPqZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 359/552] nvme-tcp: fix host memory disclosure on R2T for a read command
Date: Fri,  4 Sep 2026 06:58:36 +0200
Message-ID: <20260904045758.376966106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -756,6 +756,13 @@ static int nvme_tcp_handle_r2t(struct nv
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


