Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01C0402BBA;
	Wed, 20 May 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302528; cv=none; b=Kw7aktnCD9KoZZY/NDZltmqH5qqEGeGbp01CDbhbkFwSeDX2a0ng06GqRyhM9U5IIwjbJuK1MReTxHPEmttTPHkXXbQbhfmC2bxhAIHmwd9A/jreDyFU7kCDqge8u0KU5O3fTa+NzXVcCkkMMjmvPjqx5BYCwtLi1YGXKi1WnZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302528; c=relaxed/simple;
	bh=tHNgIn63Y+Fy3KU6sbQ6rXib69vJbUNGHjaZTBzJ4jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs383Pyol0r84vqHF330NsrvwS2tD84Jerjb+YDqIQEuMYiQXL4Te+Jn6brREzDk3Js4A/aytj4D3Z4tyZ0E/9cJwfF7ALNWYCfMz415aHtOpnQOKLyX0xLaOcEO+L5MzeELLOAz3xEEwWZJTQsmYbvnIWx12XSOUoCAiBrNlJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROegsIzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROegsIzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303621F000E9;
	Wed, 20 May 2026 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302527;
	bh=+ehfE6mTBBdjstgch4RlLQNSPhyubFENLld27kuJytQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROegsIzXrF6pibMdSFBXbPcQV3BIt6p1O3v5rIZSKh6n7NRkfiPYOvuZUqe5CDAqK
	 sBdL5J9aVnXuE0wEmhIBZzMvlTO9BBpvzPXQY98Eg2P1NhqYMM6eOxY5qYDazKWWp1
	 pKOKZ8rZUf3ulPBD8fs/wryNXuZ0SN1VbytLAm3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/508] i3c: mipi-i3c-hci: fix IBI payload length calculation for final status
Date: Wed, 20 May 2026 18:21:22 +0200
Message-ID: <20260520162104.258843817@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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



