Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68233B47E2;
	Tue, 21 Jul 2026 20:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666881; cv=none; b=J4/FU+7+WZwkmB/VyVYA8RxRPQKXfCn3JdXs4ahk7agaeYp1DTofiYfs7ztMNNY/jSslm7lpULHCtOpFh0LY/NvgTYyJRAMYOxDngfRmMP3sNmV5g2QZTHu/SnM1HaN2rYCv+UekRVIQBqGB+oA/RhWLKyjVT+66fhHIbQD7CMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666881; c=relaxed/simple;
	bh=bvNKd+EA87v0euqQrj7xteVpha0BEpzl+6rI8NaJCDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQzyVEgB4PDxeN5KiTeByUiXnrivFU9Da5xQ5RricnVNVHJjwgrBL6riyilAETyw2vpARvgpVGlv/zKBONIOPJoiaMsASYRw79TJz87Ih7Rrip/W7ZP1b27BQBnQSbvuROqZsClNbkJmad/63G3fENPk3+kXZ/8mCPUp73OEguw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGOnUdmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGOnUdmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B84D1F000E9;
	Tue, 21 Jul 2026 20:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666877;
	bh=K+p/r9qRg1DsRk40XrhBJz3ZZm7WkikMYL9UPlSI2Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGOnUdmV53UuunfJaLzjeYwaVVKPB+EANraYbpBFoY3ZgOYOYAhbVIKWYPOhe4+ku
	 V+6k9UifkALXfAg/GYDXj/PrW84dcHvAbmTdBn/HcNGR4rwScIyAbX7umkc7tuA6a9
	 MmfvDffkDygxbv/HF3MkpdwhGFEqv1bmyuzVa3Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0849/1266] gue: validate REMCSUM private option length
Date: Tue, 21 Jul 2026 17:21:26 +0200
Message-ID: <20260721152500.854430694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit d335dcc6f521571d57117b8deeebc940836e5450 ]

GUE private flags can indicate that remote checksum offload metadata is
present. The private flags field itself is accounted for by
guehdr_flags_len(), but guehdr_priv_flags_len() currently returns 0 even
when GUE_PFLAG_REMCSUM is set.

This lets a packet with only the private flags field pass
validate_gue_flags(), after which gue_remcsum() and gue_gro_remcsum()
read the missing REMCSUM start/offset fields from the following bytes.

Account for GUE_PLEN_REMCSUM when GUE_PFLAG_REMCSUM is present so that
malformed packets are rejected during option validation.

Fixes: c1aa8347e73e ("gue: Protocol constants for remote checksum offload")
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/gue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/gue.h b/include/net/gue.h
index dfca298bec9ccd..caefd6da86939b 100644
--- a/include/net/gue.h
+++ b/include/net/gue.h
@@ -80,7 +80,7 @@ static inline size_t guehdr_flags_len(__be16 flags)
 
 static inline size_t guehdr_priv_flags_len(__be32 flags)
 {
-	return 0;
+	return (flags & GUE_PFLAG_REMCSUM) ? GUE_PLEN_REMCSUM : 0;
 }
 
 /* Validate standard and private flags. Returns non-zero (meaning invalid)
-- 
2.53.0



