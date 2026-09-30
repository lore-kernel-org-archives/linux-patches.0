Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE53F355819;
	Wed, 30 Sep 2026 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789122; cv=none; b=adLR/DAhW5JfdhQoAwU0lBsdIM8cCuZ7W3UI1YsWjejnoujcUPDsjUiUqolGnarw7JzV3crodZE86eChNng3wd4nFfGB0mb6zyuN5zmzSBVhljBuTQKbcR73yA4WnnOHEwgweukU4LBbfya9feuM9rsf77Jak0x+Pl/0QRGtAfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789122; c=relaxed/simple;
	bh=voNoz9t/0FrVRuTdgGO7ilZQ5z+2sZhhTz3rW/sQW5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj4dE7liUyZpPJsJKQRaH8Pm6e5Dnl/fRnwF3TGwbKU5+Ynzosa7auiFqOc/9dUnZSPnLdhSnBP7GH5QLcA2j5SaVeuFVy8yInlbQwZ4zAthjhkZiWNnjp8BqIQyodg8uDiWP8A6BLZ5WYhCqE4xLPLsqeZmCPidvPwO7gmEo+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLuXABVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLuXABVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B581F000FF;
	Wed, 30 Sep 2026 17:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789121;
	bh=9+ijC0keUz1vNLqJQZMSHhSIqVuW4Qrd8Knl/1MI8O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLuXABVCXKs0plSoE3FaRXXwkkJZTr7/a39TMCljFp0K25Srok7ym7uJ1IvK54PKw
	 0T5a/LZANmwLg33tDcPHAloPhQCwsZ4w2Dh+ywSSJWmmUQ8eI1A9QehB9FvdUJR907
	 rTzF9/4YUtzOn5i55vGxBEob+JIC78XPpX4B05oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ren Wei <weir@nebusec.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 367/877] bpf: Check params size before reading reserved fields
Date: Wed, 30 Sep 2026 17:21:18 +0200
Message-ID: <20260930152422.599481097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

[ Upstream commit a11212910cf09b2fe8db9afa41ef60c4f81879c5 ]

bpf_crypto_ctx_create() is a kfunc whose second argument is declared
with the __sz annotation, so the verifier only guarantees that
params__sz bytes of params are valid.  The function nevertheless reads
params->reserved[0] and params->reserved[1] (offsets 14 and 15) before
comparing params__sz against the size of struct bpf_crypto_params, so a
BPF program can pass a shorter buffer and have the kernel read past the
region that was validated for it.

Move the size check in front of the reserved field reads.

Fixes: 3e1c6f35409f ("bpf: make common crypto API for TC/XDP programs")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/4f3ab4b03e79017e215521743996555439bf0bb3.1789802413.git.xuyuqiabc@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/crypto.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index 1d024fe7248ac..3837d4dcf48d5 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -149,8 +149,9 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
 	const struct bpf_crypto_type *type;
 	struct bpf_crypto_ctx *ctx;
 
-	if (!params || params->reserved[0] || params->reserved[1] ||
-	    params__sz != sizeof(struct bpf_crypto_params)) {
+	if (!params ||
+	    params__sz != sizeof(struct bpf_crypto_params) ||
+	    params->reserved[0] || params->reserved[1]) {
 		*err = -EINVAL;
 		return NULL;
 	}
-- 
2.53.0



