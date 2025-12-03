Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A580235C19C;
	Wed,  3 Dec 2025 16:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779145; cv=none; b=PfMuDhUsES4T7uv1tCXjWWNLeVq29USIvqaKGStFab6Q232s16X9JCpquh+95G16BN2MFVNU68gOHndbN6n+VbQ8Z6mvaZ+w1uBSRtx0A51TyhZA3/RhP1NBoifNy2kYtp7LI10HrcTboyANr0d0acqTCe4q52ocr0RmH5yNo7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779145; c=relaxed/simple;
	bh=p79TINPoyWyEXr7eTEDGYUjd02snDnkXHayUbm8NpGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsmvGLFNLVahjYArf7bYufTIpYbLadXA6SjCqVsBMPN2e6DEK01W9KKdl0cqPknEwz3hJ3JMmK8jKkmCyUYm/ImCnkNTUOVRJ0O8+sGt1qTJN1yUHq63l0toC3QbHioAhHfBvPZ9cnblHfLUhGcglhUvd8OROHQuucPdSKi60kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwAYtdAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwAYtdAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183FBC116C6;
	Wed,  3 Dec 2025 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779145;
	bh=p79TINPoyWyEXr7eTEDGYUjd02snDnkXHayUbm8NpGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwAYtdAi+YkkEg4ONKMKUWeHHEPaaO1qciw86+v0gL44LW0UH5zeaFLAHtTnPBIFf
	 1+m1dmm8MpN7MfPyXkvDICQZKazvipYolluATT5hFEyBbYVeFL+93wIpgCZP68/sLo
	 WK283aIgCLAUECAHnyOXqqE4qCUVzxCPbPxV7ZfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/568] rds: Fix endianness annotation for RDS_MPATH_HASH
Date: Wed,  3 Dec 2025 16:22:49 +0100
Message-ID: <20251203152446.840140464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



