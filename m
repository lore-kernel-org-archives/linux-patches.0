Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814DD4D5B7;
	Wed, 21 Feb 2024 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523098; cv=none; b=FHf/d5KUDyVhPxaXtc/2FGknsBOFjZhU9sNPXPsxvXO4hAs4RszmLMQOb3rNDSHWnYMeXGgmRUgBd99WFnOHAlP+BWdHpSNBlni8Uyn057DqPUG4mLn80dfI/gKpp+XqBOoL3PU7icbSvhNKwRTCGG4hE1RC1m6qgKioa8c8toI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523098; c=relaxed/simple;
	bh=kF8/Vr9j7SGzsL/b70CID38dsLvpXdyCj9XfLh7p/1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e23O05D4RUu+CwstaUHCK8rA/6B9ZoMM3GIguSnydkUHtt60CGDg/W6RoNgNW1/K6L2kRRASi7VCBBK3nRgsvhnzRbz0BKibircC9vbYGcdB7nZl7Yd/0f4j+RehrkSTkG7VBXxOi+gGsfVPapRi1b2ug+f1/62D3YiwB5AK1ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlsMBDui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlsMBDui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E656DC433F1;
	Wed, 21 Feb 2024 13:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523098;
	bh=kF8/Vr9j7SGzsL/b70CID38dsLvpXdyCj9XfLh7p/1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlsMBDuiDvGpRbnnraYq0doBiC5HduzQjINbYtLxLIXbRtQy8mi+YqnUpCdDJRhDm
	 Y9kJqTjY+UDTL/GnqZdui0JKwAHBIZrxGknYmux98tUhzWWVvC6mpDhdU2/7WMe+ii
	 HuEZKJuJCz+/JaEFGCBY8J3wbcTOkuBkSSC8v0tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathu Baronia <prathubaronia2011@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 5.15 339/476] vhost: use kzalloc() instead of kmalloc() followed by memset()
Date: Wed, 21 Feb 2024 14:06:30 +0100
Message-ID: <20240221130020.563462776@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2582,12 +2582,11 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
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


