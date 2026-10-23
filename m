Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774497;
	b=w8yxyUYw1te4stG1bDplLC1osoOUR17MPVOBaQGHBY3khMGkLVvstTF9Yrl4xnEgjwmG
	 Nl+MeLgCR79Y3Whkp01Ds9K5O8Y18dHEWpw+C6VzwykED+6uM7YowKlTkGKcnOt5jfq7r
	 Sm7lvI7qFGz6+E45tkOfqcZNMXTmWR4lNL4+IqG0t2Zejh0zWoSzqYg3hNBRvrp7ILyQp
	 0G3Pi3TA6pklOi8jbSlhhmj/WPCUqA3J83m5mFhSqdMJe2zFcjJYdetKisgrL1mF5D0DV
	 eUkdH+Oq/eZGgSUnYtYZxq1ZZ07gXD9JQZT438Q/HgnAkUu89KBNe7YaCaCj4pspf6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QL9kGokBDD9IvDJ2fZyq8lutpYj/lYFDrvowuKNPG5E=;
	b=e9e4BoI8gms31AVgfytrdYKSWDrqEsgxYxjuQdo07+z4bJAkzs9qSGfB8M5ZVOFFys4X
	 /8zpWIGq8ws/ONdqX3Jd7ifgNrmpQr9wH1GaY8ZsY5sjr9eoJFQlxU2laVrr6pOF4ojdn
	 N778OJ8ldOx4L40b5O4ZWraLjNBNr3ZqbHgaJBvP7HXcaVYSns/z7cRltD0Lm4xqFe/2F
	 XBya+QpO9zJqu7Aa78tGjJDD7HkzDTO0GogXDcrOhh6ug4E97m4pM75rNZnED7sWN56Nd
	 sT022imHxGX31QfnbzwsM3LQBwUbYpstgWt6PU9rFLIgZpYmN2+DmoTP5zT3IUT9zDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVP0PykO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3330D606A31B;
	Fri, 23 Oct 2026 16:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVP0PykO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BF71F01828;
	Fri, 23 Oct 2026 16:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774496;
	bh=QL9kGokBDD9IvDJ2fZyq8lutpYj/lYFDrvowuKNPG5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVP0PykOcP+bVdFGW59cKVT5dD87x8MP+AJx72HcrP2rweMLH38wNwmExBVGhVM2V
	 Ke2MorvMOJGASdG9FAR5LmHcfzaQw+r4yXIxM0u/730grd4U5/vaG/0mwABi4Deadh
	 4LDnnz5DQ/Gb9vsesuMwgt4Yl9QRr0kk0SOyQ5hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 061/242] fs: notice when init abandons fs sharing
Date: Fri, 23 Oct 2026 18:38:23 +0200
Message-ID: <20261023163715.225321404@linuxfoundation.org>
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

[ Upstream commit d114eb8577bd8d6c307ab0a096ae7df93fb7e011 ]

PID 1 may choose to stop sharing fs_struct state with us. Either via
unshare(CLONE_FS) or unshare(CLONE_NEWNS). Of course, PID 1 could have
chosen to create arbitrary process trees that all share fs_struct state
via CLONE_FS. This is a strong statement: We only care about PID 1 aka
the thread-group leader so subthread's fs_struct state doesn't matter.

PID 1 unsharing fs_struct state is a bug. PID 1 relies on various
kthreads to be able to perform work based on its fs_struct state.
Breaking that contract sucks for both sides. So just don't bother with
extra work for this. No sane init system should ever do this.

Link: https://patch.msgid.link/20260601-work-kthread-nullfs-v4-2-77ee053060e0@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: d2bdb9b61b42 ("fs: let idle threads share init_fs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_struct.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index c441586537e7e..fcecf209f1a9e 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -147,6 +147,30 @@ int unshare_fs_struct(void)
 }
 EXPORT_SYMBOL_GPL(unshare_fs_struct);
 
+/*
+ * PID 1 may choose to stop sharing fs_struct state with us.
+ * Either via unshare(CLONE_FS) or unshare(CLONE_NEWNS). Of
+ * course, PID 1 could have chosen to create arbitrary process
+ * trees that all share fs_struct state via CLONE_FS. This is a
+ * strong statement: We only care about PID 1 aka the thread-group
+ * leader so subthread's fs_struct state doesn't matter.
+ *
+ * PID 1 unsharing fs_struct state is a bug. PID 1 relies on
+ * various kthreads to be able to perform work based on its
+ * fs_struct state. Breaking that contract sucks for both sides.
+ * So just don't bother with extra work for this. No sane init
+ * system should ever do this.
+ */
+static inline void validate_fs_switch(struct fs_struct *old_fs)
+{
+	if (likely(current->pid != 1))
+		return;
+	/* @old_fs may be dangling but for comparison it's fine */
+	if (old_fs != &init_fs)
+		return;
+	pr_warn("VFS: Pid 1 stopped sharing filesystem state\n");
+}
+
 struct fs_struct *switch_fs_struct(struct fs_struct *new_fs)
 {
 	struct fs_struct *fs;
@@ -162,6 +186,7 @@ struct fs_struct *switch_fs_struct(struct fs_struct *new_fs)
 		read_sequnlock_excl(&fs->seq);
 	}
 
+	validate_fs_switch(fs);
 	return new_fs;
 }
 
-- 
2.53.0



