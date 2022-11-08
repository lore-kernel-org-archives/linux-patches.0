Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E10B15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DC6C433D6;
	Tue,  8 Nov 2022 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916037;
	bh=s4REJAzSAerx/CUhMEfmDB6XbONZmjzHVPD+ZdV3EOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpJiPfNX9OpDh4dOvE315xt1ny71gUPvVGKWphCOpG49wof3rSE432MdvGCwqitFo
	 LSrpsrgb2qmYIJ/czypHiKTUDnYFiquv9Fj6NQmuyxDxJ0l+netyr/DGgLa3v5X7KA
	 dLADzHDwUiw4xbG2BVw4DFywmWmeDzMEUr2R0ihs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dean Luick <dean.luick@cornelisnetworks.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/144] IB/hfi1: Correctly move list in sc_disable()
Date: Tue,  8 Nov 2022 14:38:11 +0100
Message-Id: <20221108133345.932633790@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 1afac08b39d85437187bb2a92d89a741b1078f55 ]

Commit 13bac861952a ("IB/hfi1: Fix abba locking issue with sc_disable()")
incorrectly tries to move a list from one list head to another.  The
result is a kernel crash.

The crash is triggered when a link goes down and there are waiters for a
send to complete.  The following signature is seen:

  BUG: kernel NULL pointer dereference, address: 0000000000000030
  [...]
  Call Trace:
   sc_disable+0x1ba/0x240 [hfi1]
   pio_freeze+0x3d/0x60 [hfi1]
   handle_freeze+0x27/0x1b0 [hfi1]
   process_one_work+0x1b0/0x380
   ? process_one_work+0x380/0x380
   worker_thread+0x30/0x360
   ? process_one_work+0x380/0x380
   kthread+0xd7/0x100
   ? kthread_complete_and_exit+0x20/0x20
   ret_from_fork+0x1f/0x30

The fix is to use the correct call to move the list.

Fixes: 13bac861952a ("IB/hfi1: Fix abba locking issue with sc_disable()")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/166610327042.674422.6146908799669288976.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/pio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 3d42bd2b36bd..51ae58c02b15 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -913,8 +913,7 @@ void sc_disable(struct send_context *sc)
 	spin_unlock(&sc->release_lock);
 
 	write_seqlock(&sc->waitlock);
-	if (!list_empty(&sc->piowait))
-		list_move(&sc->piowait, &wake_list);
+	list_splice_init(&sc->piowait, &wake_list);
 	write_sequnlock(&sc->waitlock);
 	while (!list_empty(&wake_list)) {
 		struct iowait *wait;
-- 
2.35.1



