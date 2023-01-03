Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FC5138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE2BC433D2;
	Tue,  3 Jan 2023 08:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733703;
	bh=XpAGoLewnm7MeVeyKWencPk7gX+0WahjPFWDLbjShzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IO7DG7dZVk7VjCZRNBdY5EY+livmvRbHj6P1hQ3nw/i0PFGTYhIaanHFFQXni92w
	 pW6ien7mXbkiHYGGTD/SIsu3qvKfJGIf0/Lb4GkB+okknAE6TMt5iCe/KqPrC/6yII
	 pflSOPDS9+NPSzg+s9fH94ryfigFxhDO1YcwtLjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 05/63] fix handling of nd->depth on LOOKUP_CACHED failures in try_to_unlazy*
Date: Tue,  3 Jan 2023 09:13:35 +0100
Message-Id: <20230103081308.881654061@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit eacd9aa8cedeb412842c7b339adbaa0477fdd5ad ]

After switching to non-RCU mode, we want nd->depth to match the number
of entries in nd->stack[] that need eventual path_put().
legitimize_links() takes care of that on failures; unfortunately,
failure exits added for LOOKUP_CACHED do not.

We could add the logics for that into those failure exits, both in
try_to_unlazy() and in try_to_unlazy_next(), but since both checks
are immediately followed by legitimize_links() and there's no calls
of legitimize_links() other than those two...  It's easier to
move the check (and required handling of nd->depth on failure) into
legitimize_links() itself.

[caught by Jens: ... and since we are zeroing ->depth here, we need
to do drop_links() first]

Fixes: 6c6ec2b0a3e0 "fs: add support for LOOKUP_CACHED"
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -630,6 +630,11 @@ static inline bool legitimize_path(struc
 static bool legitimize_links(struct nameidata *nd)
 {
 	int i;
+	if (unlikely(nd->flags & LOOKUP_CACHED)) {
+		drop_links(nd);
+		nd->depth = 0;
+		return false;
+	}
 	for (i = 0; i < nd->depth; i++) {
 		struct saved *last = nd->stack + i;
 		if (unlikely(!legitimize_path(nd, &last->link, last->seq))) {
@@ -686,8 +691,6 @@ static bool try_to_unlazy(struct nameida
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 
 	nd->flags &= ~LOOKUP_RCU;
-	if (nd->flags & LOOKUP_CACHED)
-		goto out1;
 	if (unlikely(!legitimize_links(nd)))
 		goto out1;
 	if (unlikely(!legitimize_path(nd, &nd->path, nd->seq)))
@@ -724,8 +727,6 @@ static bool try_to_unlazy_next(struct na
 	BUG_ON(!(nd->flags & LOOKUP_RCU));
 
 	nd->flags &= ~LOOKUP_RCU;
-	if (nd->flags & LOOKUP_CACHED)
-		goto out2;
 	if (unlikely(!legitimize_links(nd)))
 		goto out2;
 	if (unlikely(!legitimize_mnt(nd->path.mnt, nd->m_seq)))


