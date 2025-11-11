Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EB42AE8D;
	Tue, 11 Nov 2025 00:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822227; cv=none; b=iEMNxoEYAfbt202u94UR2lWojFj2FFSfyYD/I578eRS8zdH5Icza11PHpqn/g5Rbhy1WSpV2F8KW1ouA5jhTzyuQaK9OAwVN8A+q/PW38OMRJqFO2Wpzm3pdKDwIbkDRI+PqWjrLISWFqjtHTQiCiJDxAAx3tt+wjzugVSNXUyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822227; c=relaxed/simple;
	bh=IBOAfQGOXhpkA4V7u+I8yDNDk/qQ/sqBTAMw3XxTI4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8OGr/ciiZackDasB/ZuM/zijB19WAd++kfGWcJlkYP3t+6lvC8Y6l/jkf4SOiXdqIlpzREREAhrUxQgrlabgSd0kMOVlHCo7CKUsBPIRCopeyEwZnzLSYhF33mH0f/fHGnOEOulNaPGGoOcYPMvmIUODmneZcWsoHAe7qk3Yyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRv1/EFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRv1/EFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FA7C16AAE;
	Tue, 11 Nov 2025 00:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822226;
	bh=IBOAfQGOXhpkA4V7u+I8yDNDk/qQ/sqBTAMw3XxTI4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRv1/EFXS8feUBlnLEjj8KuyvVrDzABXByy+50IEiB+LOOI8b2SKRcgGRcWiMjzHw
	 f2ZhSQ/ibgYrPdtFRtGnS1iGFs/RVp8IOW4lUXwDoxcEGbCpcdfmDWbpgZJYD5BSTu
	 othQUOC7hnI9rSlwjbPF1ufxQsLgOkq+n35ccw9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 007/565] virtio-net: drop the multi-buffer XDP packet in zerocopy
Date: Tue, 11 Nov 2025 09:37:43 +0900
Message-ID: <20251111004527.016529811@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1314,9 +1314,14 @@ static struct sk_buff *virtnet_receive_x
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


