Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D4C347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302481; cv=none; b=uu5tneJ7f8C5bYqElIYNSrBnXvFeFWb5tmFo1aWMNt5TM+6a6uflsAqBp61lZtU4kx7blVQ6RKBJvAG8mF7WnIRD3JMD8ViNneG2tmfYezRN90F5AismYFD+p8SvpT7TTEQsZMpI9fp6lsiK88YiaoJWiiP1sXUCAyF+uiDfEJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302481; c=relaxed/simple;
	bh=UIg75MIevrjaCT/8eFFaWmJdS76453F3OkvZUtzs7sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8cHm9sQijv9+3EPWwC16sKzVWrC4DWWz2cQfG6J8la9++hmUSNLtfZxajR3scJcUfefWsXUrBSFUX26sX1O3MP6Y9qhiXdPPs04UVK9PKanKF+sX7awGkXF+oOyyyZPM7pTuZwe/Vify7Am0FHQf3bAhNpPlZkDfR7Tfgerrn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJmUtn1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJmUtn1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0FFC19424;
	Sat, 28 Feb 2026 18:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302481;
	bh=UIg75MIevrjaCT/8eFFaWmJdS76453F3OkvZUtzs7sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJmUtn1roCAal1h8zAdqd2Ay6NQRKVzr22M0IMbjWlbzazntlPDbfawDYLaVTiAHD
	 dEdyJomG4cWWGG0Nnkl0nzozWTGCHhpnUEC0AQs23YEJHVwWVJpXgkKv6hAKtnfGJg
	 tqaBYmcM+SHEE0DaWOlS1NHo3JNkxdpLM9kHcRYfhXVoRPklxLFUfkXCIiR5bfB+it
	 TKBT936tA1ERjOev3HEg0+VwxGvV7ngcNXN0JU6QlDUnZqeD//EQal4/OoqopRqxde
	 d9jYjPYo9RHS2l1zcm3DIrjDNfWLMfqY6fPvZ07vzmYO6nYYLBrUSVx6x8e8auFVDZ
	 Y5Q6lmswFdcxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jakub Kicinski <kuba@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 228/232] bpftool: Fix truncated netlink dumps
Date: Sat, 28 Feb 2026 13:11:21 -0500
Message-ID: <20260228181127.1592657-228-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 7c9e86faab6ce..3863c2d986830 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -143,7 +143,7 @@ static int netlink_recv(int sock, __u32 nl_pid, __u32 seq,
 	bool multipart = true;
 	struct nlmsgerr *err;
 	struct nlmsghdr *nh;
-	char buf[4096];
+	char buf[8192];
 	int len, ret;
 
 	while (multipart) {
@@ -188,6 +188,9 @@ static int netlink_recv(int sock, __u32 nl_pid, __u32 seq,
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
index 35104580870c0..ecd6e03b3ba53 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -135,7 +135,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	struct nlmsghdr *nh;
 	int len, ret;
 
-	ret = alloc_iov(&iov, 4096);
+	ret = alloc_iov(&iov, 8192);
 	if (ret)
 		goto done;
 
@@ -204,6 +204,8 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
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

