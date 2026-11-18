Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056888;
	b=V3+Xuo5VcGzcBgBz0Ksvx9LjLajfBY3a1gKXLcsdiWLxO9YgZlHd+hgw+xj5wwDRGTHR
	 2db2Dyd0yrpynt/pvruiunkJoLpGRTd+Gb4ISUYrZrw2NRz7P+swW6ANs0/w6pEIMg7dw
	 RwBb2EquNMI4gK7E521UC9EubfT91iHs8s5CiM3u4uKXfmSrmiavov7b8SPSyNTVMQpa/
	 FyrgWr6cqyu66FX2A+JqgXiX2m0f9Swc4SLqTXPOnw8NgQFmegf3g3uoiDxHa3f4N00iU
	 tbvtKBBg06nwy49/kw5K/5rfSnzwCgM4b0sNvlY+oReEzgDj83lyb7SJDpL4s2lXx2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0mSIwImKNyA1qfLs3bE/WVKOwKU3sct/li2uRNgtxaM=;
	b=F5NKYL234r64LPUiUCrETKNnQDhYCyIjLWjc3SB+Qe0FXKJSWYiwt4Zs+hsRU5ZXjXLx
	 cbIHVkMvP8kpvaHL8sLG5uMKUHmjOGs6/+L5nyPw5xCVrejE5C6AESsmVP47W3W7BrdpE
	 MYiZRilVbtwwdI0kXUsp3Tix9oQtPulDYiOrz6U3hSoXprGHQQeoIqvO47vuKJ801aOmx
	 Yx5OudhywF84oVru2znr9ta+zocEsyOXwLoYn7JN8iB/fBxisId9G6ckRX/Di5liy8MCT
	 mqMSqVZRhB8KsEqlwAxD4/pJkIDUTt+3bjYSQP7w1WFfcJY0GcQXcBLXsSTxDgARE0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMusUHnV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7271E606A31C;
	Thu, 19 Nov 2026 02:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMusUHnV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11AB1F000C5;
	Thu, 19 Nov 2026 02:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056888;
	bh=0mSIwImKNyA1qfLs3bE/WVKOwKU3sct/li2uRNgtxaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMusUHnVRISJzjjFvPpjeBq/qf6ChbN+AoyMJZ8DzK2PvdO5uNG2SvS9QB6MFeqg1
	 ZRYpvbGVoFnCQT8v++fRCODYu84C9/r/0dk1RKtXTWxy/o+xEDMycfnccv9lMArFrS
	 5Qv3V2Ylv9PAK6DFLoDj5zXD5FLWSl9zs7JY1xpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2148/2214] bpf: Fix out-of-bounds btf->types write for split BTF
Date: Wed, 18 Nov 2026 16:03:44 +0100
Message-ID: <20261118150136.399695986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8e9674f625c97..eb11231428f1d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1444,15 +1444,16 @@ static int btf_add_type(struct btf_verifier_env *env, struct btf_type *t)
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



