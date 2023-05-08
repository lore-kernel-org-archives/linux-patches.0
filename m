Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64306168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C357FC433D2;
	Mon,  8 May 2023 11:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544206;
	bh=Vla0GIz2fMFPrCo66DGoMe8brMfqUeFvzBeD4bz1yZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgT91HRJ4VjEw11JS1xCimQBI895MV0a/yawg9XF/n0zbWdeDwZoTNI4kBiTN8bHo
	 r1dw1rv7LPhU6Xmi9v7AGUov+DXUzHrkc9Z77yElanXM8lMfEeQAoSaiKP2rH5vXyQ
	 30rD1+o17l7z1dBMnvR1njdooeRGHL/Wxvg/HUoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yhs@fb.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 335/694] libbpf: Fix bpf_xdp_query() in old kernels
Date: Mon,  8 May 2023 11:42:50 +0200
Message-Id: <20230508094443.332090112@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yonghong Song <yhs@fb.com>

[ Upstream commit c8ee37bde4021a275d2e4f33bd48d54912bb00c4 ]

Commit 04d58f1b26a4("libbpf: add API to get XDP/XSK supported features")
added feature_flags to struct bpf_xdp_query_opts. If a user uses
bpf_xdp_query_opts with feature_flags member, the bpf_xdp_query()
will check whether 'netdev' family exists or not in the kernel.
If it does not exist, the bpf_xdp_query() will return -ENOENT.

But 'netdev' family does not exist in old kernels as it is
introduced in the same patch set as Commit 04d58f1b26a4.
So old kernel with newer libbpf won't work properly with
bpf_xdp_query() api call.

To fix this issue, if the return value of
libbpf_netlink_resolve_genl_family_id() is -ENOENT, bpf_xdp_query()
will just return 0, skipping the rest of xdp feature query.
This preserves backward compatibility.

Fixes: 04d58f1b26a4 ("libbpf: add API to get XDP/XSK supported features")
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230227224943.1153459-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/netlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 1653e7a8b0a11..84dd5fa149058 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -468,8 +468,13 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
 		return 0;
 
 	err = libbpf_netlink_resolve_genl_family_id("netdev", sizeof("netdev"), &id);
-	if (err < 0)
+	if (err < 0) {
+		if (err == -ENOENT) {
+			opts->feature_flags = 0;
+			goto skip_feature_flags;
+		}
 		return libbpf_err(err);
+	}
 
 	memset(&req, 0, sizeof(req));
 	req.nh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
@@ -489,6 +494,7 @@ int bpf_xdp_query(int ifindex, int xdp_flags, struct bpf_xdp_query_opts *opts)
 
 	opts->feature_flags = md.flags;
 
+skip_feature_flags:
 	return 0;
 }
 
-- 
2.39.2



