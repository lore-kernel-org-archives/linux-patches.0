Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741553D3339;
	Mon, 17 Aug 2026 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975335; cv=none; b=RFqlv5lauQbVMknXwn3c7raqBp19UKcy+TxzrdqvV4WGsmZrCMySSfXYLmmfcOtSPZNObO8XCZ70aKaADOp5JHuf6XehBDcC62fTv7BET6uJzZueBAXbkJQ2G208KR0QH3Ne6tYz+jPAXnH9XxkPD2lJIj0JZI0UGlm9GBj2soY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975335; c=relaxed/simple;
	bh=nyjRcLL7ieEbmskhx/AI6Lhc+TzXmdhL/qav0L1//fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8Jfr42mFLRagaLaZfP8VNc0tM59XwGY1PKeanZgvXHdzwhzbtim8Zy5BFePmgqvnswnX/6y2RXSg5B1aDbwxp1lOmNwGxvG8EaYeTgTMTjOTsPEYSMWnBjjemBRp+W7VH09/ad8deyl5swMpAABFqstgbZ+CRHrfnLkVp36c8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aw1snOPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aw1snOPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91BF1F00A3A;
	Mon, 17 Aug 2026 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975334;
	bh=x+XUFGATZ7kOjLRAUfhp2gS9TY6+ILAsK/8bgPHRbtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aw1snOPJ5Vl91iIRWX1kNiOKWKiDfC+NQNrMDiDH0qzZvFRewneuP+nqqX3sFELG4
	 dvKs2LGmfQ/C6iuf7TXsSZUbV0Uiv/g/Yx5mVboXDllQMPSkwC9oxJxq+DxcNU3mdl
	 5EMeoBP2VIYjBymJaUTCskjLcnvEuED3uGl2RYts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sukhdeep Singh <sukhdeeps@marvell.com>,
	Yangyu Chen <cyy@cyyself.name>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 204/250] net: atlantic: free RX pages of consumed but not refilled buffers
Date: Mon, 17 Aug 2026 15:32:45 +0200
Message-ID: <20260817132544.874858358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Yangyu Chen <cyy@cyyself.name>

commit e8e7471ef686b6c002218fee9671cc61992ae01a upstream.

aq_ring_rx_deinit() only walks [sw_head, sw_tail), the region posted to
hardware. Since the page reuse strategy was added, a cleaned RX buffer
keeps its page (and its DMA mapping) in the ring for reuse, and refill
is batched: aq_ring_rx_fill() returns early until AQ_CFG_RX_REFILL_THRES
slots are free. Slots that were consumed but not yet reposted therefore
sit in the complementary [sw_tail, sw_head) gap with a live page, and
the deinit walk never visits them: up to a refill batch worth of pages
and DMA mappings leak on every interface down.

Walk the whole ring instead and release whatever is still there. Also
bail out if the buffer ring is already gone: a partial
aq_ptp_ring_alloc() failure frees the ring but leaves aq_nic set, so
aq_ptp_ring_deinit() still gets here on the unwind path.

Cc: stable@vger.kernel.org # v5.2+
Fixes: 46f4c29d9de6 ("net: aquantia: optimize rx performance by page reuse strategy")
Reviewed-by: Sukhdeep Singh <sukhdeeps@marvell.com>
Signed-off-by: Yangyu Chen <cyy@cyyself.name>
Acked-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/tencent_607CBA8237DA438E36B844318B21538DE008@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -926,15 +926,29 @@ err_exit:
 
 void aq_ring_rx_deinit(struct aq_ring_s *self)
 {
-	if (!self)
+	unsigned int i;
+
+	if (!self || !self->buff_ring)
 		return;
 
-	for (; self->sw_head != self->sw_tail;
-		self->sw_head = aq_ring_next_dx(self, self->sw_head)) {
-		struct aq_ring_buff_s *buff = &self->buff_ring[self->sw_head];
+	/* Release every page still owned by the ring.
+	 *
+	 * Walking [sw_head, sw_tail) is not enough: refill is batched
+	 * (aq_ring_rx_fill() waits for AQ_CFG_RX_REFILL_THRES free slots),
+	 * so slots that were cleaned but not yet reposted accumulate in the
+	 * [sw_tail, sw_head) gap, and they keep their page for reuse. Walk
+	 * the whole ring and release whatever is left.
+	 */
+	for (i = 0; i < self->size; i++) {
+		struct aq_ring_buff_s *buff = &self->buff_ring[i];
+
+		if (!buff->rxdata.page)
+			continue;
 
 		aq_free_rxpage(&buff->rxdata, aq_nic_get_dev(self->aq_nic));
 	}
+
+	self->sw_head = self->sw_tail;
 }
 
 void aq_ring_free(struct aq_ring_s *self)


