Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1004734C1;
	Tue, 25 Aug 2026 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665724; cv=none; b=BsC1zz7Twm396NnEYXuH48Ew6/GM44ADwn8mVJXoi77qxvk7nWKRxvwNRuY+W9/O31FLrHwnCK0k+ff2caXtVHZH68fo44uLQQlYlF+B284O0m/7aAzKW+gJ0QVncZVO55cjjr0MlUwVQhr4Y3DoeWeZ5ITb9UFynT5KVlh/zAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665724; c=relaxed/simple;
	bh=dVU1YGfj13+7E8YSv4W4B4nIf1Tv8VnGTh2RvVbpfU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMcIElppnsVJq4twQlYkQCtCOk0t1vYwpHk+HpKAdm6Gz37zpCBxCrPKbhjWvrVE7VfA4ZQRmrdvnRg55YK/sUH9S+qQ6ShWe0utzhNhNa/tR4mFTQg0Q23oTvWiI1AyTJB0A+A5Wg+gH/BvKlejq2XtUS12/biTGfS1gmoVkQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWhC7jyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWhC7jyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A16F1F00A3E;
	Tue, 25 Aug 2026 13:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665723;
	bh=vXavtvmgoWOMeig7DgDC7mH7w1jDEibaqWaRgMINf/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWhC7jyK72IeEEGccZVNJUF6chtHqeY7aaXXLD8w7lkWqMzqtKK8WSeSF3lcx3tRS
	 ahg9aK51QMOS99SzDt92xmrJYXqzIzmJscGCUqu8in7FDG0yvaSFVyR4a64EOhICZb
	 EdckntbuY5sZKkgstUOg1can21R5HOLAR9hnTA3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.6 44/87] nfc: pn533: purge fragmented skbs during cleanup
Date: Tue, 25 Aug 2026 15:26:07 +0200
Message-ID: <20260825132543.575499419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 5718fc62198c38c2de5316020a90506f9e75e0bb upstream.

pn53x_common_clean() purges resp_q before freeing the common PN533 state,
but it leaves fragment_skb untouched.  The fragmentation helpers queue
transmit fragments there while sending large initiator or target-mode
frames, and those skbs remain owned by the driver until they are sent or
discarded.

If the device is removed while fragments are still queued, the common
cleanup path frees the PN533 state without releasing the queued fragment
skbs, leaking them.

Purge fragment_skb during cleanup alongside resp_q.

Fixes: 963a82e07d4e ("NFC: pn533: Split large Tx frames in chunks")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/2D896607CAE4408E+20260720021444.3362044-1-raoxu@uniontech.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/pn533.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2803,6 +2803,7 @@ void pn53x_common_clean(struct pn533 *pr
 	destroy_workqueue(priv->wq);
 
 	skb_queue_purge(&priv->resp_q);
+	skb_queue_purge(&priv->fragment_skb);
 
 	list_for_each_entry_safe(cmd, n, &priv->cmd_queue, queue) {
 		list_del(&cmd->queue);


