Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F4F34BA44;
	Wed,  3 Dec 2025 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777705; cv=none; b=T03Y4WyXTIriENxgUVneVVPP8X1gJVjj6GBVGjaRpoQkuH83+RSBowhpG14iVLV8mKjgbQ4qBzxlnv/R7UPIgCIM6yxz39Q4VE0RVGFlesmr38pMdireSZwuF3X4ZIDYmThmZWW3G474w3gQbFmg2+K4ZA3tninIF48zNCwKzts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777705; c=relaxed/simple;
	bh=hRVEmG8t4SjnPKUuEuYOJCs9WwSxa5K4vh1XlEAGki8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAGKAbioxYQO2x5M6DxYdXABjOeZdmlBtDBnfeDpPxPxTOJ6PusvJAqIB7DwyvP49PY9I9XE21ZTSTXq0r/VPJQiIcxkUf2Hww2lKDKzu+dTX2l8fgO6XcpcKH6HvHB7QJxavX7SU0nwLp2PeAEUFPi1RFDoxnP2rVDpN9qmPIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIH3xqL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIH3xqL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D236AC4CEF5;
	Wed,  3 Dec 2025 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777705;
	bh=hRVEmG8t4SjnPKUuEuYOJCs9WwSxa5K4vh1XlEAGki8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIH3xqL4SwQP2Cad6jcHCTw+XNYbvVBIZk8bTbDyK7Nc4K3cd4AqWc4mXXnJeUbOB
	 KS6+PFPcet6SzgoXC2fDi91ETxsI49ntTNSRnv0zKXzPhNoqUqsoUHVWXZU4A0JCow
	 ReTdxZ/cO7Jo/19VkVTa2+urOdeMq9fKhglOxGIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/392] drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption
Date: Wed,  3 Dec 2025 16:24:30 +0100
Message-ID: <20251203152418.510065493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 47ec820cae72b..2cf71155a7184 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -109,7 +109,14 @@
 
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



