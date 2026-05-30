Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D2230E847;
	Sat, 30 May 2026 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161566; cv=none; b=qvLbWmIaCdoPW0q2vyK8zYxqSohxCG27KR3h6vjIBGrrjZBANix5mpoEQdMDcV4g9/5lQ4fUvLNF/eF2GE/SeaCjyRJJChWqfFuXbML2ruk44lzcPHqO9JPI81GbTGa4Wttwm4521eZkGX5D+PfknZ7inHOvHIEjha/AM4d+tXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161566; c=relaxed/simple;
	bh=NQVPyv+3ABIzZAawP3JR29w/V3USXqvh2NKUoyzAKas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6zL/FMyVTKSbSCcTSzb9f9TZMNUSveuG6zjICyjqJ1oWZl057U4/vVURQ+qQ0YFhR0MeBpkY9d0OiP5L0us2oxFHkRIPyGAZ37S8vYmwWlNjNYJ6LjKuP4V53iZ3O9Mfq3GtQ/NrvJ2GWiNJles6NyxwpLRAsxPa4uukmgu9Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akpIOsnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akpIOsnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC13D1F00893;
	Sat, 30 May 2026 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161565;
	bh=E/pZUk9fQoJffeZce9Pi5mLHUkVmiW/F/GIgzIYIvtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akpIOsnvHJl4CusUIoKigQgNmlWJSaR+HIJ1WgfJpWZU9CXq0iChq3swaqV63d1Wz
	 cIW3untBzA9RtoIRzGnIaqr95x0V+vdrTnb8m070B6s5pSXXgQdZ1OpKHIVLtpUaPJ
	 uj7abWepr7blzI0ho6uNRcHBJAOVJKiVCgsoidME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 634/969] i3c: mipi-i3c-hci: fix IBI payload length calculation for final status
Date: Sat, 30 May 2026 18:02:38 +0200
Message-ID: <20260530160317.957865634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit d35a6db887eeae7c57b719521e39d64f929c6dc3 ]

In DMA mode, the IBI status descriptor encodes the payload using
CHUNKS (number of chunks) and DATA_LENGTH (valid bytes in the last
chunk). All preceding chunks are implicitly full-sized.

The current code accumulates full chunk sizes for non-final status
descriptors, but for the final status descriptor it only adds
DATA_LENGTH. This ignores the contribution of the preceding full
chunks described by the same final status entry.

As a result, the computed IBI payload length is truncated whenever
the final status spans multiple chunks. For example, with a chunk
size of 4 bytes, CHUNKS=2 and DATA_LENGTH=1 should result in a total
payload size of 5 bytes, but the current code reports only 1 byte.

Fix the calculation by adding the size of (CHUNKS - 1) full chunks
plus DATA_LENGTH for the last chunk.

Fixes: 9ad9a52cce28 ("i3c/master: introduce the mipi-i3c-hci driver")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260407-i3c-hci-dma-v2-1-a583187b9d22@aspeedtech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index e270fcd0f7c38..624d00b853a51 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -636,7 +636,10 @@ static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
 		if (!(ibi_status & IBI_LAST_STATUS)) {
 			ibi_size += chunks * rh->ibi_chunk_sz;
 		} else {
-			ibi_size += FIELD_GET(IBI_DATA_LENGTH, ibi_status);
+			if (chunks) {
+				ibi_size += (chunks - 1) * rh->ibi_chunk_sz;
+				ibi_size += FIELD_GET(IBI_DATA_LENGTH, ibi_status);
+			}
 			last_ptr = ptr;
 			break;
 		}
-- 
2.53.0



