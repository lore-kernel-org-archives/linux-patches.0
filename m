Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC7B38F255;
	Sat, 12 Sep 2026 19:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242817; cv=none; b=Ak/YvB9xVNeFtcuslGLSRIOiCTsix7qvZqT5g9Bqu9Ac3hm23KLZIkVch39K8GOLe3QvLUlXyBbsu6z8BC7BbsNM1nBx6AesCqM1z9v/s6dV3mmMXYtt5A3Shb1UF1WxbwAn5wyn9esMfYutNPK3tG7iOWA2FvW4VPeQ4/GJ/7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242817; c=relaxed/simple;
	bh=84Xrd5Dj0Sr/ZtWGIva+e+dLxPK0h35nP5ZuPzBxDa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FopJb9MIEI1mFUWbQMqdVQg7TRJWuth+lY96dDPRNnT7iOm8YUikXCIsc712x2efxFo95nxRdiNA2IetFXgPvNE96wXFSTUSIyENdyjgPwPjqe3XmCP6gbrfpHBraUcdateFOTWtQ84WqY6Bjd1Rt3CyojxVeDZflUG9PKfUbQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4yjrlRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4yjrlRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052781F000FF;
	Sat, 12 Sep 2026 19:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242816;
	bh=gC4G8hXMUGEIYjepKNG8XiO87oGcjpn1iQ7ESwSee3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4yjrlRCkesLOzPctr53Zva5mm4Ow1m15Lct3nRe7wBHKS8STFz/s9qwhYSjyg1UY
	 E9AYyRCWtzqhW07xKaOu7tmrcg8nZomZmELtfA2EamjPL9k5MENnsiWBD+hDSnLuDd
	 W0ag2+xoXGzdLqSIiN/EH4dcEIgPXX3MfFXQEYr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 538/798] IB/isert: reject login PDUs declaring more data than was received
Date: Sat, 12 Sep 2026 09:02:46 +0200
Message-ID: <20260912065529.460242027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 2488b5b4827e5415768afc8daf097e8eb83c98df ]

isert_login_recv_done() records how many bytes the HCA actually placed in
the login buffer, but nothing compares that against the length the login
PDU's BHS declares.  isert_rx_login_req() copies min(login_req_len,
MAX_KEY_VALUE_PAIRS) bytes into login->req_buf, and the login code then
reads the declared length back out of that buffer - for the first PDU in
iscsi_target_locate_portal(),

	payload_length = ntoh24(login_req->dlength);
	tmpbuf = kmemdup_nul(login->req_buf, payload_length, GFP_KERNEL);

and for the ones after it in iscsi_decode_text_input(), reached from
iscsi_target_do_login().

login->req_buf is a fixed MAX_KEY_VALUE_PAIRS (8192) byte allocation, so
an initiator that declares more than it sends reads off the end of it,
before authentication and with the length under its control:

  BUG: KASAN: slab-out-of-bounds in kmemdup_nul+0x43/0x80
  Read of size 8193 at addr ffff8881056a8000 by task iscsi_np/167
   __asan_memcpy+0x23/0x60
   kmemdup_nul+0x43/0x80
   iscsi_target_locate_portal+0x48d/0x1180
   iscsi_target_login_thread+0x19a9/0x3350
  Allocated by task 167:
   __kmalloc_cache_noprof+0x158/0x370
   iscsi_target_login_thread+0x971/0x3350
  which belongs to the cache kmalloc-8k of size 8192
  allocated 8192-byte region

Falsifying the second login PDU instead reaches the other reader, on the
same buffer:

  BUG: KASAN: slab-out-of-bounds in kmemdup_nul+0x43/0x80
  Read of size 8193 at addr ffff888104d10000 by task kworker/1:1/50
  Workqueue: isert_login_wq iscsi_target_do_login_rx
   __asan_memcpy+0x23/0x60
   kmemdup_nul+0x43/0x80
   iscsi_decode_text_input+0xc6/0x11c0
   iscsi_target_do_login+0x261/0x1470
   iscsi_target_do_login_rx+0x51d/0x7d0

iscsit over TCP is not exposed: iscsit_get_login_rx() validates the
declared length with iscsi_target_check_login_request() and then reads
exactly that many bytes off the socket, so the declared length governs
how much arrives rather than how much is copied out of an already-filled
buffer.  isert does not call iscsi_target_check_login_request() at all.

Reject a login PDU whose declared DataSegmentLength exceeds what was
received, in both paths that reach isert_rx_login_req():
isert_get_login_rx() for the first login PDU and isert_login_recv_done()
for the ones after it.  dlength <= login_req_len is allowed because the
received count can include up to three bytes of iSCSI padding.

Once the check is in place the copy out can no longer exceed the copy in:
the posted login SGE is ISER_RX_PAYLOAD_SIZE, so login_req_len cannot
exceed MAX_KEY_VALUE_PAIRS and the min() in isert_rx_login_req() is
login_req_len.

Like the existing short-PDU check added by 29e7b925ae6d, the reject in
isert_login_recv_done() returns without completing login_req_comp, so a
malformed subsequent PDU leaves the login to be torn down by the login
timer rather than failing immediately.  The first-PDU path returns an
error and fails straight away.

Reproduced on 7.2.0-rc4 with soft-RoCE (rdma_rxe) under KASAN, using an
initiator that sends the real key=value payload while declaring 8193 in
the BHS, on the first login PDU and on the second in separate runs.  The
reported read size tracks the declared value exactly; 16384 and 61440
behave the same.  Unpatched 3 of 3 runs report on each of the two paths,
patched 0 of 3 on both, run alternately in a single session, and a normal
login still completes on the patched build.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Suggested-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260726163931.971063-3-yhlee@isslab.korea.ac.kr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 29d79b51aa1f9..c2f789edd200d 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -975,6 +975,21 @@ isert_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 	return 0;
 }
 
+static int
+isert_check_login_req(struct isert_conn *isert_conn)
+{
+	struct iscsi_hdr *hdr = isert_get_iscsi_hdr(isert_conn->login_desc);
+	u32 dlength = ntoh24(hdr->dlength);
+
+	if (unlikely(dlength > (u32)isert_conn->login_req_len)) {
+		isert_dbg("login PDU declares %u data bytes but only %d were received\n",
+			  dlength, isert_conn->login_req_len);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void
 isert_rx_login_req(struct isert_conn *isert_conn)
 {
@@ -1414,8 +1429,12 @@ isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (isert_conn->conn) {
 		struct iscsi_login *login = isert_conn->conn->conn_login;
 
-		if (login && !login->first_request)
+		if (login && !login->first_request) {
+			if (isert_check_login_req(isert_conn))
+				return;
+
 			isert_rx_login_req(isert_conn);
+		}
 	}
 
 	mutex_lock(&isert_conn->mutex);
@@ -2370,6 +2389,10 @@ isert_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
 	if (!login->first_request)
 		return 0;
 
+	ret = isert_check_login_req(isert_conn);
+	if (ret)
+		return ret;
+
 	isert_rx_login_req(isert_conn);
 
 	isert_info("before login_comp conn: %p\n", conn);
-- 
2.53.0



