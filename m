Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028398;
	b=bFZckrBPrz95nL40TGhyEa1O9/bn4l9xJFEmZ/FzPb5oJ34c3ML7CikU0KnR6F9+gEbt
	 i+/AxKpFnPYAepMg7s196BQ7BXhG7b1uyZoPt8TGLNuU2udCt2sx06xPWEIaFYAWV4EGN
	 rVuB4UwjVzZtE9hgTg8bWygi7fvsYLnrWeqIoHSkTKUirgeIh3w4aXTMO6/GT0ZHx2ix5
	 5uoYSijLd/XtVVJ6uxDLC1cn/uAnqby1mTKmiPUKnNChPqSuVJNGxO75Z20T9gZeybUji
	 aFhCzizztfPABmUAlIuGPmo46pxnu0vmDpfzfsTC5sL2/3nZcNZZFb7EWmvX/2sA/Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NLET59Qlq8EnekCaDEXVhERdc+UuA/dGlcoEU/lhH5k=;
	b=oVldhboz27XvleFn8kGdm6ND+d56BodRIcWAIoACbWfYWyrQpvHNK3NrN4z/rddlWIPB
	 Iwm1RzXkcQQOVmax4kpI6vhVNv7MOH99amIrmRNQ54WTLSSgW2eLBaUeGwqLQQ0/dzRr4
	 PMldFjhjF4zNHW0wHN8ebgWcdl5tF++oV9w1S45lXgVcE1IWNiZ13FrKEFD8Izv92qD0z
	 qXmM/r4n9733WaXRJOSbTD6agavUUWXbHSde2lfpx4/iMo5Uv5BxbuGqPUOi3dbLYqMj1
	 BFr4i9s13hquvAV+Re5K9Kntic0VMcfhb/+FBtl5JQNSu4evRHl5vIfzkwjrckRdkFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IOJmVR+0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8596C606A325;
	Wed, 18 Nov 2026 18:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IOJmVR+0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24511F000C4;
	Wed, 18 Nov 2026 18:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028398;
	bh=NLET59Qlq8EnekCaDEXVhERdc+UuA/dGlcoEU/lhH5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOJmVR+0y5w47YAvUjUqzxTx93cfCBMJ1l37D/fWQOvWrfGz9ECuy82mPZkOv1zhl
	 x0qH8Eqp2zGFXsgTq/sT4S95XaINfR2DWhEvz7qJ8VHb+joRSbIgr2mRKzOU1DeWyP
	 tG+1Xp+5q5HDjdwzcq4gsypzqrYMp0F3kzPCBCF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <almagui@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2129/2151] libbpf: fix cross-endian build with newer libbpf
Date: Wed, 18 Nov 2026 16:04:24 +0100
Message-ID: <20261118150239.238435032@linuxfoundation.org>
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
index 7f3b23aeaaba7..4b0e99f6f5ce9 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -229,14 +229,14 @@ static int btf_parse_hdr(struct btf *btf)
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



