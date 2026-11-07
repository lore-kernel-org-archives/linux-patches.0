Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063266;
	b=o9L7Zr7t9KsXJj/9Cg3zpLYbTYFAKq3dUxtlfW9fJXe9LJA/oIwmZJ+AdKqGAOOc8qTW
	 wDDjH3Kw5i5xhfyo15WsdqAQBhm8i14jBkCJ7OglY2CTcXrrIllzPAFjWSC174ZyaI1/B
	 eW6RhRxtJrUGrkpxnZLGirEmq7i57zi3OSFqn9odUf1SGRThKd1EEaIHt32ODy2mJv+Qv
	 bmINwDfEtIeYUJADKwrBXCPR4q6+nB0ytUI+oNOCBti+UiYPC5A9HH6d7jn0yP+JvgsJy
	 cGZJRTVLFncujnZ+25BmMMY6E6yqIAMRReI2HdlacM/bH3S6RkMU9gIs0wQYUV3WmHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GMGeueMEoXc5CoOqVsLi1ygv6S/egljNPlIUPLr4ISw=;
	b=392Dh+maqudbXGeTZ98ahXaYaonW1SKaW+khAgFofrHKWtGF9F1rjegs0rqnBDZHDtf2
	 IYG62CxhH58zyXa86ce4WkSJXYl35+9w+gFxXjH0EK7Mhmuy69gRMWHL+TPqYj6/smCRj
	 a7sKzz8vg2FuowBwo5W+P7ijeTomK1wYfyY04Ei/yFU/0CS2keFElinsyUH3pA+KFDC7w
	 DvYYqrfzGD4OGuUxbgzJx473ZQiTfA6zanxzj4ByXxhYIAuTP1EtpJxOFRsNilz+3DDf/
	 apPgl6/iYzRG1kgJ4+oP4WcaRhSl8K90NYFBjrq5hqwRDYWJrN0hSashaG9m3oKYryA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgBrCREI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276B8606A331;
	Sat,  7 Nov 2026 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgBrCREI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1FB1F0089F;
	Sat,  7 Nov 2026 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063266;
	bh=GMGeueMEoXc5CoOqVsLi1ygv6S/egljNPlIUPLr4ISw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgBrCREIXWb7KibFzFGXZFTFT8yc3IRCSkTSfmY1ey3vENRYqq4hRQdPDGiw9Ev3b
	 32q/hbr9JffpfdLxNMlcsgztb1ziiIzAgA7rFrV5dimzkCUkke0i6TEeJaRZWIZpg8
	 AYDkvVldOtYcxfooOf4RQ9hrS/pZynRMvAm7ygo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 464/869] mailbox: altera: shut down RX polling timer on channel teardown
Date: Sat,  7 Nov 2026 08:52:26 -0500
Message-ID: <20261107134909.397035487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-altera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-altera.c b/drivers/mailbox/mailbox-altera.c
index 17278c2571d34..7cb91413ef7fc 100644
--- a/drivers/mailbox/mailbox-altera.c
+++ b/drivers/mailbox/mailbox-altera.c
@@ -270,7 +270,7 @@ static void altera_mbox_shutdown(struct mbox_chan *chan)
 		writel_relaxed(~0, mbox->mbox_base + MAILBOX_INTMASK_REG);
 		free_irq(mbox->irq, chan);
 	} else if (!mbox->is_sender) {
-		timer_delete_sync(&mbox->rxpoll_timer);
+		timer_shutdown_sync(&mbox->rxpoll_timer);
 	}
 }
 
-- 
2.53.0



