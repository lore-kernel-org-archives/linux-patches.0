Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2486943D504;
	Tue, 16 Jun 2026 15:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624000; cv=none; b=WJDwa8MJIdhgqYkw4zzRIeBh9h5fQTtzvHWHM/EfAb4GxwBpzQRtd/cpcN6yHKRhi7mZhcwJwh3H0/1N3R8yf19A72LDC9l5Mmrm4RAwa0tt5TWH7/8DCWTwH6+19VyTYm8S7kKQr0h03phSC/yJ97nF3ZHGpyqkpKNrNn9ZJgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624000; c=relaxed/simple;
	bh=MyWVs7NFa0QqPuubOW3Og/uBAI8RtS1LpLVlyU6yXQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSLKMKVW1YqHR9npzGpvzSBs+TiLU8tZy3kxuxKtcbjbpk/4v7EyesmcKnlQW4/epkhpFjJOZXs1dEZyK4AzTd5p7/xCZJTcDoa1Fn4EQXkAdNjL3T3zPg2lTqWqk6QN53Hf0iE22KihjJp4uJQXhcp2p1XKbLLYMNTRB8tZZec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTcCQiTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTcCQiTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9B51F000E9;
	Tue, 16 Jun 2026 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623999;
	bh=sIPhXFyCzpwTXdHYXgmaWcoeNYz3rBo01rbJgzoH+I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTcCQiTz1hGhR91YLuq1hdKeV8CXEjlyNY9hvtrlwDsCaUSBOeXKVWtFSTLAQtt91
	 IeEjFNExz1ykGyyOpJaKcgABV5cJIr4OOHQnbiLL8Zwzlt5pi1/Gm1NFULhyTcsuRw
	 7gXdZaGKA6ao+QsmmYKhlgspentCcTEr8mYWWVNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 254/378] IB/isert: Reject login PDUs shorter than ISER_HEADERS_LEN
Date: Tue, 16 Jun 2026 20:28:05 +0530
Message-ID: <20260616145123.504997338@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1383,6 +1383,12 @@ isert_login_recv_done(struct ib_cq *cq,
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


