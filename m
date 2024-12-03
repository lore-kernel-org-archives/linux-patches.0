Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4469C20B1FF;
	Tue,  3 Dec 2024 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240088; cv=none; b=kruAKFT5ANXsbWrJI2GamgEdPwp0y1rHdsSu/PP8HTmv38S3oCYW997n9RvdYZE/I2yuW/muO6wWD56hr0uRfOIEFG/Jp6NfTu5zjTvueeMqc2OIwKNWDGsQMdp8h6RSDnGYTVeHPeYFkShuHKu0zyjG74wCRHkKpIUo/Fq+1G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240088; c=relaxed/simple;
	bh=PfwNBCON4l98BqWbOAzktifPfe86rtru5kMLPmNane4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSnXhR8TMdmEls3SqsECtwcBMwDHf18gFkKn2I/x4Mk2Pqe1LSyBiw6elbxLztq92C57mJnzUdzFY0YZxnJOpnx9hJjLkNLxdK3WSJ8iZPi1G9ML9YE1CS3mnX1iOUzy/mivCRLsTUaS726Jod3h3y7tCVsDbKHk5kmk3WfFL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqcUIuYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqcUIuYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFA3C4CED6;
	Tue,  3 Dec 2024 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240088;
	bh=PfwNBCON4l98BqWbOAzktifPfe86rtru5kMLPmNane4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqcUIuYNyCaXAO3MmYfoivDLHgxGwtySV8j3ItMSn1vMkqCB83nZ+SQrOvIpPO9kq
	 l5uU+pAagT1f4nUCDryPsoMKsxsOZlRrwq0iMDMk0a/sZCGOzEO/hg8X9W+Rc2eztP
	 Q6Vg9JLtem4wNAo/fIQIEzthFgverL7RXsg3Z2Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/826] s390/cpum_sf: Fix and protect memory allocation of SDBs with mutex
Date: Tue,  3 Dec 2024 15:35:46 +0100
Message-ID: <20241203144744.208755180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit f55bd479d8663a4a4e403b3d308d3d1aa33d92df ]

Reservation of the PMU hardware is done at first event creation
and is protected by a pair of mutex_lock() and mutex_unlock().
After reservation of the PMU hardware the memory
required for the PMUs the event is to be installed on is
allocated by allocate_buffers() and alloc_sampling_buffer().
This done outside of the mutex protection.
Without mutex protection two or more concurrent invocations of
perf_event_init() may run in parallel.
This can lead to allocation of Sample Data Blocks (SDBs)
multiple times for the same PMU.
Prevent this and protect memory allocation of SDBs by
mutex.

Fixes: 8a6fe8f21ec4 ("s390/cpum_sf: Use refcount_t instead of atomic_t")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 5b765e3ccf0ca..3317f4878eaa7 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -759,7 +759,6 @@ static int __hw_perf_event_init(struct perf_event *event)
 		reserve_pmc_hardware();
 		refcount_set(&num_events, 1);
 	}
-	mutex_unlock(&pmc_reserve_mutex);
 	event->destroy = hw_perf_event_destroy;
 
 	/* Access per-CPU sampling information (query sampling info) */
@@ -848,6 +847,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 		if (is_default_overflow_handler(event))
 			event->overflow_handler = cpumsf_output_event_pid;
 out:
+	mutex_unlock(&pmc_reserve_mutex);
 	return err;
 }
 
-- 
2.43.0



