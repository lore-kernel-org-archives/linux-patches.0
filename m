Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EA51F8926;
	Tue,  3 Dec 2024 15:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240766; cv=none; b=TP81vhadnv7mr7UxLaGFFm8cggRE3L7TvlL05GHyNO3p8wKKg3I+5GFKCzC73keN+Hc3wE0iczaOS1J+j40//uKPYGq6JnGayw8gVVkA5BTkA4Dlu3dhuyi6cRuQQCtMHEFYJOo3hk1KKXjPAO09PZbzAv1vNeLRliLW5SsDzwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240766; c=relaxed/simple;
	bh=5rJh/ZeeMQdgZ+w+LgAAZvXZrfr8c5gEGlAexdyioNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnY2khhwwh+nYmHrTkoOTJbJeeit+go8brCll8VudwO8m24XrMQ0wNLwaow2CYLo2BZa02YeDU3k7SggLEsIlKQ/9WrzenSxCICdAXAetnJBSIND0u85Y4iTFOVPK0glt0keHl2/xzpNBzZDDZjMUQ7d2pQUUfRqpWfDV+JcwsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvccMvxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvccMvxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3CBC4CED6;
	Tue,  3 Dec 2024 15:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240766;
	bh=5rJh/ZeeMQdgZ+w+LgAAZvXZrfr8c5gEGlAexdyioNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvccMvxSMO4K69ApcahgXfmN6hYJmks4Cfc3goCk0WG90dotxiFGd9+rNCLkXz+9J
	 iwgwBGPRw8DNRQ4WVbF/hICpbag0z1AhmrKcpKyrtX6vFpZLVZBKNQGKS52tSQBZNe
	 WKaalYrPXnJF/kHNxazlWgMsiUUPLblVkK90QJrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/826] wifi: ath12k: fix one more memcpy size error
Date: Tue,  3 Dec 2024 15:39:15 +0100
Message-ID: <20241203144752.631636405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 19c23eb61fa4c802e6e0aaf74d6f7dcbe99f0ba3 ]

A previous patch addressed a fortified-memcpy warning on older compilers,
but there is still a warning on gcc-14 in some configurations:

In file included from include/linux/string.h:390,
                 from drivers/net/wireless/ath/ath12k/wow.c:7:
drivers/net/wireless/ath/ath12k/wow.c: In function 'ath12k_wow_convert_8023_to_80211.isra':
include/linux/fortify-string.h:114:33: error: '__builtin_memcpy' accessing 18446744073709551610 or more bytes at offsets 0 and 0 overlaps 9223372036854775797 bytes at offset -9223372036854775803 [-Werror=restrict]
include/linux/fortify-string.h:679:26: note: in expansion of macro '__fortify_memcpy_chk'
  679 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath12k/wow.c:199:25: note: in expansion of macro 'memcpy'
  199 |                         memcpy(pat + a3_ofs - pkt_ofs,
      |                         ^~~~~~

Address this the same way as the other two, using size_add().

Fixes: b49991d83bba ("wifi: ath12k: fix build vs old compiler")
Fixes: 4a3c212eee0e ("wifi: ath12k: add basic WoW functionalities")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241004095420.637091-1-arnd@kernel.org
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wow.c b/drivers/net/wireless/ath/ath12k/wow.c
index 9b8684abbe40a..3624180b25b97 100644
--- a/drivers/net/wireless/ath/ath12k/wow.c
+++ b/drivers/net/wireless/ath/ath12k/wow.c
@@ -191,7 +191,7 @@ ath12k_wow_convert_8023_to_80211(struct ath12k *ar,
 			memcpy(bytemask, eth_bytemask, eth_pat_len);
 
 			pat_len = eth_pat_len;
-		} else if (eth_pkt_ofs + eth_pat_len < prot_ofs) {
+		} else if (size_add(eth_pkt_ofs, eth_pat_len) < prot_ofs) {
 			memcpy(pat, eth_pat, ETH_ALEN - eth_pkt_ofs);
 			memcpy(bytemask, eth_bytemask, ETH_ALEN - eth_pkt_ofs);
 
-- 
2.43.0



