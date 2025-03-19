Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1191C5D53;
	Wed, 19 Mar 2025 14:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394877; cv=none; b=YcZdIAYAoK99+UiGwEkLQJZix+s4F+wUzWTXYDxigXK8uI8lvHg6lE7mgg0/cidHBuM92I8hmC08O/BKW4+BiitVeCFpbMVa+3DDKGOda5X/KevDDUsvAF0Quzmo8qp9j5+17kGa1EMA3lXTJMs9iLanNYjW7KvinqBiSpThS8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394877; c=relaxed/simple;
	bh=0dEayP+Z9dLf19jsLI0Vc+byaRSPdYkLpjwTHr7VMiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwI+o8iR6d2M43f+QZu+El2NFwJfiKrEEZjIQvWhDfYLfpB7wDMmmhz/F8W+Oo9kobkXaXj98EimL210x0w6Q2IlcV9pALzfof0KOZ1lEfyTCpqko1G5JvZ8G/O3KckYx7YaB4knF0UAgf5q/fOcmGlhqkDyXr/cm4gBIkuYVoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqm/bLCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqm/bLCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CE9C4CEE4;
	Wed, 19 Mar 2025 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394876;
	bh=0dEayP+Z9dLf19jsLI0Vc+byaRSPdYkLpjwTHr7VMiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqm/bLCh5tIdDpEuKzUcfV4vnObKkQR2795uT2vsjB5OHdcUfCgHjcJxaJ2ZJrj5m
	 IzZKZ7qS3o6kkiR95KitHl91ZFHVEOtYzYfhtYIQPxH0P5ALfIoHKj6Fx/Tu1neHAp
	 TPUaZMX1H0yrG2EM4Z3dmAQT+xLlhWd6mtEov33o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 075/241] selftests: always check mask returned by statmount(2)
Date: Wed, 19 Mar 2025 07:29:05 -0700
Message-ID: <20250319143029.581510473@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 2cc02059fbc79306b53a44b1f1a4444aa3c76598 ]

STATMOUNT_MNT_OPTS can actually be missing if there are no options.  This
is a change of behavior since 75ead69a7173 ("fs: don't let statmount return
empty strings").

The other checks shouldn't actually trigger, but add them for correctness
and for easier debugging if the test fails.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://lore.kernel.org/r/20250129160641.35485-1-mszeredi@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../filesystems/statmount/statmount_test.c    | 22 ++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/statmount/statmount_test.c b/tools/testing/selftests/filesystems/statmount/statmount_test.c
index 8eb6aa606a0d5..46d289611ce86 100644
--- a/tools/testing/selftests/filesystems/statmount/statmount_test.c
+++ b/tools/testing/selftests/filesystems/statmount/statmount_test.c
@@ -383,6 +383,10 @@ static void test_statmount_mnt_point(void)
 		return;
 	}
 
+	if (!(sm->mask & STATMOUNT_MNT_POINT)) {
+		ksft_test_result_fail("missing STATMOUNT_MNT_POINT in mask\n");
+		return;
+	}
 	if (strcmp(sm->str + sm->mnt_point, "/") != 0) {
 		ksft_test_result_fail("unexpected mount point: '%s' != '/'\n",
 				      sm->str + sm->mnt_point);
@@ -408,6 +412,10 @@ static void test_statmount_mnt_root(void)
 				      strerror(errno));
 		return;
 	}
+	if (!(sm->mask & STATMOUNT_MNT_ROOT)) {
+		ksft_test_result_fail("missing STATMOUNT_MNT_ROOT in mask\n");
+		return;
+	}
 	mnt_root = sm->str + sm->mnt_root;
 	last_root = strrchr(mnt_root, '/');
 	if (last_root)
@@ -437,6 +445,10 @@ static void test_statmount_fs_type(void)
 				      strerror(errno));
 		return;
 	}
+	if (!(sm->mask & STATMOUNT_FS_TYPE)) {
+		ksft_test_result_fail("missing STATMOUNT_FS_TYPE in mask\n");
+		return;
+	}
 	fs_type = sm->str + sm->fs_type;
 	for (s = known_fs; s != NULL; s++) {
 		if (strcmp(fs_type, *s) == 0)
@@ -464,6 +476,11 @@ static void test_statmount_mnt_opts(void)
 		return;
 	}
 
+	if (!(sm->mask & STATMOUNT_MNT_BASIC)) {
+		ksft_test_result_fail("missing STATMOUNT_MNT_BASIC in mask\n");
+		return;
+	}
+
 	while (getline(&line, &len, f_mountinfo) != -1) {
 		int i;
 		char *p, *p2;
@@ -514,7 +531,10 @@ static void test_statmount_mnt_opts(void)
 		if (p2)
 			*p2 = '\0';
 
-		statmount_opts = sm->str + sm->mnt_opts;
+		if (sm->mask & STATMOUNT_MNT_OPTS)
+			statmount_opts = sm->str + sm->mnt_opts;
+		else
+			statmount_opts = "";
 		if (strcmp(statmount_opts, p) != 0)
 			ksft_test_result_fail(
 				"unexpected mount options: '%s' != '%s'\n",
-- 
2.39.5



