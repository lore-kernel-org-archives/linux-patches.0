Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774515;
	b=KGpfgwlx9etscuMeD5SvNe02KYVe5elOYg3qcq60sp29kvvrntRNcGUXCJRKrNwMAipa
	 qYOVE4loWSRnaf7NYHfCUv0yYoV4dSAwzaURTbxKv8aUhb7eNxfggIGybI5AK0tCK6LAD
	 6P1pew+PHDSMGIKUUAV0a9A9vHqews+tUsCw1e6DG9ZQYJJwLGuwk2Lq+BcPMgVgLiUiY
	 pJK1ZYXBvVsZmSZVcS36ppvCp87sIPIa9EiIUi7GDe/exH7lfxm7vvK/IqhryiBURVJtN
	 iGwCMMbDDjJsZx31aSOF7G+prTw1zO0iibcQopCk/Itf8z3e4/sQQWyxLnQapPhXZkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=baeDLGoAzf0vg2gFAitpEjCeslbaBgog/I60NAqcajE=;
	b=RzOlklUolBppl4onBfEOzjMMAwWfl9Oqcp8gd1kB447U1G+YNgfOACzQs/xZ054kpXj1
	 EXHp3OLR/oHxGnNV1AQF5uMK5og9AEpMCDrkxS3+eS4tGEdSlmOS4jyiugBMPVn+i09q5
	 wtA31JFve4BTr+PNpC+B1dBYwT+kQN8/mDRUEAo+C9cIxqLQocl8kS1oONf6IjUVzoyJv
	 XFxvF5ItTVEhUUO9+A2CpNt9qqMhhC9dKGBuR8kUamUjkYh/DpbLcWeTPpWZQK1Xzr5Mi
	 UPWP5/c/cCoK5wlvvmRfpq6LxoUqnz7KLbL62MUeFHOVyJzVtKjgdygdI/gv5nm3D2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUfcYVAu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6956606A31D;
	Fri, 23 Oct 2026 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUfcYVAu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A98B1F01825;
	Fri, 23 Oct 2026 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774514;
	bh=baeDLGoAzf0vg2gFAitpEjCeslbaBgog/I60NAqcajE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUfcYVAuJYmzkkWNTWnY3GaMSoVwuU2kaE2VwtO6ao2d0iHEd2cD43Sf2KgxSNGHE
	 y4ng1pVv8gP9ekJPdKgu6vNPfreItvMqt7jeixVs3rbZmquGxB475+7MtsFtOWpMV0
	 s+pE5N2PW5AVvJY6gJBf4wGLgsbioMwtbqib9RNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 066/242] fs: pass flags to copy_fs()
Date: Fri, 23 Oct 2026 18:38:28 +0200
Message-ID: <20261023163715.345530918@linuxfoundation.org>
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

[ Upstream commit 9cd0df397a119d6b95ad68e2c82b69b4d620694e ]

Turn the umh boolean into a flags argument. Idle threads need their own
case in copy_fs() as well and that's nicer than a second boolean.

No functional changes.

Link: https://patch.msgid.link/20261013-work-fs-idle_fs-v1-1-2063d1bcb5aa@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: d2bdb9b61b42 ("fs: let idle threads share init_fs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 2f736fa44798b..92edfd918b74b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1618,7 +1618,12 @@ static int copy_exec_state(u64 clone_flags, struct task_struct *tsk)
 	return task_exec_state_copy(tsk);
 }
 
-static int copy_fs(u64 clone_flags, struct task_struct *tsk, bool umh)
+enum copy_fs_flags_t {
+	COPY_FS_UMH	= (1 << 0),
+};
+
+static int copy_fs(u64 clone_flags, struct task_struct *tsk,
+		   enum copy_fs_flags_t flags)
 {
 	struct fs_struct *fs;
 
@@ -1628,7 +1633,7 @@ static int copy_fs(u64 clone_flags, struct task_struct *tsk, bool umh)
 	 * filesystem state, or be started from a non-initial mount
 	 * namespace.
 	 */
-	if (umh) {
+	if (flags & COPY_FS_UMH) {
 		if (clone_flags & (CLONE_NEWNS | CLONE_FS))
 			return -EINVAL;
 		if (current->nsproxy->mnt_ns != &init_mnt_ns)
@@ -2298,7 +2303,7 @@ __latent_entropy struct task_struct *copy_process(
 	retval = copy_files(clone_flags, p, args->no_files);
 	if (retval)
 		goto bad_fork_cleanup_semundo;
-	retval = copy_fs(clone_flags, p, args->umh);
+	retval = copy_fs(clone_flags, p, args->umh ? COPY_FS_UMH : 0);
 	if (retval)
 		goto bad_fork_cleanup_files;
 	retval = copy_sighand(clone_flags, p);
-- 
2.53.0



