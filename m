Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F7112CDA5;
	Tue, 30 Apr 2024 11:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475484; cv=none; b=SqVIisRDwpHwh3egwCARcvg2fcajAavZzh4CnWjL++KwmjrVS+mgS9bkBQgCu8fC8PjZnaBQReZUj5FPQGstHlF6fhagLBi63Dx7FgWjY1/+plOK93LN6pOySXjSfqRfPcvRE4Ku3MbYiUcY9nU+ALxrq9I/NIq6oHk1QdU3r7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475484; c=relaxed/simple;
	bh=rJsdoz7cE1rJMzRa/gLBiNYBBJMdUSWegWZnNTp5bnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA4OPBfMWXuuzCp7GJll38rHr0tEUAlhfx+5mrF+58WvmY4bz9ki7NidrBJ8QhPjpiB/tVDLN+H8ES6yVEliFeN4VdIphBZjNTOQUAvuWvj1JNgBG+4BlFX7KE81X2aIvOh3lRAlvTP5lL5PXeeLKr8Ge+JMQYa+86r0T6n47ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Atelq23j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Atelq23j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D646C2BBFC;
	Tue, 30 Apr 2024 11:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475484;
	bh=rJsdoz7cE1rJMzRa/gLBiNYBBJMdUSWegWZnNTp5bnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Atelq23j+rpo45Wj0KE65BbayfKYotFaZhE/hov02o2xCKWW+4LNAgPadvrw47CT0
	 4HvAwS2xpQk+a4SlcBOpEzIlPmuyYL6AwFonBaf8+lIv8qoHzxoVd9SzjElZJrcbwq
	 4IHWg300twWdYstart8O+YWG+vcve7A5Mr2j4sLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.6 108/186] selftests/seccomp: Change the syscall used in KILL_THREAD test
Date: Tue, 30 Apr 2024 12:39:20 +0200
Message-ID: <20240430103101.169185926@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Tritton <terry.tritton@linaro.org>

commit 471dbc547612adeaa769e48498ef591c6c95a57a upstream.

The Bionic version of pthread_create used on Android calls the prctl
function to give the stack and thread local storage a useful name. This
will cause the KILL_THREAD test to fail as it will kill the thread as
soon as it is created.

change the test to use getpid instead of prctl.

Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Link: https://lore.kernel.org/r/20240124141357.1243457-3-terry.tritton@linaro.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -784,7 +784,7 @@ void *kill_thread(void *data)
 	bool die = (bool)data;
 
 	if (die) {
-		prctl(PR_GET_SECCOMP, 0, 0, 0, 0);
+		syscall(__NR_getpid);
 		return (void *)SIBLING_EXIT_FAILURE;
 	}
 
@@ -803,11 +803,11 @@ void kill_thread_or_group(struct __test_
 {
 	pthread_t thread;
 	void *status;
-	/* Kill only when calling __NR_prctl. */
+	/* Kill only when calling __NR_getpid. */
 	struct sock_filter filter_thread[] = {
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
 			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_prctl, 0, 1),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 0, 1),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL_THREAD),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 	};
@@ -819,7 +819,7 @@ void kill_thread_or_group(struct __test_
 	struct sock_filter filter_process[] = {
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
 			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_prctl, 0, 1),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 0, 1),
 		BPF_STMT(BPF_RET|BPF_K, kill),
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 	};


