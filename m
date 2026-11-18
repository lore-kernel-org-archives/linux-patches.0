Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050797;
	b=qHVdll7WZn8bQVSmj4YFFTwV2l15YIMf61B/J/74kEO9JE1gI8RH5alZrQdrtCYSX5eV
	 deIAUVfc1QwLb0Qlxqc23yYynZPrvssIoQ6zbAxAnPRVRJK2hA1eTTRgLAcLpodVU+X/t
	 9xIoHsHzhtBzKxvTAMmJy6xQ0vL3oMxNW27iZXQB8iqE/eJdxz+ctqzG/JIv108dpC7Dr
	 1FW5ESNy6qWyUQfGx0Y92pRo15TKgvoW0Ifm9bH3vLPv295OAV6T8HjFnQ296kJ30lXW6
	 ouAWNixiium1LTfA1vXzzzmfisro41bWIM7pCbPxYUoj55eBI0tJm5Q1Yb4W01yYFbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F2ONbdvqmxeRVOAuberxaJcrbJ/65bvAFr6q8BYXbA8=;
	b=3tVZnVdovzmMWI1B5Fx/4rCohFAnCKnGScR77b1UqyuskysFx3Y65hRcSR6GVZpWKQ4n
	 abfGts7Mql1/eDx8SbB1TnH5qox12UnVK9OdAIRXTFuEdn+f73w/znF8ddabY30iXMd5q
	 YTakyr7P5UuhGpjEzVB3c6+IRrGDlS8v/lLCEJhWTLE60/QvajxUrizKhDwkCpGoeCRHS
	 UR01b0gFOuXEnkxXc5pzkvIEaHgEnk84eRn67kO72h2BzwjipIwipi6okzy7cub45WJla
	 k6WINf/kT31i7LTgU+F+/2Wg+NR2rQGJUKRZxw5A5rgUKte4uatRvLuFXhsmm16JwzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/x45mxi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A828E606A320;
	Thu, 19 Nov 2026 01:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/x45mxi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0356A1F000C4;
	Thu, 19 Nov 2026 01:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050797;
	bh=F2ONbdvqmxeRVOAuberxaJcrbJ/65bvAFr6q8BYXbA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/x45mxiIIGtbmovOQjgJXv+CH9h3lTwkVIKFUvEf1tS+EfmFHosPEKT+0EKIqFb1
	 U4E4hh1n3thTDMEFb9UgnnuabW2/3qr4b2qlzjDj1IlesZZlIiV0AK46ZMgdr1abNh
	 OYK/wjA3737fAZNQExSlumNN1AXziM8dyOvoS1l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <almagui@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2835/2857] libbpf: fix cross-endian build with newer libbpf
Date: Wed, 18 Nov 2026 16:04:29 +0100
Message-ID: <20261118150343.652613674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f7e3209d6c641..df3f001dfeec7 100644
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



