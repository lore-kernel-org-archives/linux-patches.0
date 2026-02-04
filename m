Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51692D9484;
	Wed,  4 Feb 2026 15:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219245; cv=none; b=olotm5bokLqT3sI4p6OJQg9whEwmg/YXJ3SMFjUeixVHjRx41Tuq6jsF6tfP0GBvtsKHMdj2MM/r/mXbCV5KJ670ZXnb16QA3wK7go7fO4ftUjElDxXFuGxTx6yCYbsbTp/zVPWVhEXI2R93dbOmqRvPPkL2VSrPCUyhT5j103Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219245; c=relaxed/simple;
	bh=06/TSD7vddic14o+UZK5cuNjSt2us3kw+iUwzuXajNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yu0FQalQQI8y9DzITRvjoCD9gaqSvNAG8lLHFn9ci+ClzqmVZzTq1TYjtK7vanZ8gzJLIdLwYDKB0H9sgrRzDIUDw9vcAiWkoTP4ZgWvMNT1LjHq1KxRwUeRSr81GeHsBPxmXTNBrSsf9Il6t0bMQ7U615YpS9gUbU1TlC2a0Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXPlCMEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXPlCMEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8A3C4CEF7;
	Wed,  4 Feb 2026 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219245;
	bh=06/TSD7vddic14o+UZK5cuNjSt2us3kw+iUwzuXajNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXPlCMEZBIVd9F0wERwoiKikGtu5m+4MY+JPs37F7Owm7z7vcV0wPrXdcvj91Jcwo
	 3qeO2rICEIUvHK53YoWXJ5oXP9gRmq4xZojHXkU3ygu0mpyXtaQ0QppuMg5ZB9p98v
	 2Rxic7MCHkCrR9eLVgRHps/nDKKrQM0RSITrlwLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 111/122] drm/amdgpu/gfx12: fix wptr reset in KGQ init
Date: Wed,  4 Feb 2026 15:41:33 +0100
Message-ID: <20260204143855.846939152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9077d32a4b570fa20500aa26e149981c366c965d upstream.

wptr is a 64 bit value and we need to update the
full value, not just 32 bits. Align with what we
already do for KCQs.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a2918f958d3f677ea93c0ac257cb6ba69b7abb7c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -3078,7 +3078,7 @@ static int gfx_v12_0_kgq_init_queue(stru
 			memcpy_toio(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
-		*ring->wptr_cpu_addr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 	}
 


