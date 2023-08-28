Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4736311C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0090C433C8;
	Mon, 28 Aug 2023 10:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217864;
	bh=quZdhGmFBK+QKgGSM08v+juKr6bhDli2U+rexaepeqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBZinX+v6Ircsj5rKEAA1sb7KNnG68gwpvm0MZh46fs6KGp6xzkXd+727cCUZZvfG
	 E6aUJ6Zd9ADqdn+3ctyg+GlMwXX76jF/BGJLoFsQJ8qlAVgmEJEob/W8meOsvaOBF5
	 3jQ+f5OCE2wmHWZ+K8snUsYVY3ynrCBfq9HkXVOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 002/129] NFSv4: fix out path in __nfs4_get_acl_uncached
Date: Mon, 28 Aug 2023 12:11:21 +0200
Message-ID: <20230828101157.473736835@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit f4e89f1a6dab4c063fc1e823cc9dddc408ff40cf ]

Another highly rare error case when a page allocating loop (inside
__nfs4_get_acl_uncached, this time) is not properly unwound on error.
Since pages array is allocated being uninitialized, need to free only
lower array indices. NULL checks were useful before commit 62a1573fcf84
("NFSv4 fix acl retrieval over krb5i/krb5p mounts") when the array had
been initialized to zero on stack.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 62a1573fcf84 ("NFSv4 fix acl retrieval over krb5i/krb5p mounts")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 9faba2dac11dd..f16742b8e0e21 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6004,9 +6004,8 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf,
 out_ok:
 	ret = res.acl_len;
 out_free:
-	for (i = 0; i < npages; i++)
-		if (pages[i])
-			__free_page(pages[i]);
+	while (--i >= 0)
+		__free_page(pages[i]);
 	if (res.acl_scratch)
 		__free_page(res.acl_scratch);
 	kfree(pages);
-- 
2.40.1



