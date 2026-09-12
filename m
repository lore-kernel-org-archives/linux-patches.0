Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79A239A067;
	Sat, 12 Sep 2026 20:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243334; cv=none; b=EKFtXngdGrCEG7FWlcILxAIgxXj56SQnuwCsO1oG8fPJINj2h1J/8+zxsUej7wI+1sbtvmiBHbmQMngZ8Dlgmq5VhGr938nt4y2gvWvzjFTbEXd1+dfpa79n8t35/MDjmA12yJJ7x1ax12pFphAUGtekQq8k2dNfNNPs1SfcPzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243334; c=relaxed/simple;
	bh=sjyRqgNmGwh8bN0JuyIR73uavMUJfTkWAMari3XTqpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEWFgZSckpvNZcXh0n19JMEXTjzFstI/lpOE80gWk5MfR+bjGz9ODupk4A+j7tt1VSqMgHn//i6X4zOJhx1i/EgoE9IGBXOV1PvGP8aeTCc9DdKnMk6V9pj+3rN5ZWX9uKOrz5OsG4SYRsM0sIpU/CUF4VLE9bNapEH1cqJb0KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzsTC6UD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzsTC6UD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043E21F000FF;
	Sat, 12 Sep 2026 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243333;
	bh=F7OytRWD0+13IhYMVFSJSgJIkK9VZhnZreWU3qpDvn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzsTC6UD44U5TznZtO1AKBQYvz5qblZzMMw665ofJ6prVq0yJtqHj9Fe+rILXTi/D
	 3QjBnwd5HbPPTBOKVHdhi80vxKvSu8KblMhyA73n7mtIQXnjSSsapeEf/MpoCMNj/m
	 MdAscCdf25+7JqQ7Buo2kpjyh3+WSqb30FQfp+Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 719/798] bpf: Reject negative optlen in cgroup getsockopt hook
Date: Sat, 12 Sep 2026 09:05:47 +0200
Message-ID: <20260912065533.559551245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junseo Lim <zirajs7@gmail.com>

[ Upstream commit 1b5aacd5b2419b0790e955e466d389a61c79b4b1 ]

A cgroup getsockopt BPF program can shrink ctx->optlen after the
kernel getsockopt handler has run. The kernel-buffer variant, used by
TCP_ZEROCOPY_RECEIVE, only rejects values larger than the original
length.

If BPF writes a negative optlen, that value is accepted and propagated
back to the TCP getsockopt code. It can then be passed to
copy_to_sockptr() as a size_t and trigger the hardened usercopy
bytes > INT_MAX warning.

Reject negative ctx.optlen in __cgroup_bpf_run_filter_getsockopt_kern(),
matching the lower-bound validation already present in the sockptr-based
getsockopt hook.

Fixes: 9cacf81f8161 ("bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE")
Reported-by: Sechang Lim <rhkrqnwk98@gmail.com>
Signed-off-by: Junseo Lim <zirajs7@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/187a4d756275aaaee5d65eecb63c1477b3b66554.1786448307.git.zirajs7@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 939eab5afc99f..72fc467b7397c 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1576,7 +1576,7 @@ int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
 	if (!ret)
 		return -EPERM;
 
-	if (ctx.optlen > *optlen)
+	if (ctx.optlen > *optlen || ctx.optlen < 0)
 		return -EFAULT;
 
 	/* BPF programs only allowed to set retval to 0, not some
-- 
2.53.0



