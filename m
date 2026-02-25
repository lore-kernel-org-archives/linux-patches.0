Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DB23016F7;
	Wed, 25 Feb 2026 06:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002732; cv=none; b=nQ7/Wso2ibC9tXmOJyTVwRr3CNH8MB2GqsHilsrfc0Ur7EWVnFcFy+epVBZ5FLjpnMwpuxFxTyNRSderqj7kgUCZq6JhUSMIZrstYo/QXDOtRKFQrDmGpPXTWJR7XMTWlUJ2EkLiur+4Da5Ph3ixRPNCF04hugWzIYY15aRiSfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002732; c=relaxed/simple;
	bh=1Sl4FKXGEdQHrr9v8XtQORlx2iYDHFXLEkSsmzmVQnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oovdGRr6cikluVPu45LOXrEpbuOmoJg3Gr7HlJRHYf923ByYBF5NK58JVX2a3zhZiER/fj2xOkUPo0nEuWybIFgIfeFIFhpDH1qHMU4PT0jqU/oc0E2bdgjE7Br0vlW4AaCpcoDh5bZeY/OBHI6whSMwJfQSLEtMRfk1RyDqQhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnYpXEct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnYpXEct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE09C19422;
	Wed, 25 Feb 2026 06:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002732;
	bh=1Sl4FKXGEdQHrr9v8XtQORlx2iYDHFXLEkSsmzmVQnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnYpXEctfEl/Ybz8IAfL7vvusIZmG5kPd9MiKThfMnLWkjcDm7Kmwq+Q/SeRzlrDc
	 szWYBiPG6DN1pFU3ITfUDfDXNqYlMgz5KUpCdq1QN1vhtOLj6TMIMoxAxIlqwaxZk3
	 pVQ5YDxPR19aE4/Pf3tGgjmDUsZ5zDbIc6E/72ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 546/641] bpftool: Fix truncated netlink dumps
Date: Tue, 24 Feb 2026 17:24:32 -0800
Message-ID: <20260225012401.758848775@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index cfc6f944f7c33..1a06b0b5eef35 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -156,7 +156,7 @@ static int netlink_recv(int sock, __u32 nl_pid, __u32 seq,
 	bool multipart = true;
 	struct nlmsgerr *err;
 	struct nlmsghdr *nh;
-	char buf[4096];
+	char buf[8192];
 	int len, ret;
 
 	while (multipart) {
@@ -201,6 +201,9 @@ static int netlink_recv(int sock, __u32 nl_pid, __u32 seq,
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
index c997e69d507fe..c9a78fb16f115 100644
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



