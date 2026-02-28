Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4826833A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302265; cv=none; b=ReC+T3r13Ys0HEwPWMbCmx6TayZuo7wPXfn7XEXBPQRQMDYukrlMQmO/6mz0rgtEuOCpvYUuaRYTLTKeXD/pAkBlmByhgMBf30DjD8ec8rEORbf/RdUDqK3JX/SbYvjuX5bIewS088k+dDQ9xzmmZ4GjTVLQyfzYXj7f9UHDS60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302265; c=relaxed/simple;
	bh=yS7ASGiq79VD+VRbuHCwBcLtOHSaW9/i9w+RqCW54Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRoZeJCdPlcibWeBeOCfhRmVVZWCs8iPbE+TUk2B8nQqcCyEzo4s7lM8vGKdYDluKwymTY1Z+bW6Mzc6BozpJEUZAY/CTgv2wyjH0rdLd55FELlZaMTZXOOcgrTYDKwdy7KporpI6TAEefq+JEVoLaiTY1tynMOvbncANjojvSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uafCLNGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uafCLNGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96337C19425;
	Sat, 28 Feb 2026 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302265;
	bh=yS7ASGiq79VD+VRbuHCwBcLtOHSaW9/i9w+RqCW54Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uafCLNGdrLdhGG27CLIriXbHlH2jeQngNhRsqzdU/bSSWYmf157psNsZfGFUm3sY+
	 lihnYMzEifG+TEwgEWh//pgKx9YbKooqsYlOJS1gfIU9/v1k0qfmkfwPr6yiRCINiv
	 VdpkzLnkG2wuYoNbf1UvIQZXkB9UcKPGmu3XpY1k2Ex6WfULUDhNhVtyF1jIEIkKnX
	 0mo+GCHnVy8TAEFpDBu24qIg01BZKYpgKE2szXYPlM3GpvnWpVIXXKYXI9vcm0yMPJ
	 Zdotd+zlRiEHAveBXSd8ZGLr5fIFCLruEftI0bYW4BKFhM0WKjrF84vCyNhqLJkCIF
	 rQ+czVxsDuL0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jakub Kicinski <kuba@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/283] bpftool: Fix truncated netlink dumps
Date: Sat, 28 Feb 2026 13:07:03 -0500
Message-ID: <20260228180709.1583486-281-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 3b39d73cc3379360a33eb583b17f21fe55e1288e ]

Netlink requires that the recv buffer used during dumps is at least
min(PAGE_SIZE, 8k) (see the man page). Otherwise the messages will
get truncated. Make sure bpftool follows this requirement, avoid
missing information on systems with large pages.

Acked-by: Quentin Monnet <qmo@kernel.org>
Fixes: 7084566a236f ("tools/bpftool: Remove libbpf_internal.h usage in bpftool")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20260217194150.734701-1-kuba@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/net.c | 5 ++++-
 tools/lib/bpf/netlink.c | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index c2ca82fc21e21..225d3678b4ed1 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -150,7 +150,7 @@ static int netlink_recv(int sock, __u32 nl_pid, __u32 seq,
 	bool multipart = true;
 	struct nlmsgerr *err;
 	struct nlmsghdr *nh;
-	char buf[4096];
+	char buf[8192];
 	int len, ret;
 
 	while (multipart) {
@@ -195,6 +195,9 @@ static int netlink_recv(int sock, __u32 nl_pid, __u32 seq,
 					return ret;
 			}
 		}
+
+		if (len)
+			p_err("Invalid message or trailing data in Netlink response: %d bytes left", len);
 	}
 	ret = 0;
 done:
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 68a2def171751..6f16c4f7b3a43 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -143,7 +143,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	struct nlmsghdr *nh;
 	int len, ret;
 
-	ret = alloc_iov(&iov, 4096);
+	ret = alloc_iov(&iov, 8192);
 	if (ret)
 		goto done;
 
@@ -212,6 +212,8 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 				}
 			}
 		}
+		if (len)
+			pr_warn("Invalid message or trailing data in Netlink response: %d bytes left\n", len);
 	}
 	ret = 0;
 done:
-- 
2.51.0

