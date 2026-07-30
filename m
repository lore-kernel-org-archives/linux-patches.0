Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FA736607D;
	Thu, 30 Jul 2026 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426810; cv=none; b=nvCAGFxN4dlWeCIF79ikD/bIaYEkfh/v2dGqjEwUJRrv1KcztBXePwQ2JJosdeXIAG31aLgKxPdBNVMyPTy3mcnhUuV2kYE7L7ygRIIYhsetK0McN389W8KoNtzf3VQ1ya61+Wy6CcPy/+oWfSJYYQ84QtlL5+szq40dj0bLHm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426810; c=relaxed/simple;
	bh=SerOAIHKyqH5jy6QtdcucfabjSVAhQzrMjzgEDqD4FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo97tdm+W+UPMbSi6Q8pa2k9sovEAPwQi/ERJ/Wn90YHKIiWsmd06LJHLupRzn1JeafFU7M08lbOy1RuIYVC9D9y++DVRhteYh5BzH4ea4OivWZRmFVEXWmgQPK/YSdIc4ikNiryPCld1lKbLL+xnSEAOQEdGQWysZKwuc2XsUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/Fr3IFC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/Fr3IFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4DA1F000E9;
	Thu, 30 Jul 2026 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426809;
	bh=Wn4XLzJHRhh/1y2xwgI0+DCuztj2hw2OxVwgKDD13BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/Fr3IFCo/kuE05JDifxzqRM3JRVwjRNoQRMmIPYU8dLUig917KT2Ld88+jOcnONf
	 uj6hWJfs8C9ZQryq4C3MItfvFuIXaRf+JRkxl1hKzRHy6dWVmDgJgbCvkPogv1oTLt
	 nE39Ws32TO5fkuk7uZwn7jjcQpiHLnwqD5M93sGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 549/602] cred: add kernel_cred() helper
Date: Thu, 30 Jul 2026 16:15:41 +0200
Message-ID: <20260730141447.566011632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 4c7ceeb62d3330b6fb2b549ae833a92c0f481f3e ]

Access kernel creds based off of init_task. This will let us avoid any
direct access to init_cred.

Link: https://patch.msgid.link/20251103-work-creds-init_cred-v1-2-cb3ec8711a6a@kernel.org
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 981ccd97f715 ("dm: avoid leaking the caller's thread keyring via the table device file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cred.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -20,6 +20,8 @@
 struct cred;
 struct inode;
 
+extern struct task_struct init_task;
+
 /*
  * COW Supplementary groups list
  */
@@ -158,6 +160,11 @@ extern void abort_creds(struct cred *);
 extern const struct cred *override_creds(const struct cred *);
 extern void revert_creds(const struct cred *);
 extern struct cred *prepare_kernel_cred(struct task_struct *);
+static inline const struct cred *kernel_cred(void)
+{
+	/* shut up sparse */
+	return rcu_dereference_raw(init_task.cred);
+}
 extern int set_security_override(struct cred *, u32);
 extern int set_security_override_from_ctx(struct cred *, const char *);
 extern int set_create_files_as(struct cred *, struct inode *);


