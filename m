Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7731C78B60;
	Wed, 21 Feb 2024 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525676; cv=none; b=UtrNcHL02E8kwDkmutgTMKdRV+MqBGHcB+h7NrBQ4OKhFlL1vRG9565DCPetVY2vwMnXHSxRtC32TExfOx/gh9Y1FEj69U4vrROS//omKrYZIgz5v+zmAzStcRaLt1ooRoUbRRAE4So2mQfCFpQyQuqtePfaBXsby+VPOJqGEro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525676; c=relaxed/simple;
	bh=cSE5KKKLGICxGEc8twgEZGqqRbSdkgtDV256C8Ryp6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjSIt8CJs3CDezJNWBwDUkFG4DtBK8jMCijxKaSGHF5nBOMN+/IMPMUO78UeDLa3Jw/w7UgrcHokHuK3SWz9Cm1qfVLutSINqbwjMrivrBM7bUfQCVgjezAa/k0LJyMavEv92ZsnvG4auOJX/cYjWeekm2WGERnlcXFV+egYNxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryHsTJ8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryHsTJ8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFA8C433C7;
	Wed, 21 Feb 2024 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525676;
	bh=cSE5KKKLGICxGEc8twgEZGqqRbSdkgtDV256C8Ryp6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryHsTJ8OVfr1uZWvVvSADjVdxvprHx+iEGd1m3aO+yGZb4/rG5I1llCR+vO/yshZd
	 WgM4Yy8FEYD0MmQosnmiIZ1QNBebCX4IVdWDqK+DGBZKpQBGu5ZLwkVb6XR6v+SePb
	 /z6O7aFoYEfNe+pnDQ7AyidA+HLMHfqpohRGGGys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathu Baronia <prathubaronia2011@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 5.4 200/267] vhost: use kzalloc() instead of kmalloc() followed by memset()
Date: Wed, 21 Feb 2024 14:09:01 +0100
Message-ID: <20240221125946.434051090@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2583,12 +2583,11 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
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


