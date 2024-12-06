Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF0D1474AF;
	Fri,  6 Dec 2024 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496560; cv=none; b=S015r9ixfZIhGThP/n2MK1o8xq55DK+iw6Z/nttTiklr0PGL7ofSgwP4D9cdboy2uBs33qjyKE8k9rCcyjRvRtSkLzUeMvLm3evRgKP9hlQSdTOAYFrQnRA65NKgSWTrVWWk4TBpGLmKJqnE0EB2JESIyKz5q1uzJOYhmXeJiNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496560; c=relaxed/simple;
	bh=evWyYmpJO9kwd6znJXarpVlKWdjLjIxbXHB46sIRqlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYd3LRCXuJNZDJpincCHkjPnkKJraaNJbH/uHmhV1CMmCfxPKFceQ1HDbGV2oIpOXp3Vm9C6DZXZXmURDPqVUwSw3/+/jojyUmlveYpmtZChkLaoEsaYR1rYHPxV22PH4tYQbx99waBw+MCNlqLQBYoP7ACl62jdsT3O+s1jZ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjeHA8V5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjeHA8V5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF96C4CEDC;
	Fri,  6 Dec 2024 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496560;
	bh=evWyYmpJO9kwd6znJXarpVlKWdjLjIxbXHB46sIRqlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjeHA8V5lXWHLvUTfFaKbLMsZkKf4IRTP72jb4wDS+9CO5XUANxw+V5ex5Bo/8IDW
	 JKSJ8x4bVUbPdgvDypd5S/7ElsnXIpX9AHkOmGVpfZsCGBcAXpve7cY+n4h1zzi38e
	 oMa9aZfaBTzwq/MpAs+Fswu9qwnd4UO3RrKVmyrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/676] usb: typec: use cleanup facility for altmodes_node
Date: Fri,  6 Dec 2024 15:27:08 +0100
Message-ID: <20241206143653.721909823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 1ab0b9ae587373f9f800b6fda01b8faf02b3530b ]

Use the __free() macro for 'altmodes_node' to automatically release the
node when it goes out of scope, removing the need for explicit calls to
fwnode_handle_put().

Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20241021-typec-class-fwnode_handle_put-v2-2-3281225d3d27@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/class.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 64bdba7ea9938..afb7192adc8e6 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -2147,14 +2147,16 @@ void typec_port_register_altmodes(struct typec_port *port,
 	const struct typec_altmode_ops *ops, void *drvdata,
 	struct typec_altmode **altmodes, size_t n)
 {
-	struct fwnode_handle *altmodes_node, *child;
+	struct fwnode_handle *child;
 	struct typec_altmode_desc desc;
 	struct typec_altmode *alt;
 	size_t index = 0;
 	u32 svid, vdo;
 	int ret;
 
-	altmodes_node = device_get_named_child_node(&port->dev, "altmodes");
+	struct fwnode_handle *altmodes_node  __free(fwnode_handle) =
+		device_get_named_child_node(&port->dev, "altmodes");
+
 	if (!altmodes_node)
 		return; /* No altmodes specified */
 
-- 
2.43.0



