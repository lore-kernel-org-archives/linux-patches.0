Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7B878B7C;
	Wed, 21 Feb 2024 13:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523394; cv=none; b=g1Z2TTiH/i2eOFCbmik2vJLC0+cM3efiSuxU/2iKBSAb/cqCBZhTrVZxlAAZKDmi+l2FsIUCicTY2OUoDOtAjwn4Pyg+ttI5a53a8pBtc2qKsMgy8bnKYBzoStN0D6ftp9+k3LjXzUjsvc232S0FSgUPVbAyJ2y9Vh0E24VShts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523394; c=relaxed/simple;
	bh=G9jKto7B0rnc57KrkkFzgV7VSVSr8QXIVJty5nURiXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMiGbE8WvujLLG8EmW94ro6vYUyvRjgI9OflfURRpJBnTLC7i8UTTkCZPgB4ubG9xL1RVQQj5nWbEzR/GwqNmJ2yZkQITUhenXcnXNjcVW2XZB5XN0t4uuPT+2472Bwxxy/m02FVIKJ0d/zm907ZoLUoHWvNKONcik65lS6RPeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wgcg+Ati; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wgcg+Ati"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E001C433F1;
	Wed, 21 Feb 2024 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523394;
	bh=G9jKto7B0rnc57KrkkFzgV7VSVSr8QXIVJty5nURiXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wgcg+AtiwzcS04F4gQ2B4INbSd7qZyR2bRXVIZDCf1oKmO3rsk84JHrVBBNkVXwL5
	 TTL7CVqESuFFExCv0PWrWBPwovXoEqzokKTifjptWSR5UF93Vj/245Dq7TmADcOn/M
	 6gxaHmDHcCnO3xmxj4Qm1AdrityogDiu0KBhAjWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 395/476] media: rc: bpf attach/detach requires write permission
Date: Wed, 21 Feb 2024 14:07:26 +0100
Message-ID: <20240221130022.616792529@linuxfoundation.org>
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
@@ -827,7 +827,7 @@ void __exit lirc_dev_exit(void)
 	unregister_chrdev_region(lirc_base_dev, RC_DEV_MAX);
 }
 
-struct rc_dev *rc_dev_get_from_fd(int fd)
+struct rc_dev *rc_dev_get_from_fd(int fd, bool write)
 {
 	struct fd f = fdget(fd);
 	struct lirc_fh *fh;
@@ -841,6 +841,9 @@ struct rc_dev *rc_dev_get_from_fd(int fd
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


