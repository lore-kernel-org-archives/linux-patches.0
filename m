Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA4C5F54E;
	Tue, 13 Feb 2024 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845168; cv=none; b=rDtTuFGku9H+MOTgepkTKvmdRW2PNPPPYzHC5Zeq9HslOXCUQAyl8W/44Bspn6FRjtnw+gTxcsQTQs3EtQBOq7+VAMt3nSQ1dFw/P53IkbykFOWa3Iqr02QXmZvwLK6dgbNqpHOYlgWPhDUtzeua5160frCWC+NwtV5W4ccKTg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845168; c=relaxed/simple;
	bh=djLbFt4MQ8xIx3jvoHhcqYgA+nZFjsJAGUBMRHCsHsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMDEbWi4gDar+tla3th7pn+uFYV9TKDpsdcfK1lOcr6uot0GFpuaqv/p++7sX0LaFz1BYI0RfjI2sU24rZRc/ItEDEAltee6h3YuYHAD4NakqaXndOdUMLxisjXzfel6+zjP4beqmZRc71Hn8NQGmAcXo3Xxi9+/OAfJKt6z83k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cg86WUsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cg86WUsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4217FC433C7;
	Tue, 13 Feb 2024 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845167;
	bh=djLbFt4MQ8xIx3jvoHhcqYgA+nZFjsJAGUBMRHCsHsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cg86WUsVOhy9PnvKG8qsAb6rise84dRXD0PnPAUEax/9q6PGQ8xeSOEIYzIy5VrjK
	 1CJoLS71ZbUZvdlZf65H/RTirMC5e641z9t+uHWLGVg2pb4HTE6TtY3Qi0tsPr/c8L
	 wcQltJOkuOfwVFOmXFvOjVg2Fcz7vhE4BA44xYi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathu Baronia <prathubaronia2011@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.1 60/64] vhost: use kzalloc() instead of kmalloc() followed by memset()
Date: Tue, 13 Feb 2024 18:21:46 +0100
Message-ID: <20240213171846.629933212@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathu Baronia <prathubaronia2011@gmail.com>

commit 4d8df0f5f79f747d75a7d356d9b9ea40a4e4c8a9 upstream.

Use kzalloc() to allocate new zeroed out msg node instead of
memsetting a node allocated with kmalloc().

Signed-off-by: Prathu Baronia <prathubaronia2011@gmail.com>
Message-Id: <20230522085019.42914-1-prathubaronia2011@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vhost.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2588,12 +2588,11 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
 /* Create a new message. */
 struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
 {
-	struct vhost_msg_node *node = kmalloc(sizeof *node, GFP_KERNEL);
+	/* Make sure all padding within the structure is initialized. */
+	struct vhost_msg_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
 	if (!node)
 		return NULL;
 
-	/* Make sure all padding within the structure is initialized. */
-	memset(&node->msg, 0, sizeof node->msg);
 	node->vq = vq;
 	node->msg.type = type;
 	return node;


