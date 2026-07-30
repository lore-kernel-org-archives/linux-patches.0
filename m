Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A146B442FBC;
	Thu, 30 Jul 2026 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425211; cv=none; b=ilTcAomkqOnAJNx5HAMgpxv7bqYJbIzgwtzNFmnu0jF+Hyugz2EDbMzZcnmNNmOl67eAlHm4o9F/Wv6APV6QpOzvcHpxPDDaeG6rgyHMaRJMEoNul0gE4U2M5Txsy63yKkn3ETJ/pl9YluXJN8NaYCbmwrs9MEnEYpXEiXE2E5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425211; c=relaxed/simple;
	bh=VQpXPv6AWnd1EBncNAOc6OPTLJdTg13mPzSCR28nOew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cthB7W/iDTr7fXXXwJ8brNODyNmfHlTnKULuDYn8LIbKcMUsohsmL5v5w1akrcDfjEmrxLABrf8YCsmRPxJdjRU5L0OwCu+a3eKoucOF3ZLXR8N+SNQc0u1fVfa7TzODyNGWGMJinGsB8QXtDxi7aIWFgvMyquALYWpBmFwzG8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0Thd3qn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0Thd3qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D711F00A3E;
	Thu, 30 Jul 2026 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425210;
	bh=BRaz1sxelUyIItOx5VX4LaQvjFNl6b2k92rTDCT0XVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R0Thd3qnfK4A+Kau41dYznarRts+nhlh1FyxEK9NRf8d9Q1VRh3eFZtnmD4E/in+o
	 UHxJfYk5BJ17W7LZo3VSAVi5cZTRJhBkpy+V5Vf5tIB6M3H/pQOfCvWOYGMvWU2+r3
	 80UUVglq8jq4Dgy/8EK4Zo+1wP3F2xU7SnpT5zBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 645/675] cred: add kernel_cred() helper
Date: Thu, 30 Jul 2026 16:16:15 +0200
Message-ID: <20260730141458.845070833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -156,6 +158,11 @@ extern struct cred *prepare_exec_creds(v
 extern int commit_creds(struct cred *);
 extern void abort_creds(struct cred *);
 extern struct cred *prepare_kernel_cred(struct task_struct *);
+static inline const struct cred *kernel_cred(void)
+{
+	/* shut up sparse */
+	return rcu_dereference_raw(init_task.cred);
+}
 extern int set_security_override(struct cred *, u32);
 extern int set_security_override_from_ctx(struct cred *, const char *);
 extern int set_create_files_as(struct cred *, struct inode *);


