Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BE43491D0;
	Fri, 21 Nov 2025 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732553; cv=none; b=OTH0w8mW5wXAwdUdKYtWhPr64vGPZE6MT82Z38Pk9qQGS5KBcHLphMpbYLVMCpegr5K+7O/Ln0IIw+pFtzltnQZD1uHdmyqY9Q8H/l90sMvwp5pzUuG5eP0X6D/w4X+oHjhJsYQpkhsRrrvBikfeuNfK6w8LS2gMKysqcSD6Cos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732553; c=relaxed/simple;
	bh=tdjDk6EkKJpi8/Mo5dwYEWNRFGxz/JUX7YLDL/FiI24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC2ZUiifUheyo5s00Vq/2yi6dGtkTpgclixxVxwF3cTK5HIAhGb1VqsM5Snv+v5y3i/csvSLsc2cOBTHXa9roDIIeT72KvuNJIICSH9p8zvKSzZUXK6OkL+RNBNYqdcaBFZ5pXDHMqcfd7zzOIwevLtoGr/R385/HYQzpkZbGiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9dqrsQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9dqrsQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2175C4CEF1;
	Fri, 21 Nov 2025 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732553;
	bh=tdjDk6EkKJpi8/Mo5dwYEWNRFGxz/JUX7YLDL/FiI24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9dqrsQChX2NIwUX5NKEozVMcBtuM9Se2abedqAiFhe6IxNyZZYUYDEcTfOAQBbXi
	 Ys7gHvkvMQBuC1gFUexxfUp03NqdX66igzYAuVu3sci6QLczSP+bCrO+5dbMlT1CYG
	 AbRqB5SyWelinDttEilDdHAn5pct6U1aEsVnT3Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/529] rds: Fix endianness annotation for RDS_MPATH_HASH
Date: Fri, 21 Nov 2025 14:07:39 +0100
Message-ID: <20251121130236.713845930@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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



