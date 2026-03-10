Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFFD313537;
	Tue, 10 Mar 2026 11:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141084; cv=none; b=ZRIJqS6Z7MZjAFqaz2qAssYdzvu2A5WG3Mxh0pZoDCJ1HGwjEz5wA9b8vinu2uViXro5hDEaSoDT1wGPlsR0cckM65ZiFqd6BjE4IQGoSMoc/owXj+XGXBA+HJicSNoxnlyXnKUG+TvBOSu53tCtxWm3grrVSYrNGFpMN0JAtrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141084; c=relaxed/simple;
	bh=YiZPymN7dxn1ugYtNiA8rdoZkN7WYwZ+I34jDwkU+Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVRoKGplmjpT+yk3KbBVdjrCM71occreosMEzutlbGY/X6kbgunZxM/szhbGPFNuYLX3/xQe1U+b5IOzH8O7vkMlkDvFlkfy6AfKliaN5LzUBDjb9I/0eInOeVQClpW4+KrdbRLB89DVL5ZiBt4ReK2mvngZxpuJLTPbqLFs2no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNJLrWUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNJLrWUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FFBC2BC9E;
	Tue, 10 Mar 2026 11:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141084;
	bh=YiZPymN7dxn1ugYtNiA8rdoZkN7WYwZ+I34jDwkU+Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNJLrWUh/wJmzhZC7x3iAnqxkRWrHq0JKRzzmdrmOK0czXlPX5iXtU0eoxdBvNDDk
	 52ZS9MLY/aNknWrDW6oQEWBthu+sqHBV1HQGDjRyd/ALnTMBnBlB+CTMTiaIunD9HS
	 P2MNfeLu0zSX8+FuieEOToo5OpxQkuZ6FsaOT4pjlH+qGeRFv+lO32U0nK23du8S7/
	 CJXtN5/sj2+BFiYosCUIUt/zjupgtfQC+Tg2GX1c3xQxG/ECEozyTbEaGkh+KjTbGz
	 0I4L6n0kNFLChfuuLxRnx3PCfg7O/JFg6yOqKyjeGdAwgRAzELROyqZq4hPZ4S5Uo0
	 3LVLiS9aCROMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "T.J. Mercier" <tjmercier@google.com>,
	Jerome Lee <jaewookl@quicinc.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 084/311] selftests/bpf: Fix OOB read in dmabuf_collector
Date: Tue, 10 Mar 2026 07:02:11 -0400
Message-ID: <d41a197dce3a2f0be5c5fb9d4a743eeb1abe6fe0.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "T.J. Mercier" <tjmercier@google.com>

[ Upstream commit 6881af27f9ea0f5ca8f606f573ef5cc25ca31fe4 ]

Dmabuf name allocations can be less than DMA_BUF_NAME_LEN characters,
but bpf_probe_read_kernel always tries to read exactly that many bytes.
If a name is less than DMA_BUF_NAME_LEN characters,
bpf_probe_read_kernel will read past the end. bpf_probe_read_kernel_str
stops at the first NUL terminator so use it instead, like
iter_dmabuf_for_each already does.

Fixes: ae5d2c59ecd7 ("selftests/bpf: Add test for dmabuf_iter")
Reported-by: Jerome Lee <jaewookl@quicinc.com>
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Link: https://lore.kernel.org/r/20260225003349.113746-1-tjmercier@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/dmabuf_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/dmabuf_iter.c b/tools/testing/selftests/bpf/progs/dmabuf_iter.c
index 13cdb11fdeb2b..9cbb7442646e5 100644
--- a/tools/testing/selftests/bpf/progs/dmabuf_iter.c
+++ b/tools/testing/selftests/bpf/progs/dmabuf_iter.c
@@ -48,7 +48,7 @@ int dmabuf_collector(struct bpf_iter__dmabuf *ctx)
 
 	/* Buffers are not required to be named */
 	if (pname) {
-		if (bpf_probe_read_kernel(name, sizeof(name), pname))
+		if (bpf_probe_read_kernel_str(name, sizeof(name), pname) < 0)
 			return 1;
 
 		/* Name strings can be provided by userspace */
-- 
2.51.0

