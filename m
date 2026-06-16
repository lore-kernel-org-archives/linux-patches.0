Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818413BFE5A;
	Tue, 16 Jun 2026 18:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634185; cv=none; b=btKKSqHcqWP6ZpItQ1XB0K//vpDzWwWCdi2eC/4BJPFpmvJWP1mtb3OVLxTLkDJQAgF8UJDJUE4VTIXDz9I5yCqzvjuU07mxfNBU8k8Z1oean1RZmw3LCKxd8RAF8EuCXCymdbnDt+pHyJFrO8aIK4iPwpYb3DIRiYYw/x4wgo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634185; c=relaxed/simple;
	bh=vbNviFBeEMv7Ms8QUYvFkinwMzOFvY7BkmXhfoxn5Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqR5nwQA+Oomxw6E0QQeN9QlAI2CVXwmFeVQM+YRQYAe+CYb09TA20Jq/JPJZNmOdaBOLnapWNiOhEaRx1YHn4EFkwq/GyEJUAZRswTStcD5mNbnAfhE7W+H8XPjk+aGtGaqugulF8hCTOBczHanPy5SVvaaN+Z9tmL3X57Xb3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVDNtwtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVDNtwtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5111F000E9;
	Tue, 16 Jun 2026 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634184;
	bh=g6GfiiBohW29lAynUwjkbOe+RC6L4R+UFkYrQ2gFjYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVDNtwtz5yVZ/LvTyF74KmsT7FI64A4JMZWlMN7KyabCQzPR1b/jgrFkytByd55yL
	 5oTr2r0GBd2OSztnVGSbajtqLu7+ZqHWWtJkUyZ43aPL/qM59BjFGMJTR3PqNyyzsJ
	 nwvD0UY3Hd33jP+aPQ5zs3yxvOOgtjbq43/jYFZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 218/411] IB/isert: Reject login PDUs shorter than ISER_HEADERS_LEN
Date: Tue, 16 Jun 2026 20:27:36 +0530
Message-ID: <20260616145112.370720287@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


