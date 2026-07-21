Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F3F30D3FF;
	Tue, 21 Jul 2026 20:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667142; cv=none; b=Ykfn1LWag533yj0J9RBKrnOVJjVoaYj0zvLJjgEj1hMaBrvrHl7LUCHa5Fub8HcTICxI3qK3UQerG/wYsZdSbEbgW3lzRYjANn6S0jsImJz/hZl7a4N0/ylBNWkjGtRZGrrMXyZ4Sx5YlMCOXxnvGsOTK/G50pSMP+wrsb2FCxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667142; c=relaxed/simple;
	bh=XcPo18UmnWAL2xW1xdRbWCeOcZvogbt2Cb9RDed1h24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTvBt3YtqZSiHa3FHZ2ulfgeRLI4LiBpHE37G794XgKNHvtvu+Ei89KhTBMd2vQqDEGBh/O3Ed+GrtqtrENstY5qW9Yf6VPm/qujK0SN81u9nttC66W6j4As3OqvjHG5FzEAPHoO+q4tktMQiutHPsWh/phekcY2/uzZ3DSk3rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+uvCAw7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+uvCAw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038391F000E9;
	Tue, 21 Jul 2026 20:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667141;
	bh=H2olKVfmLPjvivCaSuxP0zIBvvBsSOJg3q43Jo9otAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+uvCAw7Tf3oCLk7TzOpHYT2LcsIl3rayTx09P01zaxa2Ft6JizLY3lBP65Th1RUr
	 rAhjojphwptAMHmM3MA7pBqRX2JGrPsMvC0nhHRsE4hdRnVwGFMzmAIv2mX9crxAUv
	 XCHZXe5PHP51zC/At+vrKpTJE7h0d/oNJPpxt0c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Val Packett <val@packett.cool>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0922/1266] ASoC: qcom: q6apm: fix NULL pointer dereference in graph_callback
Date: Tue, 21 Jul 2026 17:22:39 +0200
Message-ID: <20260721152502.470244463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 2e9261761b35f0b67b7487688cd1365f535be0b3 upstream.

When q6apm_free_fragments() is called it frees rx_data.buf/tx_data.buf
and sets them to NULL under graph->lock. A late DSP buffer-done response
can race with this: graph_callback() passes the !graph->ar_graph guard
(not yet NULL), acquires the lock, but then dereferences a now-NULL buf
pointer to read buf[token].phys, crashing at virtual address 0x10.

Add a NULL check for buf inside the mutex-protected section in both the
write-done (DATA_CMD_RSP_WR_SH_MEM_EP_DATA_BUFFER_DONE_V2) and
read-done (DATA_CMD_RSP_RD_SH_MEM_EP_DATA_BUFFER_V2) handlers and bail
out cleanly if buffers have already been freed.

This problem is only shown up recently while apr bus was updated to
process the commands per service rather from single global queue.

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Cc: Stable@vger.kernel.org
Assisted-by: Claude:claude-4-6-sonnet
Reported-by: Val Packett <val@packett.cool>
Closes: https://lore.kernel.org/all/133ced18-1aa9-475d-80d8-6120678bdde4@packett.cool/
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260616170257.9381-1-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -533,6 +533,10 @@ static int graph_callback(struct gpr_res
 		token = hdr->token & APM_WRITE_TOKEN_MASK;
 
 		done = data->payload;
+		if (!graph->rx_data.buf) {
+			mutex_unlock(&graph->lock);
+			break;
+		}
 		phys = graph->rx_data.buf[token].phys;
 		mutex_unlock(&graph->lock);
 		/* token numbering starts at 0 */
@@ -567,6 +571,10 @@ static int graph_callback(struct gpr_res
 		client_event = APM_CLIENT_EVENT_DATA_READ_DONE;
 		mutex_lock(&graph->lock);
 		rd_done = data->payload;
+		if (!graph->tx_data.buf) {
+			mutex_unlock(&graph->lock);
+			break;
+		}
 		phys = graph->tx_data.buf[hdr->token].phys;
 		mutex_unlock(&graph->lock);
 		/* token numbering starts at 0 */


