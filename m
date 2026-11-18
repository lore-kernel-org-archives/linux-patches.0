Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033426;
	b=l8+QMMqWcujRMxy19/FIXg0e0gzIpI/FHWxyZI9IDRvyUbxm0hY3nHdjbxzg4rOdXbC7
	 +TmUfONvcu6rxzRe9L2CwEqI+9BlE5BnZAeH5TIhoRjX8oYfkvHAh3mSaeDSKpz7zV7ER
	 HgvrXRjO9ORxhLLbdrksKfGbmZg8zLxvMlAKsDvYJEftTSUIYTHqFKGrXWXhmL5xNpwd2
	 GxXcjxD/TafJY2vYvkK8SJJXdwNcv7fBdvk9k4DG7sBuBb5vtivcHtucu6zh3NfL2WjOj
	 Ir+qb3n0dwQceekT3y6XhzIik5brAEuO4ZrU6ElTKsYn8iSRosmmaRyWHlnjRZhQr0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QjX1qdOfjOfyyGuUYIdrDhygneheO6H/BKC2TlPI2xQ=;
	b=2DVZmxJf+evs2uxtbD5WmvSbOOXI1lmeH6HDCG5EzpE/ozewtSesZUP4BbvI0WR6A6Bc
	 zSLDuOm3apYtj0hE8FnT0DyZl3SPA6p08E9IXg6hXz/31M1gIe6Xy/Z8uN7loDN1H3e1x
	 FiRctW+CmaB0frvrFohJj7QcFnsL76xeJBE+/ChRciasPWTFx8j7QfC7Jp4raUdfMRudz
	 KVgddoN6BCsDPO8+wziia5Ttm7L0mQp9/TWfz3C7usalK8wNcqLcsNluaMFVoTT8RiAdV
	 SEZ9l2zmNa4q57T/6H/6KN5HYAZAtG4UcvUzOCV/Vyfq9k2AdckV9dhAwZ32jeKZo9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6mIsZ7H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDEC606A31C;
	Wed, 18 Nov 2026 20:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6mIsZ7H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E8C1F000C4;
	Wed, 18 Nov 2026 20:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033425;
	bh=QjX1qdOfjOfyyGuUYIdrDhygneheO6H/BKC2TlPI2xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6mIsZ7HjuYfk3mbmk9RlU0O8sd+MdH6hiuiSAQ/zp2n/ULgwDVoLFGjpbYEW46DR
	 4D9W6Dgjra2+5Ftlz4wLvIu9eidZSnZau0NhsIq3X4CVbvCXW/BJOag1iJsg/w3x7S
	 t3BiBQUGqMcFrM1269SnQDuDJveCOv+oFIBVDTdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 1736/1756] libbpf: Fix accessing BTF.ext core_relo header
Date: Wed, 18 Nov 2026 16:04:23 +0100
Message-ID: <20261118150118.667494467@linuxfoundation.org>
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

From: Tony Ambardar <tony.ambardar@gmail.com>

commit 0a7c2a84359612e54328aa52030eb202093da6e2 upstream.

Update btf_ext_parse_info() to ensure the core_relo header is present
before reading its fields. This avoids a potential buffer read overflow
reported by the OSS Fuzz project.

Fixes: cf579164e9ea ("libbpf: Support BTF.ext loading and output in either endianness")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://issues.oss-fuzz.com/issues/388905046
Link: https://lore.kernel.org/bpf/20250125065236.2603346-1-itugrok@yahoo.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/btf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3018,8 +3018,6 @@ static int btf_ext_parse_info(struct btf
 		.desc = "line_info",
 	};
 	struct btf_ext_sec_info_param core_relo = {
-		.off = btf_ext->hdr->core_relo_off,
-		.len = btf_ext->hdr->core_relo_len,
 		.min_rec_size = sizeof(struct bpf_core_relo),
 		.ext_info = &btf_ext->core_relo_info,
 		.desc = "core_relo",
@@ -3037,6 +3035,8 @@ static int btf_ext_parse_info(struct btf
 	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_relo_len))
 		return 0; /* skip core relos parsing */
 
+	core_relo.off = btf_ext->hdr->core_relo_off;
+	core_relo.len = btf_ext->hdr->core_relo_len;
 	err = btf_ext_parse_sec_info(btf_ext, &core_relo, is_native);
 	if (err)
 		return err;


