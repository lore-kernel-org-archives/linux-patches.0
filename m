Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9D535292A;
	Fri, 21 Nov 2025 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732671; cv=none; b=h3nhl/ITGvgrzTCluZI/S1u2yOzuI0MIOf/Fwr6jt3vF9TfPuWDTu6j+rSbnhxnHQ2Ro7h6H342+3OwufmuHFLduSXtIpFCNrZkYyj3MNOS0rgnZVO4MhDgcVRqskAwxhdWrFPuVjlB+cCXHrt2pP13WvgA6ierZ6wOV1zMskd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732671; c=relaxed/simple;
	bh=83jt0dGDk5XRrYzXJNkCeeeETsVN+lBKJOrRdeNlYLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyTxu67m7LNgvow8ZZ1R0SomDhySSqo+qKLx2kOevK8zLGE6ZckJoyJW+oAuRcSRrcNtevIzkoFAEqNGTQxN0fY4ugAyc26U5QrKArAg2dEIN278H5LuREPkgdMyNDNVSl31HxIOFD84rNya/za7w1W8FILmfm36zgVnqBmyQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/D3szhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/D3szhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56787C4CEF1;
	Fri, 21 Nov 2025 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732669;
	bh=83jt0dGDk5XRrYzXJNkCeeeETsVN+lBKJOrRdeNlYLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/D3szhqMnAD0lMtKGp50s9spaao/Xmf1sq6uldj8iJXuFMk/fp+2uDh9qFheaLEv
	 JxGgEWju/YFaXDxyvjWBghhYO9cImkq4r8AoPzDMcAgxmj25NFhxhETuWUAtGBO0Qh
	 1d4yurdiBMf60+ZwGgyZNiXTCX0e6nRK6qrX2C1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonino Maniscalco <antomani103@gmail.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/529] drm/msm: make sure to not queue up recovery more than once
Date: Fri, 21 Nov 2025 14:08:20 +0100
Message-ID: <20251121130238.167741468@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Antonino Maniscalco <antomani103@gmail.com>

[ Upstream commit 10fb1b2fcaee5545a5e54db1ed4d7b15c2db50c8 ]

If two fault IRQs arrive in short succession recovery work will be
queued up twice.

When recovery runs a second time it may end up killing an unrelated
context.

Prevent this by masking off interrupts when triggering recovery.

Signed-off-by: Antonino Maniscalco <antomani103@gmail.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/670023/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 00bfc6f38f459..4654c0f362c7d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1702,6 +1702,9 @@ static void a6xx_fault_detect_irq(struct msm_gpu *gpu)
 	/* Turn off the hangcheck timer to keep it from bothering us */
 	del_timer(&gpu->hangcheck_timer);
 
+	/* Turn off interrupts to avoid triggering recovery again */
+	gpu_write(gpu, REG_A6XX_RBBM_INT_0_MASK, 0);
+
 	kthread_queue_work(gpu->worker, &gpu->recover_work);
 }
 
-- 
2.51.0



