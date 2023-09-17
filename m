Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDB46FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB39FC433C7;
	Sun, 17 Sep 2023 19:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978472;
	bh=myNBlNjYzErbhjQi7ahhiMO/Fa8MQ1MnQmx81g4pfiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOo2TH+CndlYGAne9oiXUIxj12Jke0GnEjf0Qynlkr+aNpScZuDgl5HBqHoMvO2R2
	 tilaHqZDc4WV/ZaUIHDzwD0UrsK6eX18KKSDIWRx71i5pms5RVLLvvPRRyL5z/+d+u
	 mPmGAP0SpMTokhf0HGCnT8KlsKkt39iDciSKRXnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/406] fs: Fix error checking for d_hash_and_lookup()
Date: Sun, 17 Sep 2023 21:08:42 +0200
Message-ID: <20230917191102.932642506@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bc5e633a5954e..3ff954a2bbd1d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2640,7 +2640,7 @@ int path_pts(struct path *path)
 	dput(path->dentry);
 	path->dentry = parent;
 	child = d_hash_and_lookup(parent, &this);
-	if (!child)
+	if (IS_ERR_OR_NULL(child))
 		return -ENOENT;
 
 	path->dentry = child;
-- 
2.40.1



