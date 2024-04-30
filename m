Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CC512C462;
	Tue, 30 Apr 2024 10:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474352; cv=none; b=Dde5P5rLxniiRheGcYuLm85UaAyhb4CZ+0CYWlkaHgVUk3BptkQs51XSHLlgV+YhGvunR2YrGFxT6cmI5+Yj18+GmHjCCKB9Q3ao60kdcaTGMUsJu/tY8vN13N3vV8yFOEVqYbzc+2FRACUrGBJQjymlVBlK63A56e6gzy41e3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474352; c=relaxed/simple;
	bh=/hiDeTv0tVkuNjPwdcuIChKw1aszxw1iK/qlFPs5mR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUuqMno01VrXgHOa1tEnv5CSxxWcf/YIykiQDixGVm5CpS7kzdSAf+NZeAXX43aP6hv1aqes05aa8tK2vAPpNjhw6SC2msvIDeNBsAMD7+uegd6xvcITET6u2Q8ra1OiiXhqBepOKj3EpcaBNxXZW5omcqyyCdztsDaor0qqoIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUk7e9nL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUk7e9nL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF04C2BBFC;
	Tue, 30 Apr 2024 10:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474352;
	bh=/hiDeTv0tVkuNjPwdcuIChKw1aszxw1iK/qlFPs5mR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUk7e9nLcW9OTqgsvPP1utWNjD4oPXNj92Mes4xzpKAm2w6jwZEQVD5llAy2bqzzv
	 03sI8Genib0AezLKMSdtP5Grlw6jXWAZlDMaqauVteOABIjH99+SdJVy9TPELs0IQC
	 H9P09cctdHWM5TtAGyEzH9+jw9bT5z0o+rjVQKDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.8 131/228] selftests/seccomp: Handle EINVAL on unshare(CLONE_NEWPID)
Date: Tue, 30 Apr 2024 12:38:29 +0200
Message-ID: <20240430103107.584006468@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Tritton <terry.tritton@linaro.org>

commit ecaaa55c9fa5e8058445a8b891070b12208cdb6d upstream.

unshare(CLONE_NEWPID) can return EINVAL if the kernel does not have the
CONFIG_PID_NS option enabled.

Add a check on these calls to skip the test if we receive EINVAL.

Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Link: https://lore.kernel.org/r/20240124141357.1243457-2-terry.tritton@linaro.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3709,7 +3709,12 @@ TEST(user_notification_sibling_pid_ns)
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
-		ASSERT_EQ(unshare(CLONE_NEWPID), 0);
+		ASSERT_EQ(unshare(CLONE_NEWPID), 0) {
+			if (errno == EPERM)
+				SKIP(return, "CLONE_NEWPID requires CAP_SYS_ADMIN");
+			else if (errno == EINVAL)
+				SKIP(return, "CLONE_NEWPID is invalid (missing CONFIG_PID_NS?)");
+		}
 
 		pid2 = fork();
 		ASSERT_GE(pid2, 0);
@@ -3727,6 +3732,8 @@ TEST(user_notification_sibling_pid_ns)
 	ASSERT_EQ(unshare(CLONE_NEWPID), 0) {
 		if (errno == EPERM)
 			SKIP(return, "CLONE_NEWPID requires CAP_SYS_ADMIN");
+		else if (errno == EINVAL)
+			SKIP(return, "CLONE_NEWPID is invalid (missing CONFIG_PID_NS?)");
 	}
 	ASSERT_EQ(errno, 0);
 


