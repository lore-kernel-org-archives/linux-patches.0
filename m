Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD26279915;
	Tue, 12 Aug 2025 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021021; cv=none; b=oxksssoyYPgWtkCwUFN8V80OLOnNn0A+WuI5q8r2n+GsEhGkbnsqgV3fp7svwcLkg1/nMNRpJiWYJVgOVrPBvPSYZeTTXwkEq8/rqolA+Yyb400V2w/sr3dVbFczbE64jUB0F4ZK7REAP/ZwkwdJxIJbX9hOANl6Ntr2U7cgeLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021021; c=relaxed/simple;
	bh=Lo8Vc3x6dziqL0T6esg71cg7nmGMlqH+ooS29O1IHZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMKr4qamXMo+7jB7vWySbba+WJMax2tc95d7fOuivdAhhCb4dNQR+USDLs7wxKf9qPRoDfEe3QdLDWx9S1GLHTyfWz5RmWc/zIJGcDmeUSOywpdtNdDDIu+ua07YaAY/Lx9gVQTyQZtBz1mAqnXzIiJWL5N9TahHQQT4T9SOPkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFm1ZxRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFm1ZxRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C91DC4CEF0;
	Tue, 12 Aug 2025 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021021;
	bh=Lo8Vc3x6dziqL0T6esg71cg7nmGMlqH+ooS29O1IHZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFm1ZxRDDq7Q5h41fIqQsfWxX0K/pX2Sditih1UJf8U7pSHEdHmg8O3kj5U/Zz+Xh
	 F6Rs6YduCmQF8F3ufSJtMh5rswGYFFwSiftoi3o/vOOcwfqS03I8UiP8UqH7RjVq3U
	 1J1n5XzUbyNZ2cjYuOsc/7hgUbWJOTQs1Vg1eB0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/262] selftests/bpf: fix signedness bug in redir_partial()
Date: Tue, 12 Aug 2025 19:27:19 +0200
Message-ID: <20250812172955.149781835@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit 6a4bd31f680a1d1cf06492fe6dc4f08da09769e6 ]

When xsend() returns -1 (error), the check 'n < sizeof(buf)' incorrectly
treats it as success due to unsigned promotion. Explicitly check for -1
first.

Fixes: a4b7193d8efd ("selftests/bpf: Add sockmap test for redirecting partial skb data")
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Link: https://lore.kernel.org/r/20250612084208.27722-1-wangfushuai@baidu.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 84d59419e4eb..a6d8aa8c2a9a 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -894,6 +894,8 @@ static void redir_partial(int family, int sotype, int sock_map, int parser_map)
 		goto close;
 
 	n = xsend(c1, buf, sizeof(buf), 0);
+	if (n == -1)
+		goto close;
 	if (n < sizeof(buf))
 		FAIL("incomplete write");
 
-- 
2.39.5



