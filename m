Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4B72459DA;
	Tue, 20 May 2025 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749422; cv=none; b=N/k3S4daICVDBevoFCiTh9Ffyqefu+K5wtR4bWFHjRlkZq38QPzHdR8p5klgDUAuDK0OZhk2hPIDMUny6Fo6R1g6gbqZ1AQsBgLpbH5zA7cbt1upY9WDR/YLFJyV2dBU0fuz8n1d0mFeCB85ELjK3+43foitZElzXUrffIai570=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749422; c=relaxed/simple;
	bh=3B2cRyrpTLalrkrhLy8h3HJt3qe4BV2qG+BZroVkrfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8TqLaY8OsF2s4QCyrmk7eEaM5ajQ5VjnWQJffhl1leIPHpeF2LMOKjklTzmnMx10fYVjXxF1Cmqz60ViqTJnItlt2cJq0D3rQE6OM0I2f1A+L2fWEcK1FVKBSFdBuHcNWiqlUhQMVuAc7kQrSEQWjcJlOt/BwOglPDjYuty7ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6DdNt+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6DdNt+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F2BC4CEE9;
	Tue, 20 May 2025 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749422;
	bh=3B2cRyrpTLalrkrhLy8h3HJt3qe4BV2qG+BZroVkrfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6DdNt+wOqEidLg1WVPHO6zG+CkmuuwsY4MGIpnHnYiNk6dnfcUnjkBIsPWa8BaIg
	 aHhvVgMrTFcjfcYmVmpgGjZUV4YtMZkt/61M2PBpOboV4KFiKvWV3Myu0LDKJbUsoR
	 QlqJ/d/XJ1SJApLX0PFotoW/cy1Pz5SFlDCqMhAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathan.lynch@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 40/97] dmaengine: Revert "dmaengine: dmatest: Fix dmatest waiting less when interrupted"
Date: Tue, 20 May 2025 15:50:05 +0200
Message-ID: <20250520125802.231790569@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan.lynch@amd.com>

commit df180e65305f8c1e020d54bfc2132349fd693de1 upstream.

Several issues with this change:

* The analysis is flawed and it's unclear what problem is being
  fixed. There is no difference between wait_event_freezable_timeout()
  and wait_event_timeout() with respect to device interrupts. And of
  course "the interrupt notifying the finish of an operation happens
  during wait_event_freezable_timeout()" -- that's how it's supposed
  to work.

* The link at the "Closes:" tag appears to be an unrelated
  use-after-free in idxd.

* It introduces a regression: dmatest threads are meant to be
  freezable and this change breaks that.

See discussion here:
https://lore.kernel.org/dmaengine/878qpa13fe.fsf@AUSNATLYNCH.amd.com/

Fixes: e87ca16e9911 ("dmaengine: dmatest: Fix dmatest waiting less when interrupted")
Signed-off-by: Nathan Lynch <nathan.lynch@amd.com>
Link: https://lore.kernel.org/r/20250403-dmaengine-dmatest-revert-waiting-less-v1-1-8227c5a3d7c8@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dmatest.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -827,9 +827,9 @@ static int dmatest_func(void *data)
 		} else {
 			dma_async_issue_pending(chan);
 
-			wait_event_timeout(thread->done_wait,
-					   done->done,
-					   msecs_to_jiffies(params->timeout));
+			wait_event_freezable_timeout(thread->done_wait,
+					done->done,
+					msecs_to_jiffies(params->timeout));
 
 			status = dma_async_is_tx_complete(chan, cookie, NULL,
 							  NULL);


