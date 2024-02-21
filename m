Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D775A69953;
	Wed, 21 Feb 2024 13:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521628; cv=none; b=Ekle7L9BrzswAh9AkqFFalrg6MG/PwcZ9gRbZvGJc6JvBISLXyrFQpG7AEUY0P7Irx3o7i+UmA1uo78ZR1O5iI+phCFkwnaWvGJ9WCgs+EwdkxJZ211tny++yOxbX5lolTzc+0MgJUfG8D0OyrBchzKxNysUNy3AVSjvYtzzw+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521628; c=relaxed/simple;
	bh=odtCWk29SCVpF1NqZCb+ow8CAKyqIFCw8+JWpl5gyK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCJHDVf6AS2vqboteWr1mRsvwH5Q8U+SJ+SJ8Jn/4a9GNIbEYU+6R+z5S0OIArBipp5oXj1D3hjwrx0t6Rz0JkF/nEj6IFS1pHEjSOiuwnYXLUTF3ipB9dmOU0y3JwVPg4O/AehDjHP2t5Sbgjg43uwKiQEEi9uGXeeEaWbJI1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4cRIQHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4cRIQHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F771C43390;
	Wed, 21 Feb 2024 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521628;
	bh=odtCWk29SCVpF1NqZCb+ow8CAKyqIFCw8+JWpl5gyK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4cRIQHX/gtmi3qumbhrnN08Cl1R+jIgSIcEkrCMrhEFGwh4RcdNOATQFDZnIPwzs
	 8blkt4/HdYuoWJhZ2u/BENm9iT7k6D3MyxqlJ+h+mdfpxEYwtrKo0H7oUs3kF7HFhS
	 M6DjrExvWEWQicmSF+blWNeRr6d+OU1CiHL8qeJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathu Baronia <prathubaronia2011@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 4.19 163/202] vhost: use kzalloc() instead of kmalloc() followed by memset()
Date: Wed, 21 Feb 2024 14:07:44 +0100
Message-ID: <20240221125937.000598371@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2490,12 +2490,11 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
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


