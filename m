Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6E022A1E6;
	Mon,  2 Jun 2025 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875199; cv=none; b=MgG8I0Gz9ElfUpXhOuy7sP7xI86kvgebeL4IFdLY4lsTAXjxBsn5mWUM+Cow/PzAU4CvQkZNLRJIhcoGpKYlGUUPOE5gBr8jUihiWECdogCZwej0cC09iITRB3s0nTYr+6ex/C8aW2jDKuNQJ/AuQxHUILyT7kyYUfD6udmJ6Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875199; c=relaxed/simple;
	bh=ZYB2w0aSDo5F8mFP0O7bTpP8k4NBEZKm3iUuAP0Duxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAuv/TIOanFNszxwljji85GmWV2wRpr2UsOQyZFzQsVKXmdEsX3pHv+0OhEP0hYUkaxFfXVlqg+J3C09Ln8XBHAAEBB7PALkjY4JcYKdnYWRe1kMn6vgGiIwjCyrUS/5A+S7qXGos1L3EWifVUwKxweDfTQlyO8nPKao5PyP0q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kb4KGO24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kb4KGO24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1273C4CEEB;
	Mon,  2 Jun 2025 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875199;
	bh=ZYB2w0aSDo5F8mFP0O7bTpP8k4NBEZKm3iUuAP0Duxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kb4KGO24/RL+af0UO4QOInTr1S0fBs0wBDv4x6Ym1UqH+341YeObzJQV14JkM/yLb
	 lcAdZ17Di7v4eesG7nQJbcIN5psaUl5ncwCYDHsMiV7PPG1N62BW5bRI/reR3ZEoD6
	 yiSO7FqI4ZzjJEiqKzli/p9WTKwdL0K6p+Nw5l3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>
Subject: [PATCH 5.10 058/270] staging: axis-fifo: Correct handling of tx_fifo_depth for size validation
Date: Mon,  2 Jun 2025 15:45:43 +0200
Message-ID: <20250602134309.564767203@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 2ca34b508774aaa590fc3698a54204706ecca4ba upstream.

Remove erroneous subtraction of 4 from the total FIFO depth read from
device tree. The stored depth is for checking against total capacity,
not initial vacancy. This prevented writes near the FIFO's full size.

The check performed just before data transfer, which uses live reads of
the TDFV register to determine current vacancy, correctly handles the
initial Depth - 4 hardware state and subsequent FIFO fullness.

Fixes: 4a965c5f89de ("staging: add driver for Xilinx AXI-Stream FIFO v4.1 IP core")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Link: https://lore.kernel.org/r/20250419012937.674924-1-gshahrouzi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/axis-fifo/axis-fifo.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -780,9 +780,6 @@ static int axis_fifo_parse_dt(struct axi
 		goto end;
 	}
 
-	/* IP sets TDFV to fifo depth - 4 so we will do the same */
-	fifo->tx_fifo_depth -= 4;
-
 	ret = get_dts_property(fifo, "xlnx,use-rx-data", &fifo->has_rx_fifo);
 	if (ret) {
 		dev_err(fifo->dt_device, "missing xlnx,use-rx-data property\n");


