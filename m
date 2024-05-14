Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2991257CBC;
	Tue, 14 May 2024 11:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686935; cv=none; b=CpnOrGBXhjzQ9hl3Ph6TUO4ugHn1vzxgnlooiY77hvucE6EdoA9OUtRQ7ZhcBgEvf3A721CvQ+3uFxVvyl1gEt8ZwNWmf0lDbJTJJMYqpUaezi0EMjFgmWkgoEz0vHpoz3Lj2bT8NqeAMUtMC73N5ouFq+JOWgGe8t6sCFvA6lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686935; c=relaxed/simple;
	bh=YmwHUznoiKUGY4titB40+s1gIfg7Q8NahNMfAsT7fHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1QylNLbgfcvRovQ/RxgRd2c5NEH8ZJhP6B/Vi6eXPMOQMd0aM5hK2ydHKAnuRAYE1gsEHs+PG02oThxKSwPF3lLGOUNjp41I+5HUnciTNNn1mApPmroCQK/2G51/yw+Z1fB+Zja2ZXoudOlOl/ddI0que0Gh1uHnK8304dQpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pv/hf8uB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pv/hf8uB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D6CC2BD10;
	Tue, 14 May 2024 11:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686935;
	bh=YmwHUznoiKUGY4titB40+s1gIfg7Q8NahNMfAsT7fHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pv/hf8uBNbxlA2IrfQ5xmk6m2HKKgkUyGjZ9XSGLSF/nktLa5zF6ZdwQHL8z8Hfui
	 T/iMLVFT0qFVUtad7Ec79SgrADpFi3tfr+/+IF/AYG8Tn39B/IuRdnUbNKch+1258u
	 PPf5IBKNm8NALl5TaDfwxRviWsrlGhC3hBOYML1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bumyong Lee <bumyong.lee@samsung.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/84] dmaengine: pl330: issue_pending waits until WFP state
Date: Tue, 14 May 2024 12:19:12 +0200
Message-ID: <20240514100951.744141191@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bumyong Lee <bumyong.lee@samsung.com>

[ Upstream commit 22a9d9585812440211b0b34a6bc02ade62314be4 ]

According to DMA-330 errata notice[1] 71930, DMAKILL
cannot clear internal signal, named pipeline_req_active.
it makes that pl330 would wait forever in WFP state
although dma already send dma request if pl330 gets
dma request before entering WFP state.

The errata suggests that polling until entering WFP state
as workaround and then peripherals allows to issue dma request.

[1]: https://developer.arm.com/documentation/genc008428/latest

Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Link: https://lore.kernel.org/r/20231219055026.118695-1-bumyong.lee@samsung.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: afc89870ea67 ("dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 1d7d4b8d810a5..d12939c25a618 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1051,6 +1051,9 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	thrd->req_running = idx;
 
+	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
+		UNTIL(thrd, PL330_STATE_WFP);
+
 	return true;
 }
 
-- 
2.43.0



