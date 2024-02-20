Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C2F14A4E6;
	Tue, 20 Feb 2024 21:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464429; cv=none; b=FP3OhxpUYLEC+RLPIP4eHsm5w/wQOf6ya/oOyxqf48htNd/TnVKyfHhPI5tck+uhp15jtqTYZioC30+S5HgIrnbxpY/3irUFKcKtxVU5nhst0aStlnRDlhNUTgrYgU+0iQ96C0XELKN4Poy2wYINbIddwoHEfEITnnhtIZE1jPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464429; c=relaxed/simple;
	bh=TDiJPxS53aa7qgobsRqXPVBoW4ak7yuF81imzFL5igo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6wi7cRS2yVUfBw26g56YFwAp3YT4cYyiABfRoHzdsDNwUmYqzffbsCb+SPQLHr7icVqhfxjPZuZxzdvlUat5wvNVfG70tCujQR+lm/CIPyyQ9+n9uo2luRxPr8/Xu319hKWNoJkDkHxMivaMU813TchU41k5Ny2LBpj2I8tOEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bMkU34M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bMkU34M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437DAC433C7;
	Tue, 20 Feb 2024 21:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464429;
	bh=TDiJPxS53aa7qgobsRqXPVBoW4ak7yuF81imzFL5igo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bMkU34MrS7uBOaJwutZ49xtJy4BamtF5YEY7ScD9Afpu3WbPYVm1BdBckcUNtfbL
	 4r/mqPKlDy7dTRg5zedLNh/wRZSQdWKF7xsw566Pe8e5bal/Nmkl7QvOgOMXYIA7sp
	 uDeBRPGpOUjezh+fR6VjfKB/HzPlEzDAdcSU6FJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 022/309] selftests/landlock: Fix capability for net_test
Date: Tue, 20 Feb 2024 21:53:01 +0100
Message-ID: <20240220205633.877683678@linuxfoundation.org>
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

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit bb6f4dbe2639d5b8a9fde4bfb6fefecfd3f18df3 ]

CAP_NET_ADMIN allows to configure network interfaces, not CAP_SYS_ADMIN
which only allows to call unshare(2).  Without this change, running
network tests as a non-root user but with all capabilities would fail at
the setup_loopback() step with "RTNETLINK answers: Operation not
permitted".

The issue is only visible when running tests with non-root users (i.e.
only relying on ambient capabilities).  Indeed, when configuring the
network interface, the "ip" command is called, which may lead to the
special handling of capabilities for the root user by execve(2).  If
root is the caller, then the inherited, permitted and effective
capabilities are all reset, which then includes CAP_NET_ADMIN.  However,
if a non-root user is the caller, then ambient capabilities are masked
by the inherited ones, which were explicitly dropped.

To make execution deterministic whatever users are running the tests,
set the noroot secure bit for each test, and set the inheritable and
ambient capabilities to CAP_NET_ADMIN, the only capability that may be
required after an execve(2).

Factor out _effective_cap() into _change_cap(), and use it to manage
ambient capabilities with the new set_ambient_cap() and
clear_ambient_cap() helpers.

This makes it possible to run all Landlock tests with check-linux.sh
from https://github.com/landlock-lsm/landlock-test-tools

Cc: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Fixes: a549d055a22e ("selftests/landlock: Add network tests")
Link: https://lore.kernel.org/r/20240125153230.3817165-2-mic@digikod.net
[mic: Make sure SECBIT_NOROOT_LOCKED is set]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/common.h   | 48 +++++++++++++++++----
 tools/testing/selftests/landlock/net_test.c |  5 ++-
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 5b79758cae62..e64bbdf0e86e 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -9,6 +9,7 @@
 
 #include <errno.h>
 #include <linux/landlock.h>
+#include <linux/securebits.h>
 #include <sys/capability.h>
 #include <sys/socket.h>
 #include <sys/syscall.h>
@@ -115,11 +116,16 @@ static void _init_caps(struct __test_metadata *const _metadata, bool drop_all)
 		/* clang-format off */
 		CAP_DAC_OVERRIDE,
 		CAP_MKNOD,
+		CAP_NET_ADMIN,
+		CAP_NET_BIND_SERVICE,
 		CAP_SYS_ADMIN,
 		CAP_SYS_CHROOT,
-		CAP_NET_BIND_SERVICE,
 		/* clang-format on */
 	};
+	const unsigned int noroot = SECBIT_NOROOT | SECBIT_NOROOT_LOCKED;
+
+	if ((cap_get_secbits() & noroot) != noroot)
+		EXPECT_EQ(0, cap_set_secbits(noroot));
 
 	cap_p = cap_get_proc();
 	EXPECT_NE(NULL, cap_p)
