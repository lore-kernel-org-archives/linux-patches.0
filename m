Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765E6AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF44AC433D2;
	Wed,  4 Jan 2023 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849165;
	bh=O6wiKCupFA3cYumLXNEDZszkyucDIx/CQRmtWJWex/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crrMs5I1e8E1Vk2wpV/erOGdppIOaC8s1WIytME37u3kY5uRXO2IbroHvr3TGCh27
	 pUYGzTE8If86LrFqLJ7zDKgxtcOe+PnD3zpFCYCTWmrNRJXtEYYqGska/udATvwolR
	 eAk9Y3Ubhp6gKZ1OZvzEf4UJtsRWyCvNlD3WELsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.1 136/207] bus: mhi: host: Fix race between channel preparation and M0 event
Date: Wed,  4 Jan 2023 17:06:34 +0100
Message-Id: <20230104160516.223569967@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiang Yu <quic_qianyu@quicinc.com>

commit 869a99907faea6d1835b0bd0d0422ae3519c6ea9 upstream.

There is a race condition where mhi_prepare_channel() updates the
read and write pointers as the base address and in parallel, if
an M0 transition occurs, the tasklet goes ahead and rings
doorbells for all channels with a delta in TRE rings assuming
they are already enabled. This causes a null pointer access. Fix
it by adding a channel enabled check before ringing channel
doorbells.

Cc: stable@vger.kernel.org # 5.19
Fixes: a6e2e3522f29 "bus: mhi: core: Add support for PM state transitions"
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/1665889532-13634-1-git-send-email-quic_qianyu@quicinc.com
[mani: CCed stable list]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/pm.c
+++ b/drivers/bus/mhi/host/pm.c
@@ -301,7 +301,8 @@ int mhi_pm_m0_transition(struct mhi_cont
 		read_lock_irq(&mhi_chan->lock);
 
 		/* Only ring DB if ring is not empty */
-		if (tre_ring->base && tre_ring->wp  != tre_ring->rp)
+		if (tre_ring->base && tre_ring->wp  != tre_ring->rp &&
+		    mhi_chan->ch_state == MHI_CH_STATE_ENABLED)
 			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 		read_unlock_irq(&mhi_chan->lock);
 	}


