Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A78146D57A;
	Tue, 21 Jul 2026 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672157; cv=none; b=OEFCs3lleMsPaBepqWKTx5gOVD6TSEtGZGXYaK0gqSM0NVdu4Jdz2D2lG3ABsyW930+qEhUS49y0Lkj/awCJ3eGyuvMlPFOOwxsKdADR9C/LqiwMvmToYm+pUr8zCUPcKDyv05dw+VDQQbeGX910PsByOpAdlh6V7d00iitU1jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672157; c=relaxed/simple;
	bh=L5gMPrVoYaBsoMhZ3Kg6kTgtCmek8ArGjUt2l98g95M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjLv5OpJUPrLSd9Z5U2Wy1Z9C9wLktoDJ91fvW9LU2bxIuWg73rDISgryxRSR6RiE4UpIKlmY9X9wAwcGh8J3AcRAzdPW8+lg6SjNviF4UtoT4hOHWkbxMXHC0SAI68FbtoZwb2sjPEaRQDyZ9P2eNLyYWcreFhdyj2HK1ae9r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tridhvS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tridhvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7511F000E9;
	Tue, 21 Jul 2026 22:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672155;
	bh=afuhaDq4tj+o+xeTLZ8aXfC1HqN+t9GJ2lTV4GMqxXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tridhvSzq33TdazQ2Rs68oVedDc6TpxrK3PcqMC399GD4BC4jdpcjSUfO7rHrov5
	 vTxmv4V+DSsWJAM6ldCT9zSt4uPwLoi0eR6kqFPn+vkI5D/mMjhhRuFQpdPHLmsbTW
	 /9fDcvYnhx4HkUBdApkK7bc4ZsEaJfGfpDH0/1qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 518/843] gue: validate REMCSUM private option length
Date: Tue, 21 Jul 2026 17:22:33 +0200
Message-ID: <20260721152417.683349063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e42402f180b75a..e5246d5d3e87d1 100644
--- a/include/net/gue.h
+++ b/include/net/gue.h
@@ -77,7 +77,7 @@ static inline size_t guehdr_flags_len(__be16 flags)
 
 static inline size_t guehdr_priv_flags_len(__be32 flags)
 {
-	return 0;
+	return (flags & GUE_PFLAG_REMCSUM) ? GUE_PLEN_REMCSUM : 0;
 }
 
 /* Validate standard and private flags. Returns non-zero (meaning invalid)
-- 
2.53.0



