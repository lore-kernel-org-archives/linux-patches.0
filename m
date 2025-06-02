Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0805219EEBD;
	Mon,  2 Jun 2025 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875368; cv=none; b=hptU8NXF/Zx4QWjacQl/gwxGe4Cm/qEbOSlJrNBO9ngMDApc2VOvqJ/ZOBLJcxGLy8hWOlj1i310FdymIbts0tFXTZH/wLUTGNWq7pN3zEPfL57BaPNnQjs5h9WCopsGs5V15PbxbJHDVbHtsAJvEWxx1KLHt7acaQQeix5AMk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875368; c=relaxed/simple;
	bh=7H85x1unmjANEZ9lrm01GebyVNaB+jv1F+Z17sVLZ28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVIo8XZE+xiqSdp7d1S7H3MEEjggafytb+Qoqt7oWzAAyEYrME/Mt3wtc6O+MKR4rn0t+cANQ7olYPlS80tkMBaWDV3Up4fyp1V0X1H08EhSjWlMkiTddxOMMRV6nux0FaxRjdM4fgpnRGk2UC47sYuaI67kidlx7+MjGHikKHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxYj6mD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxYj6mD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB35C4CEEE;
	Mon,  2 Jun 2025 14:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875367;
	bh=7H85x1unmjANEZ9lrm01GebyVNaB+jv1F+Z17sVLZ28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxYj6mD4fQT6X4MK9nUm74dQ3eYZZJ9skGiAS/SVSoopKX+3QdzCn2GKrM63L2XKQ
	 b4svYcWySJVD3bLv/Ce387Byqneq9XtaQY/aDIhZ4lqZ44GbkN34HGc6BW9BS0W3lI
	 N15UfKWeEtKFZTjlvmicoZR7cIdgLqb3YLgvTgRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathan.lynch@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 095/270] dmaengine: Revert "dmaengine: dmatest: Fix dmatest waiting less when interrupted"
Date: Mon,  2 Jun 2025 15:46:20 +0200
Message-ID: <20250602134311.060723797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -825,9 +825,9 @@ static int dmatest_func(void *data)
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


