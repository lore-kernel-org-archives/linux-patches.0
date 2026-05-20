Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF383D7D66;
	Wed, 20 May 2026 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298765; cv=none; b=hrRY6KjiS0cxpwxJoui05aeXXL3DT68qwf1MnU9snpzVyO8zieU1lurr1nmym4EdkW/XtQAzm9TvzYwQ3SZWJC6OjPiXUWZX0Qr8rYu3niv56t9TRb5pXLw9tef/ljNHdD9Gs/sAoiqoJpcaeuV1xjJubD76WuMNVBcBem1up/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298765; c=relaxed/simple;
	bh=7c/YYnussZU2APp2DrCVeVgbJGSQ6TbLuEnyzvd53tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWJaBiUN6YI/JJnRvhafXfdOo50XyiOM6zZ+uRnYT5CdItN+QgteWnaXAZxB7u4rit+ZWTwE+WlpCH9bf5GkqqtMqKdvmi+dAc3Zt5gaya48i9RjfNrYNeDq0vuOtxnHWhWq2Xgf7RMZECbYyzwlyX2nbpG151GAslOeAvkXs3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdT6DgvJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdT6DgvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AF61F000E9;
	Wed, 20 May 2026 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298764;
	bh=FmF7duMJAuYRhbSXLQEkPx8HCQvuivrz1MX2mrM22BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdT6DgvJqo3vqMWqYRz6OID2DH0kTKVnas4HWSuK6WRkse0TRA1xDum3LE9ihUwWQ
	 4j0U85Va4ao4O9kb2hu6HyTF4lVITP4bgsixs7RVq/PtISOwuBXll3DCp1V4rNfaYZ
	 rKrf9l3D2i1zItzPhSPBHrewrBm/8T9C2zy98rLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/957] i3c: mipi-i3c-hci: fix IBI payload length calculation for final status
Date: Wed, 20 May 2026 18:16:51 +0200
Message-ID: <20260520162145.983828377@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index fe8894f6fe607..42ee94767be3d 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -683,7 +683,10 @@ static void hci_dma_process_ibi(struct i3c_hci *hci, struct hci_rh_data *rh)
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



