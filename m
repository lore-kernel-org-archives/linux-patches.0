Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E8921660C;
	Thu, 12 Dec 2024 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019209; cv=none; b=ajGFj9g1rbGkn396FeAWxqCeFcxgpl4dtvXw3LaEcYW+8JsrQiUsJtllZh5K2nVVCwl9oA+4yT258m/KAW4/eFeIm8gKQA0Pr5l0dd+Dz3w/NTx2l8CkCZGBO5STFA+3zwjMQwIY2HgCjHyOXzin2K/NNsqIbdCKeF4j9yAr9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019209; c=relaxed/simple;
	bh=eNeKkNl59b/x+TIZwZCkLn9VHbtxEm17ppsKSxOGzyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzio5mHyd43HbDu+GWnAUIV3h5gUS4vQ5t2Cb6A223dzWQFVlwhSttkOA0fIXMjXKtrWGZfvtVA73YAe1eAl5sVS8oj9zNDJIU9ohTM5Hz++Xcw30yc/tJ2HHIuwYWRZ0QZjB/dYOeUQ/YpkJZdlTs0hEgcgxNTmD505zBboh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQ+MZV8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQ+MZV8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2ABC4CED0;
	Thu, 12 Dec 2024 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019209;
	bh=eNeKkNl59b/x+TIZwZCkLn9VHbtxEm17ppsKSxOGzyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQ+MZV8XZxg+8Wn0AVFA3mR6qo1NyJVky+cjC1vPJJfwXVKRwzPDYTBY6/cCe+Ypz
	 f48NMgkW8Zf+S1yV0AX2/tDNQYJLYQJT8cGKDjLMdHEz1XZbDs1KMztn+coEzHhOuO
	 NHlwc+1kFi0J8YE+xMo0W8IzLe5FXdB7PkZKDb2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/772] selftests/bpf: Add csum helpers
Date: Thu, 12 Dec 2024 15:51:32 +0100
Message-ID: <20241212144356.010153791@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit f6642de0c3e94d3ef6f44e127d11fcf4138873f7 ]

Checksum helpers will be used to calculate pseudo-header checksum in
AF_XDP metadata selftests.

The helpers are mirroring existing kernel ones:
- csum_tcpudp_magic : IPv4 pseudo header csum
- csum_ipv6_magic : IPv6 pseudo header csum
- csum_fold : fold csum and do one's complement

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20231127190319.1190813-11-sdf@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 5bf1557e3d6a ("selftests/bpf: Fix backtrace printing for selftests crashes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.h | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index f882c691b7909..2582ec56dcc50 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -66,4 +66,47 @@ struct nstoken;
  */
 struct nstoken *open_netns(const char *name);
 void close_netns(struct nstoken *token);
+
+static __u16 csum_fold(__u32 csum)
+{
+	csum = (csum & 0xffff) + (csum >> 16);
+	csum = (csum & 0xffff) + (csum >> 16);
+
+	return (__u16)~csum;
+}
+
+static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
+					__u32 len, __u8 proto,
+					__wsum csum)
+{
+	__u64 s = csum;
+
+	s += (__u32)saddr;
+	s += (__u32)daddr;
+	s += htons(proto + len);
+	s = (s & 0xffffffff) + (s >> 32);
+	s = (s & 0xffffffff) + (s >> 32);
+
+	return csum_fold((__u32)s);
+}
+
+static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
+				      const struct in6_addr *daddr,
+					__u32 len, __u8 proto,
+					__wsum csum)
+{
+	__u64 s = csum;
+	int i;
+
+	for (i = 0; i < 4; i++)
+		s += (__u32)saddr->s6_addr32[i];
+	for (i = 0; i < 4; i++)
+		s += (__u32)daddr->s6_addr32[i];
+	s += htons(proto + len);
+	s = (s & 0xffffffff) + (s >> 32);
+	s = (s & 0xffffffff) + (s >> 32);
+
+	return csum_fold((__u32)s);
+}
+
 #endif
-- 
2.43.0



