Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A3A4D7D4C;
	Wed, 30 Sep 2026 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787105; cv=none; b=Bh17Gmompsczsbk4jQBwdzAsW++Fq/hXqIIkS0VHGTmBRTvOF1LbV/vY2nUwUGgIjPzWAEKiDdgYXfbwpYiO+5EO6Zr7y47natO8n6g25RpZd1+7yheMpP5KBudeY7tzTycAGyH0oHQN8vPsm/WRABkenVFpxUaXwGrnI8ck8LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787105; c=relaxed/simple;
	bh=BnjiblOnGu3r8P01HKSSwgbiaEB4dhJSLjCEcjLRSeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwOr1G7SSy6M8i9mHoN/6kSudHpFvxUjZZojxumut3BCC3LVuatdwfUG7l6avff61XSsb53sHhKc+1UCe0td0vQRB+BAwZt41u1k5KwwieHF6cy8JuKGDJUwB6iAaFn6FvwS4vfYhpSMNkrlZI6eSTRDOUwXR+uo5wjZ5HE3iqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abIy4uqr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abIy4uqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACFB1F00898;
	Wed, 30 Sep 2026 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787103;
	bh=SiF1nW46Rl/K8BJ7tVj5F8A+OfdWdvcYgwgI51dCaeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abIy4uqrDrOZFEdtpdC6vJPf5Vvk1tC5wCsZQ8b7nhnzmLyqMMpUUYTGl5ukwY+Vv
	 L5uU3+54U22yza/IwSyzh7NqLijs2C4KHSswULETI9hwNM/v2XcoBEiB80maP1+hE4
	 P9s2knKWSfPX5RqmiuFSc1tpOA8C0zrxW/8xVWKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ren Wei <weir@nebusec.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 106/457] bpf: Check params size before reading reserved fields
Date: Wed, 30 Sep 2026 17:23:31 +0200
Message-ID: <20260930152348.340129900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 51f89cecefb4d..3f3fe2450fc6c 100644
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



