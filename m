Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE8A4C6E;
	Mon, 23 Jun 2025 13:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686091; cv=none; b=tt9J4XqVE2sVJ/oRDV6dA3E9cCDjFxiVuzlc0Aw4djLLYArMy3EZUmf/mfg/JFgfTC0Qgvc+qnG/7mU9G5+flF/VznqlDFDPyssPIXKgM20rNosbvb5Yn/ok8dezNrDS8/rtdFUdmtgl5WRDKrBj2YjMENpzY1o3VMaO506bWPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686091; c=relaxed/simple;
	bh=zwcWopX4dDTuaHc0y/CIqZNIjgXywO3vwK3x+GryTNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOezYBAc4zFqiCIBL2T+iKBncgqVp5dOJpa/OpEoCMWzOUYu2JMi206UDO0KA/wRRV1IzBRTWAibM4te1mnV/FneQUzuaHn4wkNxXYgUfFikdZOnIejf4mocQk/Q9aK53I0FAlVn4EA6lGlzoCKTMAF8DjH6Ep0FpECdGeYT4uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+nlkQyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+nlkQyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F956C4CEEA;
	Mon, 23 Jun 2025 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686091;
	bh=zwcWopX4dDTuaHc0y/CIqZNIjgXywO3vwK3x+GryTNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+nlkQykmFoiGKk6bCMUaF+kr8dLgCqyoXjzD54CvJDqmA0ga1+ix/D8BuVIkHHwi
	 85GpWZaQgk3aXiqLmAAx1WNl+GK754c4jrnavRQs+EGLgTq174rR/LRdRlMqpou3Xl
	 3i6fXSy1vJHBGk03rAO/ID48THwkqZVQFCOjtSZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neill Kapron <nkapron@google.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/508] selftests/seccomp: fix syscall_restart test for arm compat
Date: Mon, 23 Jun 2025 15:01:32 +0200
Message-ID: <20250623130646.403332309@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4ae6c89913074..b300e87404d8e 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3136,12 +3136,15 @@ TEST(syscall_restart)
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



