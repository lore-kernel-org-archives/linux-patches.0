Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49F24F93D0;
	Tue, 13 Oct 2026 12:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894467; cv=none; b=sHndCa+WYujvA8Sz5m2MJ2Wn8rihPEIMd8kKhm07dKsRG2qZFbFKKthMaatTHQbeSzn5H2YdjTQu8W4XrPgPqiZ4UBtKskva5PHqbqLyeCFEBsSeVLKuX+mmqpfeBiMqD0m0vo+NzGseKBJU/EARYscnB4owRM9dpUFxHP2OND8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894467; c=relaxed/simple;
	bh=i1yXHGZ8C0SgbR7RBHAylzXs1FiHRhrl0eNp5a5yvrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNQPZHodZwbkRlqxePXAcJUbRzdUq6vTj8hTWc3Moc883G9/HXo6TisSZPB1k5ii7A4QZkBMd2M/dIJc1wOTxNKmfvQAVMvsJ0oXMEJdpPy1mvM7Kd4Fk1DBDFgQAPl/hFFwgU/2zWEAdWpcDtLyxLcV8OuZTBotjCDJ2jm10VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJGDsZET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJGDsZET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198C11F000FF;
	Tue, 13 Oct 2026 12:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894466;
	bh=5YZB08y1mL1Nm3b05iN1gLrR7jwzEc0fIQaYBrHf9gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJGDsZETJA23y2Vkozpovi2dGuyth1j528ZE0UrwpVyG+gpsDGQVGEvVh+BcSQNzs
	 3QFym04xSCUs9sAcn2dfqfURoYVqfK9LEF/H0Ti4My6llPMx63IVwGA8BP3k+y6yL8
	 4AynGDhTOuTKtT/1/f+J9c7oKHgdjJy5yCguTIDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 533/621] fs: move mntput_no_expire() slowpath into a dedicated routine
Date: Tue, 13 Oct 2026 13:38:48 +0200
Message-ID: <20261013112933.468888349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit bfef6e1f3488fc09ae966cb4dd2cb09f73cff791 ]

In the stock variant the compiler spills several registers on the stack
and employs stack smashing protection, adding even more code + a branch
on exit..

The actual fast path is small enough that the compiler inlines it for
all callers -- the symbol is no longer emitted.

Forcing noinline on it just for code-measurement purposes shows the fast
path dropping from 111 to 39 bytes.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://patch.msgid.link/20251114201803.2183505-1-mjguzik@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7eb84d54fac5 ("fs: don't let a migrating task hide its reference from do_umount()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 0bc34cf8fe001..b7d431156738f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1342,26 +1342,12 @@ static void delayed_mntput(struct work_struct *unused)
 }
 static DECLARE_DELAYED_WORK(delayed_mntput_work, delayed_mntput);
 
-static void mntput_no_expire(struct mount *mnt)
+static void noinline mntput_no_expire_slowpath(struct mount *mnt)
 {
 	LIST_HEAD(list);
 	int count;
 
-	rcu_read_lock();
-	if (likely(READ_ONCE(mnt->mnt_ns))) {
-		/*
-		 * Since we don't do lock_mount_hash() here,
-		 * ->mnt_ns can change under us.  However, if it's
-		 * non-NULL, then there's a reference that won't
-		 * be dropped until after an RCU delay done after
-		 * turning ->mnt_ns NULL.  So if we observe it
-		 * non-NULL under rcu_read_lock(), the reference
-		 * we are dropping is not the final one.
-		 */
-		mnt_add_count(mnt, -1);
-		rcu_read_unlock();
-		return;
-	}
+	VFS_BUG_ON(mnt->mnt_ns);
 	lock_mount_hash();
 	/*
 	 * make sure that if __legitimize_mnt() has not seen us grab
@@ -1412,6 +1398,26 @@ static void mntput_no_expire(struct mount *mnt)
 	cleanup_mnt(mnt);
 }
 
+static void mntput_no_expire(struct mount *mnt)
+{
+	rcu_read_lock();
+	if (likely(READ_ONCE(mnt->mnt_ns))) {
+		/*
+		 * Since we don't do lock_mount_hash() here,
+		 * ->mnt_ns can change under us.  However, if it's
+		 * non-NULL, then there's a reference that won't
+		 * be dropped until after an RCU delay done after
+		 * turning ->mnt_ns NULL.  So if we observe it
+		 * non-NULL under rcu_read_lock(), the reference
+		 * we are dropping is not the final one.
+		 */
+		mnt_add_count(mnt, -1);
+		rcu_read_unlock();
+		return;
+	}
+	mntput_no_expire_slowpath(mnt);
+}
+
 void mntput(struct vfsmount *mnt)
 {
 	if (mnt) {
-- 
2.53.0



