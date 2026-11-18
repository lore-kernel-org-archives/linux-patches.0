Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033304;
	b=WGgoH7KwavEfH3BLISI7ntLfU8esNXipONi61P0FujSWUsU68kDxYYH5LHQeKCkgzlf0
	 XAbvH1VrjYEPsldaNP7hKK/nBoNLhc4YLEMOh/vIS06CzrNLwoJYOh6Z8BxQPsF/9EOCa
	 WG2KfJlXfj2qeuS6YOvwIuksFcxUDJxJMYi4ZtULQ6dsp2mfv+zivvHLirv374/m+5E5Y
	 16bO36xrW27lRv20GcjS1QHPIZCpXGvdZcFvLWeErlXGApAo237mNxvaWVmxeYrOwQUcI
	 drYNkDKoRbfjomihrvywUtKAKqcVtGxYvPWdt/LVlU5sTsS9KdCXY+YLSTl5KVzgN/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cY4DY19+PBCyQySxp/ZPodHsDMMv6isQVsGX40WiqSU=;
	b=da38qvbo/pjrtuPFBv9cEosdoidoKxsUIz701JckKWceOnS5b/B3awRzv6yC71+SsVcm
	 6cqccZcz+0Hcyn73o2Be4GLxI4lfR4lAY3OJWzhSUGhvY90y3IFfoydDaPV1qnWEGVPzK
	 axHCQ5B3EER6sGMdQ7/jjnjDDKIDGgLl8oHsHq1RILYscZ7LavJHFgyEAkzY4ib4208Ts
	 PHK9D9nZtE+QX71ZNP7L21lwJFecsl9zYEaiO7sUDOWfmMCilAcasUiMdCjlqddfW1r9A
	 Q7KSPjFeYmIeeCnVjWqRsqwL+bLvzz5ZyyDRd+ODPs1YoQyfDaw784PvBENbldREzxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emVq6adj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA58606A31C;
	Wed, 18 Nov 2026 20:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emVq6adj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C181F000C4;
	Wed, 18 Nov 2026 20:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033303;
	bh=cY4DY19+PBCyQySxp/ZPodHsDMMv6isQVsGX40WiqSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emVq6adjazIRAm3KPdlW2icai1UwE9qxb7le8kRwAtwyAzdwzuL2wo3RHv1k7PMP1
	 SYMKDdH4yUdoL6ggfyuiFOikNxsyLGS3/xdotyVPgAcaVQwvCxqnGMpEC/92k3MonB
	 8K8+f47gx8guCaHErjUZmLXS4GZppYqC8CrbXxvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <almagui@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1720/1756] libbpf: fix cross-endian build with newer libbpf
Date: Wed, 18 Nov 2026 16:04:07 +0100
Message-ID: <20261118150118.063520465@linuxfoundation.org>
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
index 9f14ab48eef3e..723eb64fc7932 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -225,14 +225,14 @@ static int btf_parse_hdr(struct btf *btf)
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



