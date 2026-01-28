Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AEC10A1E;
	Wed, 28 Jan 2026 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614263; cv=none; b=KJYI1hugwPmEH9IU0FdlYjmZNM2NdK8IFjGjBWbYBGBxFXKBaKRsP9cmv6Ij8y4c6nOd62Rl28oj/XNDenusJop1UUamu9bMEHPpmnSBc1yvL7DciyPU/ZWn8qGueDjLPaHUi5WqkEUdJybAn/l27bPXJFcoEBhhLs6hnZnpsZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614263; c=relaxed/simple;
	bh=nzM+RL/vd/t0Mzmc/2SQBT/vwAjJznwmgX3D11L2nio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYAI8wmo00t1ChIJ2ESQv1Z0CoXOrtMT5Pjg3whD9YSbkkN5jABlpyl9kADZhOHenu5P5vW3v9OYwY2x4FpdiYzBwOg7w3ZU1BvQQlqIO5NIvj5LSsRNnh+456vk9KQXQjxi23QwemTXtTcu6cLe6QwNUGnfHQ4rHzuTU6UM1dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nc+5v+RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nc+5v+RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2AAC4CEF1;
	Wed, 28 Jan 2026 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614262;
	bh=nzM+RL/vd/t0Mzmc/2SQBT/vwAjJznwmgX3D11L2nio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nc+5v+RTuH8ZfvKwAJMUBHZ9OiQ3ON4wQNNcsozkNZ7ZAMSbfzE2aQx8Zx6PsYpth
	 p+HcSwT3rnbnlQ6z6bW8g4s8eK12FV7ABBZs0xDs/u2hcstYAiHlwXKiZXf3MOp8KC
	 3DLlfs6xLfMg0TTPzK/4iRlmuBzBadZgGkSpGD8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 084/254] dmaengine: qcom: gpi: Fix memory leak in gpi_peripheral_config()
Date: Wed, 28 Jan 2026 16:21:00 +0100
Message-ID: <20260128145347.722691043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 3f747004bbd641131d9396d87b5d2d3d1e182728 upstream.

Fix a memory leak in gpi_peripheral_config() where the original memory
pointed to by gchan->config could be lost if krealloc() fails.

The issue occurs when:
1. gchan->config points to previously allocated memory
2. krealloc() fails and returns NULL
3. The function directly assigns NULL to gchan->config, losing the
   reference to the original memory
4. The original memory becomes unreachable and cannot be freed

Fix this by using a temporary variable to hold the krealloc() result
and only updating gchan->config when the allocation succeeds.

Found via static analysis and code review.

Fixes: 5d0c3533a19f ("dmaengine: qcom: Add GPI dma driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://patch.msgid.link/20251029123421.91973-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/qcom/gpi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -1621,14 +1621,16 @@ static int
 gpi_peripheral_config(struct dma_chan *chan, struct dma_slave_config *config)
 {
 	struct gchan *gchan = to_gchan(chan);
+	void *new_config;
 
 	if (!config->peripheral_config)
 		return -EINVAL;
 
-	gchan->config = krealloc(gchan->config, config->peripheral_size, GFP_NOWAIT);
-	if (!gchan->config)
+	new_config = krealloc(gchan->config, config->peripheral_size, GFP_NOWAIT);
+	if (!new_config)
 		return -ENOMEM;
 
+	gchan->config = new_config;
 	memcpy(gchan->config, config->peripheral_config, config->peripheral_size);
 
 	return 0;


