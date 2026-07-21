Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C5A47140A;
	Tue, 21 Jul 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656544; cv=none; b=E+KGoiJKER+0N/4PSPnKWF/uIqba+W2Ypm5ihYIVPjsCJLb6i3AE6e1pV2EngThDv29QdSjiw/sdsTRFkSNIV+4O156rEunzTZEGhG4W3jojhK8aM4+kDB5mGd5xlX9ccOLOCtS2lNdZw6TG9PndFt1QB0Jzz0K0VzmrlkbeUCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656544; c=relaxed/simple;
	bh=8j68RaHz/yXhUdOCJcjPbYAvXlx8UzTEoU+CBGa4D4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pURHc8TmUbWNWwucfk7XcYeS5DoZc4Mijpb2lg8knv45ux9LWSXzZYLhx1h0I7a6QLz5SF1HpcBFsxQs9iMPXUtqLmq9Ue57VaZkkO8gyIljHFcldpgr/S2Qw2zW2OXwQMlRCpijVClLxRftw/SuraTKwfICFvNPMvzXk1Dz/zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMZKJzRd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMZKJzRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4552B1F000E9;
	Tue, 21 Jul 2026 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656542;
	bh=iysL6SyEQ46MQjkJutGvDdoX5dbQ1C5wGZj3+Mof21w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMZKJzRdtpX9Oi01GpuJPKpf1EJGpdeuWdpihcGxa5RCisyajjvVIAiO4Jp9T7nAh
	 xB9qsFasVLe6dQICW5nZrCOPtQJE75pKfHpsIsGSPbQZKq910pUuZZGNz8ZGUOk8Kg
	 OYTXY9UHrB4C6S6d+rXMs8vMW/XcA0YQZ27SRT0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faizal Rahim <faizal.abdul.rahim@linux.intel.com>,
	KhaiWenTan <khai.wen.tan@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0428/1611] igc: skip RX timestamp header for frame preemption verification
Date: Tue, 21 Jul 2026 17:09:04 +0200
Message-ID: <20260721152524.899343279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: KhaiWenTan <khai.wen.tan@linux.intel.com>

[ Upstream commit 38b7a274cf84af9b1f4b602b8e2741565b81947b ]

When RX hardware timestamping is enabled, a 16-byte inline timestamp header
is added to the start of the packet buffer, causing FPE handshake
verification to fail.

Because an incorrect packet buffer is passed to igc_fpe_handle_mpacket(),
the mem_is_zero() check inspects the timestamp metadata instead of the
actual mPacket payload. As a result, valid Verify/Response mPackets can be
missed when inline RX timestamps are present.

Pass pktbuf + pkt_offset to igc_fpe_handle_mpacket() so it inspects the
actual mPacket payload instead of the timestamp header.

Fixes: 5422570c0010 ("igc: add support for frame preemption verification")
Co-developed-by: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
Signed-off-by: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
Signed-off-by: KhaiWenTan <khai.wen.tan@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 104d6ab2ce5fa8..ebc00ce2e3a6b1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2649,7 +2649,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		}
 
 		if (igc_fpe_is_pmac_enabled(adapter) &&
-		    igc_fpe_handle_mpacket(adapter, rx_desc, size, pktbuf)) {
+		    igc_fpe_handle_mpacket(adapter, rx_desc, size, pktbuf + pkt_offset)) {
 			/* Advance the ring next-to-clean */
 			igc_is_non_eop(rx_ring, rx_desc);
 			cleaned_count++;
-- 
2.53.0



