Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A4A346AFB;
	Fri,  7 Aug 2026 15:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116575; cv=none; b=GfqDY1UXJpQ0nQWKdY/mW2YBWNxaFanRHmDPcDdiqxQ6QsFbPdOJpzmM5+AJS57KzOKDD1lulKgBNWkZdxyxlxN8yrnt9aMFg8jT/g+tii/gm9ANyzBBQYVOuh6NH/XTsi3Zdpjg7y2m0LrNNLzxbjzGTXw5n5xlLMUfyEA45xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116575; c=relaxed/simple;
	bh=do81iSuLLjAJa7y77Uj6wntC31eSJRfw56ySXqTy4PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5TZO1qknSiyEb0gmabHC0K7bgpUT6BRiRMM1YcYxeszS7PYNCd2lNJ5PCWiNzOU8M9VQ2fiTWcI6ZPOiIB0LC0/avIb5NLmc9SvoKzYIqUBpvQN809QCvpUE7GH44mWBZTzNMqTQHWMA/y6Igw0mU/e6IvYiOmwZYej+vIxPug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7CwUbeH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7CwUbeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75E31F000E9;
	Fri,  7 Aug 2026 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116574;
	bh=XkUTmDFhqZec1/3KmaC/Mr4WgVPN0WtGmPR5IAP8xtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7CwUbeHuOcvELPAdRcrk6t2OLWClfqzhpGDsSIvjh9I4A3a2/p/HT5nO37APPWYk
	 CU+hG42/ooyE4tz2kLVh0nffbptfXB2zm01ReYsaJtU5qr5NpajVf/KjDUcc72kcFx
	 OkGb2SE1qlqRgZUtzxfQTvmQ1xr+wmyBVrs04ktE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 017/438] selftests/seccomp: Fix pointer type mismatch build error
Date: Fri,  7 Aug 2026 16:33:33 +0200
Message-ID: <20260807143428.377089187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>

[ Upstream commit 3421b9b056a6576d0ebac1030eafb48ad0544092 ]

We hit the following build error while running the seccomp selftests in
our testing.

CC seccomp_bpf
seccomp_bpf.c: In function ‘UPROBE_setup’:
seccomp_bpf.c:5175:74: error: pointer type mismatch in conditional expression [-Wincompatible-pointer-types]
5175 | offset = get_uprobe_offset(variant->uretprobe ? probed_uretprobe : probed_uprobe);
| ^
seccomp_bpf.c:5175:57: note: first expression has type ‘int (*)(void)’
5175 | offset = get_uprobe_offset(variant->uretprobe ? probed_uretprobe : probed_uprobe);
| ^~~~~~~~~~~~~~~~
seccomp_bpf.c:5175:76: note: second expression has type ‘int (__attribute__((nocf_check)) *)(void)’
5175 | offset = get_uprobe_offset(variant->uretprobe ? probed_uretprobe : probed_uprobe);
| ^~~~~~~~~~~~~

get_uprobe_offset() takes a 'const void *' argument, so cast both
operands to 'void *'.

Fixes: 9ffc7a635c35 ("selftests/seccomp: validate uprobe syscall passes through seccomp")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://patch.msgid.link/20260715053559.28535-1-kuan-ying.lee@canonical.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 358b6c65e120e..0622bc2acad40 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -5178,7 +5178,8 @@ FIXTURE_SETUP(UPROBE)
 		ASSERT_GE(bit, 0);
 	}
 
-	offset = get_uprobe_offset(variant->uretprobe ? probed_uretprobe : probed_uprobe);
+	offset = get_uprobe_offset(variant->uretprobe ? (void *)probed_uretprobe
+						      : (void *)probed_uprobe);
 	ASSERT_GE(offset, 0);
 
 	if (variant->uretprobe)
-- 
2.53.0



