Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E38339B58;
	Tue, 11 Nov 2025 01:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823423; cv=none; b=scyAtq4xzal8sSJ8UvXFtQgVG6RNQXOdmaibdmpfExNB2iRknCKqSe1oKqi2/JM+YrETvSf4BFudHbeHrEI5gUboch+eJd2LY777q/mwTeY/ReoT8ZabttkK/kPSEmWBajpGM4y/24VnxPRfqRNxlGWN3Snvlu27Iw1rSSmOVng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823423; c=relaxed/simple;
	bh=b3uGZs5I2eaVzQ/lIs//+dm7tZukxalm0YuxtJ5562U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQWe+R1LA9RYwpIS5nh0YB0kdQBHghfeoXK/4byq1u17OCbohmEFPN203mVk0Ch3QGHgc7FPAxmXrvm3XExxPEHms44Z7NLrzkcixGe+hX4h78TJrSOuovth9idnVP0Z0M6suuIRhhXJjLbxtf6+PaUNu8Bq4A0bLkR2CyQsVmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZbAFhr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZbAFhr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B43C16AAE;
	Tue, 11 Nov 2025 01:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823423;
	bh=b3uGZs5I2eaVzQ/lIs//+dm7tZukxalm0YuxtJ5562U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZbAFhr0iQPRtxXLKF98WpUa5soW4LjqTeEUhYFqVWHtZuUURFYgZ17WyzAgzGQJL
	 iPDSrk+/rdsnwoDnFBHjjU3hg+0aCQIvMURPWr3oBoGHHfMO6Cve9o8w6Db8bN1fz0
	 oozwOzX2ilLZHjUvK/qUn3LzDJeZfn1XneSgExgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/565] rds: Fix endianness annotation for RDS_MPATH_HASH
Date: Tue, 11 Nov 2025 09:41:40 +0900
Message-ID: <20251111004532.400513890@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ujwal Kundur <ujwal.kundur@gmail.com>

[ Upstream commit 77907a068717fbefb25faf01fecca553aca6ccaa ]

jhash_1word accepts host endian inputs while rs_bound_port is a be16
value (sockaddr_in6.sin6_port). Use ntohs() for consistency.

Flagged by Sparse.

Signed-off-by: Ujwal Kundur <ujwal.kundur@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Link: https://patch.msgid.link/20250820175550.498-4-ujwal.kundur@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/rds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/rds.h b/net/rds/rds.h
index dc360252c5157..5b1c072e2e7ff 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -93,7 +93,7 @@ enum {
 
 /* Max number of multipaths per RDS connection. Must be a power of 2 */
 #define	RDS_MPATH_WORKERS	8
-#define	RDS_MPATH_HASH(rs, n) (jhash_1word((rs)->rs_bound_port, \
+#define	RDS_MPATH_HASH(rs, n) (jhash_1word(ntohs((rs)->rs_bound_port), \
 			       (rs)->rs_hash_initval) & ((n) - 1))
 
 #define IS_CANONICAL(laddr, faddr) (htonl(laddr) < htonl(faddr))
-- 
2.51.0



