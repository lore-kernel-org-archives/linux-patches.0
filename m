Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126CE246335;
	Tue, 20 May 2025 13:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749233; cv=none; b=evEJwwluXT6YMAvvmuUKAZ1pi7FNwPc90EDXfYWYzHVXXhHni1zvbaT/rgVI1g28TV74/q2XgYlL+x9gIwkEDmcmmWestr4hww8MHxcSBp7e+tQT3OPOIzqCql8pHHfs+RGHhPYY8DzMgpqZo2+bl0OcopaEoGZO2wODfc40D2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749233; c=relaxed/simple;
	bh=9vxIbJsW3JoD5mox7TBu8b4V68sPF8uLkIwY1QeGkY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOAPf/+RyEMRLYdeOwbB+CV7aE0QatoDoxjzFByJdMAI/k3jAwZIFMrVLe2i7Z8eEHTpgG+XXmcmNx0aMu7ZVfVkNJjjePsGvXS+xFeE0cDqmbbzsOfiCyFNenkJPtFYZARb8vaGTufeuSL+D49oDHO5Ua3eZSwGY5+1k9U477E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mc/t0diT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mc/t0diT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06230C4CEE9;
	Tue, 20 May 2025 13:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749232;
	bh=9vxIbJsW3JoD5mox7TBu8b4V68sPF8uLkIwY1QeGkY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mc/t0diTsUCL1RmV5muhtgPsKuyzdFovMe7mlmVayH33CoeplDuZFJst9JK5XMB3p
	 UNazeVM9oWy0gdxPB6CWRn2hRU009hTIDvuMSUmrWtlAws+IwQ4BXN0NOBQmsazR8v
	 Fms7W7RTYlySCVIcAtKz7Dbv+xPEHD2jH7pi+9j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathan.lynch@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 30/59] dmaengine: Revert "dmaengine: dmatest: Fix dmatest waiting less when interrupted"
Date: Tue, 20 May 2025 15:50:21 +0200
Message-ID: <20250520125755.055077179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -828,9 +828,9 @@ static int dmatest_func(void *data)
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


