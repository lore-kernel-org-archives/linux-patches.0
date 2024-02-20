Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCC314A4E6;
	Tue, 20 Feb 2024 21:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464417; cv=none; b=bsSB4tYNenbe7VOvWBP4RuPhLuSuv5JcbhvfOqofUk7LD/bUSi8RblLw3iq56Nx4eZILba2Ex4L/kXxNFnHvDIu9mZ4aRfS+CweRsCLmgSd9ZXmKgC+Oh+xm3C9K7YAiQSmnbI70cz4Dgvwc6i7ZUntZc4zvAIHxP3QClzIJ/h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464417; c=relaxed/simple;
	bh=bhUu+RgW/vx5HrjHYisNAMRVe0x+icjUuYJ7ZhjwKaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJUca5Jf2t9/bdM2KpSYUm1KVq0UAn30nyKvxphnMiDlu4mlx2dXKqP6v+ahfNB0YBi98471AVQsSMQk+UrjHB3jUgFVqxfqXe7Kt+eL8wuU4/3Bxcz35so/h1oEMD9gKiuS3CKrpbmd1t+E6WhtBKvNffVywZTunsgPC+GPWho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqpJLOOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqpJLOOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D899DC433C7;
	Tue, 20 Feb 2024 21:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464417;
	bh=bhUu+RgW/vx5HrjHYisNAMRVe0x+icjUuYJ7ZhjwKaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqpJLOOPeT30jo5TryjeBN/8uRSARoTbtPM/W6CgUnuqrEDQa2AuCVnWabeDlQGzK
	 rpQ+UNiBSBEO0gf+fXQqKkSJcUuHQUn4kXU6Kcc7UADg6c86Fknk+H19TC6QyMUjSQ
	 M2f3AaXyJRdJ5EhtWGy0txIjeQa0OMiWfkJ2NuTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hu Yadi <hu.yadi@h3c.com>,
	Jiao <jiaoxupo@h3c.com>,
	Berlin <berlin@h3c.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 019/309] selftests/landlock: Fix fs_test build with old libc
Date: Tue, 20 Feb 2024 21:52:58 +0100
Message-ID: <20240220205633.779425915@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hu Yadi <hu.yadi@h3c.com>

[ Upstream commit 40b7835e74e0383be308d528c5e0e41b3bf72ade ]

One issue comes up while building selftest/landlock/fs_test on my side
(gcc 7.3/glibc-2.28/kernel-4.19).

gcc -Wall -O2 -isystem   fs_test.c -lcap -o selftests/landlock/fs_test
fs_test.c:4575:9: error: initializer element is not constant
  .mnt = mnt_tmp,
         ^~~~~~~

Signed-off-by: Hu Yadi <hu.yadi@h3c.com>
Suggested-by: Jiao <jiaoxupo@h3c.com>
Reviewed-by: Berlin <berlin@h3c.com>
Link: https://lore.kernel.org/r/20240124022908.42100-1-hu.yadi@h3c.com
Fixes: 04f9070e99a4 ("selftests/landlock: Add tests for pseudo filesystems")
[mic: Factor out mount's data string and make mnt_tmp static]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 18e1f86a6234..fde1a96ef9f4 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -241,9 +241,11 @@ struct mnt_opt {
 	const char *const data;
 };
 
-const struct mnt_opt mnt_tmp = {
+#define MNT_TMP_DATA "size=4m,mode=700"
+
+static const struct mnt_opt mnt_tmp = {
 	.type = "tmpfs",
-	.data = "size=4m,mode=700",
+	.data = MNT_TMP_DATA,
 };
 
 static int mount_opt(const struct mnt_opt *const mnt, const char *const target)
@@ -4572,7 +4574,10 @@ FIXTURE_VARIANT(layout3_fs)
 /* clang-format off */
 FIXTURE_VARIANT_ADD(layout3_fs, tmpfs) {
 	/* clang-format on */
-	.mnt = mnt_tmp,
+	.mnt = {
+		.type = "tmpfs",
+		.data = MNT_TMP_DATA,
+	},
 	.file_path = file1_s1d1,
 };
 
-- 
2.43.0



