Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B4479DAE;
	Wed, 21 Feb 2024 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524710; cv=none; b=TEqVEZP98W+zPgzBG8ULMIXv2eTWEC6A5IWxYyds09F7SnObAUtL7tTtWkcSVbxuoApH5eBr8cqUBdvkVtThUnGCmDdAhpTGfN6QN8cs/8Hw3h4km9b9vd4JwkweTy/Z9s0R/jEHVP5ZO7+oCTqd4I21nylfC03o8VL9PGf3VF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524710; c=relaxed/simple;
	bh=MB3uY1N3ID8t+J4d7nDhrLrB1VxUaDJLcAZyHsMgOak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMElczZDqo+1y6dJW4HRASjbQw2xeEC2i5RdoaExk5EEiLQ0wEiUSjx8X2vG23AR1SonZJZBTXUm1uCSnvLfZEZRJnLGV8KVf876aYKNIGaDjTuB4M56av3BPm6i4FwtjLOr/ZTkTe6vXmH7rcr4qSgC3epVR2aAkmx4laZdPa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgMCwwGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgMCwwGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57937C433F1;
	Wed, 21 Feb 2024 14:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524710;
	bh=MB3uY1N3ID8t+J4d7nDhrLrB1VxUaDJLcAZyHsMgOak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgMCwwGuhDzSuNDACowFDlItqqRsVv1pb27qm/Zad0/W/87Z7S5GR9FnD2JUhGQcV
	 PTNCv90aCftWc4EKp4QH179RYzXSshcdZ9bVONNAG9oDcGEMpvsxsNZ37e2GujQi0u
	 8MD22k9bXhqA2PxSSlrDQWVSv8n1dXwSAv6ZYUYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 326/379] media: rc: bpf attach/detach requires write permission
Date: Wed, 21 Feb 2024 14:08:25 +0100
Message-ID: <20240221130004.597680546@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 6a9d552483d50953320b9d3b57abdee8d436f23f upstream.

Note that bpf attach/detach also requires CAP_NET_ADMIN.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/bpf-lirc.c     |    6 +++---
 drivers/media/rc/lirc_dev.c     |    5 ++++-
 drivers/media/rc/rc-core-priv.h |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -249,7 +249,7 @@ int lirc_prog_attach(const union bpf_att
 	if (attr->attach_flags)
 		return -EINVAL;
 
-	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	rcdev = rc_dev_get_from_fd(attr->target_fd, true);
 	if (IS_ERR(rcdev))
 		return PTR_ERR(rcdev);
 
@@ -274,7 +274,7 @@ int lirc_prog_detach(const union bpf_att
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	rcdev = rc_dev_get_from_fd(attr->target_fd, true);
 	if (IS_ERR(rcdev)) {
 		bpf_prog_put(prog);
 		return PTR_ERR(rcdev);
@@ -299,7 +299,7 @@ int lirc_prog_query(const union bpf_attr
 	if (attr->query.query_flags)
 		return -EINVAL;
 
-	rcdev = rc_dev_get_from_fd(attr->query.target_fd);
+	rcdev = rc_dev_get_from_fd(attr->query.target_fd, false);
 	if (IS_ERR(rcdev))
 		return PTR_ERR(rcdev);
 
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -826,7 +826,7 @@ void __exit lirc_dev_exit(void)
 	unregister_chrdev_region(lirc_base_dev, RC_DEV_MAX);
 }
 
-struct rc_dev *rc_dev_get_from_fd(int fd)
+struct rc_dev *rc_dev_get_from_fd(int fd, bool write)
 {
 	struct fd f = fdget(fd);
 	struct lirc_fh *fh;
@@ -840,6 +840,9 @@ struct rc_dev *rc_dev_get_from_fd(int fd
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (write && !(f.file->f_mode & FMODE_WRITE))
+		return ERR_PTR(-EPERM);
+
 	fh = f.file->private_data;
 	dev = fh->rc;
 
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -325,7 +325,7 @@ void lirc_raw_event(struct rc_dev *dev,
 void lirc_scancode_event(struct rc_dev *dev, struct lirc_scancode *lsc);
 int lirc_register(struct rc_dev *dev);
 void lirc_unregister(struct rc_dev *dev);
-struct rc_dev *rc_dev_get_from_fd(int fd);
+struct rc_dev *rc_dev_get_from_fd(int fd, bool write);
 #else
 static inline int lirc_dev_init(void) { return 0; }
 static inline void lirc_dev_exit(void) {}


