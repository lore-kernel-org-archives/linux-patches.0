Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F1540099C;
	Tue, 21 Jul 2026 18:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658155; cv=none; b=F+x8XX1s+KQQgbBPMbNno4x6D6nA5NZ1B2mLXIWv7Ya0/Dspv7sSpv8PA7ExbjX3kvqnhBvysF7CAhz8sfFWZP1euZu1VvmZtRjURurvVi+yRdDgdXVAjxhAgPMCNVKOPD9bzD15GI79Fc6onbcA8NePhxHgtU0oa5XLUEyyBTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658155; c=relaxed/simple;
	bh=E7h3daCXqBgnpMJem2xbcC2zDWhLCY8Ucjg2E8z6CP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3naxgdWRD0c3mGGLHocflxMQeSPtRb6Dyht6PXj7OG6lAZkhDAMIumHuDFKVyLm5qk8dPLaNBXEx7Hyt5YKXxX9v/Lg94jcGcTjmfX49/6jqN1fadXqe9wXs7aRKFVqXr+msK4fIvD43s3BwcK5nKX4Vn6j5a8TBDP9Z22vJIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gcej7K0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gcej7K0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1481F000E9;
	Tue, 21 Jul 2026 18:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658153;
	bh=PQ91mxNdV3aiQBl0q0ZdbBZMqZHR3J58Qke9s8cQzxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gcej7K0od4rybLnd4AM2JMc2cxJ9ubUhH3e8o7400O9xMSDTVGdvlNpCuGK2BhA/U
	 gcXwKHLZMKBJqdAlTp95JNZFHZUWh3rqUZsa8Mg0rYO9S4ojxJ0bn6xaXCx+4eBV3+
	 vTUuUpxPix0PPBfHi8tDd6QNchrGMtXae2PzLNYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1037/1611] gue: validate REMCSUM private option length
Date: Tue, 21 Jul 2026 17:19:13 +0200
Message-ID: <20260721152538.727521483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



