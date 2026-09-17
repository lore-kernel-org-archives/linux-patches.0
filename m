Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF495AA66E;
	Thu, 17 Sep 2026 16:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661242; cv=none; b=bTjf8hkLf/fGkIq78/XZaQcwxL723ccTRe7noGyviOayaXyEftFS9bIDSN3PHHuUBfLRkT0AyaxnK6Z1SjJr3/A0GvUomZXan0M2FvQZ8iGyMVUZemWKMJo9ReF2Xc5DQZwgQfOXgRHz4vqRW3DovP0l7G3vwBjXZ7+odpisJ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661242; c=relaxed/simple;
	bh=GIxzHzDLqFeNE/tKKzN40yNw5+UduRQbjMGgVmbcsgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIxXv77UEqlQalRp8ExolPMTMAyk9ENhcX/cgAan9FX4V4Qc64Ik319XvFSZzCQ+onjdS1pDeLe2+zaLSPSKiJ1QWw0WKZz440jRB/ByzfvYROMHk2NJfk+Y0YQ5MymHi63+E3L8SeoVVbXX0ImC6QlSzbv0phoH6ZYdcTveFSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXS4gUNJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXS4gUNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D366B1F000FF;
	Thu, 17 Sep 2026 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661241;
	bh=DU15Y7SkCNIk6GLTYZr17tCzo/wRAjXGPLosTgGG7kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXS4gUNJzw+UB3u8Yg9rQUw+UPiTMnNqdQsygGAAY0CT+HHk6T8f54uXNzfByjHkL
	 sZ2CtEkMDs9ehKW7Jgc8TvcTu7+zN1fqDZkKzTTmbfZCQ7mQzgU9ecEKCNPeXQ5ZS5
	 dG94Fbne/fWsH3GOtE2M0QlEiyOyfgx/yq4KgmlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonwon Kang <joonwonkang@google.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0131/1250] mailbox: Make mbox_send_message() return error code when tx fails
Date: Thu, 17 Sep 2026 15:58:46 +0100
Message-ID: <20260917151555.592777473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonwon Kang <joonwonkang@google.com>

[ Upstream commit 96a3d2f3167f5644b30e60171898e67123c3c2c6 ]

When the mailbox controller failed transmitting message, the error code
was only passed to the client's tx done handler and not to
mbox_send_message() in blocking mode. For this reason, the function could
return a false success. This commit resolves the issue by introducing the
tx status and checking it before mbox_send_message() returns.

This commit works with the premise that the multi-threads' access to a
channel in blocking mode is serialized by clients, not by the mailbox
APIs, since the current mbox_send_message() in blocking mode does not
support multi-threads.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c          | 6 +++++-
 include/linux/mailbox_controller.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 60866e8417c9b..0f2019aadc216 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -100,8 +100,10 @@ static void tx_tick(struct mbox_chan *chan, int r)
 	if (chan->cl->tx_done)
 		chan->cl->tx_done(chan->cl, mssg, r);
 
-	if (r != -ETIME && chan->cl->tx_block)
+	if (r != -ETIME && chan->cl->tx_block) {
+		chan->tx_status = r;
 		complete(&chan->tx_complete);
+	}
 }
 
 static enum hrtimer_restart txdone_hrtimer(struct hrtimer *hrtimer)
@@ -270,6 +272,8 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 		if (ret == 0) {
 			t = -ETIME;
 			tx_tick(chan, t);
+		} else if (chan->tx_status < 0) {
+			t = chan->tx_status;
 		}
 	}
 
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
index 1db0069c27c52..e6af0721198b4 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -114,6 +114,7 @@ struct mbox_controller {
  * @txdone_method:	Way to detect TXDone chosen by the API
  * @cl:			Pointer to the current owner of this channel
  * @tx_complete:	Transmission completion
+ * @tx_status:		Transmission status
  * @active_req:		Currently active request hook
  * @msg_count:		No. of mssg currently queued
  * @msg_free:		Index of next available mssg slot
@@ -126,6 +127,7 @@ struct mbox_chan {
 	unsigned txdone_method;
 	struct mbox_client *cl;
 	struct completion tx_complete;
+	int tx_status;
 	void *active_req;
 	unsigned msg_count, msg_free;
 	void *msg_data[MBOX_TX_QUEUE_LEN];
-- 
2.53.0



