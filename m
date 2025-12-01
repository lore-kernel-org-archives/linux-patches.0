Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A018B302CD6;
	Mon,  1 Dec 2025 11:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588492; cv=none; b=Tt/hLkim7jkIa9pP8jZ8EQ62MiW7LLApeJ2vzAEftKd4ZbdxEXQEVhoOhKFeMMcDAShFKtIov81FGgkOVcnzju/ksKKDXIB7xCWQvmf0/lMthyPJryTQ3o73QldNsKh9BhLt6Fx/SHFqHKtyqUwznwRCGtx2G46KrUrtnxqjWJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588492; c=relaxed/simple;
	bh=bLrfkfaibJxXz1VBv/I1PJRN0E6z0Zoklk5xjPbhA9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH8T/zNHtTKUWww0fyb6OlHyFNTSolfbVRqCKA3JUOfHrbIUFa6Av4ClpzxzlF0jUi0PoQ0BfqUY2dE8KkLJnIgSUw6mIX1Fhe79g4zaiJ38P4F/D5NRscBtsEGb4Dl0BWW2vdq4jSUL1WKcqIUb2CCLIDtNVV2y1G84zgA/IzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gG/C+W2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gG/C+W2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2348BC4CEF1;
	Mon,  1 Dec 2025 11:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588492;
	bh=bLrfkfaibJxXz1VBv/I1PJRN0E6z0Zoklk5xjPbhA9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gG/C+W2f+3XXpnWSqaPskN5F4+a5hG4GP2fj5eNNM8j+j8HnO32UuY+KtcevFuFq1
	 7F0ttHbgYfISHqaZK+TNBiXHGfjk0HrVF7sNooKWjeXqUGVgJTaN5FpMoAr2+bOrra
	 roHNGrQTPHU20FtryORFRpNDYgLqN2nJiDjwEGvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/187] drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption
Date: Mon,  1 Dec 2025 12:22:55 +0100
Message-ID: <20251201112243.660188735@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c89326125d711..f6012c378b46c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -105,7 +105,14 @@
 
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
 
 /*
  * 512 = 0x200
-- 
2.51.0



