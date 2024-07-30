Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742271A6161;
	Tue, 30 Jul 2024 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356941; cv=none; b=h21FUiz2Pr9OcGacwjUB8FyX/PHRWC4AulqNV96QZeSubTiBU8rPyCJ3i4AKojx2ztDWPVhrKVRSxO31dw1piFQp5kVvxUvuJLauQq5ctL8CsYYpxDfOJnSsNYx8TUwN5NjP/faK2NmUtDhuXQqnXd9JvFu9RqeZ0OCUhpdQ544=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356941; c=relaxed/simple;
	bh=fGVbRV5dCK439TYXjV0xHekroXHb6meZ1aIV7brjods=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8faweGjn2pnLm6xHStXXpXvOlQRHAeHlNqT8zBX0JvkYkSDKqsp3tOpIli1odZMTt8gBQ7bR6bfIVVaYnhDY6CFVoyc0inS+iYus3NzeLBRT6rRsu0aZ9Zsb+VKLyiF6rZ+R0rvs1mQh/hpMFw93VVsvv7oXhf+O6X8R774uy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HG0X8aSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HG0X8aSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49C3C32782;
	Tue, 30 Jul 2024 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356941;
	bh=fGVbRV5dCK439TYXjV0xHekroXHb6meZ1aIV7brjods=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HG0X8aSB4wKZKHfiI0Ug2+Xwhcde+u8LBpKThUI8Ye+TiGZs3bUIU84F/wmFc+jPD
	 +PW6dg9JbR/RBj5uhQeyiLIdeKYShNRXmgiaLV5HN8z3SzjJm+UGAt6+gx7McImuNb
	 Lsg8yhDffblBCOR9Et8zamUOiRMwg/1YPPgA0iiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 203/809] bpf: Change bpf_session_cookie return value to __u64 *
Date: Tue, 30 Jul 2024 17:41:19 +0200
Message-ID: <20240730151732.625983622@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 717d6313bba1b3179f0bf1026aaec6b7e26f484e ]

This reverts [1] and changes return value for bpf_session_cookie
in bpf selftests. Having long * might lead to problems on 32-bit
architectures.

Fixes: 2b8dd87332cd ("bpf: Make bpf_session_cookie() kfunc return long *")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240619081624.1620152-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c                                        | 2 +-
 tools/testing/selftests/bpf/bpf_kfuncs.h                        | 2 +-
 tools/testing/selftests/bpf/progs/kprobe_multi_session_cookie.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index bc16e21a2a443..d1daeab1bbc14 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3527,7 +3527,7 @@ __bpf_kfunc bool bpf_session_is_return(void)
 	return session_ctx->is_return;
 }
 
-__bpf_kfunc long *bpf_session_cookie(void)
+__bpf_kfunc __u64 *bpf_session_cookie(void)
 {
 	struct bpf_session_run_ctx *session_ctx;
 
diff --git a/tools/testing/selftests/bpf/bpf_kfuncs.h b/tools/testing/selftests/bpf/bpf_kfuncs.h
index be91a69193158..3b6675ab40861 100644
--- a/tools/testing/selftests/bpf/bpf_kfuncs.h
+++ b/tools/testing/selftests/bpf/bpf_kfuncs.h
@@ -77,5 +77,5 @@ extern int bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr,
 				      struct bpf_key *trusted_keyring) __ksym;
 
 extern bool bpf_session_is_return(void) __ksym __weak;
-extern long *bpf_session_cookie(void) __ksym __weak;
+extern __u64 *bpf_session_cookie(void) __ksym __weak;
 #endif
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_session_cookie.c b/tools/testing/selftests/bpf/progs/kprobe_multi_session_cookie.c
index d49070803e221..0835b5edf6858 100644
--- a/tools/testing/selftests/bpf/progs/kprobe_multi_session_cookie.c
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi_session_cookie.c
@@ -25,7 +25,7 @@ int BPF_PROG(trigger)
 
 static int check_cookie(__u64 val, __u64 *result)
 {
-	long *cookie;
+	__u64 *cookie;
 
 	if (bpf_get_current_pid_tgid() >> 32 != pid)
 		return 1;
-- 
2.43.0



