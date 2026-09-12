Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2181472074;
	Sat, 12 Sep 2026 11:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211566; cv=none; b=XIAHMEGefrxAHH007yfN7Y29yy9CBQJgDwT2orijKIJ+dtz2Pf7kPzkuVZWn5Z6TKrhTzrci6seOAX6t8XqRXrl+BjeDcPyBYOBYs2zffTQ+xVvmERtKzqDXvjAi1lZ/NjFgE2IWsIuxddmAtiSTWNhwGsw5BnZDO+FYd7WgbC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211566; c=relaxed/simple;
	bh=kDAxfHmZ3QzZ0o+EmKnDVXiBvtSxpRPIe1yNiIglArc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Op4SeFBNOoUZJfxbPSPaXhW73k8gcoEa+KuU/kBSnUGOHQCO9M1s1h+x6T2PDA6WdTVLc0kuT1uotLMYHE2oYqMGpx3xwcusa6U3rIr53y0mVISB2ba4T25b5GD6aKKwmmJT+4EXL8+5UPnrgKl8GM0tQLBo0yUzI8Lm/ZsVR64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4sNadbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4sNadbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780501F000FF;
	Sat, 12 Sep 2026 11:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211565;
	bh=Ork4KRmPUCc1zHJZM1uP20EZ3UF3yPo/f0/e11pEVLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4sNadbA+DYUiTpF3UruEtS5qYIWYgVgp79/6xos3/2Ii4gapgSJ40RPa3JbOn5R7
	 WRfa/pvUXYKr01Jc4Fc7yDA92zU3ltxxSvkudh55SFGR4cDIP7hiIdmSUYPly35c5m
	 K+Po5p8b/LaPHgkevdp77dcuswL0DKTEnGqe9sms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1240/1518] bpf: Disallow bpf_{g,s}etsockopt() in cgroup UNIX getname hooks
Date: Sat, 12 Sep 2026 08:56:49 +0200
Message-ID: <20260912065651.557254747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 332f4986376f1..48af015981abd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8189,10 +8189,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
@@ -8212,10 +8210,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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



