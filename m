Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3D8222D68;
	Thu, 12 Dec 2024 17:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023326; cv=none; b=oHaf+ENYcW/l6VwHCeqBQ0JbgrT29BfCxVdSLXPWjQmqWsNDRKK61kwpjF88SES/6KyLKF9H0fnTLV4nHZy3c05Eit5vqMJyUknMD1PRp9Mv33dpEbADqR+CjtUfkVN2xK7LwGJ9iHZdtcDRD7csIAtbb2jZW2OyavLeiG/LT1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023326; c=relaxed/simple;
	bh=8DiqBZC1/eydaoajg8Y0aWfalbXNuLPOiuLK+tS5lKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Foityc7jMD+FxDMWIYyB6umc8Lj/6VmA1gHJgixrt6P4u1SP+MaeKNiQ8M4zN5nsrj4kHn4ZW0VnxpHsXVMhiISDX99Zsz78RNnN/SpzFZwg247JTsylkOdg58+kE8gHw9tOFXNRNfX7HaPRbIt2i3NpK2DF0eRhqSrxBn18tfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfPSpnBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfPSpnBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8691FC4CECE;
	Thu, 12 Dec 2024 17:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023325;
	bh=8DiqBZC1/eydaoajg8Y0aWfalbXNuLPOiuLK+tS5lKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfPSpnBhEuGIxFWgDTYnBAxyi1vYFPVj34y1xwd17xn/1JtkS69hHVTsJE8S8SdCv
	 0v190WOdA/mPBc1sCpZwDTCeIAMt7ewPS4HER/1ry9yykHqBbHH7Khs6/W77Pmdb2k
	 a2jyuJOLUiP3SzYfirC/GCpOFBgNh7TrmKvAXVM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Nikitin <denik@chromium.org>,
	Levi Yun <yeoreum.yun@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 498/565] dma-debug: fix a possible deadlock on radix_lock
Date: Thu, 12 Dec 2024 16:01:33 +0100
Message-ID: <20241212144331.451234787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 09ccb4d6bc7b6..b3961b4ae1696 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1046,9 +1046,13 @@ static void check_unmap(struct dma_debug_entry *ref)
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



