Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460B030748A;
	Tue, 11 Nov 2025 01:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825564; cv=none; b=qY0Ed/FvvwOPtBhxVJxCWTP4Vo6fS3NQeD1ljsWv1DsLiUybe10vG+Oy+bBKrM4IGTlFbGkKSHu+wUrte+KYN3ra4Buah0jC2bEgEkpCHNaCsEX4slmkFzrQGmM4fXF51YlJOZLW5oWmAqaV5yUWMmnj1ECQurNVfLHAqBKlyG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825564; c=relaxed/simple;
	bh=1pR4YrtN+4ogmSGKp6tmEwJY8s6jfnxhkz+zGwj7AA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbMwllpks22gVsNBwxt9fSgc5Zo9xVIiuujiJGXm5WMGkfblO+zJsZCYqEq1bRggn/A5YcXOSv+CxuWV5/M8QILhM33cKoadwm3s9kYpVO8oNa4Dp1hN1iz/vGIsU6rqYtcowwaKviHNRSWU2IttS9onlpbW9uhQoBDgsy9oxu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVNvII3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVNvII3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A1DC113D0;
	Tue, 11 Nov 2025 01:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825564;
	bh=1pR4YrtN+4ogmSGKp6tmEwJY8s6jfnxhkz+zGwj7AA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVNvII3RgDyCqGH7stY1vSZvUMjhidk7c8jlt1FiWfEFsQdmplaDNRUeLXrgC4ue9
	 4s3UEkswVuyrlBKpAsdiAI+ksf0JEfTVV4FG+8P5nINv/4skQ+Bccxfk8D+CqRHOj3
	 3l2KUslfex8s00VChjU/Nj48PTzLgip+hX8dYq7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 849/849] selftests: drv-net: Reload pkt pointer after calling filter_udphdr
Date: Tue, 11 Nov 2025 09:46:59 +0900
Message-ID: <20251111004556.943064230@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amery Hung <ameryhung@gmail.com>

commit 11ae737efea10a8cc1c48b6288bde93180946b8c upstream.

Fix a verification failure. filter_udphdr() calls bpf_xdp_pull_data(),
which will invalidate all pkt pointers. Therefore, all ctx->data loaded
before filter_udphdr() cannot be used. Reload it to prevent verification
errors.

The error may not appear on some compiler versions if they decide to
load ctx->data after filter_udphdr() when it is first used.

Fixes: efec2e55bdef ("selftests: drv-net: Pull data before parsing headers")
Signed-off-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250925161452.1290694-1-ameryhung@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/lib/xdp_native.bpf.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/lib/xdp_native.bpf.c b/tools/testing/selftests/net/lib/xdp_native.bpf.c
index df4eea5c192b..c368fc045f4b 100644
--- a/tools/testing/selftests/net/lib/xdp_native.bpf.c
+++ b/tools/testing/selftests/net/lib/xdp_native.bpf.c
@@ -420,7 +420,6 @@ static int xdp_adjst_tail_grow_data(struct xdp_md *ctx, __u16 offset)
 
 static int xdp_adjst_tail(struct xdp_md *ctx, __u16 port)
 {
-	void *data = (void *)(long)ctx->data;
 	struct udphdr *udph = NULL;
 	__s32 *adjust_offset, *val;
 	__u32 key, hdr_len;
@@ -432,7 +431,8 @@ static int xdp_adjst_tail(struct xdp_md *ctx, __u16 port)
 	if (!udph)
 		return XDP_PASS;
 
-	hdr_len = (void *)udph - data + sizeof(struct udphdr);
+	hdr_len = (void *)udph - (void *)(long)ctx->data +
+		  sizeof(struct udphdr);
 	key = XDP_ADJST_OFFSET;
 	adjust_offset = bpf_map_lookup_elem(&map_xdp_setup, &key);
 	if (!adjust_offset)
@@ -572,8 +572,6 @@ static int xdp_adjst_head_grow_data(struct xdp_md *ctx, __u64 hdr_len,
 
 static int xdp_head_adjst(struct xdp_md *ctx, __u16 port)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
 	struct udphdr *udph_ptr = NULL;
 	__u32 key, size, hdr_len;
 	__s32 *val;
@@ -584,7 +582,8 @@ static int xdp_head_adjst(struct xdp_md *ctx, __u16 port)
 	if (!udph_ptr)
 		return XDP_PASS;
 
-	hdr_len = (void *)udph_ptr - data + sizeof(struct udphdr);
+	hdr_len = (void *)udph_ptr - (void *)(long)ctx->data +
+		  sizeof(struct udphdr);
 
 	key = XDP_ADJST_OFFSET;
 	val = bpf_map_lookup_elem(&map_xdp_setup, &key);
-- 
2.51.2



