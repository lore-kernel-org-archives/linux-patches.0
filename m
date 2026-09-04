Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B3E3DAAB7;
	Fri,  4 Sep 2026 05:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499512; cv=none; b=DpkOn8ffUvehXlX4o8Bov8zGwbR6iK/XAfl++x8UJ2F3n5vUCZzGcLrWtpv5FKwuiEFVRxLYzFRtxgMQt+p+NAdDsFOoa7cI23aEA3xvmQkwTdseMgZX7eIc5oj+NVAB0sJ/QJl0Xp3UdeWWvI+sfqmLIWuOtvDm6ZgOSjmu2Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499512; c=relaxed/simple;
	bh=SCMgz6NdnjqJqjZiAdUTXXp6sxlQ5YNkpk36uPC0rlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECMdQOWiipGo3jDtQ3QF3QPWNoknf645vvpuvYTtKeb+/vm/GhncWf6S1kMpFpeVsfanANz90uLok3IXXwHzZ5JomASzZ8f7jtesQPAZJWW0i978mFBWXG/G1HYL31kdHxkpSfaqBb5C0aE8EhTLwOw4Vz06TQcWmSJhjyiX5VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvPH/F1X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvPH/F1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389691F00A3E;
	Fri,  4 Sep 2026 05:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499510;
	bh=hx+feGmlfGTOJRXxxCLPVw9BtTwvGu4mFu1sJf42Ekg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vvPH/F1XZiatZP49vsl/l6/ne+OwLVcbk6HzBLGc2WCA+DYmJHVwX+RjvU2O77j8x
	 7fLZXnnznb3AjCPzrLMQ4lc11D5hgFBZ77Ul7vWfNuMp8tWp//w5PEUdktq1Gw4Mhs
	 Scg5g/DFQ6wYDaPqtXsocmU9/uvaOoFZP/5176Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Nagare <vnagare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 441/713] qede: Fix NULL pointer dereference in TPA fragment processing
Date: Fri,  4 Sep 2026 06:56:49 +0200
Message-ID: <20260904045813.715734788@linuxfoundation.org>
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

From: Vaibhav Nagare <nagarevaibhav@gmail.com>

commit 06aa3d26327f24edd039ff249672fdf6f2ba5695 upstream.

Under memory pressure, the qede driver encounters NULL pointer
dereferences when processing TPA continuation fragments.

Commit 8a8633978b84 ("qede: Add build_skb() support.") accidentally
dropped the assignment of tpa_info->buffer.data in qede_tpa_start().

When memory pressure causes an SKB allocation failure in qede_tpa_start(),
the driver sets tpa_start_fail = true and attempts to recycle the physical
page later in qede_tpa_end() via qede_reuse_page(). However, because
buffer.data was left uninitialized (NULL), qede_reuse_page() pushes a
"ghost" BD (valid DMA mapping but NULL data pointer) back into the
active Rx ring.

The next time the hardware uses this ring slot, it passes a NULL page
to qede_fill_frag_skb(), causing a kernel panic.

Example crash from production system:
 BUG: unable to handle kernel NULL pointer dereference at 0x8
 RIP: qede_fill_frag_skb+0x96/0x430 [qede]
 Call Trace:
   qede_rx_int+0xb06/0x1de0
   qede_poll+0x2f4/0x6c0
   __napi_poll+0x2d/0x130

Fix the root cause by restoring the tpa_info->buffer.data assignment
in qede_tpa_start(), ensuring valid pages are correctly tracked and
recycled. Additionally, update the stale comment for
struct qede_agg_info::buffer to reflect its current usage.

Fixes: 8a8633978b84 ("qede: Add build_skb() support.")
Cc: stable@vger.kernel.org
Signed-off-by: Vaibhav Nagare <vnagare@redhat.com>
Link: https://patch.msgid.link/20260818073309.2266072-1-vnagare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede.h    |    8 ++++----
 drivers/net/ethernet/qlogic/qede/qede_fp.c |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -303,10 +303,10 @@ enum qede_agg_state {
 };
 
 struct qede_agg_info {
-	/* rx_buf is a data buffer that can be placed / consumed from rx bd
-	 * chain. It has two purposes: We will preallocate the data buffer
-	 * for each aggregation when we open the interface and will place this
-	 * buffer on the rx-bd-ring when we receive TPA_START. We don't want
+	/* buffer is used to retain the Rx consumer descriptor when a TPA
+	 * session starts. If the SKB allocation fails during TPA_START,
+	 * we use this saved buffer to safely recycle the physical page
+	 * back into the rx-bd-ring via qede_reuse_page(). We don't want
 	 * to be in a state where allocation fails, as we can't reuse the
 	 * consumer buffer in the rx-chain since FW may still be writing to it
 	 * (since header needs to be modified for TPA).
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -850,6 +850,7 @@ static void qede_tpa_start(struct qede_d
 					      pad, false);
 	tpa_info->buffer.page_offset = sw_rx_data_cons->page_offset;
 	tpa_info->buffer.mapping = sw_rx_data_cons->mapping;
+	tpa_info->buffer.data = sw_rx_data_cons->data;
 
 	if (unlikely(!tpa_info->skb)) {
 		DP_NOTICE(edev, "Failed to allocate SKB for gro\n");


