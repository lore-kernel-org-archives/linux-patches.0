Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017926;
	b=fcOO1bOXzTGmemsQoUG85G6cFOP8MQ4MMlhBfijyXY3Jw09iJ4cIKIiMXeDPgcu5f2RY
	 h2ZGyKItvYNl4zg31HShv7h3/2A1mpehmFv4KJWMKf+DZlx7Ur8b2HjBeD/s5eRly/lhf
	 e16bbc810/Rr2n42jR70jOqo9J2YsIYGzvbCPw0k26A0rt1Eq62ptgiWNX/r2bcnaLqwH
	 3jLpCwLdIdpGL9f5odDnpcW3e+ET73oh4EK2AoNeH5lLvyeIGluolvH9HEV1aJZKRwxPs
	 rJ6fCRhx5TFaWf86FMn6uOrBxc6x57gyYNYz36gpXJb6SdJgNqNFqADrj3aQjlWZmnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOYWoT9zB70l7mwVnjqL/07IzhvrK03BDFcOd+xCFWo=;
	b=Ux8J9d3M67BpLCqx40ftZdL6VzssJFBkLh277A2aVxvoM4/PFiuo3Ff6M/zV/hpnGrqV
	 lw4ZBiHOvhrUA/Mo6GvRSMKEbG3Po8gkjBROGb1C9EA1tItC4XqTCdzsPQh56xR8X5e5b
	 jhXjk1KClxOnAl0f69+xzsw0jH3RV4kFkeaVoY+SqJ7gZlSznS3/3ETEzDqoBKJec07Wi
	 eup8vGClH6ecqlURMGZa5g2eg4IKCSiBtT4GHO2B3s+MxXAB8NqcIpu+/GExKKeEz/HMd
	 c/6FmBIUxQhl6EEo8FFGPVjiDUluKdtA+cCNWYsbNn5Y+XimVghdTpB9UvoD7YTOqKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvzvXDG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31843606A320;
	Wed, 18 Nov 2026 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvzvXDG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847BA1F000C4;
	Wed, 18 Nov 2026 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017926;
	bh=UOYWoT9zB70l7mwVnjqL/07IzhvrK03BDFcOd+xCFWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvzvXDG8Bjq6Jbgr1mbtDz1GJPxD7gfg+mk5YyQkeCTVHo9wASWtHi7xziKi9Y13k
	 ks2D8AR9N6N4PrpbJtajJRoG0ZuQuvY+maLayavvrTr5LRexKibbcRn5LamshhKCIQ
	 TAVzYBN6+1bS4bB+BUnZdfFAY6Qybr4cikCPJfnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1059/2651] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Date: Wed, 18 Nov 2026 15:38:19 +0100
Message-ID: <20261118150326.101604323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e95d076bc1fca7cc36fc8f2f0e9687f79fd314bd ]

The SDMA state reference and completion cover the software cleanup
tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
flush_worker. Queued instances can therefore access an SDMA engine after
per_sdma is released.

After the state machine has stopped, cancel err_halt_worker first
because it can publish the hardware cleanup tasklet. Then kill that
tasklet and drain the remaining flush work.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134148.977-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index f253c8ee182d5..a71fc8f2d37e4 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1569,6 +1569,9 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 * it is not running.
 		 */
 		sdma_finalput(&sde->state);
+		cancel_work_sync(&sde->err_halt_worker);
+		tasklet_kill(&sde->sdma_hw_clean_up_task);
+		cancel_work_sync(&sde->flush_worker);
 	}
 }
 
-- 
2.53.0



