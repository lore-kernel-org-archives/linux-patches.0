Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585761;
	b=skrmgE44ogtftWMhZemfa3oYkWQwg7nULrLmF2D7TMFYjAfEdkR5cSTWJMNsWlfz2cEt
	 IjhQW948UMu9AN2PxvExjGHxMnt9+0BWOGVm635Lu8HSEzeT0cOq5rk2SB9W5Yyq4Am9C
	 QsbUrUk4JzmPelWltA4wNKBm7UZJxZjt/vjAv1vkgS1qtJ0ki5EfTI9x2OzHdo35AD7Th
	 7L5LYa3tKIdd0mOjc9AZjKDR/0ksSUOlAqArqLhnsUcpnAazfFVVmbAnXb5NgvtYz/e4I
	 b64K+WCixBuByOj738o7ldEg28pDw6swc7sza0d4pzmEpHXQMT+uVu0ImF0Czq0RBwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKsLhD932BcS2Rp66lYjp5y0bk4ZwZn+DDG7Eg9exL8=;
	b=g9Kit5ZObWtAhSvcgQ/Olz3C+Nznt0A6R4WmEgmwMTAGt/5GgOI9mlTfJ67EwDTXeeqv
	 eoF1491mvjNYsgn2bNQEsQF93ivNaaXo+rQDLYxspPgb4VEzUPtTE/j6ygk0wvlqbVEbB
	 srW1ykTWpDS4G7dnoJ5y8pyiHT/2weEygcJgE0WM8/8oIBosOMRChw4L3O8FbSed1zLFn
	 /a35VaihyWD9BY14bC3ojjJWxzrO080ELj23bksLSLGixPnM4bNqqaeipftFqRMWP/Trm
	 e3bH0UK6U5tnCSvDKQbd3AlZGz5ORSrnPJdenzDf5gZ9+bSIP8HEIz3wuXbFYmoTPnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itNpdax6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ED2606A334;
	Fri, 13 Nov 2026 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itNpdax6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD6B1F000C4;
	Fri, 13 Nov 2026 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585761;
	bh=rKsLhD932BcS2Rp66lYjp5y0bk4ZwZn+DDG7Eg9exL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itNpdax6/jhPW6afWZXq9HK+vnH3G6aYxGcLMhc7sdK9WXGNdX5qLTsChNV8olQ26
	 xN5hSWfJyri+u0uWf1caPrUae6grDlJvHsNuw8PYyxqfCqPaBLmDmClhi5EASBMPkG
	 TI42SklephNNkHXrlQ4T1H/d3IYMCD7BXyXhyGJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Dariusz Marcinkiewicz <darekm@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 354/507] drm/amdgpu: check amdgpu_vm_ready() in dma-buf move notify
Date: Fri, 13 Nov 2026 10:50:58 -0500
Message-ID: <20261113153807.511003057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dariusz Marcinkiewicz <darekm@google.com>

[ Upstream commit 920ca822f527e45ce084b36f3c420b625eb7c62a ]

amdgpu_dma_buf_move_notify() touches the page tables without first
calling amdgpu_vm_ready(). When a process is SIGKILLed, its VM entities
are stopped. Teardown of an imported dma-buf then tries to clear PTEs by
submitting to one of those stopped entities. That eventually hangs the
task.

Commit aa5fc4362fac ("drm/amdgpu: fix task hang from failed job
submission during process kill") added the stopped entity check in
amdgpu_vm_ready() and used it in amdgpu_cs_vm_handling(). That did not
cover a call in amdgpu_dma_buf_move_notify(), what was already mentioned
in:
https://lists.freedesktop.org/archives/amd-gfx/2025-October/133076.html

Tested by SIGKILLing a GPU workload holding imported dma-bufs. Without
the patch "Trying to push to a killed entity" errors are logged, then a
task hangs. With the patch there are no hung tasks. This was tested on a
6.18 kernel.

Fixes: aa5fc4362fac ("drm/amdgpu: fix task hang from failed job submission during process kill")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dariusz Marcinkiewicz <darekm@google.com>
Assisted-by: LLM
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bee5c9d7a34cb1b510ad3b4c18c30f9d38b0ab7d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index 9adf3eed8822c..ccadbcf38d3fb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -547,6 +547,11 @@ amdgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
 				continue;
 		}
 
+		if (!amdgpu_vm_ready(vm)) {
+			dma_resv_unlock(resv);
+			continue;
+		}
+
 		/* Reserve fences for two SDMA page table updates */
 		r = dma_resv_reserve_fences(resv, 2);
 		if (!r)
-- 
2.53.0



