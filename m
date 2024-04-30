Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1523B12CD84;
	Tue, 30 Apr 2024 10:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474349; cv=none; b=q7lxQvTYxdmKwgocoTGMx+6QEER8nn3e4EmaQs3G3P07Vw++VyI0SHpErZJZCAK43J6ozz2G2qc5jQpUCGMT8c4aYtRiPf6RctM4NYHMZ9TCoCndtnhxC2xqRgbzs5tGqFSveXuWbXdb664UgN1j/tDKzeduaoUKVwdTtNykO7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474349; c=relaxed/simple;
	bh=NgFwAGMrOh0mbcxolAdoalXTbG1J6vi6SDMrJU4jnm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBNgveTAgIUGt7gT9Lou130cLGydWvYya3qqioEl1t5VYgY/azVNs8yTI+JMt38WtMyzABfvTd+Do7kxb8hiqsSlYYFep1WAOpzq1qOtRm0pxRO3MWecEbTqyUimg3u3EGYSTujStKANxUd6lgFe9B0wFy01Hfx06PQXaMaDOx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DIh2FZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DIh2FZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92573C4AF49;
	Tue, 30 Apr 2024 10:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474349;
	bh=NgFwAGMrOh0mbcxolAdoalXTbG1J6vi6SDMrJU4jnm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DIh2FZj4LzY2i/GBANQgcM1PJDgAKvNnxlrrBrJLJsh1MQx2IAyKkyWrxuIAUqUI
	 9qSrPxekr1T39nSeSCC4mH4ofZnA2SZzy5ceW69oLOUBu1mU1xBC7mANjDiIASpW2K
	 gdYXP1XA4SRrJLtwAkoGhVD3QYaxjF2R6xYDsqUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.8 130/228] selftests/seccomp: Change the syscall used in KILL_THREAD test
Date: Tue, 30 Apr 2024 12:38:28 +0200
Message-ID: <20240430103107.556222561@linuxfoundation.org>
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


