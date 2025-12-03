Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0C734B40E;
	Wed,  3 Dec 2025 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777693; cv=none; b=b2JEV0UpF7oXtcs5yP0W5qr0Ej0SRltUcOX2zrcp5nAGMVNlrK31fPe9sGLiCtCGzFSihd2XcuuGLompecIADoc9zSmh/7ds0u7CGGTi7RZozB+0lsJYg8qhc8hkMreOZwboJcEDJgoK285QdmEozqDyKStHFFdXASsejawOkHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777693; c=relaxed/simple;
	bh=PjoVhRFruOmVTEs0OxGNNQVdQzIqzvVHNTh3k8kobAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRG6CddI8lfv25Y8NGMezvPd3n1VOUcZe+5ieTpsLNpEwkB+BAl5zmGysLldvWXdIw9TbBxxQjvZjmomosXpwdLu4xz9cnyNKlkuAW2EIZo6Kr4qJLvKb68pKA3qzbV5cTiGnM/1p3IZ6aDAavygV0aE89DjsbYdc0YPVMZISCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJu7rDN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJu7rDN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C122C4CEF5;
	Wed,  3 Dec 2025 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777692;
	bh=PjoVhRFruOmVTEs0OxGNNQVdQzIqzvVHNTh3k8kobAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJu7rDN/sDFlCbV7WToauqeZ6ojXrygjvg1W2t/5GWmcf6hkrn/KR2y8s15obexQb
	 Euaz6jTIKng4rTfZVECl2cMSrZbt8ClPmoSXyDRnC0q/x4yHC0F2SCUxdIBZeiEhsz
	 SySM1Kn/gpBvrXmVrl46hX+7xmjMcpb8qMyDehFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/392] rds: Fix endianness annotation for RDS_MPATH_HASH
Date: Wed,  3 Dec 2025 16:24:26 +0100
Message-ID: <20251203152418.365515351@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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



