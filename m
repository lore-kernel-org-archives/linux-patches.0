Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062884;
	b=if5tXiBLclmjK/K81L4VRIzSxT2srFk3aB+m15Eg3AZbygiUHg6hYqVnhN/qfwxDNe3k
	 LCkbbuSYJK//wpxzSniWMybDOATwF6b+e6wnWIo1SS3sITAEOex9CYZeVjwlo9i4ewIuL
	 fxTTawkoxnNfq4KXF37uxtjiVS1PDK0GlS7V0xqWARuIylNdXjiUTeh1rsnViQyx/bS8h
	 C9bd+gNRD0OeJnJrCk2KpVMwy79yRaQbVy7P/bk17MPK6Z2mtjfwfxG+JmTIw1YDWZ7LN
	 +vJE1etKueDZFb5ia+Eaae00wBCXFQNPRvdE3iIVo81NBTaMcuPwUVOfH5mkiFhs5lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hEyQr8f7kCCui8EkIcvLnNMtvtsGtzZy2dWEB39rgPM=;
	b=FoeR6T0ZrFo1k0EOUQFi1I04LaUPDspgt81GBeD/9/PBT91im1iEIGxvaqsxdn7ACR1V
	 h/KhaxuMgbvhP9seQz7st3GK6ss7uQ9xIxA7YTxxqaXM2kZv8UIqUJk02lIsWGd6/92sB
	 UztenaACAb4vjgnsqDjDucqScZbmpmGXr0PBOh8+ZHvKb9B825vH1eJ5ChrYw3k6YrfGC
	 SRzD6chklvk8JGuxa0lGRnxgxt+vtxV2SwtQdXlZbvMWPge6Z1esfTdrEh35xMBj6ddGi
	 /Gje/x3W8O3Bxqe2qnRyIBAAAO/mfw5GoiJK5WFL50fuMkgAW1Jl9XLZQjgXct4rOfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQto6TDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74B9606A32D;
	Sat,  7 Nov 2026 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQto6TDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945861F0089F;
	Sat,  7 Nov 2026 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062883;
	bh=hEyQr8f7kCCui8EkIcvLnNMtvtsGtzZy2dWEB39rgPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQto6TDcVz38mvFwOM11OUJifpQ7/zciVsb3UfAnVUHp8ffsg8Y+bTrF5p2rRcyJJ
	 IBKStoF8vIoxJwujE2MKhu+X2/mK4FlpREDD7K11Z6+punr03fDPQltb6OfYZxSSxG
	 gI/4mNDYR6nG4K3KtOn4x46jVoKsGIz4HZXfoPiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/869] lib/842: reject output overflows from index and short data
Date: Sat,  7 Nov 2026 08:46:50 -0500
Message-ID: <20261107134856.818740834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 38ed7182f3491ec1449ff246551e11ad82adba45 ]

The output length passed to sw842_decompress() is the caller's buffer
capacity. Indexed copies write 2, 4 or 8 bytes and short-data templates
write up to 7, but neither checks that capacity before writing and
decrementing p->olen.

Overwriting an undersized destination then underflows p->olen, which is
unsigned, so every later bounds check in the stream passes. Subsequent
operations keep writing past the destination, and a matching CRC lets
sw842_decompress() return success with an output length larger than the
capacity the caller supplied.

This is reachable through zram's compressed writeback path. With 842
selected, targeted corruption of the compressed data on its backing device
made a KASAN kernel report vmalloc-out-of-bounds writes in __do_index() and
sw842_decompress() when zram read the page back.

Check the remaining output before both operations and return -ENOSPC,
matching the other output-producing templates.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/842/842_decompress.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 582085ef8b49c..87d1e0f8a4926 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -165,6 +165,9 @@ static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
 	u64 index, offset, total = round_down(p->out - p->ostart, 8);
 	int ret;
 
+	if (size > p->olen)
+		return -ENOSPC;
+
 	ret = next_bits(p, &index, bits);
 	if (ret)
 		return ret;
@@ -344,6 +347,8 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 
 			if (!bytes || bytes > SHORT_DATA_BITS_MAX)
 				return -EINVAL;
+			if (bytes > p.olen)
+				return -ENOSPC;
 
 			while (bytes-- > 0) {
 				ret = next_bits(&p, &tmp, 8);
-- 
2.53.0



