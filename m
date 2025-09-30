Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614EE266B65;
	Tue, 30 Sep 2025 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244889; cv=none; b=GeViC/nf3Su5AeSGTk15x1ramB3Sjhs6P1/b6hQKb+azcS9I4pD9x39NGVsNKt95EXU4LTQx6+GlFU0C9cNQQdZQokR2S15T3Uv10LnzgpqwoOfkR9lvMJB29y8eqVALXEiKr9aEI8LnQsWoc3t9whRaocTJunszt5w/PphB1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244889; c=relaxed/simple;
	bh=NyVvgPv65DaEZn4J69Tw8dRlHsi4Q1lS7Mx8JD4O95M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX4wDSK99vug1k0m1aOMmpddPaZeRqS7XxGwnqo+f0UER7/7dr7XH4b35zqgxM1pW+9vFpKpmOM3WjPZJJR3aDt4E101V4zl8lQ0t8pEQJnRrdsDDiBhpvPb/VtiosmgA8VJZMbevPPGWy92cHvFcMyEN1sQ3O/0qPdM97wQLac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBFk3EF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBFk3EF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F286C4CEF0;
	Tue, 30 Sep 2025 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244888;
	bh=NyVvgPv65DaEZn4J69Tw8dRlHsi4Q1lS7Mx8JD4O95M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBFk3EF4GinEUtT8lekWhiE+fIuhjeidAhb+yi3tdk5kBxkz5ZVnawgkvF226czZX
	 pxTfkWf95lYwac90LQAxZ0k09wCFWVZqrqHmDDKX1cDVongotvZfCA6W9KGhm8Jkro
	 4xLEnbpIXB5pg+vwy015ZS6rvNK/GTu09izOZ8MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Kohler <jon@nutanix.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.16 124/143] vhost-net: flush batched before enabling notifications
Date: Tue, 30 Sep 2025 16:47:28 +0200
Message-ID: <20250930143836.172558252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit e430451613c7a27beeadd00d707bcf7ceec6328e upstream.

Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
sendmsg") tries to defer the notification enabling by moving the logic
out of the loop after the vhost_tx_batch() when nothing new is spotted.
This caused unexpected side effects as the new logic is reused for
several other error conditions.

A previous patch reverted 8c2e6b26ffe2. Now, bring the performance
back up by flushing batched buffers before enabling notifications.

Reported-by: Jon Kohler <jon@nutanix.com>
Cc: stable@vger.kernel.org
Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20250917063045.2042-3-jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -774,6 +774,11 @@ static void handle_tx_copy(struct vhost_
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
 		if (head == vq->num) {
+			/* Flush batched packets to handle pending RX
+			 * work (if busyloop_intr is set) and to avoid
+			 * unnecessary virtqueue kicks.
+			 */
+			vhost_tx_batch(net, nvq, sock, &msg);
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
 			} else if (unlikely(vhost_enable_notify(&net->dev,


