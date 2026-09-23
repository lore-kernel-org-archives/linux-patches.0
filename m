Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EF353976D;
	Wed, 23 Sep 2026 14:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172482; cv=none; b=NK2BUD6G1e57jZZpxLf07hiZE+O8KAlrB/xMID9wPUxkkgyWIbXJJKyNSG930LTBeIZWrMqOr9u0OUNuuCmCxWhLe2y8JkZgBAOl1otowfNibhG2vqTN+4pAioMD3rmof6J+G+2ZtxTtPxwzRZnh1TzSJIny9vfh9GRMfwlWdD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172482; c=relaxed/simple;
	bh=pccZ4vAGO2wk0nzVJDLClhBQwdQFsRuKDWsvvsxIOfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+cDHONEWVUNdUcnHVuZcBM7Cw4CuPkjDPykLKvQgdlatBCSXq+w6Wrexbjl9AUAmMOci6b1aOYDY3c8myz0+JW/4t4rvqAK/0ZkJux4UySctcyB/R4NOvmk3ZRAoFMBw+RyhLKt7rgiUrxijlC/bokbdbLD0AJEvnAqnEirr8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQWznXTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQWznXTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946031F000FF;
	Wed, 23 Sep 2026 14:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172480;
	bh=0/bgJiDIEcssfp+UE6rDAmRx90yKzLZlleovt0SkR8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQWznXTVlEvusJsUydu3aWFl8MAaTRZgINxYhlBfpKe9s0QF2t4piFS2wAbxE5s+1
	 OsRAmq5+GLEZogD4b7VNLP+kKo7gYAJCs9Y8ajLyCB0/zcQvdQ+wHCPcvZAm/DgHIH
	 DibP8isT7alpu1U4TDCjO5f+uZFoaKaGeUGNLslY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 001/438] selftests/landlock: Use an actual chardev for MAKE_CHAR audit test
Date: Wed, 23 Sep 2026 16:00:22 +0200
Message-ID: <20260923140644.796580289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit 173b1bd8730825e1f6862dbd07856e7d68447a41 ]

By passing a (0, 0) device number, the audit test for
LANDLOCK_ACCESS_FS_MAKE_CHAR was accidentally creating a whiteout object
rather than a char device.  In preparation to treating whiteout objects
differently, use an actual character device instead.

Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20260813093157.1436894-2-gnoack@google.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 86e08aa6e0a7e..e82b56a74c5f5 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -7436,7 +7436,7 @@ TEST_F(audit_layout1, make_char)
 
 	enforce_fs(_metadata, ACCESS_ALL, NULL);
 
-	EXPECT_EQ(-1, mknod(file1_s1d3, S_IFCHR | 0644, 0));
+	EXPECT_EQ(-1, mknod(file1_s1d3, S_IFCHR | 0644, makedev(7, 0)));
 	EXPECT_EQ(EACCES, errno);
 	EXPECT_EQ(0, matches_log_fs(_metadata, self->audit_fd, "fs\\.make_char",
 				    dir_s1d3));
-- 
2.53.0



