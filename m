Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2178481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2DCC433D2;
	Fri, 10 Mar 2023 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457116;
	bh=oMLcx12sWEjXpPr5YpO+2Fz1fSNsEvWR0NIPbwauhtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKd4TcMydD0/6jdv2vYPj8m9/PcX5f1yElQn/ZC9ZDRaRpisbu4pSyjmC6M8o6i3U
	 RylnzotMZ3dLnTACTd/fz1sUToRWZAzA4HpLjAtcsa8g1UA3FkecRTpClyXH3VlSVt
	 jcsuIB1fYa/JHZQJ0En3y4vUcfh86cvmMSr2vgz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Hua <hucool.lihua@huawei.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/200] ubifs: Fix build errors as symbol undefined
Date: Fri, 10 Mar 2023 14:37:12 +0100
Message-Id: <20230310133717.818950885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Hua <hucool.lihua@huawei.com>

[ Upstream commit aa6d148e6d6270274e3d5a529b71c54cd329d17f ]

With CONFIG_UBIFS_FS_AUTHENTICATION not set, the compiler can assume that
ubifs_node_check_hash() is never true and drops the call to ubifs_bad_hash().
Is CONFIG_CC_OPTIMIZE_FOR_SIZE enabled this optimization does not happen anymore.

So When CONFIG_UBIFS_FS and CONFIG_CC_OPTIMIZE_FOR_SIZE is enabled but
CONFIG_UBIFS_FS_AUTHENTICATION is not set, the build errors is as followd:
    ERROR: modpost: "ubifs_bad_hash" [fs/ubifs/ubifs.ko] undefined!

Fix it by add no-op ubifs_bad_hash() for the CONFIG_UBIFS_FS_AUTHENTICATION=n case.

Fixes: 16a26b20d2af ("ubifs: authentication: Add hashes to index nodes")
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/ubifs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 478bbbb5382f8..2f1f315810949 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1623,8 +1623,13 @@ static inline int ubifs_check_hmac(const struct ubifs_info *c,
 	return crypto_memneq(expected, got, c->hmac_desc_len);
 }
 
+#ifdef CONFIG_UBIFS_FS_AUTHENTICATION
 void ubifs_bad_hash(const struct ubifs_info *c, const void *node,
 		    const u8 *hash, int lnum, int offs);
+#else
+static inline void ubifs_bad_hash(const struct ubifs_info *c, const void *node,
+				  const u8 *hash, int lnum, int offs) {};
+#endif
 
 int __ubifs_node_check_hash(const struct ubifs_info *c, const void *buf,
 			  const u8 *expected);
-- 
2.39.2



