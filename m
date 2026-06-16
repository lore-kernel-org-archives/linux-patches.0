Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F5547B41C;
	Tue, 16 Jun 2026 17:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629637; cv=none; b=eRDJ+sW3YH552fKsubWXelXtiRRYlBgK3bzQ5+SvKMNcLHY0jCS0XbIfCVGrvwm7jZw3sXCW3efF6A7wSYcky/ktGyBM4VBDROdQcjWEjA+IvGI0P4bboNGNPL7tsUfeG2zoNRfL9mDQ95WnpTYkkuGSK3uNlMx11brZkv/mbRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629637; c=relaxed/simple;
	bh=w/U7n2fm9rvwR/Ti92IZAYu6pqFg6AxJp9GLm80Gsdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrmeEu4GdO67JnGZRS06dJYcsU9cALhCfGbbaJ/aFQxoIaJsSgr8C8W4JVtVRyb0sBHlR7/RrvZQjmxZn/SmaFbC1rPtJ9VxBV1o0HhqNjMjkHdAbbBZmsNVQxSjXC+pX/+uA6+HkseJIc9BvLrvmyYCb7f4trc17Y9iC0sJ9PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6HKwPsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6HKwPsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA3D1F000E9;
	Tue, 16 Jun 2026 17:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629636;
	bh=ikILd5nwif8GtJfXWRsuS1TjIwQrMxntEsI3WhwOavI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6HKwPszRTmx0GlNl7Zwhnb2S8EUlT0snUEyMXXJUtzXrfSeIzIoLZMBUs3DOmCLo
	 npcOBFOgVmX/IBg//+Y3n+0lGI/xxRrBMQ0NLQsaYrXVDqpOEBUtyEBUERxv0QM5Mg
	 2Kqg4AkGascNOcGk0IEx0A2EEU6tVjxVoSKYAkkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 323/452] IB/isert: Reject login PDUs shorter than ISER_HEADERS_LEN
Date: Tue, 16 Jun 2026 20:29:10 +0530
Message-ID: <20260616145134.400163691@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 29e7b925ae6df64894e82ab6419994dc25580a8a upstream.

In drivers/infiniband/ulp/isert/ib_isert.c, isert_login_recv_done()
computes the login request payload length as wc->byte_len minus
ISER_HEADERS_LEN with no lower bound, and login_req_len is a signed int.
A remote iSER initiator can post a login Send work request carrying
fewer than ISER_HEADERS_LEN (76) bytes, so the subtraction underflows
and login_req_len becomes negative.

isert_rx_login_req() then reads that negative length back into a signed
int, takes size = min(rx_buflen, MAX_KEY_VALUE_PAIRS), and because the
min() is signed it keeps the negative value; the value is then passed as
the memcpy() length and sign-extended to a multi-gigabyte size_t. The
copy into the 8192-byte login->req_buf runs far out of bounds and
faults, crashing the target node. The login phase precedes iSCSI
authentication, so no credentials are required to reach this path.

Reject any login PDU shorter than ISER_HEADERS_LEN before the
subtraction, mirroring the existing early return on a failed work
completion, so login_req_len can never go negative. The upper bound was
already safe: a posted login buffer cannot deliver more than
ISER_RX_PAYLOAD_SIZE, so the difference stays at or below
MAX_KEY_VALUE_PAIRS and the existing min() clamps it; only the missing
lower bound needs to be added.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Link: https://patch.msgid.link/r/20260602194642.2273217-1-michael.bommarito@gmail.com
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1388,6 +1388,12 @@ isert_login_recv_done(struct ib_cq *cq,
 	ib_dma_sync_single_for_cpu(ib_dev, isert_conn->login_desc->dma_addr,
 			ISER_RX_SIZE, DMA_FROM_DEVICE);
 
+	if (unlikely(wc->byte_len < ISER_HEADERS_LEN)) {
+		isert_dbg("login request length %u is too short\n",
+			  wc->byte_len);
+		return;
+	}
+
 	isert_conn->login_req_len = wc->byte_len - ISER_HEADERS_LEN;
 
 	if (isert_conn->conn) {


