Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5E5248191;
	Mon, 23 Jun 2025 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685059; cv=none; b=Bw2x7eOYNhLtK80/JfH/js497ju8cwp58Ho0cl3uw1CDYsXmUoj4/jyFXmJxO5nNqsnOkZROLyepXnRygfDuieEB3q+XcMhtbgipe0OHYCA5E6qCxik3kaZ4ZNjBNPIXL4QrQDphDWbH1ktB2gCDdtIL0LIrvOv5MxTXey1RCp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685059; c=relaxed/simple;
	bh=7/RQ46W1USMvNb+sDImB9teg1F9sKYXKA2Fv/RsR12o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faxUQZ8BxXd6mEC9oQ5eAcCI8D5JrTBqDEI99ahI2PzqvZtukj8D2vxS9kotysMQNwdRI+kF/3c7hpWb2mKAqiFW76I4gsDHmdjGfq26ADlc7FeB9Uk9OKXkrs1jDI5AwdQqNazrw0Xi68pd92MIpdX5c9w1je4AcrMVoTFuo1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFBHu+bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFBHu+bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A58C4CEEA;
	Mon, 23 Jun 2025 13:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685059;
	bh=7/RQ46W1USMvNb+sDImB9teg1F9sKYXKA2Fv/RsR12o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFBHu+buVoBGL5Fh6GJ43ltjsDYL8PcKw+pJNXp9D/3onMO+rEeJT/p8iSbVIXTPs
	 LvPRgAO9k16UD8hhjDXZa/EZ2WcYj1EnsgP/Gwb4LIgN2C1QovQt6DncsZLw/k48X7
	 +nTLYvh9ZtWmTG36dE8Qsovnr1L2AxWmR2zv/txA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neill Kapron <nkapron@google.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/411] selftests/seccomp: fix syscall_restart test for arm compat
Date: Mon, 23 Jun 2025 15:02:56 +0200
Message-ID: <20250623130633.971316764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neill Kapron <nkapron@google.com>

[ Upstream commit 797002deed03491215a352ace891749b39741b69 ]

The inconsistencies in the systcall ABI between arm and arm-compat can
can cause a failure in the syscall_restart test due to the logic
attempting to work around the differences. The 'machine' field for an
ARM64 device running in compat mode can report 'armv8l' or 'armv8b'
which matches with the string 'arm' when only examining the first three
characters of the string.

This change adds additional validation to the workaround logic to make
sure we only take the arm path when running natively, not in arm-compat.

Fixes: 256d0afb11d6 ("selftests/seccomp: build and pass on arm64")
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://lore.kernel.org/r/20250427094103.3488304-2-nkapron@google.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index ac340a9c09187..c1da445ab4db9 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3085,12 +3085,15 @@ TEST(syscall_restart)
 	ret = get_syscall(_metadata, child_pid);
 #if defined(__arm__)
 	/*
-	 * FIXME:
 	 * - native ARM registers do NOT expose true syscall.
 	 * - compat ARM registers on ARM64 DO expose true syscall.
+	 * - values of utsbuf.machine include 'armv8l' or 'armb8b'
+	 *   for ARM64 running in compat mode.
 	 */
 	ASSERT_EQ(0, uname(&utsbuf));
-	if (strncmp(utsbuf.machine, "arm", 3) == 0) {
+	if ((strncmp(utsbuf.machine, "arm", 3) == 0) &&
+	    (strncmp(utsbuf.machine, "armv8l", 6) != 0) &&
+	    (strncmp(utsbuf.machine, "armv8b", 6) != 0)) {
 		EXPECT_EQ(__NR_nanosleep, ret);
 	} else
 #endif
-- 
2.39.5



