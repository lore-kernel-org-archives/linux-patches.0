Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282B51D0173;
	Wed,  2 Oct 2024 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876019; cv=none; b=tPzlqMtXOb13tQVJl9VyOA/Ye1pnk/CTz8z68zGD864dCc/9O0FjlWp9o4naKsvzAKn/vu5FBcCAAkZHbHxyACo+risC9gTQQW84ZJso3HDf7hJwJxBAF0uYtFjKfTmvdXH56DUvp0ODY4hO8iF9vNmIGaO4gYblPjDrPqbdCI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876019; c=relaxed/simple;
	bh=7Pk5eozPeidyJSYW9d9SsB34IClgTqGgB4vo1US+GKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5k5I9b+9u2aRlFRFdecrzjYOpL82ucqIRgRHnbFIX/rbafQ0puhnWHDC/SoK/hzTiL+mxkci9x8MILkvTLmvekxI/WLeA2KSApcgD+aBkdDYEk5IdG9vkAaO2HTaMAFKqLaM7hWeiaJVRbyzE/57k+34liEJJpGJ4QKMP6FjQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJC8p3Qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJC8p3Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DB0C4CECD;
	Wed,  2 Oct 2024 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876018;
	bh=7Pk5eozPeidyJSYW9d9SsB34IClgTqGgB4vo1US+GKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJC8p3QntXkHJqyLEchY5bRrnqED4h5HZ5IZdVwXpLZvWw+MiJ9MthXGEAKFnK4jP
	 VVc98MPpFCyNyVNm8+d5B9qNdanpZ2H8urCmapKII375AxZ9F+81iVSXku2zsYmees
	 WHeYclu2gn1Xy1rMOgt8pn4NwTRj9CmeRzMdO1ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 301/695] libbpf: Ensure new BTF objects inherit input endianness
Date: Wed,  2 Oct 2024 14:54:59 +0200
Message-ID: <20241002125834.454437394@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit da18bfa59d403040d8bcba1284285916fe9e4425 ]

New split BTF needs to preserve base's endianness. Similarly, when
creating a distilled BTF, we need to preserve original endianness.

Fix by updating libbpf's btf__distill_base() and btf_new_empty() to retain
the byte order of any source BTF objects when creating new ones.

Fixes: ba451366bf44 ("libbpf: Implement basic split BTF support")
Fixes: 58e185a0dc35 ("libbpf: Add btf__distill_base() creating split BTF with distilled base BTF")
Reported-by: Song Liu <song@kernel.org>
Reported-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/6358db36c5f68b07873a0a5be2d062b1af5ea5f8.camel@gmail.com/
Link: https://lore.kernel.org/bpf/20240830095150.278881-1-tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 32c00db3b91b9..40aae244e35f7 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -996,6 +996,7 @@ static struct btf *btf_new_empty(struct btf *base_btf)
 		btf->base_btf = base_btf;
 		btf->start_id = btf__type_cnt(base_btf);
 		btf->start_str_off = base_btf->hdr->str_len;
+		btf->swapped_endian = base_btf->swapped_endian;
 	}
 
 	/* +1 for empty string at offset 0 */
@@ -5394,6 +5395,9 @@ int btf__distill_base(const struct btf *src_btf, struct btf **new_base_btf,
 	new_base = btf__new_empty();
 	if (!new_base)
 		return libbpf_err(-ENOMEM);
+
+	btf__set_endianness(new_base, btf__endianness(src_btf));
+
 	dist.id_map = calloc(n, sizeof(*dist.id_map));
 	if (!dist.id_map) {
 		err = -ENOMEM;
-- 
2.43.0



