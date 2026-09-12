Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE34478E25;
	Sat, 12 Sep 2026 13:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220405; cv=none; b=RV+4qu3QldDtm8/PhtE+1xiCO0QlFJx+27UBDypVVbeFXL/5gJhjfC+vemGWNHC4qaCXv4m8Mr2aVYLG9QD7giBCUS5D6zFKZnH/SexjW5epPjOs+SX5iTroW26sM1vwDruWLbwMXkMizHA2++/FIBhSJeK7iGRTI2VL5YmmjFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220405; c=relaxed/simple;
	bh=7/G0r0pcu6ubx4itZ4eeH2z9urX3voswvm7sVm99ckY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQziA4eAgnggXcyCuAEp1jgYuJ+remQlCSsrA8veer9Yfb2SQaFWAtyrLV9/c4t778Mt+8DCsWG7TOxu38l3JyT3IBBHuT154RhLB53brnbmW/XrKO6k+a5tc5qy3GlfbSz/oKawhh9YQwRgXrnp676hDP6C1MHqBRAAbUpj7uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1fxI/QN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1fxI/QN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4BE1F000FF;
	Sat, 12 Sep 2026 13:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220403;
	bh=m86OtTWeMQRqW7ym/0afco84j6sxY4mDjdCzuo/+NB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1fxI/QNt+U3p56hYCzNfawIWHTMopVXgWDDHZRdxLZe3FHdT9SKWhiMEqxrKj1yQ
	 0dbUn50qsgau5bjSkBkf58SGqsvfHIA0hQsZKoZSgOH0vJWTdl8DVvbX5CAG0JPP2o
	 Gl69ScYq1st0rBFannTy8xL0P1wjqPkqjRZMVF6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Nagare <vnagare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0171/1424] qede: Fix NULL pointer dereference in TPA fragment processing
Date: Sat, 12 Sep 2026 08:43:23 +0200
Message-ID: <20260912065611.122326509@linuxfoundation.org>
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


