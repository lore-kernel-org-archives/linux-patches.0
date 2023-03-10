Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC631881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498BBC433D2;
	Fri, 10 Mar 2023 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459320;
	bh=InlbkbX+wtDS4QLYAiNLPCJhLq6mvELIdi9vLKREqQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GegeYPz5lREAHqAT+M+ClXiJ8IJgUkRa9Cp9pZAdy0Gq9BL7IuPoxR5+O22TUAV8B
	 SMmrs/D/W7KhJpdUGuflTC8B9VFLRDn0tQzu+Qd3M+9Myi46OdRiZKN5y0ThucNOee
	 4+1y/Ou3SJbmjD7o8+i+WariofSh7wYH5QONYudE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Hua <hucool.lihua@huawei.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 292/357] ubifs: Fix build errors as symbol undefined
Date: Fri, 10 Mar 2023 14:39:41 +0100
Message-Id: <20230310133747.635018116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index b3b7e3576e980..85e84138649b5 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1593,8 +1593,13 @@ static inline int ubifs_check_hmac(const struct ubifs_info *c,
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