@@ -137,6 +143,8 @@ static void _init_caps(struct __test_metadata *const _metadata, bool drop_all)
 			TH_LOG("Failed to cap_set_flag: %s", strerror(errno));
 		}
 	}
+
+	/* Automatically resets ambient capabilities. */
 	EXPECT_NE(-1, cap_set_proc(cap_p))
 	{
 		TH_LOG("Failed to cap_set_proc: %s", strerror(errno));
@@ -145,6 +153,9 @@ static void _init_caps(struct __test_metadata *const _metadata, bool drop_all)
 	{
 		TH_LOG("Failed to cap_free: %s", strerror(errno));
 	}
+
+	/* Quickly checks that ambient capabilities are cleared. */
+	EXPECT_NE(-1, cap_get_ambient(caps[0]));
 }
 
 /* We cannot put such helpers in a library because of kselftest_harness.h . */
@@ -158,8 +169,9 @@ static void __maybe_unused drop_caps(struct __test_metadata *const _metadata)
 	_init_caps(_metadata, true);
 }
 
-static void _effective_cap(struct __test_metadata *const _metadata,
-			   const cap_value_t caps, const cap_flag_value_t value)
+static void _change_cap(struct __test_metadata *const _metadata,
+			const cap_flag_t flag, const cap_value_t cap,
+			const cap_flag_value_t value)
 {
 	cap_t cap_p;
 
@@ -168,7 +180,7 @@ static void _effective_cap(struct __test_metadata *const _metadata,
 	{
 		TH_LOG("Failed to cap_get_proc: %s", strerror(errno));
 	}
-	EXPECT_NE(-1, cap_set_flag(cap_p, CAP_EFFECTIVE, 1, &caps, value))
+	EXPECT_NE(-1, cap_set_flag(cap_p, flag, 1, &cap, value))
 	{
 		TH_LOG("Failed to cap_set_flag: %s", strerror(errno));
 	}
@@ -183,15 +195,35 @@ static void _effective_cap(struct __test_metadata *const _metadata,
 }
 
 static void __maybe_unused set_cap(struct __test_metadata *const _metadata,
-				   const cap_value_t caps)
+				   const cap_value_t cap)
 {
-	_effective_cap(_metadata, caps, CAP_SET);
+	_change_cap(_metadata, CAP_EFFECTIVE, cap, CAP_SET);
 }
 
 static void __maybe_unused clear_cap(struct __test_metadata *const _metadata,
-				     const cap_value_t caps)
+				     const cap_value_t cap)
+{
+	_change_cap(_metadata, CAP_EFFECTIVE, cap, CAP_CLEAR);
+}
+
+static void __maybe_unused
+set_ambient_cap(struct __test_metadata *const _metadata, const cap_value_t cap)
+{
+	_change_cap(_metadata, CAP_INHERITABLE, cap, CAP_SET);
+
+	EXPECT_NE(-1, cap_set_ambient(cap, CAP_SET))
+	{
+		TH_LOG("Failed to set ambient capability %d: %s", cap,
+		       strerror(errno));
+	}
+}
+
+static void __maybe_unused clear_ambient_cap(
+	struct __test_metadata *const _metadata, const cap_value_t cap)
 {
-	_effective_cap(_metadata, caps, CAP_CLEAR);
+	EXPECT_EQ(1, cap_get_ambient(cap));
+	_change_cap(_metadata, CAP_INHERITABLE, cap, CAP_CLEAR);
+	EXPECT_EQ(0, cap_get_ambient(cap));
 }
 
 /* Receives an FD from a UNIX socket. Returns the received FD, or -errno. */
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index e07267acbc9a..4499b2736e1a 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -107,8 +107,11 @@ static void setup_loopback(struct __test_metadata *const _metadata)
 {
 	set_cap(_metadata, CAP_SYS_ADMIN);
 	ASSERT_EQ(0, unshare(CLONE_NEWNET));
-	ASSERT_EQ(0, system("ip link set dev lo up"));
 	clear_cap(_metadata, CAP_SYS_ADMIN);
+
+	set_ambient_cap(_metadata, CAP_NET_ADMIN);
+	ASSERT_EQ(0, system("ip link set dev lo up"));
+	clear_ambient_cap(_metadata, CAP_NET_ADMIN);
 }
 
 static bool is_restricted(const struct protocol_variant *const prot,
-- 
2.43.0



