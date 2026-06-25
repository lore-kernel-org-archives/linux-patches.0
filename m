Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368322848A7;
	Thu, 25 Jun 2026 13:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392817; cv=none; b=VJv8QnwjMbINX2/2nCWTe+rqeFhvSjGGetnEf3sOciCNHjBHg/xISEhQ7Z5HN90gLM7egPs1b+0HGJESCNmMfvo9xlkKoomzbI3As3LOSTyu0zr6FwqqMr497X1cgpmPQFEv4NtCut7JXXxMxqORw8cBD+6ytUUmPdaNmU4pHpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392817; c=relaxed/simple;
	bh=/F8JHvimZ7U2iQSN6ESjtQyZlqn0ybLxU1zW/1AHjAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caredIUJMcXAHhh6HlWWlAMsSz7zDIVzUaHsAAcr4X8enZnLnSv+YY/nGc4uZwtrfwFHAvRqhqNm10MAQk2pu3u7DFi73sTppF1BuUBs8dw1jsVPGdEz2wtK07AyLkNoV4OYiSTmaNIGfpoK0z0RwS+JaKq+NEBZs2UqPqcJeZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k19N7OwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k19N7OwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5F51F000E9;
	Thu, 25 Jun 2026 13:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392816;
	bh=1/rrI75J5Sg2r+pWcLT1Ce+tloORQkOGjn5IC/N4apM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k19N7OwZQwu7pmyo4aBKfOVTbCbrLWlz/gJ26JopgKbM/lpd4UxlAy295WSZ79Fh6
	 uvqNFK/qqejZ52GvL55S4+/jT4QP+U5DZETCZzcDApwG3Z0faoxETOKfzy9ZBXmvgu
	 rlNAXrJIUbRz3Ch1awpnsTu5pCJEINwrHJZMzr9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titouan Ameline de Cadeville <titouan.ameline@gmail.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 32/60] firmware: samsung: acpm: Fix cross-thread RX length corruption
Date: Thu, 25 Jun 2026 14:03:17 +0100
Message-ID: <20260625125650.257724749@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit f133bd4b5daf71bccdde0ad1a4f47fac76a6bfb1 ]

Sashiko identified a cross-thread RX length corruption bug when
reviewing the thermal addition to ACPM [1].

When multiple threads concurrently send IPC requests, the ACPM polling
mechanism can encounter responses belonging to other threads. To drain
the queue, the driver saves these concurrent responses into an internal
cache (`rx_data->cmd`) to be retrieved later by the owning thread.

Previously, the driver incorrectly used `xfer->rxcnt` (the expected
receive length of the *current* polling thread) when copying data for
*other* threads into this cache. If the threads expected responses of
different lengths, this resulted in buffer underflows (leading to reads
of uninitialized memory) or potential buffer overflows.

Fix this by replacing the boolean `response` flag in
`struct acpm_rx_data` with `rxcnt`, caching the exact expected receive
length for each specific transaction during transfer preparation. Use
this cached length when saving concurrent responses.

Consequently, ensure that `xfer->rxcnt` is explicitly zeroed in driver
helpers (e.g., `acpm_dvfs_set_xfer`) for fire-and-forget messages to
prevent uninitialized stack garbage from being interpreted as a massive
expected receive length.

Cc: stable@vger.kernel.org
Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Closes: https://sashiko.dev/#/patchset/20260420-acpm-tmu-v3-0-3dc8e93f0b26%40linaro.org [1]
Reported-by: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
Closes: https://lore.kernel.org/r/20260426210255.73674-1-titouan.ameline@gmail.com/
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260505-acpm-fixes-sashiko-reports-v5-1-43b5ee7f1674@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/samsung/exynos-acpm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/firmware/samsung/exynos-acpm.c
+++ b/drivers/firmware/samsung/exynos-acpm.c
@@ -103,12 +103,12 @@ struct acpm_queue {
  *
  * @cmd:	pointer to where the data shall be saved.
  * @n_cmd:	number of 32-bit commands.
- * @response:	true if the client expects the RX data.
+ * @rxcnt:	expected length of the response in 32-bit words.
  */
 struct acpm_rx_data {
 	u32 *cmd;
 	size_t n_cmd;
-	bool response;
+	size_t rxcnt;
 };
 
 #define ACPM_SEQNUM_MAX    64
@@ -196,7 +196,7 @@ static void acpm_get_saved_rx(struct acp
 	const struct acpm_rx_data *rx_data = &achan->rx_data[tx_seqnum - 1];
 	u32 rx_seqnum;
 
-	if (!rx_data->response)
+	if (!rx_data->rxcnt)
 		return;
 
 	rx_seqnum = FIELD_GET(ACPM_PROTOCOL_SEQNUM, rx_data->cmd[0]);
@@ -253,7 +253,7 @@ static int acpm_get_rx(struct acpm_chan
 		seqnum = rx_seqnum - 1;
 		rx_data = &achan->rx_data[seqnum];
 
-		if (rx_data->response) {
+		if (rx_data->rxcnt) {
 			if (rx_seqnum == tx_seqnum) {
 				__ioread32_copy(xfer->rxd, addr,
 						xfer->rxlen / 4);
@@ -267,7 +267,7 @@ static int acpm_get_rx(struct acpm_chan
 				 * after the response is copied to the request.
 				 */
 				__ioread32_copy(rx_data->cmd, addr,
-						xfer->rxlen / 4);
+						rx_data->rxcnt);
 			}
 		} else {
 			clear_bit(seqnum, achan->bitmap_seqnum);
@@ -379,8 +379,8 @@ static void acpm_prepare_xfer(struct acp
 	/* Clear data for upcoming responses */
 	rx_data = &achan->rx_data[achan->seqnum - 1];
 	memset(rx_data->cmd, 0, sizeof(*rx_data->cmd) * rx_data->n_cmd);
-	if (xfer->rxd)
-		rx_data->response = true;
+	/* zero means no response expected */
+	rx_data->rxcnt = xfer->rxlen / 4;
 
 	/* Flag the index based on seqnum. (seqnum: 1~63, bitmap: 0~62) */
 	set_bit(achan->seqnum - 1, achan->bitmap_seqnum);


