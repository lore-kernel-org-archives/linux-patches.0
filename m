Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B2230FC30;
	Wed,  3 Dec 2025 15:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776139; cv=none; b=IbXspnCy6Od9RhGsz2r2l8srMR/UtKkhCuCCSWiKuzAV29vZowAbDOztzJB3U0y6TLkEFc58XArnvV26SDgpSE7ExL4x0eGQddhQnTdNKKvpCG1+256MolYfzb1tqnNKVHD7jF1VUTc9e7uBAbOH5u8l//vQeNPPBVyZvzjEF0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776139; c=relaxed/simple;
	bh=pTGCTSNInxJkjOw1dGGyk2KOP2yB92y5daEXKjpBDuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaGMmRazJXodvHqWEe0U5ZatGehF/k26+3Ju9Kvcb7UpslXPITEkKgfFcHZ59pF3hFzkjhULittz74l3X0ob9CI7U2r6+1F9gN2YSptPxq8rX+HFuYqH8gsRUVmkrtpcOMBFjFFVAKtj68urWaKta1d85eldNOuTaKfOZZ0ma9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsSk/Yzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsSk/Yzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4398FC4CEF5;
	Wed,  3 Dec 2025 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776139;
	bh=pTGCTSNInxJkjOw1dGGyk2KOP2yB92y5daEXKjpBDuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsSk/YzpFWe8jkmSp4vb9xN59feeWvrzGz8/s5UWtQNXbNjLv8cjWcJrQUAC6FmKw
	 7Ze1dQJVQASNrFvWkEUTfmYZnsyUae+VF0t9i1bZicGTbdBiZpCDYvd6KAgzFbNNmY
	 Cb6cNIf02s2zHWDLX4n7vOgLuCyC1ugOI3RVqpRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/300] rds: Fix endianness annotation for RDS_MPATH_HASH
Date: Wed,  3 Dec 2025 16:24:55 +0100
Message-ID: <20251203152403.994907401@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d35d1fc398076..1257867e85e4e 100644
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



