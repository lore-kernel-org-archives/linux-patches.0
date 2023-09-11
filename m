Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE1D1172A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADDAC433C8;
	Mon, 11 Sep 2023 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444752;
	bh=zLYoMdwExIzjF44ly5Ga5eyTEPyuvws7G4YZwsESzaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lNR1YgeugL4pcLwG7dwSd+DTjnb0p7SUjLzFNR+Jd/E00RgHrbImirRIyCn1iIKX
	 pXUl/KgUdC2XqeD/9mygiO//k3UEPytgz8jhK/4CJzGt5yQ1tVWaXcR05sRepeA321
	 5IfIAIqZU2drXpCtQ2qRhsJRQvV0AkNQp4qHFa8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/600] fs: Fix error checking for d_hash_and_lookup()
Date: Mon, 11 Sep 2023 15:42:16 +0200
Message-ID: <20230911134636.642156612@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Ming <machel@vivo.com>

[ Upstream commit 0d5a4f8f775ff990142cdc810a84eae078589d27 ]

The d_hash_and_lookup() function returns error pointers or NULL.
Most incorrect error checks were fixed, but the one in int path_pts()
was forgotten.

Fixes: eedf265aa003 ("devpts: Make each mount of devpts an independent filesystem.")
Signed-off-by: Wang Ming <machel@vivo.com>
Message-Id: <20230713120555.7025-1-machel@vivo.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5b3865ad9d052..4248647f1ab24 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2859,7 +2859,7 @@ int path_pts(struct path *path)
 	dput(path->dentry);
 	path->dentry = parent;
 	child = d_hash_and_lookup(parent, &this);
-	if (!child)
+	if (IS_ERR_OR_NULL(child))
 		return -ENOENT;
 
 	path->dentry = child;
-- 
2.40.1



