Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022780;
	b=Y1C3JnkW7fthklS4UqOVSYLMMkz1OKH0UV7T3l1Lj+VD2V89fvMzd3raVhw2tepy7a/D
	 Vpgv/4lxOhuYGSPy8c01pFfmwIh3+F/XplZCRY8fqYYBk0m6Ix8Z/rt962qgTbiDPETCJ
	 iTALmH3fjhhgpvaoncwr1j/8G8Tbh4bTymvV45R/PnnH7ScTB/ryRm2DJioTCao72JDdz
	 go8bqd/aBFrBdARDlyOIpa+ngE6GxpahuSb6/VoobIsiBM92yiXXnCpKca79cSxdjAaWq
	 5LcWu6G7lqJ6wMSq5tbHNEn6ZZD8kq2byjzkyao3RWlomxs7rwVEcgeF6vhY6Oo+arg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VuD38D9oTASK4Q3DGCsWOMTsK7/h/q57TLFiUeaM2kQ=;
	b=fkUnrXsneWAkEX+E78osQo4tpUA1Gw3nzyd2RM0DpwI9DEtKH0wiU6SasmBlW8jVFERV
	 BxPy1InsauMGR79/+Yuggm9xVCKWYvXSTbQ261cC7eOuuBR1jBMJY3f9H8Tp1jlOlB33A
	 MYpThHcscenuR4GG1aatxfLCMuA/weBCIdXsI/UT1/oy1kFGoDEnbLGEuX9WZOgRt/g6d
	 AvSFSZqYJjQMhyKq0Tb/klO/2YDTmtsKOhljm0jm09hZw+f7Dzl5J9rSh2cvG1Is0m2cT
	 GIl+DZf6JJw4CgYcHk6ncLdhrMGPDMMj+62kb7lZDNhJsxtsFejiO6g+RsguCgWoVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1Qmxlyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43846606DABF;
	Wed, 18 Nov 2026 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1Qmxlyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9563B1F000CB;
	Wed, 18 Nov 2026 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022780;
	bh=VuD38D9oTASK4Q3DGCsWOMTsK7/h/q57TLFiUeaM2kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1QmxlyiE6kFXGAK+8wembYkVpnlLrworM7BFKDobkQAHneBR/oI6bd/2KXm55EmO
	 peHFAC0L4UMdW0DsIUfhSIBv/xrn3SzB9ar53QEuQUQVeXpBctzqgpVvTV9vaMzvzp
	 lVvJqKh6I5SB3zFfK5OXsaReWrCsDC9xKQLZxUgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Darren Carreras <carrerasdarren@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0133/2151] libbpf: Avoid overflow in BTF.ext bounds check
Date: Wed, 18 Nov 2026 15:31:08 +0100
Message-ID: <20261118150126.636514394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Carreras <carrerasdarren@gmail.com>

[ Upstream commit e40f61a31688898e7cf81e91074a42f805883e4d ]

A malformed BTF.ext subsection length in an ELF input can wrap the
pointer addition used by btf_ext_parse_sec_info() on 32-bit builds. The
wrapped pointer passes the bounds check and parsing then reads beyond the
copied BTF.ext data.

Ensure the header fits in the copied data, then validate the subsection
offset and length with subtraction before forming its pointer.

Fixes: ae4ab4b4117d ("btf: expose API to work with raw btf_ext data")
Closes: https://issues.oss-fuzz.com/issues/477315119
Signed-off-by: Darren Carreras <carrerasdarren@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260813-b4-libbpf-v6-send-20260813-v6-1-56be61c52758@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 9f141395c074e..f1ee53a07f17b 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3013,7 +3013,7 @@ static int btf_ext_parse_sec_info(struct btf_ext *btf_ext,
 {
 	const struct btf_ext_info_sec *sinfo;
 	struct btf_ext_info *ext_info;
-	__u32 info_left, record_size;
+	__u32 data_left, info_left, record_size;
 	size_t sec_cnt = 0;
 	void *info;
 
@@ -3026,16 +3026,20 @@ static int btf_ext_parse_sec_info(struct btf_ext *btf_ext,
 		return -EINVAL;
 	}
 
-	/* The start of the info sec (including the __u32 record_size). */
-	info = btf_ext->data + btf_ext->hdr->hdr_len + ext_sec->off;
-	info_left = ext_sec->len;
+	if (btf_ext->hdr->hdr_len > btf_ext->data_size)
+		return -EINVAL;
 
-	if (btf_ext->data + btf_ext->data_size < info + ext_sec->len) {
+	data_left = btf_ext->data_size - btf_ext->hdr->hdr_len;
+	if (ext_sec->off > data_left || ext_sec->len > data_left - ext_sec->off) {
 		pr_debug("%s section (off:%u len:%u) is beyond the end of the ELF section .BTF.ext\n",
 			 ext_sec->desc, ext_sec->off, ext_sec->len);
 		return -EINVAL;
 	}
 
+	/* The start of the info sec (including the __u32 record_size). */
+	info = btf_ext->data + btf_ext->hdr->hdr_len + ext_sec->off;
+	info_left = ext_sec->len;
+
 	/* At least a record size */
 	if (info_left < sizeof(__u32)) {
 		pr_debug(".BTF.ext %s record size not found\n", ext_sec->desc);
-- 
2.53.0



