Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028849;
	b=Fee+vsfHa0nBWInZxFZ5z/etEm5Tg4p9k5JAxs6VFjvsH1JSdRhE1w6ei6iq6S7d+tGK
	 A9EsMQPTij7c6kGMJfy+ep9PlEVu/TgDzEgUjhLrTQAANqSyks9ELvGemddWqWyMdATyQ
	 g5lVskfbzyps0sAqM4MOybBj0B+ao1zynYO2gNJ0Y0prtPtTjw6EnucshNhTvu3btpsCf
	 eYIAaH0pDg8c5h1PkjY+zY4NoIXdShTUG3NJCYms8kXxDbul/p3mDE3Ms/uIJ2F0dZ5Ea
	 n1SPYh1jV7cfpVR8e9U/yQkTfGmyOp6B1Eh8pe7vhgVSfbVeCikpc43omCnzmhch9xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+9brJWCI27WnO7X4oonTRSXdlMZnBceN3RPoES4WLyg=;
	b=zmRv+sxS1NpunzU2dDcVs9RKfYLQ+wmYcsU/Ug0puShoC9LCWVSjL7cmoyx4zkA6W2f0
	 R5uJFRPft3+3gPwySQPnG6+vFsmJRTGsiD3SnjSXk/49QXaG+ffDsSe3BDKNT4UF0ti0m
	 1x6O0wI6/jI4M/KHmj8m/zpfIDtbK0RdWZJQUE8f+rtyb/H6qSdytuXJ589iWMuMnG8UR
	 yynedCdQOidxv6XELP4Qh9F9/K8ii7ZtWSzSfD/abnEy2BprlzvObl56hSjCmQnbwtThe
	 XxK2ywCof5hREijblB/1G5ds6w7sdQ5ejp8AmgKS8H+RsLaFFIXiduT38rgzFOx9ukg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXNAr5sd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C745A606A336;
	Wed, 18 Nov 2026 19:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXNAr5sd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCD11F000C4;
	Wed, 18 Nov 2026 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028849;
	bh=+9brJWCI27WnO7X4oonTRSXdlMZnBceN3RPoES4WLyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXNAr5sdIWsHILTFWVdB6WwUXVjRWVYA3ZGFCFjW6zc9GTJak9nNflc83UuLC7R2F
	 bf6EvjElMQloXTXNh6E5+O5rlGuJ07g69Q4f3Al+bV7fcJ2i1jAZ/7o+D4FEKRntxK
	 4GBVS5RF3ouCgPwQyxgOAB+nnXXhq/BPUISv9tYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Darren Carreras <carrerasdarren@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0140/1756] libbpf: Avoid overflow in BTF.ext bounds check
Date: Wed, 18 Nov 2026 15:37:47 +0100
Message-ID: <20261118150013.737291457@linuxfoundation.org>
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
index 8c20395ebfd30..9f14ab48eef3e 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2906,7 +2906,7 @@ static int btf_ext_parse_sec_info(struct btf_ext *btf_ext,
 {
 	const struct btf_ext_info_sec *sinfo;
 	struct btf_ext_info *ext_info;
-	__u32 info_left, record_size;
+	__u32 data_left, info_left, record_size;
 	size_t sec_cnt = 0;
 	void *info;
 
@@ -2919,16 +2919,20 @@ static int btf_ext_parse_sec_info(struct btf_ext *btf_ext,
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



