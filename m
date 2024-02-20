Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6598314AD12;
	Tue, 20 Feb 2024 21:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463113; cv=none; b=jpgkfwFl8E0g916CSii6AF2lB2SMl1v5jQFuVUyjmVPiBTwRb50MrbUB2lkwpy/xvAr6pKUVPEEHxiszRXS2H5sl4RjB3UPbySQzYPGqTPwoF9LPGA2VVutTOE2zY96RJll6tYE3U1hAiOOBTHdd54gEbDQLx0GjZFXkGA4aHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463113; c=relaxed/simple;
	bh=WN/Y2hoCRBymcMuCvjJJvTETlYgblTiIQimjaEyckrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cto/9z8B9dj6MGcEOLWVjXpLhK8ysJiuiImVqLfoaZ8/37NKvDtGuNpnByqydct1lo7LXWuv7nEXIiyG7mXnxM0vCwvoKyrbRyaFZDy1MgXZ0FoiUJAtVGd0V3BlMix/5tiCyYOIPgBC6OuT7am9kJgFT12/i8M0J+o44ffORlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s13/fZ4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s13/fZ4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E742C433F1;
	Tue, 20 Feb 2024 21:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463113;
	bh=WN/Y2hoCRBymcMuCvjJJvTETlYgblTiIQimjaEyckrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s13/fZ4FwukFJD5DSPU+YyEWttArRDTlJLi35XWZ3agRjL9XS+9N3mf/gI/uGnVHf
	 gIewebL/g7WxHPVn4Hx1DFKE0qRbuooHBHhcsdcg0e0VOiK6shAWsGtrQa6EzGqwRn
	 K2UDTjgSc5PTzeBRCNufgcY6c5/RGGalh5FATVmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.1 109/197] media: rc: bpf attach/detach requires write permission
Date: Tue, 20 Feb 2024 21:51:08 +0100
Message-ID: <20240220204844.343817657@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
@@ -253,7 +253,7 @@ int lirc_prog_attach(const union bpf_att
 	if (attr->attach_flags)
 		return -EINVAL;
 
-	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	rcdev = rc_dev_get_from_fd(attr->target_fd, true);
 	if (IS_ERR(rcdev))
 		return PTR_ERR(rcdev);
 
@@ -278,7 +278,7 @@ int lirc_prog_detach(const union bpf_att
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	rcdev = rc_dev_get_from_fd(attr->target_fd);
+	rcdev = rc_dev_get_from_fd(attr->target_fd, true);
 	if (IS_ERR(rcdev)) {
 		bpf_prog_put(prog);
 		return PTR_ERR(rcdev);
@@ -303,7 +303,7 @@ int lirc_prog_query(const union bpf_attr
 	if (attr->query.query_flags)
 		return -EINVAL;
 
-	rcdev = rc_dev_get_from_fd(attr->query.target_fd);
+	rcdev = rc_dev_get_from_fd(attr->query.target_fd, false);
 	if (IS_ERR(rcdev))
 		return PTR_ERR(rcdev);
 
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -814,7 +814,7 @@ void __exit lirc_dev_exit(void)
 	unregister_chrdev_region(lirc_base_dev, RC_DEV_MAX);
 }
 
-struct rc_dev *rc_dev_get_from_fd(int fd)
+struct rc_dev *rc_dev_get_from_fd(int fd, bool write)
 {
 	struct fd f = fdget(fd);
 	struct lirc_fh *fh;
@@ -828,6 +828,9 @@ struct rc_dev *rc_dev_get_from_fd(int fd
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


