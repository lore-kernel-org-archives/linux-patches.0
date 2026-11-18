Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042788;
	b=BS4X8WbmmD1iwlv9y/QpoS5W3i01SyJOcSn9/EYItTtN7L9hIi5D31W8RL+9t+BaoLL3
	 oHwHCkrl9EQrE81H8hypFQubMbyggGWTQa78hMfxYLd99YBCdu4OGtQykE/N/PrB0uBsp
	 WX9AaYchfBMOwn7Jy1x7Sq0/PGcTeJ8/igIz9FqsCoR9lXZOEVdJMjMBUDZ7nFfnODI0R
	 anxctFZXZpCOOnTl2COuNifdy+k42mymnLNGY8cBDz+SZpZis9LyKf/O0pSr2rlDkaOU7
	 do2B3eVglf79As7n0D/YOYefu+O8gUckAF2yVhy2NByNkGJ/vyoXcIRgn7uPdr+kNXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EcBUH1ub3bd37h3BY/jjchskoBRJS3Nm5PG8L2SGyt0=;
	b=Xwcn8dlduQsxjTr8Rry/NmuKLSYikQMxXele/VciXOxu1GyUuR6GZO9/LQyl3cTCOv3C
	 hQp8gGkp1EEZc0+UQDZ9OE1RtQppMHN7kPYRFi+MkHB64lO2NGXdgaPa+DyqlYSJ539nZ
	 HfeXC1v/QgjWR6sH4lxmoodZqMcMZpmi9Pzq3DuX5bEHyniRcNN3yr+7xkzZCeO4hZAbf
	 go+nN4D4j5yMa5YycdU1nsN6dqLQVVVpnOOIFibhfus/wP/7nM8q0g16FbPjLMmXeWiFT
	 Mjh8yzlq218XYeVB2qYRQ+uMHL7QSOxAh91GWZil/sXVHcr7UAECHZOS9DmbtdKxJHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSD+lzyN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20246606A325;
	Wed, 18 Nov 2026 22:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSD+lzyN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C9A1F000C5;
	Wed, 18 Nov 2026 22:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042788;
	bh=EcBUH1ub3bd37h3BY/jjchskoBRJS3Nm5PG8L2SGyt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSD+lzyNyIWFzHNhtelc2d2q2vpsJtZm3xFRBsTnpV+asqMAPDUyxxdHpZgoOh0M8
	 hDFBfHuwsdk0xQ/iXhvA9E2gBmz20LxU9Rs1VN5oIZAtMHwTI430KlAqGfEBYQ3Agr
	 qqvYl76GFLFEbpxG4wGRCZTR3sXG00JD1JhQOOls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <almagui@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3296/3318] libbpf: fix cross-endian build with newer libbpf
Date: Wed, 18 Nov 2026 16:05:18 +0100
Message-ID: <20261118150458.474819109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

commit 087f3964f4b3 ("libbpf: Support layout section handling in BTF")
added extra data to the BTF header.

This extra data is ignored in the native case, but when building with
different endianness the bswap code in old libbpf would check for strict
size equality, leading to build failures such as this when BTF data is
generated with a newer version of libbpf (through pahole)
    BTFIDS  vmlinux.unstripped
  libbpf: Can't load BTF with non-native endianness due to unsupported header length 32
  FAILED: load BTF from vmlinux.unstripped: Operation not supported
  make[2]: *** [../scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 255

Newer libbpf versions also properly ignore trailing data in the bswap
case, but the patch is too intrusive to backport, so take the header
length comparison fix from it instead.

Link: https://github.com/NixOS/nixpkgs/pull/570639
Fixes: 3289959b97ca ("libbpf: Support BTF loading and raw data output in both endianness")
Acked-by: Alan Maguire <almagui@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 2e9f28cece3ff..54ad899a1e96c 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -222,14 +222,14 @@ static int btf_parse_hdr(struct btf *btf)
 	struct btf_header *hdr = btf->hdr;
 	__u32 meta_left;
 
-	if (btf->raw_size < sizeof(struct btf_header)) {
+	if (btf->raw_size < offsetofend(struct btf_header, str_len)) {
 		pr_debug("BTF header not found\n");
 		return -EINVAL;
 	}
 
 	if (hdr->magic == bswap_16(BTF_MAGIC)) {
 		btf->swapped_endian = true;
-		if (bswap_32(hdr->hdr_len) != sizeof(struct btf_header)) {
+		if (bswap_32(hdr->hdr_len) < offsetofend(struct btf_header, str_len)) {
 			pr_warn("Can't load BTF with non-native endianness due to unsupported header length %u\n",
 				bswap_32(hdr->hdr_len));
 			return -ENOTSUP;
-- 
2.53.0



