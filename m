Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6474D2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6A4C433C8;
	Wed, 20 Sep 2023 12:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211285;
	bh=l6bLvtopecGIxG9goFVE60FvhMW5RXlGdMStFdnzAUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gJk3S7pTR6C1VwNzeeBhBXPHGjk3REqzoqr40MsYmjy0GWrvBl0bZ6fyBvTUkCJr
	 4dhWIAN1THae3GBA++2U2BiwKB0Gz2Jv2S+VuKt1l/48fvP36OneLUk5yt2l39zKgV
	 /65sC3ju8ryEZKrp72zyzZEscWZlJ8gOP52ea+Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 036/186] fs: Fix error checking for d_hash_and_lookup()
Date: Wed, 20 Sep 2023 13:28:59 +0200
Message-ID: <20230920112838.254962816@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
index a8c36363e6b1e..b6de8f0a16077 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2615,7 +2615,7 @@ int path_pts(struct path *path)
 	this.name = "pts";
 	this.len = 3;
 	child = d_hash_and_lookup(parent, &this);
-	if (!child)
+	if (IS_ERR_OR_NULL(child))
 		return -ENOENT;
 
 	path->dentry = child;
-- 
2.40.1



