Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03A725B0A5;
	Sat, 12 Sep 2026 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240276; cv=none; b=RjUXuLyZ7zCpnbiKSFVYwa1XPB6OvwBlCzyE9Oi3loEwe2y4fC+Gjs7L11mR8OZRmtC6b12W12sQ6no8kYxhP+m6aP59gLNJIA9XUDS2h3l48Zl6oSSXKX8P4SaTfng0qO5NPZzUZb7YYNlvkBqkrBixB3RGa3TnDCUoY5+W7BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240276; c=relaxed/simple;
	bh=cUiVj+SKOakwyebMLJNq6xC5jz7xq0Bs3ZxJSDHJZQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPcLQxBnu7GYvSgVCkim6ctMbeT95WyPm8SWWzsiQis8bLu+dgPkOPfcG9w36GtFOL2ACaWxgPRvTkqcNeFjgXQEEzYnTJ5yHRYFOC3jKyb1ZJORdGYNrkXVTz4ErAhjQj2tRsCTajPEwQTfHq8bVQvOCdOKFoiP1WyU0/i5mDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tegc+Lrh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tegc+Lrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B001F000FF;
	Sat, 12 Sep 2026 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240274;
	bh=Fkp2YQ0Q28C04TUy4Wf+CoILW/665L+Hv3jkvvSWz6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tegc+LrhiL+HrgDGQmBrPGmRZ40cRgZkFM+lPz2j6P5rv+j4ZwP+q/3cOfcDNqeHv
	 Kw3Q2Q9MjNgiV/Z0TVFipuyPbjyGAsIMVFr1abHiUzoNFvh6WPczLFvtoXH9oR+W1Q
	 8PAYxuVm24vEp8LIdWUO2R9IXFvXpQAQbSRAfbN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 835/935] bpf: Reject negative optlen in cgroup getsockopt hook
Date: Sat, 12 Sep 2026 09:04:25 +0200
Message-ID: <20260912065545.975098933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3883d4cf77245..93c576a6ea8dd 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1661,7 +1661,7 @@ int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
 	if (!ret)
 		return -EPERM;
 
-	if (ctx.optlen > *optlen)
+	if (ctx.optlen > *optlen || ctx.optlen < 0)
 		return -EFAULT;
 
 	/* BPF programs only allowed to set retval to 0, not some
-- 
2.53.0



