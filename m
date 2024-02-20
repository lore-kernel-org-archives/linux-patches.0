Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9599B2DF9F;
	Tue, 20 Feb 2024 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464919; cv=none; b=ihZKQO6bj2+Qmr++49BmS01meoU3pEfA/O+ODCOvP2vZ3T26pdU2x72ayO4rJm7kYfJyAcJa0ibloW0TnSlnKsANEUiE+qAJ2A3lEe4gikYlYruzb0YrTbkxuVeZSb+NTnF9mIG6lMkp0bspVV1TJOJiJpUMXCwBc/jmszf9Gf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464919; c=relaxed/simple;
	bh=cp3gD1oPp+Ex/TIBQ2phGcIS+yvIKDrALSTjGNjb1ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8OxaNJBX6jnhIBBPPNW2ngm2w0y8wJMrRF1obpRPp33k7lcToJm8eIckGdxW5hCHtMJ3IJlUR+NokczzRFbb24sUvXEjjZbCeBEj8xd5DgTRzEvtFssnoFYiDOnPwXSVUj9Z1+fHKb9OzjPHe5dAENEYGBd/0aZbzNnq2MuCF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LENY/B3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LENY/B3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8725EC433C7;
	Tue, 20 Feb 2024 21:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464919;
	bh=cp3gD1oPp+Ex/TIBQ2phGcIS+yvIKDrALSTjGNjb1ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LENY/B3sGYtolkiEm4OTF+QG9fNMNgdBhIyRCkvy5DCNaDfa0YwACWuxMmdtEjxgL
	 3gMj5N3uSGS+PUsIsipAthzkhzElL8UGij3qNo9zHA2R3mpzP4MRx976kZMpLJDTtD
	 M1/P+K9PP0ienPC08jtsricbzR7XekZlvQgtC2rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.7 178/309] media: rc: bpf attach/detach requires write permission
Date: Tue, 20 Feb 2024 21:55:37 +0100
Message-ID: <20240220205638.723276226@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


