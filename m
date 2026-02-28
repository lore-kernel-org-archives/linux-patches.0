Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AA44BCAB0;
	Sat, 28 Feb 2026 17:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301362; cv=none; b=T1rhlaXy3XgpEm7mr3pDgqfhjnyjwlstQMPQBPm+7N8od8ZKF+yexMb+0ISciNFC+y1KGgN+KWmWPOEgkkxR3TGaspjvIjDQUuODUz0Ik5z0W393Ij+exJLMd5jU0FfuUrEv6JDLwXnL7w4oV4R5jXFdsKzggJcfA+l97rJxt04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301362; c=relaxed/simple;
	bh=dTle06lUXDk7SlT5K/JGW0wMzFUKzTs8xoOQno5za78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7MumSOh8jG6dvz7m+baUAAKTWLnZ7aRRz3sWkJGxTiL7OLYmSjDQdX+pWJfrws2jFkkuJHVGT1wpona8kiVUQAiz1wx3TIGxl74w2mmIZKDOi7gmn997hQdOeimy7KWC0i52blwMpTGgULxWxX9ZmZZkwb/Ssucz2RprE5qrB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvyx6iRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvyx6iRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B806C2BC87;
	Sat, 28 Feb 2026 17:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301362;
	bh=dTle06lUXDk7SlT5K/JGW0wMzFUKzTs8xoOQno5za78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvyx6iRl5AENPh10NpAYwn29JGiXg4HY9FN17i077hl6GqngZdo8Sncm2+SNz1+1u
	 35pUfT8A5AiIv76P75kTWSYA8mkjK5CzfdwiLRavG1MvEeTmJNamRadAuOerTERGVM
	 FdsmdwLDaJ1MjYYva1nfKLFrIZ7D+8+e67LHnWiEyxd07f+WpyzwxP/QUGZ067O5Vk
	 BZJwuIeeIUiLGNpfwBJjV8hU/kyrsisT5B+8wQaRYR2Y+xHK2yY2o/rcmF3oTz0u3O
	 bA6KoEWcLI7zfuB/7pcp55iUquCBC3iYMRkZj0amTkSqvsUDuMgRRAn5edCQLuGsZO
	 pULrCtnNKBzmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alain Volmat <alain.volmat@foss.st.com>,
	stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 550/752] media: stm32: dcmipp: bytecap: clear all interrupts upon stream stop
Date: Sat, 28 Feb 2026 12:44:21 -0500
Message-ID: <20260228174750.1542406-550-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 222f1279edd9008ee35b62de156ddac84e31443c ]

Ensure that there are no pending interrupts after we have stopped the
pipeline. Indeed, it could happen that new interrupt has been generated
during the stop_streaming processing hence clear them in order to avoid
getting a new interrupt right from the start of a next start_streaming.

Fixes: 28e0f3772296 ("media: stm32-dcmipp: STM32 DCMIPP camera interface driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
index 1c1b6b48918ee..b18e273ef4a3e 100644
--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
@@ -512,6 +512,9 @@ static void dcmipp_bytecap_stop_streaming(struct vb2_queue *vq)
 	/* Disable pipe */
 	reg_clear(vcap, DCMIPP_P0FSCR, DCMIPP_P0FSCR_PIPEN);
 
+	/* Clear any pending interrupts */
+	reg_write(vcap, DCMIPP_CMFCR, DCMIPP_CMIER_P0ALL);
+
 	spin_lock_irq(&vcap->irqlock);
 
 	/* Return all queued buffers to vb2 in ERROR state */
-- 
2.51.0

