Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20998519DFD;
	Wed, 30 Sep 2026 18:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792966; cv=none; b=EWxdm2LXsgtrJ0rz98+Pheydpl12/aOqDOIFL6vlzav3Hf6vKYoc/atAosqyoJpr/Sh3pIYRQ/m5C93Wgxk6i2vvIodVbk6Pqs7XPhu3hHArAvBk8i+PfFL8QMuENpESPjrvQNYua4RJ10IXToFAFk8IfNE6ARKyLkNmkWiXbp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792966; c=relaxed/simple;
	bh=xxETB8frNzDOlbALSAz0qs1vCfyKa0Wvcm/mB85SZjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8ecuSYWQwziHN2nNQNznV2wvlchiHW0jNr3BP/LfD082u/ZwhvSHX2o2sRmXV81r08LbAbX/vXycOb3qednA9XdlaUs7da/r/Uaut8qfe/wOiM/my5A0X9mHhAlCH47ysG7T9WJF9YrwXLvcAI38dXKgF93HUL1UoYmltwf79E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Txbuju4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Txbuju4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5609E1F000FF;
	Wed, 30 Sep 2026 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792964;
	bh=m88pJuX+e+uzxDs5tfgBh8kv+EccHIObZx1jBw/BtI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Txbuju4wcgDz99t5eVTi4KJ8+1DfXWLBuEm72t33nfORWkJXOpAw8LsEMx0R5jf6v
	 CdquVyHzUsFzG/dL91uAqXBchCpuyaVeHfN0qR7i5Dik1WNm6RS08JprtSqWm0H16C
	 3AsAPHmUXvvIQd9zy3No9DW1Ucz1tJsg88wvLuyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ren Wei <weir@nebusec.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/395] bpf: Check params size before reading reserved fields
Date: Wed, 30 Sep 2026 17:25:51 +0200
Message-ID: <20260930152342.565716373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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



