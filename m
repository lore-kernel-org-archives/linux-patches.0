Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B821F1A682B;
	Tue, 16 Jun 2026 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624924; cv=none; b=ZiMq88brlABQXOBbUOZGplbfLQzRBBl7M/4M8G97R5ES+BHo0F890vg5jY04c/Jb6SSYs1RimLpX6LtlRqUmSyz0VqGbeqz+i1NCmLo1WlpB1Ym9lsfMcTk0WmGiSFeLeFCuQwyNCW7HzvVFbGz0EAUNaB1DSuHzFkSUY3VNpSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624924; c=relaxed/simple;
	bh=sKxeKpCY0BsFxvbd4lZx0r9PmHJxReZDEFCsnrD6r8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcfAmJ9PwWh0LXcrctySnRRY163xGh55dYdrmcYD7Xf33hhKJtsP2TsGay5NcOhKRoELMggtT0MU2G/02gX/7icushIrPPIqjaFEVvA3T0YnYVfpn57Np/AhBYzi08aAWrHWzSAsnWrbmHrIIy8ncpNgw07gSPNg0zq2swXRr/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H00w/70q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H00w/70q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706DD1F000E9;
	Tue, 16 Jun 2026 15:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624923;
	bh=a1Qo5uh3W5a8j7WUybVJi723XhGQmq9/3IY8/0ZhlUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H00w/70q08IQR9WeM7hvoILl/ik2zd6iVeJlhQWRdEGRMX4ZWVl6rTs+f7jXkFsG/
	 nyeTJIZWmuVi4+jkDhqKHx+a0cOrLwJoaKxEcdohArNtj3bq5ACGQEX9FBi7WgTFD3
	 BDAIpLrBsCWPVBKKfnMfSTpEn9Mu1xCpWaYjwFnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jason Xing <kernelxing@tencent.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/325] xsk: cache csum_start/csum_offset to fix TOCTOU in xsk_skb_metadata()
Date: Tue, 16 Jun 2026 20:27:28 +0530
Message-ID: <20260616145100.297940577@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 22ba97ea9cc1f63a0d0244fae38057ed452b6ac7 ]

The TX metadata area resides in the UMEM buffer which is memory-mapped
and concurrently writable by userspace. In xsk_skb_metadata(),
csum_start and csum_offset are read from shared memory for bounds
validation, then read again for skb assignment. A malicious userspace
application can race to overwrite these values between the two reads,
bypassing the bounds check and causing out-of-bounds memory access
during checksum computation in the transmit path.

Fix this by reading csum_start and csum_offset into local variables
once, then using the local copies for both validation and assignment.

Note that other metadata fields (flags, launch_time) and the cached
csum fields may be mutually inconsistent due to concurrent userspace
writes, but this is benign: the only security-critical invariant is
that each field's validated value is the same one used, which local
caching guarantees.

Closes: https://lore.kernel.org/all/20260503200927.73EA1C2BCB4@smtp.kernel.org/
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Link: https://patch.msgid.link/20260530042630.80626-1-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 259ad9a3abcc42..9e0a486d54fb33 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -685,6 +685,7 @@ static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 			    u32 hr)
 {
 	struct xsk_tx_metadata *meta = NULL;
+	u16 csum_start, csum_offset;
 
 	if (unlikely(pool->tx_metadata_len == 0))
 		return -EINVAL;
@@ -694,13 +695,15 @@ static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 		return -EINVAL;
 
 	if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM) {
-		if (unlikely(meta->request.csum_start +
-			     meta->request.csum_offset +
+		csum_start = READ_ONCE(meta->request.csum_start);
+		csum_offset = READ_ONCE(meta->request.csum_offset);
+
+		if (unlikely(csum_start + csum_offset +
 			     sizeof(__sum16) > desc->len))
 			return -EINVAL;
 
-		skb->csum_start = hr + meta->request.csum_start;
-		skb->csum_offset = meta->request.csum_offset;
+		skb->csum_start = hr + csum_start;
+		skb->csum_offset = csum_offset;
 		skb->ip_summed = CHECKSUM_PARTIAL;
 
 		if (unlikely(pool->tx_sw_csum)) {
-- 
2.53.0



