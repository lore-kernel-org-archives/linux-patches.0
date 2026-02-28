Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33FF39B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302642; cv=none; b=ssb4TQ8iTEcnEKsO6KLzHZjSr00Obcrn8Jx+SetdXlyvfI5+gmsMzwccOZmxsAFU4NZF0sw0FZo+EEG3puyHWsDoiWD8iwwd7tRSh5G8sGdOPDT1MD/yzvGFWYwsvRmumQyW1YfiRECje59t07vZZGjQEwO3HmROl2QoS3WY4V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302642; c=relaxed/simple;
	bh=KzBelGAVkTQu32eUhicHP8L3iEWU1w8czvHt4zYuzAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzmcFvhyxXnGZ2fTVuAXCoZWivZciOIXfRRxVYvaL3T7t1IgOdFp+cEvzlFt446ivjxHhf4mluOgPLByMzBqoK5mRN1fVNoY8048Sof9BYFzY3d66gBbriFoEbY649pbwnw/YGd6jdB62aeEbrCEx+/a1pu5D2AhSI9mFBPiGHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vq6x75RN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vq6x75RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD30C19425;
	Sat, 28 Feb 2026 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302641;
	bh=KzBelGAVkTQu32eUhicHP8L3iEWU1w8czvHt4zYuzAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vq6x75RNVfHElhDM063JdSlKteoMm2lxHHM/923BRgkr91gQpzQNbzsjIQbBziwV0
	 nYrjEV8M0diwJ+7jdYGAE2O+03Raowue+PN3o4MYf7gLaw8GKrgYiqNz7V49Zwp4HZ
	 RtxiIeVCPSd+/pxGJNu/n5KJ52OO7/iTfydAMoFyrbULx82DZYp8Cc6a03vMG6cmOz
	 uRRAUsMr2eqmwTFKr7ImT+DqJqc5ggCLnl8UAvR8mn5pBBgR+cOrQ7xr2rtIs9SRE5
	 FOS3M67oyUbKjtfn6wdb/SsuorOLNLnK5useE7AC31wBqX635i7eH8voyxOY9sWMQD
	 TpivH5t/A9e3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jakub Kicinski <kuba@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/164] bpftool: Fix truncated netlink dumps
Date: Sat, 28 Feb 2026 13:15:02 -0500
Message-ID: <20260228181505.1600663-163-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 18e5e5faa2aa2..ef7fe8dd50984 100644
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
index fadde7d80a51c..00ba40b0a57e2 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -127,7 +127,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	struct nlmsghdr *nh;
 	int len, ret;
 
-	ret = alloc_iov(&iov, 4096);
+	ret = alloc_iov(&iov, 8192);
 	if (ret)
 		goto done;
 
@@ -196,6 +196,8 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
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

