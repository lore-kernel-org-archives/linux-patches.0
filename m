Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8112E46D0A6;
	Tue, 21 Jul 2026 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655402; cv=none; b=HbLGi/BvkQkgPZeJGI9lXcTllzbo0VOsRwipp2HsNOxOpdZFDevdf206CJRqkl7aNXq9YZlZaW5Jo+zGQ2Yu0gq3wYZQx2Gjg9k3IjuU7bwWw1yBcdWIZUHCzagkbfPMzL808FYWJGDijJ5F0+iH4wC96/aHkXrAL06QyTgu+tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655402; c=relaxed/simple;
	bh=h+DEUfWWMQizim2nSZ6Az7HF1v/pbDms0s2eCkZ3TI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAPWev8COlJJW2W+YiIZoZhCjvZoKqnzg05UnxwWt+7vIcGyy9XU6mnDE1uDYEStp5Yo0g/RBG80dk6EA2hX+A4J+TEOGVzSTJoKBy25t8y0Jih/9ksHzEZoVlHsZXXAiCdjVhIBQQg/XM1u3nn7cz9CwN9qnybYtjHYxZnomog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpbPiyBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpbPiyBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39641F000E9;
	Tue, 21 Jul 2026 17:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655401;
	bh=lmrG6DnkU9hc3VpLK/6mBoVeZj+LgOqAGloDwGdRuhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpbPiyBg8LdroO7Tt38R1DrOJrZzwf255JukD36+HEx/VS6e2d1GXOAuDvCbckw+z
	 HBF0t6uXGDlKguLyO1jCExdwTFOrKYcKdIRiIqLDF03sSzczr5rzbz7Y9lX/AT+CuM
	 PIEw5znDKcX6Y2lsLdUa9TJYava5X8yfJmiRgp18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2068/2077] liveupdate: validate session type before performing operation
Date: Tue, 21 Jul 2026 17:29:01 +0200
Message-ID: <20260721152641.478666319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

[ Upstream commit 507e3b479f9c6d85135eb5e1a77fb3fddb259ad8 ]

The sessions ioctls are not applicable to all session types. PRESERVE_FD
is only applicable to outgoing sessions. RETRIEVE_FD and FINISH are only
valid for incoming session. Calling a incoming ioctl on an outgoing
session is invalid and can cause file handlers to run into unexpected
errors.

For example, a user can create a (outgoing) session, preserve a memfd,
and then immediately do a retrieve without doing a kexec in between.
This would result in memfd's retrieve handler to run. The handlers
expects to be called from a post-kexec context, and will try to do a
kho_restore_vmalloc() or kho_restore_folio() to try and restore memory.

KHO catches this (thanks to KHO_PAGE_MAGIC) and returns an error, but
since this is considered an internal error and KHO throws out a bunch of
WARN()s.

Associate a type with each ioctl op and validate the type in
luo_session_ioctl() before dispatching the ioctl handler to make sure
the op is being called for the right session type.

Fixes: 16cec0d26521 ("liveupdate: luo_session: add ioctls for file preservation")
Cc: stable@vger.kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20260519122428.2378446-1-pratyush@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/liveupdate/luo_session.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -330,32 +330,58 @@ union ucmd_buffer {
 	struct liveupdate_session_retrieve_fd retrieve;
 };
 
+/* Type of sessions the ioctl applies to. */
+enum luo_ioctl_type {
+	LUO_IOCTL_INCOMING,
+	LUO_IOCTL_OUTGOING,
+	LUO_IOCTL_ALL,
+};
+
 struct luo_ioctl_op {
 	unsigned int size;
 	unsigned int min_size;
 	unsigned int ioctl_num;
+	enum luo_ioctl_type type;
 	int (*execute)(struct luo_session *session, struct luo_ucmd *ucmd);
 };
 
-#define IOCTL_OP(_ioctl, _fn, _struct, _last)                                  \
+#define IOCTL_OP(_ioctl, _fn, _struct, _last, _type)                           \
 	[_IOC_NR(_ioctl) - LIVEUPDATE_CMD_SESSION_BASE] = {                    \
 		.size = sizeof(_struct) +                                      \
 			BUILD_BUG_ON_ZERO(sizeof(union ucmd_buffer) <          \
 					  sizeof(_struct)),                    \
 		.min_size = offsetofend(_struct, _last),                       \
 		.ioctl_num = _ioctl,                                           \
+		.type = _type,                                                 \
 		.execute = _fn,                                                \
 	}
 
 static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 	IOCTL_OP(LIVEUPDATE_SESSION_FINISH, luo_session_finish,
-		 struct liveupdate_session_finish, reserved),
+		 struct liveupdate_session_finish, reserved, LUO_IOCTL_INCOMING),
 	IOCTL_OP(LIVEUPDATE_SESSION_PRESERVE_FD, luo_session_preserve_fd,
-		 struct liveupdate_session_preserve_fd, token),
+		 struct liveupdate_session_preserve_fd, token, LUO_IOCTL_OUTGOING),
 	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
-		 struct liveupdate_session_retrieve_fd, token),
+		 struct liveupdate_session_retrieve_fd, token, LUO_IOCTL_INCOMING),
 };
 
+static bool luo_ioctl_type_valid(struct luo_session *session,
+				 const struct luo_ioctl_op *op)
+{
+	switch (op->type) {
+	case LUO_IOCTL_INCOMING:
+		/* Retrieved is only set on incoming sessions */
+		return session->retrieved;
+	case LUO_IOCTL_OUTGOING:
+		return !session->retrieved;
+	case LUO_IOCTL_ALL:
+		return true;
+	}
+
+	/* Catch-all. */
+	return false;
+}
+
 static long luo_session_ioctl(struct file *filep, unsigned int cmd,
 			      unsigned long arg)
 {
@@ -380,6 +406,8 @@ static long luo_session_ioctl(struct fil
 	op = &luo_session_ioctl_ops[nr - LIVEUPDATE_CMD_SESSION_BASE];
 	if (op->ioctl_num != cmd)
 		return -ENOIOCTLCMD;
+	if (!luo_ioctl_type_valid(session, op))
+		return -EINVAL;
 	if (ucmd.user_size < op->min_size)
 		return -EINVAL;
 
@@ -659,4 +687,3 @@ err_undo:
 
 	return err;
 }
-


