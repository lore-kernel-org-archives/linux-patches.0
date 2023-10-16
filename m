Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF1812B6D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuSqswxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7265C433C8;
	Mon, 16 Oct 2023 08:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445922;
	bh=fcEiLCK8wCu2jmyoKs3DdP4OnRLFN9SBZj4QoG+fdvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuSqswxYUrhjx7Mu4NOANTLBwLmlvhkXWUYDatJJXzRGSz35fiBFIF01LE4YnIK1x
	 ECJBVZ43cN238A6aezemYq2USNLr65MNeWkbyC2G2KjKmYNv818CYYtFixJ70AzD+C
	 vsrCM+iWd47DAnjDTWwSk74Rj0jhE6sZV0rOuf3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Nils Hoppmann <niho@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/102] net/smc: Fix pos miscalculation in statistics
Date: Mon, 16 Oct 2023 10:40:37 +0200
Message-ID: <20231016083954.716989104@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nils Hoppmann <niho@linux.ibm.com>

[ Upstream commit a950a5921db450c74212327f69950ff03419483a ]

SMC_STAT_PAYLOAD_SUB(_smc_stats, _tech, key, _len, _rc) will calculate
wrong bucket positions for payloads of exactly 4096 bytes and
(1 << (m + 12)) bytes, with m == SMC_BUF_MAX - 1.

Intended bucket distribution:
Assume l == size of payload, m == SMC_BUF_MAX - 1.

Bucket 0                : 0 < l <= 2^13
Bucket n, 1 <= n <= m-1 : 2^(n+12) < l <= 2^(n+13)
Bucket m                : l > 2^(m+12)

Current solution:
_pos = fls64((l) >> 13)
[...]
_pos = (_pos < m) ? ((l == 1 << (_pos + 12)) ? _pos - 1 : _pos) : m

For l == 4096, _pos == -1, but should be _pos == 0.
For l == (1 << (m + 12)), _pos == m, but should be _pos == m - 1.

In order to avoid special treatment of these corner cases, the
calculation is adjusted. The new solution first subtracts the length by
one, and then calculates the correct bucket by shifting accordingly,
i.e. _pos = fls64((l - 1) >> 13), l > 0.
This not only fixes the issues named above, but also makes the whole
bucket assignment easier to follow.

Same is done for SMC_STAT_RMB_SIZE_SUB(_smc_stats, _tech, k, _len),
where the calculation of the bucket position is similar to the one
named above.

Fixes: e0e4b8fa5338 ("net/smc: Add SMC statistics support")
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Nils Hoppmann <niho@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_stats.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_stats.h b/net/smc/smc_stats.h
index 84b7ecd8c05ca..415131a975b11 100644
--- a/net/smc/smc_stats.h
+++ b/net/smc/smc_stats.h
@@ -93,13 +93,14 @@ do { \
 	typeof(_smc_stats) stats = (_smc_stats); \
 	typeof(_tech) t = (_tech); \
 	typeof(_len) l = (_len); \
-	int _pos = fls64((l) >> 13); \
+	int _pos; \
 	typeof(_rc) r = (_rc); \
 	int m = SMC_BUF_MAX - 1; \
 	this_cpu_inc((*stats).smc[t].key ## _cnt); \
-	if (r <= 0) \
+	if (r <= 0 || l <= 0) \
 		break; \
-	_pos = (_pos < m) ? ((l == 1 << (_pos + 12)) ? _pos - 1 : _pos) : m; \
+	_pos = fls64((l - 1) >> 13); \
+	_pos = (_pos <= m) ? _pos : m; \
 	this_cpu_inc((*stats).smc[t].key ## _pd.buf[_pos]); \
 	this_cpu_add((*stats).smc[t].key ## _bytes, r); \
 } \
@@ -139,9 +140,12 @@ while (0)
 do { \
 	typeof(_len) _l = (_len); \
 	typeof(_tech) t = (_tech); \
-	int _pos = fls((_l) >> 13); \
+	int _pos; \
 	int m = SMC_BUF_MAX - 1; \
-	_pos = (_pos < m) ? ((_l == 1 << (_pos + 12)) ? _pos - 1 : _pos) : m; \
+	if (_l <= 0) \
+		break; \
+	_pos = fls((_l - 1) >> 13); \
+	_pos = (_pos <= m) ? _pos : m; \
 	this_cpu_inc((*(_smc_stats)).smc[t].k ## _rmbsize.buf[_pos]); \
 } \
 while (0)
-- 
2.40.1



