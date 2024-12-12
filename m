Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43DE22966A;
	Thu, 12 Dec 2024 16:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021334; cv=none; b=NknNViEszELlrffKeXe/TOYXDSIwS73Ejn89CWqBd6p2Jik8oR9e+D3fxb2XTrDO5/Y7b1mY8uqpjk4+dO1Nl5TGAeGC5SXrzNxoTOgifsdU4P6Bxx3LVRJMD7dJhmkqT8CA53JdC3Blp3ixI1ap8To+c3dUCxgF3dC/fnkqhmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021334; c=relaxed/simple;
	bh=gPcrefA+Y9WdUZuIDyAwL5gqyxbFGkuyZsctx82NU7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0vlSv1eLWH7CFqVQEyzS5Kljw9jd6qgSNSv2FFi+9zgfO4BtsRvVNG8DKGiYu03FfHbZyrzeIlEGDiRHgxh9OygmSjKmjw8J633AttFiXz/WB0iY83XhgSxqDCzoRhnCfN1co7ftjV1hLlXOmP/LJNNgFToj+ibh4oJ5qNzpnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qlx9Pl8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qlx9Pl8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B6BC4CECE;
	Thu, 12 Dec 2024 16:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021333;
	bh=gPcrefA+Y9WdUZuIDyAwL5gqyxbFGkuyZsctx82NU7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qlx9Pl8B2FKCD/aoJK+QQDqUEfz0MC3Ksxkx60eG7Qy4h5WmlxRGhMh76txMGX411
	 n5V2Djts+uQxTXZaatIYWZVZhAdyhonmsMn4PMTHWvptW4vowdKcIJh9bN2LmRWcYK
	 a4HwFXz6B41cEgQfZqtIsEIccvjNDsdjZMcE5OW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Nikitin <denik@chromium.org>,
	Levi Yun <yeoreum.yun@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 682/772] dma-debug: fix a possible deadlock on radix_lock
Date: Thu, 12 Dec 2024 16:00:27 +0100
Message-ID: <20241212144418.096013976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Levi Yun <yeoreum.yun@arm.com>

[ Upstream commit 7543c3e3b9b88212fcd0aaf5cab5588797bdc7de ]

radix_lock() shouldn't be held while holding dma_hash_entry[idx].lock
otherwise, there's a possible deadlock scenario when
dma debug API is called holding rq_lock():

CPU0                   CPU1                       CPU2
dma_free_attrs()
check_unmap()          add_dma_entry()            __schedule() //out
                                                  (A) rq_lock()
get_hash_bucket()
(A) dma_entry_hash
                                                  check_sync()
                       (A) radix_lock()           (W) dma_entry_hash
dma_entry_free()
(W) radix_lock()
                       // CPU2's one
                       (W) rq_lock()

CPU1 situation can happen when it extending radix tree and
it tries to wake up kswapd via wake_all_kswapd().

CPU2 situation can happen while perf_event_task_sched_out()
(i.e. dma sync operation is called while deleting perf_event using
 etm and etr tmc which are Arm Coresight hwtracing driver backends).

To remove this possible situation, call dma_entry_free() after
put_hash_bucket() in check_unmap().

Reported-by: Denis Nikitin <denik@chromium.org>
Closes: https://lists.linaro.org/archives/list/coresight@lists.linaro.org/thread/2WMS7BBSF5OZYB63VT44U5YWLFP5HL6U/#RWM6MLQX5ANBTEQ2PRM7OXCBGCE6NPWU
Signed-off-by: Levi Yun <yeoreum.yun@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index de02c0808fb83..3e6f2a39beb3b 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1044,9 +1044,13 @@ static void check_unmap(struct dma_debug_entry *ref)
 	}
 
 	hash_bucket_del(entry);
-	dma_entry_free(entry);
-
 	put_hash_bucket(bucket, flags);
+
+	/*
+	 * Free the entry outside of bucket_lock to avoid ABBA deadlocks
+	 * between that and radix_lock.
+	 */
+	dma_entry_free(entry);
 }
 
 static void check_for_stack(struct device *dev,
-- 
2.43.0



