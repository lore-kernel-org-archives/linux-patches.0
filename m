Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E27524A04A;
	Tue, 20 May 2025 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750604; cv=none; b=fMZp/9cwWbJRIEDIa6hOh98zgj/2t0vjhGMCnF+KV4MIxZxddtpGVUOmysFzPFbrqvGIc3yvhdkvD2EeXaRZTFFrAyxuXemLBDKeq333agffd9eGJo/ZxJzuoxN2KQRd1D8btrXMY3vzWlx4IZyP+rAd1cn/+JQbvlVHhX+a8pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750604; c=relaxed/simple;
	bh=Iy5WWRAQOR2z3dZP97USklvob/VyAmWMZ13Mgoljs2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVajRFYYjUezMaD1BMmex0xZfSEdr/CMbx/i3l+ft7vfXA5+ScR42H4b1TAicrRvoR+RyQt6Kdm/f2+i+4H1S9U19eRHjoV5qRxSnq138WCPnsNvp/Ru1NaxqdyFWNPB/nTN+6ynI224bp3I5e9R3am2xr+ZKFnPcmoGRV8mW74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0O74TXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0O74TXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF760C4CEE9;
	Tue, 20 May 2025 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750603;
	bh=Iy5WWRAQOR2z3dZP97USklvob/VyAmWMZ13Mgoljs2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0O74TXK6Jcb/swyn2v/KV/DJt1dJ97ON8dlwLRrsRPiZlK+L1Tj8gQiJQpLP8GL+
	 i+0dIzuAu7uCsUau1dFZzBW95HpBntRnUCT+FW+gXrVk5WnZC2OC3EXOt4Hii4QYsS
	 ExD0/rQfycOyHvvJ2eaXVz54to3Oq1gMHiaMWwFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathan.lynch@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 062/145] dmaengine: Revert "dmaengine: dmatest: Fix dmatest waiting less when interrupted"
Date: Tue, 20 May 2025 15:50:32 +0200
Message-ID: <20250520125813.011066813@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -841,9 +841,9 @@ static int dmatest_func(void *data)
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


