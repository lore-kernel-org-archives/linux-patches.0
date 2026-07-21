Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988C03E49CF;
	Tue, 21 Jul 2026 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653701; cv=none; b=jXZqplBo2i5ZDQhTezMwmNVWiiQUtcOC5r9t+g0qOusKUCUl/ibxLz6rM4UlpZva55ptMMGVig3bF6giL/yN9P4u3JIVbS+PRWkZs8A1M34LkqR+tIvPOrJzavkJZ7A2bu9O0zn+BeDwe31YXBa2RlwkX93KjnaRicIvaCYCzHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653701; c=relaxed/simple;
	bh=2YVQ2VNZkCaZ+UnfjSeTcwwq44noqq488d7PJv2J4ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWvUKfXEmFuUGT97xqPTJ0JdVaOtjVa4D6ZF1XBdxC9Vs3Yh2yWFa5gKkLeap44gNDQpcM8nR3rZCtolbDM5KLXXV5pDD5aCUtJPOFQnbQNQTY8Pw5SfwdweJvQ0oVh+i4n7YQqzLvZcHEaaQQlDTdP/eEBEZjHggBCqUrMOUR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIAhH9mI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIAhH9mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC27D1F000E9;
	Tue, 21 Jul 2026 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653700;
	bh=CNKVmYdnl0FvObkkoMrmq9NHbqyAQbHONnOcNgysonM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIAhH9mI4F4ydf9+ByObcyQddMQQicxUVXwokkdb+7Y9fO50StXktlK0rDpVSqnW2
	 Yryx6ZBXIBv+NQSFUghqP6FEsaFNsVnPC7silzMkAOmgP//qa9M+ue4EwQbPwSmIaV
	 Dn7Q9MRdiWBWKkqzTFGIj1R/9+mN1Dyk6p0A/06M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1424/2077] gue: validate REMCSUM private option length
Date: Tue, 21 Jul 2026 17:18:17 +0200
Message-ID: <20260721152626.391389870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



