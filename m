Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B991365A0B;
	Sat, 12 Sep 2026 09:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204021; cv=none; b=GPpTzn1/tCUIqWXMl9nkTAWB7v+4reBDBGeSLvWILPz0K9ZI4l+VUeTKddAiW84BcLJkciQq6xiu4Vwo+/k4JPQjEXq1QN8AD/ykXdZaLu4xs7DLZgAYMMfKhuPRsnOquDVSv95eQjJYe6wHGqBye8p+w3roXcgN/QuzA9ScXdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204021; c=relaxed/simple;
	bh=I0W4zdRvx/6MIUuuV3Plbxw24vo1XnCBvdPFIiFYEu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaL/sOOiI4Ohyg2vSfY/5rDfMDZakBo0a4UnKGTnaXn6HSFeFeAHB2zJCcLGgD1EYQ041yycbn/XMpPgxYbwYdTHgbcU5SuC55LXaYqFKReMZlYDgjlvmIBZyeEPmXE8pA2rKt5mJEnto8Wt02P+f7ql7/9av5Do0+JFJmjC1TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Axy/Lsmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Axy/Lsmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1971F000FF;
	Sat, 12 Sep 2026 09:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204019;
	bh=zXZo1ASDMeXwLyTxH8Epj/KfXVB1UKpi7h9G9wEyZfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Axy/LsmbxRfEli2fcO5JVxFDD5KYvPJ0WZtP40rTvk22ompoEhyh8bTsiWrZByxLQ
	 UokYAYfjBzf/zOeUOJpDtVWOc780z9Iw2ae4VwHdQxQlMKAZuRCIxKSwGr4rXe83h/
	 Jfzj/YxhUQaHWVhnlhUCOQJej5XWxXcIi4ZJBiAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1527/1815] bpf: Disallow bpf_{g,s}etsockopt() in cgroup UNIX getname hooks
Date: Sat, 12 Sep 2026 08:54:37 +0200
Message-ID: <20260912065724.853535624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junseo Lim <zirajs7@gmail.com>

[ Upstream commit 84473a7e1813a2da7b759ab1d098a84998c8d3f5 ]

_bpf_setsockopt() and _bpf_getsockopt() call sock_owned_by_me() for
full sockets, so these helpers expect the socket lock to be held.

BPF_CGROUP_UNIX_GETPEERNAME and BPF_CGROUP_UNIX_GETSOCKNAME run BPF
programs without acquiring the socket lock. A program attached to
either hook can therefore trigger the sock_owned_by_me() warning by
calling bpf_setsockopt() or bpf_getsockopt().

Disallow bpf_setsockopt() and bpf_getsockopt() for CGROUP_UNIX_GETPEERNAME
and CGROUP_UNIX_GETSOCKNAME.

Fixes: 859051dd165e ("bpf: Implement cgroup sockaddr hooks for unix sockets")
Reported-by: Sechang Lim <rhkrqnwk98@gmail.com>
Signed-off-by: Junseo Lim <zirajs7@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://lore.kernel.org/bpf/20260812091654.244752-1-zirajs7@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 16845987b2449..1e80a52ef86d0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8350,10 +8350,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		case BPF_CGROUP_UNIX_SENDMSG:
 		case BPF_CGROUP_INET4_GETPEERNAME:
 		case BPF_CGROUP_INET6_GETPEERNAME:
-		case BPF_CGROUP_UNIX_GETPEERNAME:
 		case BPF_CGROUP_INET4_GETSOCKNAME:
 		case BPF_CGROUP_INET6_GETSOCKNAME:
-		case BPF_CGROUP_UNIX_GETSOCKNAME:
 			return &bpf_sock_addr_setsockopt_proto;
 		default:
 			return NULL;
@@ -8373,10 +8371,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		case BPF_CGROUP_UNIX_SENDMSG:
 		case BPF_CGROUP_INET4_GETPEERNAME:
 		case BPF_CGROUP_INET6_GETPEERNAME:
-		case BPF_CGROUP_UNIX_GETPEERNAME:
 		case BPF_CGROUP_INET4_GETSOCKNAME:
 		case BPF_CGROUP_INET6_GETSOCKNAME:
-		case BPF_CGROUP_UNIX_GETSOCKNAME:
 			return &bpf_sock_addr_getsockopt_proto;
 		default:
 			return NULL;
-- 
2.53.0



