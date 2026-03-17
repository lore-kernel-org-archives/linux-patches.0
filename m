Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9870A3F54DB;
	Tue, 17 Mar 2026 16:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766491; cv=none; b=TsZV9vn4K1Xp4c2r6a3JSGV2VuBtqTMVKDADekIeQ4cZhY9H3ml8BnAlFCFoR06KJh68YsN0csyA/kvPvYLmPYYjikYfLEH37VY9cS+6skcuN35/zTAU5r7xEFFPvfKN4N6gk+ab/4HiYzhQSbiNdq43HWw/CGGil25IUS05C60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766491; c=relaxed/simple;
	bh=pZh/Vm3LDywhWtQrwRyWVTkRbMKDxySmvf1KxmUvJ/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiDAmKrMztcOL3nd5C8uzzIOuHURrSNrsOdYodze4Fua5feZh7/dH92V0yIaqyN4Z72C2KvUWSnFKHBlpqNqW33Qkp+46eEnZ/p8SZypdPCt40gFu5QRUnNCSFdqHi+lMMewaLTje9RE/uf8uAMp3fm2QjU87xPfzmDx3v/ggx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+BvAmZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+BvAmZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12291C4AF09;
	Tue, 17 Mar 2026 16:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766491;
	bh=pZh/Vm3LDywhWtQrwRyWVTkRbMKDxySmvf1KxmUvJ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+BvAmZ3ck2CczZY0dIqgWc1M/aL5aXPR6f42x6KWbr/aVXTVJznki2mlgXFTJ0/h
	 uekjUZg5ILWN/Uv7oJCvOB9Av3vSNaBRvex6hgShnMwdbShIQF7AZAbkWcUE/N6y1t
	 ZgR7fnNwt3sAHRB1otG8wfwlMA1QC8KEglg6aA7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.19 257/378] selftests: fix mntns iteration selftests
Date: Tue, 17 Mar 2026 17:33:34 +0100
Message-ID: <20260317163016.470804170@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 4c7b2ec23cc5d880e3ffe35e8c2aad686b67723a upstream.

Now that we changed permission checking make sure that we reflect that
in the selftests.

Link: https://patch.msgid.link/20260226-work-visibility-fixes-v1-4-d2c2853313bd@kernel.org
Fixes: 9d87b1067382 ("selftests: add tests for mntns iteration")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@kernel.org # v6.14+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/filesystems/nsfs/iterate_mntns.c |   25 +++++++++------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/filesystems/nsfs/iterate_mntns.c
+++ b/tools/testing/selftests/filesystems/nsfs/iterate_mntns.c
@@ -37,17 +37,20 @@ FIXTURE(iterate_mount_namespaces) {
 	__u64 mnt_ns_id[MNT_NS_COUNT];
 };
 
+static inline bool mntns_in_list(__u64 *mnt_ns_id, struct mnt_ns_info *info)
+{
+	for (int i = 0; i < MNT_NS_COUNT; i++) {
+		if (mnt_ns_id[i] == info->mnt_ns_id)
+			return true;
+	}
+	return false;
+}
+
 FIXTURE_SETUP(iterate_mount_namespaces)
 {
 	for (int i = 0; i < MNT_NS_COUNT; i++)
 		self->fd_mnt_ns[i] = -EBADF;
 
-	/*
-	 * Creating a new user namespace let's us guarantee that we only see
-	 * mount namespaces that we did actually create.
-	 */
-	ASSERT_EQ(unshare(CLONE_NEWUSER), 0);
-
 	for (int i = 0; i < MNT_NS_COUNT; i++) {
 		struct mnt_ns_info info = {};
 
@@ -75,13 +78,15 @@ TEST_F(iterate_mount_namespaces, iterate
 	fd_mnt_ns_cur = fcntl(self->fd_mnt_ns[0], F_DUPFD_CLOEXEC);
 	ASSERT_GE(fd_mnt_ns_cur, 0);
 
-	for (;; count++) {
+	for (;;) {
 		struct mnt_ns_info info = {};
 		int fd_mnt_ns_next;
 
 		fd_mnt_ns_next = ioctl(fd_mnt_ns_cur, NS_MNT_GET_NEXT, &info);
 		if (fd_mnt_ns_next < 0 && errno == ENOENT)
 			break;
+		if (mntns_in_list(self->mnt_ns_id, &info))
+			count++;
 		ASSERT_GE(fd_mnt_ns_next, 0);
 		ASSERT_EQ(close(fd_mnt_ns_cur), 0);
 		fd_mnt_ns_cur = fd_mnt_ns_next;
@@ -96,13 +101,15 @@ TEST_F(iterate_mount_namespaces, iterate
 	fd_mnt_ns_cur = fcntl(self->fd_mnt_ns[MNT_NS_LAST_INDEX], F_DUPFD_CLOEXEC);
 	ASSERT_GE(fd_mnt_ns_cur, 0);
 
-	for (;; count++) {
+	for (;;) {
 		struct mnt_ns_info info = {};
 		int fd_mnt_ns_prev;
 
 		fd_mnt_ns_prev = ioctl(fd_mnt_ns_cur, NS_MNT_GET_PREV, &info);
 		if (fd_mnt_ns_prev < 0 && errno == ENOENT)
 			break;
+		if (mntns_in_list(self->mnt_ns_id, &info))
+			count++;
 		ASSERT_GE(fd_mnt_ns_prev, 0);
 		ASSERT_EQ(close(fd_mnt_ns_cur), 0);
 		fd_mnt_ns_cur = fd_mnt_ns_prev;
@@ -125,7 +132,6 @@ TEST_F(iterate_mount_namespaces, iterate
 		ASSERT_GE(fd_mnt_ns_next, 0);
 		ASSERT_EQ(close(fd_mnt_ns_cur), 0);
 		fd_mnt_ns_cur = fd_mnt_ns_next;
-		ASSERT_EQ(info.mnt_ns_id, self->mnt_ns_id[i]);
 	}
 }
 
@@ -144,7 +150,6 @@ TEST_F(iterate_mount_namespaces, iterate
 		ASSERT_GE(fd_mnt_ns_prev, 0);
 		ASSERT_EQ(close(fd_mnt_ns_cur), 0);
 		fd_mnt_ns_cur = fd_mnt_ns_prev;
-		ASSERT_EQ(info.mnt_ns_id, self->mnt_ns_id[i]);
 	}
 }
 


