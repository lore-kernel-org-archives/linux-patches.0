Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DEA1A1894;
	Thu,  6 Jun 2024 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683728; cv=none; b=rbTCt5fJ+9E1BsvRiU2Uo4fZgnPPagVrBBe0pE93AF713Tc3x6I7UZs1tweWH8+ThKWQXNWriOfsC0yWEwMsmVrDcP8Ced4L3y1xY9Drrxo454Eme1Tmpt3YD6foN8B/zCqxWGXmfDomxHQ7AHptyRaR8JSR9OpL7hSkB14Dd8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683728; c=relaxed/simple;
	bh=T1q0HYYCgsrpuKLdqC6DjK4HtTWtI9aV0EPa/Uoczkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/ixA8HZV2VqaUpOHmpucx+5uQe6ogaiNybf3EpLG+9Azvmle52b42prfGFSlsOAqJnMGzvXhY2vKGBVMYcQRena+7g2LhcWHVijzI9qEoLmqG2vofnYDtt1vlHob0phJlaDyNJmMvGBgHaCUI5j8PiptkzuTI0DFByQeOZKhhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+QAe+FI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+QAe+FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FAEC32782;
	Thu,  6 Jun 2024 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683728;
	bh=T1q0HYYCgsrpuKLdqC6DjK4HtTWtI9aV0EPa/Uoczkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+QAe+FIRtBSCGOc+h9rhy2KbR97LVSmlpkVN353oRxXbk393ItRjgC9bLEXwIDGk
	 T1TD80BG0N9Cso0XxKM6/L8JyGlioE0HFpohUu4LjoJCfvpAQSyjQu/zQD9WrvtfTo
	 4xSebdWDKq34qu6UjSiEhlpY+oB1xIdHyzhWIFXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 677/744] dma-mapping: benchmark: fix up kthread-related error handling
Date: Thu,  6 Jun 2024 16:05:49 +0200
Message-ID: <20240606131754.213763170@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit bb9025f4432f8c158322cf2c04c2b492f23eb511 ]

kthread creation failure is invalidly handled inside do_map_benchmark().
The put_task_struct() calls on the error path are supposed to balance the
get_task_struct() calls which only happen after all the kthreads are
successfully created. Rollback using kthread_stop() for already created
kthreads in case of such failure.

In normal situation call kthread_stop_put() to gracefully stop kthreads
and put their task refcounts. This should be done for all started
kthreads.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 65789daa8087 ("dma-mapping: add benchmark support for streaming DMA APIs")
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/map_benchmark.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/map_benchmark.c b/kernel/dma/map_benchmark.c
index 02205ab53b7e9..2478957cf9f83 100644
--- a/kernel/dma/map_benchmark.c
+++ b/kernel/dma/map_benchmark.c
@@ -118,6 +118,8 @@ static int do_map_benchmark(struct map_benchmark_data *map)
 		if (IS_ERR(tsk[i])) {
 			pr_err("create dma_map thread failed\n");
 			ret = PTR_ERR(tsk[i]);
+			while (--i >= 0)
+				kthread_stop(tsk[i]);
 			goto out;
 		}
 
@@ -139,13 +141,17 @@ static int do_map_benchmark(struct map_benchmark_data *map)
 
 	msleep_interruptible(map->bparam.seconds * 1000);
 
-	/* wait for the completion of benchmark threads */
+	/* wait for the completion of all started benchmark threads */
 	for (i = 0; i < threads; i++) {
-		ret = kthread_stop(tsk[i]);
-		if (ret)
-			goto out;
+		int kthread_ret = kthread_stop_put(tsk[i]);
+
+		if (kthread_ret)
+			ret = kthread_ret;
 	}
 
+	if (ret)
+		goto out;
+
 	loops = atomic64_read(&map->loops);
 	if (likely(loops > 0)) {
 		u64 map_variance, unmap_variance;
@@ -170,8 +176,6 @@ static int do_map_benchmark(struct map_benchmark_data *map)
 	}
 
 out:
-	for (i = 0; i < threads; i++)
-		put_task_struct(tsk[i]);
 	put_device(map->dev);
 	kfree(tsk);
 	return ret;
-- 
2.43.0



