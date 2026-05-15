Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179563BB68B;
	Fri, 15 May 2026 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862354; cv=none; b=jOVm6YpGEdjVv4CZ4xV4XeQv4vXdzuDU7mf67sjTDDgHqR5i+9vK0L6dKc766BtC9t1ZyPO58xyhxS6OX+NT0KiwQxtjhBzV6aCSJAIbl/IxjRnsmMWoy7T6EbKALdIDx8Y8qBwTOX2iJBzecm9km0r7juUXq/v4z88mtjVuuQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862354; c=relaxed/simple;
	bh=a+SN8f6xlUPYbeSdi2SckGdurlb+t8Om05InlAhmkLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqWPgUncxmr0aLKrqJCx8fHBXT8n+A4yG4S9EKT5vyvDncpkxUFIegQeqF4EqEqscO4x1uzP/0hCk/Nsr6XW0LzFYGnCXtKlU6CFE3B6VxB8P0JZKO2aYdUOaUNVMJSnqfghfkk1ZgqNqGS8L8+m7RdvCZ1pFvc5dZIQrzIJOlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09fqOWuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09fqOWuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A936C2BCB0;
	Fri, 15 May 2026 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862353;
	bh=a+SN8f6xlUPYbeSdi2SckGdurlb+t8Om05InlAhmkLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09fqOWuAidzCKBnYY0khFE3PDQVdxgJobFW5+648yNifvaUTnrfHUF7KvtNrnafYH
	 YOcy9/TjHTrFnBBIBYHt765D0mR87TU+tmCs4C6xwSt56J05oOZ3BMtUeLILjJdmk5
	 D0wfg4bW/LKgg7lUye3WZO4pP0ckGCA0szkQ8/aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 017/201] media: renesas: vsp1: Fix NULL pointer deref on module unload
Date: Fri, 15 May 2026 17:47:15 +0200
Message-ID: <20260515154658.909059862@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>

commit 58b1e9664d8f74d55d8411cc7a7b275a76a6f24f upstream.

When unloading the module on gen 4, we hit a NULL pointer dereference.
This is caused by the cleanup code calling vsp1_drm_cleanup() where it
should be calling vsp1_vspx_cleanup().

Fix this by checking the IP version and calling the drm or vspx function
accordingly, the same way as the init code does.

Fixes: d06c1a9f348d ("media: vsp1: Add VSPX support")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/vsp1/vsp1_drv.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/renesas/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/renesas/vsp1/vsp1_drv.c
@@ -240,8 +240,12 @@ static void vsp1_destroy_entities(struct
 		media_device_unregister(&vsp1->media_dev);
 	media_device_cleanup(&vsp1->media_dev);
 
-	if (!vsp1->info->uapi)
-		vsp1_drm_cleanup(vsp1);
+	if (!vsp1->info->uapi) {
+		if (vsp1->info->version == VI6_IP_VERSION_MODEL_VSPX_GEN4)
+			vsp1_vspx_cleanup(vsp1);
+		else
+			vsp1_drm_cleanup(vsp1);
+	}
 }
 
 static int vsp1_create_entities(struct vsp1_device *vsp1)


