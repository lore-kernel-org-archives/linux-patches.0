Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEDC13A25F;
	Tue,  9 Jul 2024 11:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524222; cv=none; b=hFAITS/lm8D73O4/dUiqXQwKC51Tb9N/3qMVcYMjNPnzf8udS2JTiLrLEobNt2T4pumxaN7LLmkjHM6L11m12cLb/TtaLKv9qJM5VswRXuOGNgTca533Q1tD545/gEjYUZckGzPnoiH9q0mSIEW7uybqA9E9NXO6puWwuEGlFrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524222; c=relaxed/simple;
	bh=rg1lSn5NSUpKyWk5dc8wa71xHbZ0HCyKe8FkFY7NGhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKARU8vpPiTwmhV2LFgOZhphDRcsHjk254QXt6dgyGMRAKh85VuzvqxPpWEXnJXvfrp8vrftDFJ0/T7M4AVRAe0FPCxMu2Jt0N+Zal2H+z+M5ZP/bafjdjiqkVwRUNiMnWmWIX7av1BBtYGaQi1Mfsvd5QhORdUjsFYDZVlw5eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVqYVN+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVqYVN+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CAFC3277B;
	Tue,  9 Jul 2024 11:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524222;
	bh=rg1lSn5NSUpKyWk5dc8wa71xHbZ0HCyKe8FkFY7NGhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVqYVN+8SvMGnmOxX/UOw6sp22m8QKDdEcLYftjY96E6TeEtMDncGxfdN63mVWv8Y
	 N9znub14CZUsxAINCYb15VhYG/NLj6zZxNRzXNW1dTzZV0HrcasYLEXxHnG8kXR/2h
	 FPkuUQt7uQLT2zofVAjK9NE26fKm+Z5YeWsHB6Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 112/197] s390/vfio_ccw: Fix target addresses of TIC CCWs
Date: Tue,  9 Jul 2024 13:09:26 +0200
Message-ID: <20240709110713.290446111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 2ae157ec497d93c639a60e730e21ec9c66fa9a6e ]

The processing of a Transfer-In-Channel (TIC) CCW requires locating
the target of the CCW in the channel program, and updating the
address to reflect what will actually be sent to hardware.

An error exists where the 64-bit virtual address is truncated to
32-bits (variable "cda") when performing this math. Since s390
addresses of that size are 31-bits, this leaves that additional
bit enabled such that the resulting I/O triggers a channel
program check. This shows up occasionally when booting a KVM
guest from a passthrough DASD device:

  ..snip...
  Interrupt Response Block Data:
  : 0x0000000000003990
      Function Ctrl : [Start]
      Activity Ctrl :
      Status Ctrl : [Alert] [Primary] [Secondary] [Status-Pending]
      Device Status :
      Channel Status : [Program-Check]
      cpa=: 0x00000000008d0018
      prev_ccw=: 0x0000000000000000
      this_ccw=: 0x0000000000000000
  ...snip...
  dasd-ipl: Failed to run IPL1 channel program

The channel program address of "0x008d0018" in the IRB doesn't
look wrong, but tracing the CCWs shows the offending bit enabled:

  ccw=0x0000012e808d0000 cda=00a0b030
  ccw=0x0000012e808d0008 cda=00a0b038
  ccw=0x0000012e808d0010 cda=808d0008
  ccw=0x0000012e808d0018 cda=00a0b040

Fix the calculation of the TIC CCW's data address such that it points
to a valid 31-bit address regardless of the input address.

Fixes: bd36cfbbb9e1 ("s390/vfio_ccw_cp: use new address translation helpers")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20240628163738.3643513-1-farman@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_cp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 6e5c508b1e07c..5f6e102256276 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -490,13 +490,14 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
 			      struct channel_program *cp)
 {
 	struct ccwchain *iter;
-	u32 cda, ccw_head;
+	u32 offset, ccw_head;
 
 	list_for_each_entry(iter, &cp->ccwchain_list, next) {
 		ccw_head = iter->ch_iova;
 		if (is_cpa_within_range(ccw->cda, ccw_head, iter->ch_len)) {
-			cda = (u64)iter->ch_ccw + dma32_to_u32(ccw->cda) - ccw_head;
-			ccw->cda = u32_to_dma32(cda);
+			/* Calculate offset of TIC target */
+			offset = dma32_to_u32(ccw->cda) - ccw_head;
+			ccw->cda = virt_to_dma32((void *)iter->ch_ccw + offset);
 			return 0;
 		}
 	}
@@ -914,7 +915,7 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
 	 * in the ioctl directly. Path status changes etc.
 	 */
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
-		ccw_head = (u32)(u64)chain->ch_ccw;
+		ccw_head = dma32_to_u32(virt_to_dma32(chain->ch_ccw));
 		/*
 		 * On successful execution, cpa points just beyond the end
 		 * of the chain.
-- 
2.43.0



