Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02B64C97;
	Tue, 11 Nov 2025 00:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822146; cv=none; b=ua/uRqrJnRuFX4tjhocZg3sqe2Eby6r7ofLkgKFDe+UjWMr14ZU6lTH+W32RWDeVbDD1eOzQHVh4OD1EzwC68CXdSnfNYkvdXLyF2a4PV75oQAihDcL0XErj32Xid/6kpuJ/7lg0duW3b6mpf02PBN9dIKQ9109khURQ8c1rt6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822146; c=relaxed/simple;
	bh=1T4/19dnJw+dGWRbMjsvPTtL0ztW+Vz1gxaC13ubm5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQl/mj7LS9lQHpj0XkIEynUOxvJsJCdvs2in8t2gCeRhjXpwLSKLbvzSs7X/blZLrJCGiQN1+ZcpUWWMjrm0rC6WOlKHHZ1CljaoAro+7XP03IAwXwqthcnyTtzW3EV57QN6XeIwZlmdtfYevAXV/kWgsezzE83TW0nTwltJ49M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCf0dl/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCf0dl/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBACC4CEF5;
	Tue, 11 Nov 2025 00:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822145;
	bh=1T4/19dnJw+dGWRbMjsvPTtL0ztW+Vz1gxaC13ubm5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCf0dl/7KjR+2r18fFGF0Nx9twW5GOMKmAAtKaE4YOz1DU452QG6TzbcgtR8TJvA8
	 x2awsG/X8ChKxQoyNG8ghyjyl1LoajR5KfLI5dXrgSneveb64xVqrJRDV1+4nD6XHZ
	 lBKYZPuhSmxlBRIEstjrk+YfIGlZQQgSAi21EJNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 012/849] virtio-net: drop the multi-buffer XDP packet in zerocopy
Date: Tue, 11 Nov 2025 09:33:02 +0900
Message-ID: <20251111004536.758331100@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

commit 1ab665817448c31f4758dce43c455bd4c5e460aa upstream.

In virtio-net, we have not yet supported multi-buffer XDP packet in
zerocopy mode when there is a binding XDP program. However, in that
case, when receiving multi-buffer XDP packet, we skip the XDP program
and return XDP_PASS. As a result, the packet is passed to normal network
stack which is an incorrect behavior (e.g. a XDP program for packet
count is installed, multi-buffer XDP packet arrives and does go through
XDP program. As a result, the packet count does not increase but the
packet is still received from network stack).This commit instead returns
XDP_ABORTED in that case.

Fixes: 99c861b44eb1 ("virtio_net: xsk: rx: support recv merge mode")
Cc: stable@vger.kernel.org
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://patch.msgid.link/20251022155630.49272-1-minhquangbui99@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1379,9 +1379,14 @@ static struct sk_buff *virtnet_receive_x
 	ret = XDP_PASS;
 	rcu_read_lock();
 	prog = rcu_dereference(rq->xdp_prog);
-	/* TODO: support multi buffer. */
-	if (prog && num_buf == 1)
-		ret = virtnet_xdp_handler(prog, xdp, dev, xdp_xmit, stats);
+	if (prog) {
+		/* TODO: support multi buffer. */
+		if (num_buf == 1)
+			ret = virtnet_xdp_handler(prog, xdp, dev, xdp_xmit,
+						  stats);
+		else
+			ret = XDP_ABORTED;
+	}
 	rcu_read_unlock();
 
 	switch (ret) {


