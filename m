Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062277;
	b=el9cFSIKGp/BUB99JC5+UYO2Q/eqwuMytf2PItAkPNb4mTwJfC5zwMKJplEJOJ8qdZS/
	 GkmzEJtDrtCFbo2qdefrDM9Ln7yZQRX8ikil9bMw3kGkV/FhWmcQpzyuCWDokPb23sOWs
	 HngCqjonb+tpLO7xqIkyQc1W6NiIuMRHteMVOHKe9buX4C+bnh5yq9p05eeqgVy/KfN3Z
	 zz5138BmaN9ZBzNV5djEeh/3dPYTE2TRCcrP/knPn2HHnepbGxrVArys9OaCFVes5Ztue
	 mhD+AyaGYCRuFbPVfPKQa4AnR+I6dHX9BLz77805Qlbc+S4kvzQ2Dz5rymhNgaHl1Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uzcPKpHuL+wIX4xyprYZFmv945NG4/qnUiwQkruQLM4=;
	b=V5jlO35cqgx0gHVeJD5v76ju8GdTRvJBIplhA1C0gJmD+z3ZONfYAndj9gMmLdzTgkLw
	 L4nO1as1TxSbALGr1RrlVLsefO2anvXjHTDoscyiJThopUEGem90hrpiBr5HG2WCp5aph
	 v978FUm7RxX6LT6fuCdYBSjchIGps70Y6B0XhM3wiGULy9giivOhqZhC/dVYtPbd9syug
	 RHzlfZCvwXWThg9CuzgsxfZRlo9eVuyG+6whEelnKOh8gT2hF/9Se6XOWNF02nJC8B67y
	 NySfJP0gKPuCpq4OGBmF2gUno7gDMDHMcJf2YZCzYomaHT6X/ldDbF9cgyY9AeyNrKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e8vW+xQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBF8606A325;
	Thu, 19 Nov 2026 04:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e8vW+xQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D148B1F000C4;
	Thu, 19 Nov 2026 04:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062277;
	bh=uzcPKpHuL+wIX4xyprYZFmv945NG4/qnUiwQkruQLM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8vW+xQUUI4I1kY/UsxGUyQMJOMgkI/1x6vI/7K7DIrESqdFezVz70FRrFxBN9LLh
	 O3xxBTVZZ8Lw2SeezwKrzzyWe8EEYkFeAwCRCBWVVwZoeJgA1IiNfewQG04lapcewq
	 i+QuiMmV6OcHGkkEpGVUAzeTIpW19DsfNF5wRh8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <almagui@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1824/1848] libbpf: fix cross-endian build with newer libbpf
Date: Wed, 18 Nov 2026 16:04:22 +0100
Message-ID: <20261118150036.033545785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f7c48b1fb3a05..25bd1dfeb8059 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -191,14 +191,14 @@ static int btf_parse_hdr(struct btf *btf)
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



