Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064279;
	b=Jay8hW1huQZvvhJ6etdYT/uARcSNSSJ6RB6Hqab99VWV9GYUPB84/JNBtCeYKOvVguDp
	 CJUjClbzvnj9rQh1W2nd0jQ8yPRZ9lsxTWpbjUeIWk0INj4fXBcry/7kmOwRDmL1C3dGH
	 d+fBP6/0PhYIkAFZg3na8oTwmVG+30+ODMWWI97k3w4iLWJioG3qQs9YVo3VFtVDTREVu
	 zAn7V3+x6B9FFw7M/jKgmK1wD9ZZ164hRcUXzalTQDdS6FaIy1BUvG1SVadiM0kIYttcN
	 J/wUtgSyHnGgGXEHF8wD44dXISiQOhrDV3pLwVs8DfYLc4AiLXMp5DoLpkMs0gT3A1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YaWv3v+utrm5dKoJ5Mj4VqBdGve4cNGNaFu+ADu3GSM=;
	b=NCWBsBBnPLEZjyfF9N1BH5/zfgtQKPY8LZPmiFPFZPJqqwV/1NX6s03syYQk0gV6l8K2
	 AD2M0V3foEhVYW2aZc0NLbPfLf4Wfw26aQXnYNKwu7WyzRnFBcW2XPoQ39sxoF6LjR3jS
	 rQ5DSk2y9AxXYZcJNSbd+WRPbxBsCM7tr3MIIqZBQYGBVhaPQSY1GgFzvpGSjFS9SDldS
	 w1lrFR7q3f3FoMW67CnJTKqatE5y7bH/GAd8Qlpx3+7cD6ThXUaeBbJOQq+y2K9+xSXbX
	 Vs7NmIRZqAfuaN4ZpWeVbow3YgOcvo4mKFKELMisu/ZpCyQBHum1C9V8TSXZkE0N/HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gNLnIVYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F946082BDF;
	Sat,  7 Nov 2026 15:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gNLnIVYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE371F008A5;
	Sat,  7 Nov 2026 15:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064278;
	bh=YaWv3v+utrm5dKoJ5Mj4VqBdGve4cNGNaFu+ADu3GSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNLnIVYh7NJsDPLTDk+ivuKXjepzbfSR8rOoH3MoOMpcln3BfeLrhomR5GqIzqbS8
	 uefbqc4VVuXGAxJyhorD89GQy/iISME9DR04gl/DOSXJ348on7itM6HmQCRrA9ipj4
	 SilNeOtV6mRXJXfXa5xOXCnGPZ99gMRr3EdrtxwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Abhishek Dubey <adubey@linux.ibm.com>,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Yeswanth Krishna Tellakula <yeswanth@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0373/1257] powerpc64/bpf: fix percpu private stack leak on JIT failure
Date: Sat,  7 Nov 2026 08:44:29 -0500
Message-ID: <20261107134949.858570421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Dubey <adubey@linux.ibm.com>

[ Upstream commit 24affb84d98e6b37b276aa57e5dd25ad93458cea ]

The existing conditional statement in bpf_int_jit_compile() frees the
percpu private stack at out_addrs only when the image buffer was never
allocated.

If bpf_jit_build_body() fails during a code-generation pass, the
image buffer has already been allocated, so !image is false and the
percpu stack is not freed.

Because JIT compilation failed, fp->jited remains at 0. The subsequent
bpf_jit_free() path only frees priv_stack_ptr when fp->jited is set, so
freeing is skipped here too, leaking the percpu allocation.

Fix implements freeing the private stack whenever fp->jited was not set,
i.e. compilation did not succeed, instead of keying off !image. !fp->jited
already covers the !image case, since image is only NULL on early-failure
paths where fp->jited is likewise 0.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/bpf/20260616135426.A06B71F000E9@smtp.kernel.org
Fixes: 156d985123b6 ("powerpc64/bpf: Implement JIT support for private stack")
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Dubey <adubey@linux.ibm.com>
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Tested-by: Yeswanth Krishna Tellakula <yeswanth@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Link: https://lore.kernel.org/bpf/20260616135426.A06B71F000E9@smtp.kernel.org
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/a827e3ef81cd43f2aee7e9bdfe8683f2c77065da.1789982239.git.skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 7a612688e7a20..ffee1a76e5302 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -357,7 +357,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_verifier_env *env, struct bpf_pr
 				(void *)fimage + FUNCTION_DESCR_SIZE);
 
 out_addrs:
-		if (!image && priv_stack_ptr) {
+		if (!fp->jited && priv_stack_ptr) {
 			fp->aux->priv_stack_ptr = NULL;
 			free_percpu(priv_stack_ptr);
 		}
-- 
2.53.0



