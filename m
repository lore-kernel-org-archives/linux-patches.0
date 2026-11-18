Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033020;
	b=XSY4JuFf6FLOlu1Efy/pWj6i2WsLnWDP4J2nsCSRikonohlecdYWg8wZuEElY4CuKdL0
	 +ztVq+OOZ1rqX3Qh5pUfXs9N80CNeqpoetAQzEekOQBm3849DDYP6NJ5oYupK2lThSIhz
	 eiY9OW6yB7NnWBorv4hl9aOctn9QUGGcaaPjcFQktvq3Ednx5Xgq0knZHDAAZX33VF1J+
	 BLUu2HsAV5J3UxrYCo7A4jHDVORT7X+2rhUabdpo4WTl3o13T1Nqi7LHs4y3rA+dDt/9Z
	 8wFaQGw0PMllidqISH7hvGohW454h6Ruyng07ikKPHLH6tO3xLKGsEBp37nLzgPMw+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+jtTB5cwY8wxMM1CBpjfIhWUs0rnJXTMpBfb97hm5a8=;
	b=SS66KK7bVx7eJavNZKySDP9Td1afWdx4vB8l7hcd4i/qXkTvE0/36WDpI7fT4q3WlvI1
	 Ps9ccOr+8LX2aDJVhTcLGnic6aqrwWGD2OV2QGO/JXS/4Vsf92W8rtIGRWtt9+mYjvX/j
	 JIFr5GJ/NSDOu+i6mQwD1MBpmuBfZ/3ymtodE21IaDzJ22YeBkJZOuJm7tBZj9C1xHDW/
	 285iZ73+qcyRmfPBCccXfzJ/5yDZeOAnYfptzxyEo1cVUMKutM+ZGM7YjJgoEHN7hjP3u
	 GYVGjXgIV7Xg7UNxiqQT3yAjvSJ6Tyyt728nwI5ThRvNreUnDrSMAX9j+rEsTHPl5Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjyPdd7q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347A4606A320;
	Wed, 18 Nov 2026 20:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjyPdd7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB571F000C4;
	Wed, 18 Nov 2026 20:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033020;
	bh=+jtTB5cwY8wxMM1CBpjfIhWUs0rnJXTMpBfb97hm5a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjyPdd7q2YGvClYIxp0yedmqJfLumvAYWl5TaSTez9DiTboVSBQyv1CHJuZPkijhV
	 R1PxQGUd/GpQZbM51t3/8od2M5+4hIFnpFpRa/i/lHEkq/vzVA1uORxxJ8qBq6y4HA
	 F+HWZD0vQSB9XxDrrpFVDKHNjOp9UVSdTn7w97kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1619/1756] bpf: Fix out-of-bounds btf->types write for split BTF
Date: Wed, 18 Nov 2026 16:02:26 +0100
Message-ID: <20261118150114.287977211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit 6c476d2b73056ed151c3f8b884c627c75999ed7c ]

btf_add_type() stores the types of a BTF in btf->types[], which can hold at
most BTF_MAX_TYPE entries.  The types of a split BTF get IDs start_id ..
start_id + nr_types - 1, so only BTF_MAX_TYPE - start_id of them fit, but
neither the limit check nor the size used to grow the array accounts for
start_id: the check is an equality test against BTF_MAX_TYPE
('start_id + btf->types_size == BTF_MAX_TYPE') and the new size is clamped
to BTF_MAX_TYPE.

The check therefore only fires if the array happens to grow to exactly
BTF_MAX_TYPE - start_id entries.  Otherwise, if the module has more than
BTF_MAX_TYPE types, the array is filled up to BTF_MAX_TYPE entries.  The
next type that needs to be added reallocates the array to the same size,
after which btf->types_size no longer equals btf->nr_types and the growth
path is not taken anymore, so every following type is written past the end
of the array:

  BUG: unable to handle page fault for address: ffffc90006200000
  RIP: 0010:btf_add_type+0x74/0x270
  Call Trace:
   btf_check_all_metas
   btf_parse_module

Bound both the array size and the limit check by BTF_MAX_TYPE - start_id.
Base BTF (start_id == 0) is unaffected.

Fixes: 951bb64621b8 ("bpf: Add in-kernel split BTF support")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Mahe Tardy <mahe.tardy@gmail.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://patch.msgid.link/20261028031933.277550-1-yangfeng59949@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8956f2fd0c57d..e152b4d9113f8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1600,15 +1600,16 @@ static int btf_add_type(struct btf_verifier_env *env, struct btf_type *t)
 		/* Expand 'types' array */
 
 		struct btf_type **new_types;
-		u32 expand_by, new_size;
+		u32 expand_by, new_size, max_size;
 
-		if (btf->start_id + btf->types_size == BTF_MAX_TYPE) {
+		if (btf->start_id + btf->types_size >= BTF_MAX_TYPE) {
 			btf_verifier_log(env, "Exceeded max num of types");
 			return -E2BIG;
 		}
 
+		max_size = BTF_MAX_TYPE - btf->start_id;
 		expand_by = max_t(u32, btf->types_size >> 2, 16);
-		new_size = min_t(u32, BTF_MAX_TYPE,
+		new_size = min_t(u32, max_size,
 				 btf->types_size + expand_by);
 
 		new_types = kvcalloc(new_size, sizeof(*new_types),
-- 
2.53.0



