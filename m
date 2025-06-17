Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF172EE613;
	Tue, 17 Jun 2025 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175039; cv=none; b=usfGlmgOqK/p8sDSZff75J2I6chwHE97OgWyGb+HEtR5XtUX7vbtCJUrFPhA7RF8JSKwASn9jMUESUaFc2dWoIDndDvjpr39MFI8lVd9WgFG+VlNcaW6qlcGV2cxD09g1NJTbID56kQV4coFCoiA/g8droRUDqDbcgtHKBbkqPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175039; c=relaxed/simple;
	bh=Uw+SRu5NB4HwJtbkFsy6oDYTiOwAytkgtgK6jycvOQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQMy40QCXiTNWi79ULaZOT02pxu2TwBixNDPhocPk0d2bLblGzSMb/DZqgI+qSbRpHPu6yr8NtEBTCww/0htXlqpy0M+ZG3XqlskCTcav3hfiLoKJ+y8yIuYS6yFWGArz3DivuushsNs408dziljEw5RJnPvh31r1zUf09yr7Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=St4l1VVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="St4l1VVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ED1C4CEE3;
	Tue, 17 Jun 2025 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175038;
	bh=Uw+SRu5NB4HwJtbkFsy6oDYTiOwAytkgtgK6jycvOQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=St4l1VVKGvvvlH8e45O0wlc0cz5mnAmQtwyjLKGxoBszh4JU7T95J+goGMLOeEuCE
	 yuy3w1Y1YtI7v57eBa1110rgIEGpQfL4J8eU6XUfqV/if7FoytT+/DxpcNnDV5WU4Z
	 aqeNfqpngM5xo9aEruThTnR0reh4lhUCNrP//fLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neill Kapron <nkapron@google.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/512] selftests/seccomp: fix syscall_restart test for arm compat
Date: Tue, 17 Jun 2025 17:20:52 +0200
Message-ID: <20250617152423.056804383@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c3a73461475b..abc32e4352df3 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3155,12 +3155,15 @@ TEST(syscall_restart)
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



