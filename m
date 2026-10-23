Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774500;
	b=CwK0MEPqidCtqLGjqtj9ckss8DHW2XXZxKFkkyiE1VMCXLJba0Wv6BoRQ0W2TYFE80VA
	 iYQtIUUBOw9vwQWFxKVpgFoYfaYheWXZrP1lbkdzFgKmVLf4lGIv1+SbmeZ50dSzG/Bzx
	 Qps0LESh/Z5h7ApjJsbiyMtS3EQDXTqZjria+Wcjdg+G0PGjN1NTkTG8QOf2O7VqxdOFo
	 x2qsZkIM2fuGrxWnNp7Ry/3sdd5aAlYk1QNkPJPH0a+NVg/xPVS3uqZOri0XRdxpjcbFH
	 GEfnQuiEiZZ/PmR3zR+iigY/lvNh8kiLY/mScoBovPcaVvjmuNVktpkW8o7b3OW2QnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zcjhYWjZeOy7N+pC4LaCHw+/Rt4hNRbEjiPsNqMWdD4=;
	b=NRdjSxpTXb8/dhjU4cEcQI83E8RYQia6bX6jTcvTX7oBjrFgHa+qkNHdZA1jc2SJhowH
	 TexgeJZ8w5NAOCSuiEFdzw9i3XwSViKlGUO7sfTH+t28+ojz2NFn81NBe+F4wuE43Vzzx
	 ZG5/40z9Iur8iow3RCnsoDXHBMZlcsiGGL2kFLFDF3YwOBejkekrWaa5Vqw60jg/XiCP3
	 bkLVBWDvQjxqghzV9lmnWM0q75/kxWwS7c6C/ke6eHIww4AZj6VRYip2M8FA3A7rTVaib
	 jZk7UPwsDUsPDkMOMTYsfUGVYxCEucx8caOl8MUJ9gXJ60anlr8Wjtv6yRwKfwWS3xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iIridc/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B20606A31B;
	Fri, 23 Oct 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIridc/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B20E1F01825;
	Fri, 23 Oct 2026 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774499;
	bh=zcjhYWjZeOy7N+pC4LaCHw+/Rt4hNRbEjiPsNqMWdD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIridc/StOljFuHXZgwQ2CfJEDbBsDasKHwfcq0Vpxf8kzYrvLC4hCId8S162BZEk
	 G8lSMTxqDrFc1vO/FhgXJ1cCgsKgEYGYgnDU2kWjsulNJ7nsjEx8ebqvSqpBrz9qcH
	 0xklOqZVbhTWRtigCBgArRDk8u2cjg8rJ8pOUSKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 062/242] fs: add scoped_with_init_fs()
Date: Fri, 23 Oct 2026 18:38:24 +0200
Message-ID: <20261023163715.248048727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 67c54d1d730a8b7a43f2560dcea9b7dc95fba1cd ]

Similar to scoped_with_kernel_creds() allow a temporary override of
current->fs to serve the few places where lookup is performed from
kthread context or needs init's filesytem state.

Link: https://patch.msgid.link/20260601-work-kthread-nullfs-v4-3-77ee053060e0@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: d2bdb9b61b42 ("fs: let idle threads share init_fs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs_struct.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index ade459383f925..e11d0e57168fd 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -6,6 +6,7 @@
 #include <linux/path.h>
 #include <linux/spinlock.h>
 #include <linux/seqlock.h>
+#include <linux/vfsdebug.h>
 
 struct fs_struct {
 	int users;
@@ -49,4 +50,34 @@ static inline int current_umask(void)
 	return current->fs->umask;
 }
 
+/*
+ * Temporarily use userspace_init_fs for path resolution in kthreads.
+ * Callers should use scoped_with_init_fs() which automatically
+ * restores the original fs_struct at scope exit.
+ */
+static inline struct fs_struct *__override_init_fs(void)
+{
+	struct fs_struct *fs;
+
+	fs = current->fs;
+	WRITE_ONCE(current->fs, fs);
+	return fs;
+}
+
+static inline void __revert_init_fs(struct fs_struct *revert_fs)
+{
+	VFS_WARN_ON_ONCE(current->fs != revert_fs);
+	WRITE_ONCE(current->fs, revert_fs);
+}
+
+DEFINE_CLASS(__override_init_fs,
+	     struct fs_struct *,
+	     __revert_init_fs(_T),
+	     __override_init_fs(), void)
+
+#define scoped_with_init_fs() \
+	scoped_class(__override_init_fs, __UNIQUE_ID(label))
+
+void __init init_userspace_fs(void);
+
 #endif /* _LINUX_FS_STRUCT_H */
-- 
2.53.0



