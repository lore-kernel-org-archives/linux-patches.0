Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581C126E703;
	Tue, 11 Nov 2025 01:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823802; cv=none; b=lX3kpgdypUNMNN8GpOyaUUlI/Jv+w4X42V1Vb1wbEh1SpG53nEa6O/yX7Ln7RzgqqD9rlFNxVvNz6Ypzcg+/w7C7lritC6/ok7CKLa1GzxAYfINzTO7CUWo3oIEeDFO3P+BT9mpEK0x1anH4t1UCzRQHYkPPgeSsEVgOuE0mZkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823802; c=relaxed/simple;
	bh=fEkinqh0nEyfijRYdWEmUdE6MWwfIqsY4kgb+V1QQ5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfN3aL7tk0EQilLvB/SHyXOR6S+aBiJpL3SpupVSSK4WWt0G7BBVhg7qFAejQnGYoi3yOvGsEJtkWvHm/7+Otuvnv1WP230jLtDwi1EDgO2/A+vEkmjXHs578uXf0SlEnm4FWkkaJRF2aEbwMD6NZdXd/u/BXOoodDmxaKIZkoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kq9kkvjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kq9kkvjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA134C16AAE;
	Tue, 11 Nov 2025 01:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823802;
	bh=fEkinqh0nEyfijRYdWEmUdE6MWwfIqsY4kgb+V1QQ5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kq9kkvjLW7f2Kee8ddfjlIQn7VVEc19zskoYgp2afcCt9Wz4rCtUnPNNM52x66vMS
	 0i5o2eY1/xBVLVH/YXauwN6tlQF1fl7miUKQy52a/TPaMhMfn0ozADwMUbcoTerfmU
	 YcLn/I1DlBd0GAHcw9UWrDKa68hLwNlcY/Uw/wYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 375/849] drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption
Date: Tue, 11 Nov 2025 09:39:05 +0900
Message-ID: <20251111004545.498067657@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amber Lin <Amber.Lin@amd.com>

[ Upstream commit f3820e9d356132e18405cd7606e22dc87ccfa6d1 ]

When KFD asks CP to preempt queues, other than preempt CP queues, CP
also requests SDMA to preempt SDMA queues with UNMAP_LATENCY timeout.
Currently queue_preemption_timeout_ms is 9000 ms by default but can be
configured via module parameter. KFD_UNMAP_LATENCY_MS is hard coded as
4000 ms though. This patch ties KFD_UNMAP_LATENCY_MS to
queue_preemption_timeout_ms so in a slow system such as emulator, both
CP and SDMA slowness are taken into account.

Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 67694bcd94646..d01ef5ac07666 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -111,7 +111,14 @@
 
 #define KFD_KERNEL_QUEUE_SIZE 2048
 
-#define KFD_UNMAP_LATENCY_MS	(4000)
+/*  KFD_UNMAP_LATENCY_MS is the timeout CP waiting for SDMA preemption. One XCC
+ *  can be associated to 2 SDMA engines. queue_preemption_timeout_ms is the time
+ *  driver waiting for CP returning the UNMAP_QUEUE fence. Thus the math is
+ *  queue_preemption_timeout_ms = sdma_preemption_time * 2 + cp workload
+ *  The format here makes CP workload 10% of total timeout
+ */
+#define KFD_UNMAP_LATENCY_MS	\
+	((queue_preemption_timeout_ms - queue_preemption_timeout_ms / 10) >> 1)
 
 #define KFD_MAX_SDMA_QUEUES	128
 
-- 
2.51.0



