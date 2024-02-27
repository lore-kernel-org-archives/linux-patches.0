Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F413AA4C;
	Tue, 27 Feb 2024 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042102; cv=none; b=hW4yXcJbjHGN5xX2HCmCWTfEQ1AJw1uYEEtyhEp56yeNYXR4uc5V1sz8lT9P0/xFdqrldXOFwobzl88n3VH7oEKbfWY1cgeh9xzYmUXEo4TxgnKluEQ8gL3uRyLd5H60WIzbUEXTJHxp3AGpSWXV4Rrxb/DbVLvoGVhdrVn0ZXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042102; c=relaxed/simple;
	bh=DfZgH3Rbj/ZDj1I0ib7167oE8aKmwzz3x8ecXr9YmAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=patjx7I0gDSdy3Vdseo6ms7UBGApLAFLqWQi1MgOkNh3+oZFSfpk4pA2VDomQqFx+eXJizaEGgCqBR/y5t6z6y7ojQ+x+tLpaRzsmp+S01qt4CuiZyoY6b/Tyj9FGuqk5QtzXzW5IzyrTB7kJHt3X+vml2k5xBQBofwX/5qV78E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2K0aN6G5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2K0aN6G5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E171C433C7;
	Tue, 27 Feb 2024 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042101;
	bh=DfZgH3Rbj/ZDj1I0ib7167oE8aKmwzz3x8ecXr9YmAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2K0aN6G5PX6ftYF9exMf1vzsQCnMY8ntuWjKTyaQnU5NLw8LzbfN/xU+Irb6Ev0Ka
	 WltSSqiCKBgROma2AJmIcYkfu4rWy+eqpSBR4n4WIeMOYJ/U37HuBA/HfHuwS4Q5ef
	 Xjapu//NhnE29QXl5t264Nq3ePgRg5VZQtC87WcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandeep Dhavale <dhavale@google.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.6 179/299] erofs: fix refcount on the metabuf used for inode lookup
Date: Tue, 27 Feb 2024 14:24:50 +0100
Message-ID: <20240227131631.598850593@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandeep Dhavale <dhavale@google.com>

commit 56ee7db31187dc36d501622cb5f1415e88e01c2a upstream.

In erofs_find_target_block() when erofs_dirnamecmp() returns 0,
we do not assign the target metabuf. This causes the caller
erofs_namei()'s erofs_put_metabuf() at the end to be not effective
leaving the refcount on the page.
As the page from metabuf (buf->page) is never put, such page cannot be
migrated or reclaimed. Fix it now by putting the metabuf from
previous loop and assigning the current metabuf to target before
returning so caller erofs_namei() can do the final put as it was
intended.

Fixes: 500edd095648 ("erofs: use meta buffers for inode lookup")
Cc: <stable@vger.kernel.org> # 5.18+
Signed-off-by: Sandeep Dhavale <dhavale@google.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20240221210348.3667795-1-dhavale@google.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/namei.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/erofs/namei.c
+++ b/fs/erofs/namei.c
@@ -130,24 +130,24 @@ static void *erofs_find_target_block(str
 			/* string comparison without already matched prefix */
 			diff = erofs_dirnamecmp(name, &dname, &matched);
 
-			if (!diff) {
-				*_ndirents = 0;
-				goto out;
-			} else if (diff > 0) {
-				head = mid + 1;
-				startprfx = matched;
-
-				if (!IS_ERR(candidate))
-					erofs_put_metabuf(target);
-				*target = buf;
-				candidate = de;
-				*_ndirents = ndirents;
-			} else {
+			if (diff < 0) {
 				erofs_put_metabuf(&buf);
-
 				back = mid - 1;
 				endprfx = matched;
+				continue;
+			}
+
+			if (!IS_ERR(candidate))
+				erofs_put_metabuf(target);
+			*target = buf;
+			if (!diff) {
+				*_ndirents = 0;
+				return de;
 			}
+			head = mid + 1;
+			startprfx = matched;
+			candidate = de;
+			*_ndirents = ndirents;
 			continue;
 		}
 out:		/* free if the candidate is valid */


