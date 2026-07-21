Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B5246DFF5;
	Tue, 21 Jul 2026 18:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660288; cv=none; b=mw7mM+dbZHer95pQKubJp4BEewC42mHYsWQwx/VrxrVZsMpuIvGZu6fh3WEYeGaCGQr6HfooR+mtX33CWd9SrWirrZE50p/dwai0Yn6FlXUmUrq8w2+fnBECl2QduUaucL1bpQQ7xE42KIosnmCZgPvgwklEKwNKM8poPrgXiq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660288; c=relaxed/simple;
	bh=ovpIkxbRbIY9hnTjFFx1vqVAdURYkBOOjeG3o9qclwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HexjQXApIhJe8niOjeUOLHAz9ctc4zoFvzjO9s/+ARqlFCUpj1IrKEVjquBwfBYCQgd+lPCqiuhqkcGdTFTf/12tFSqM08lSJb7S2c8GeZEafdlbC8Zg6N5DOj/EhILbfmd4PBV+xBu/NjnNjJvENHY1g3yRVQG5oGW/a3MDTRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtpMpWI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtpMpWI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FA91F000E9;
	Tue, 21 Jul 2026 18:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660285;
	bh=Ldsy+UAx1ukTU1LoxHa0roVMcglhxbYCmMmH+8m9B6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtpMpWI5iB6NVqLre28C5GVi0h4+WuHhEZRYpD8rrfAUFkKVCKS1nW/IJI/02SWF+
	 3NMiy4Ay8FHQrDwSAR9jwuS9qkYP4v1V1Bo7ccYCLqwZ3S7b4baj0/qxk8/sN0I/Q2
	 kOlJ5qzdiEZhCxg0fr9ta7F3Zh2mSvqrKR1lFkjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0879/2077] mailbox: dont free the channel if the startup callback failed
Date: Tue, 21 Jul 2026 17:09:12 +0200
Message-ID: <20260721152613.527136768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 4f176444dcc977d1888fd9220c357a4d32338ee0 ]

If the optional startup() callbacks fails, we need to clear some states.
Currently, this is done by freeing the channel. This does, however, more
than needed which creates problems. Namely, it is calling the shutdown()
callback. This is totally not intuitive. No user expects that shutdown()
is called when startup() fails, similar to remove() not being called
when probe() fails. Currently, quite some mailbox users register the IRQ
in startup() and free them in shutdown(). These drivers will get a WARN
about freeing an already free IRQ. Other subtle issues could arise from
this unexpected behaviour.

To solve this problem, introduce a helper which does the minimal cleanup
and use it in both, in free_channel() and after startup() failed.

Link: https://sashiko.dev/#/patchset/20260402112709.13002-1-wsa%2Brenesas%40sang-engineering.com # second issue
Fixes: 2b6d83e2b8b7 ("mailbox: Introduce framework for mailbox")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index bbc9fd75a95f7c..006ea5a5c32074 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -327,6 +327,19 @@ int mbox_flush(struct mbox_chan *chan, unsigned long timeout)
 }
 EXPORT_SYMBOL_GPL(mbox_flush);
 
+static void mbox_clean_and_put_channel(struct mbox_chan *chan)
+{
+	/* The queued TX requests are simply aborted, no callbacks are made */
+	scoped_guard(spinlock_irqsave, &chan->lock) {
+		chan->cl = NULL;
+		chan->active_req = MBOX_NO_MSG;
+		if (chan->txdone_method == MBOX_TXDONE_BY_ACK)
+			chan->txdone_method = MBOX_TXDONE_BY_POLL;
+	}
+
+	module_put(chan->mbox->dev->driver->owner);
+}
+
 static int __mbox_bind_client(struct mbox_chan *chan, struct mbox_client *cl)
 {
 	struct device *dev = cl->dev;
@@ -350,10 +363,9 @@ static int __mbox_bind_client(struct mbox_chan *chan, struct mbox_client *cl)
 
 	if (chan->mbox->ops->startup) {
 		ret = chan->mbox->ops->startup(chan);
-
 		if (ret) {
 			dev_err(dev, "Unable to startup the chan (%d)\n", ret);
-			mbox_free_channel(chan);
+			mbox_clean_and_put_channel(chan);
 			return ret;
 		}
 	}
@@ -495,15 +507,7 @@ void mbox_free_channel(struct mbox_chan *chan)
 	if (chan->mbox->ops->shutdown)
 		chan->mbox->ops->shutdown(chan);
 
-	/* The queued TX requests are simply aborted, no callbacks are made */
-	scoped_guard(spinlock_irqsave, &chan->lock) {
-		chan->cl = NULL;
-		chan->active_req = MBOX_NO_MSG;
-		if (chan->txdone_method == MBOX_TXDONE_BY_ACK)
-			chan->txdone_method = MBOX_TXDONE_BY_POLL;
-	}
-
-	module_put(chan->mbox->dev->driver->owner);
+	mbox_clean_and_put_channel(chan);
 }
 EXPORT_SYMBOL_GPL(mbox_free_channel);
 
-- 
2.53.0



