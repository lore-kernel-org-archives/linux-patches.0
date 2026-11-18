Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053825;
	b=4naSdnOWiQ3m3QMhCYVOh7Ms9x0G+oUd09l0xHzoWnnjjhOzK+5A0XQLtFUPg2JGSKjp
	 A3HkRs/91uibR8hShSdFRCFIy8mLZCsEvNSDCY4tAJudx7mK9VwAXHLFngj1UczZyy9Cg
	 cIGLNC1w4RylichcoVN5CVoSy4M2koyLdB6kUQe4wcudgv8eFR9ByFdZpj7heHEgud8iy
	 HlXVddNvBNOGOrYh4fRAyUF2TGsIADVMO2Q/kUNavMBqhwTSud4PlnMb99e4dJ6ZyQmya
	 bhN8CsKa17ANIGCSXHduC3ukFVOtS4bPTT5hBvS8c5StHG4faoLx8Ruiv3sHiBmfOaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=95Z56vjwq7mXBISGhKGaDvx+gFnEWL3iweP3azGqEtA=;
	b=o315dk8bnm2J+dp36O74CMkDRkFvoSoYnXx3Ezvl1emjNv/bSEw3ntYFUhzNA7JY1MB5
	 L5Vea6exkzPhlzzpdg2ez1FbwljyyjgXCss2JftakmkDdh6qNzMlMmlvq++85YyT/KRmQ
	 i4/zsVO0o6WKyU1ES1tyhxlxRqO5C7xiCCUuDz7PZqZxSqYMJUW6wxDiTnbXl8ZWsx/T9
	 XRHlnwXI9jWdsHKMyZnJF5gseSmBI48BFRn6WrDar1FPoHDRMGGT6noBVRlQyv2gl+QhG
	 QMz1EKdqInatpN98KdW+6Oq330gP+H9AERhZhUhIS99OhuJadvM2qz9XDyau3v6GMkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QOx5r1ns;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2715606A320;
	Thu, 19 Nov 2026 02:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QOx5r1ns
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36991F000C4;
	Thu, 19 Nov 2026 02:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053825;
	bh=95Z56vjwq7mXBISGhKGaDvx+gFnEWL3iweP3azGqEtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOx5r1ns1s2JmvptKaTTS8jxhBlSqA55+tJyZ2d2ah2wjVQDPuP0xcZ4llOBqNuTP
	 8YUbgJ6CQOu2IZmGqUmyk2CS6fxiq66tkSR7KR6LHRcAns9HgV6pcfsWFpZ1Mm5R+2
	 quwY+Bgd9UeIBfUR6YSc5jp7gs6txJjlsTj529bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1055/2214] mailbox: altera: shut down RX polling timer on channel teardown
Date: Wed, 18 Nov 2026 15:45:31 +0100
Message-ID: <20261118150054.523574817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 0cf10e65639cba32d05994f85e6a8f08dd0ffe08 ]

The RX polling callback unconditionally rearms the timer after it
processes mailbox data.  altera_mbox_shutdown() uses
timer_delete_sync(), which waits for a running callback but does not
prevent that callback from rearming the timer after the deletion.

Use timer_shutdown_sync() for the final polling teardown so the timer
cannot be queued again while the mailbox channel is being released.
The timer is reinitialized with timer_setup() on a later channel startup,
so polling mode remains reusable.

Fixes: f62092f6d77d ("mailbox: Add Altera mailbox driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
[ sashal: replaced del_timer_sync() instead of timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-altera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-altera.c b/drivers/mailbox/mailbox-altera.c
index 75282666fb06c..2b1be8828440e 100644
--- a/drivers/mailbox/mailbox-altera.c
+++ b/drivers/mailbox/mailbox-altera.c
@@ -270,7 +270,7 @@ static void altera_mbox_shutdown(struct mbox_chan *chan)
 		writel_relaxed(~0, mbox->mbox_base + MAILBOX_INTMASK_REG);
 		free_irq(mbox->irq, chan);
 	} else if (!mbox->is_sender) {
-		del_timer_sync(&mbox->rxpoll_timer);
+		timer_shutdown_sync(&mbox->rxpoll_timer);
 	}
 }
 
-- 
2.53.0



