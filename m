Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048037;
	b=K12JkEZxR/xS8a8RWcf9x7UC+KFlqXvnDexHG/nm3E63Hq+JRAgUUsVBPHYpbENeefvt
	 M6pYQO2SCMdsAuPgMMujfH4eiopNrssGwNXMG7qqVXtMvrsZctxg35bcCLjc+DWpAcsA7
	 d0fSXzxDDNeP0R2xTuqpmlnbSdgsNVQPqClsDY7fRYbDPwA00VktEn+/W+7ieC5/Umilt
	 SWV5ml9tR+R4uiKA/vl9aVO1HumuEftuibXOZCumcXmwR0ryw1WopvASI14TpWJnmf4gI
	 wzwa4NCIFBwlpOGE9yE313WJSNRL8CeqRqW5TT4sWlj2n+WKgBXZYch6sLH0212UUlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2MGE3uTHBlBc+mvyB1AXSaoJiHL+Fd0P0HQwBdBjOz4=;
	b=uj5PwKQdeSzLyUABinsN/9cAjOoBjNj5Wf1OPpeSbcKgheLVP4SZZW6ei+NMUi/axylg
	 3+bxbmti4mDWEF1fErsnJXrh2MKXtpp4AXXDeKb2ck19L6dYzeIPV5fh5jAmTvaIBGBuY
	 o5fpYOLiFU5leAB+KVQ5FrFHTlKYKAj+bVZVch/CyzntbJmT8A+DfOWXs1BIBKMmaYoQt
	 ZUAEMVvbGb7tJAGndT2rDpbOGsc/lynhbtccyT6Ijv7ugiWoQpFP9SK6693Y3llX8yx8S
	 farn2vNXFyE4G0USjwSlRsKqYFjp//nCCCQWS+3TA8Glf269snosqj0xNAEApXj6v0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VbX/GBaQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD9E606A325;
	Thu, 19 Nov 2026 00:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VbX/GBaQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E5E1F000C4;
	Thu, 19 Nov 2026 00:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048036;
	bh=2MGE3uTHBlBc+mvyB1AXSaoJiHL+Fd0P0HQwBdBjOz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbX/GBaQA853U90sg2MFb5NRhqabjj5MrtF4rfMpod6wcAwZrqtXV6OFqR3GuzYs4
	 0yKpBqmVr/A1dDYI2GMzR9LK159hBC4zrIB3NxbkCoavhFbOCWHsGvlAMcZt8lttM/
	 tmu8en3FRpNzNjLsc1OUImE9tlK6PcHus+b9KmTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1851/2857] scsi: mpi3mr: Fix out-of-bounds reply frame access
Date: Wed, 18 Nov 2026 15:48:05 +0100
Message-ID: <20261118150307.890515939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit bcf0a5bed59acd5ae19d80e1f617c1a5b355af0b ]

The reply frame address reported on completion is only checked against the
start and the end of the pool. An address near the top can pass the check
while leaving less than a full frame, and an unaligned one resolves into
the middle of a frame instead of the start of one.

Require a whole frame to fit and the address to be frame aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-7-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8cdbb593c8e59..11ac22947ca07 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -119,11 +119,16 @@ void mpi3mr_build_zero_len_sge(void *paddr)
 void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 	dma_addr_t phys_addr)
 {
+	u64 offset;
+
 	if (!phys_addr)
 		return NULL;
 
+	offset = phys_addr - mrioc->reply_buf_dma;
+
 	if ((phys_addr < mrioc->reply_buf_dma) ||
-	    (phys_addr > mrioc->reply_buf_dma_max_address))
+	    (phys_addr > mrioc->reply_buf_dma_max_address - mrioc->reply_sz) ||
+	    do_div(offset, mrioc->reply_sz))
 		return NULL;
 
 	return mrioc->reply_buf + (phys_addr - mrioc->reply_buf_dma);
-- 
2.53.0



