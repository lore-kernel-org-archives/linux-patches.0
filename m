Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969B22472A6;
	Tue, 11 Nov 2025 01:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823503; cv=none; b=WqcDjpYnEqr+9Sf7L3piRSuCn6gILxWBP3w3LQzt1ahy39FPg263Mr79aVtVkNHJc8YUCbPY7XKhKGoxxO9oGT4tJbFQdYTyM4LHL6RmUIrlRtOU3Kn6D+3peWVAbV075kMolF5odQqV2oNr5YyAvIsMI2bXRPU12jpixEnC6wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823503; c=relaxed/simple;
	bh=cTMhbSbDAfMPNSOim0OmA/52SHKXNP6ReOc7zH1OVDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj+Yjd7c/f9xaL8Urb9xENGk8uPg4WAHPUjqdRzzVm2ccwuKPbuxrimohxutwEUUABfUvfbZzQ+IpyZY4a6u8OW31/tcMwlPoigU0sGEdd4fHogzBIaqqjBcHon5WIxdleEmomqKsLL9Pv50h7bbwPjr0KvMO3fHSkKqHJCxq5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aV56JjKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aV56JjKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CCEC19424;
	Tue, 11 Nov 2025 01:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823503;
	bh=cTMhbSbDAfMPNSOim0OmA/52SHKXNP6ReOc7zH1OVDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aV56JjKjq12Wfc/jOs7LRmRvUlksQTTaAnCWFoDWlUZD+pooI3IV2Y8I1dgzfzXLO
	 fLowHtZSAQfowviCj85C+a9LLmBMmIM+FcKacia4zRUEY0Tr9c62idtQRdk3+xZq5W
	 Vi36p/QVF8/NVaO8rSdd/Z4mWfIsCQ1NTyIZFVI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/565] drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption
Date: Tue, 11 Nov 2025 09:41:55 +0900
Message-ID: <20251111004532.722993847@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 75523f30cd38b..5041860e2737c 100644
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



