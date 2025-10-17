Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B431330B29;
	Fri, 17 Oct 2025 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715889; cv=none; b=phsz3V4FcAe5v/cWttyE84Kf5kQVZfe6ft3gpfqwd1yxTVfcvhqZdZKzjNxTPZRA6XM7lIDqr5FB62K22SREBANI9v/JdLG/JTIsaZT6iYD7yQplwwEYxuerEYh50zWUxLHNxVJgVooYW4P19s+Oh4qzeddS3lPEmTFHEXWH5wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715889; c=relaxed/simple;
	bh=kfUZUg8I1NCaz9qppZ8EdQlm3BGu7jNKZgvJcK8aQaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uy20RTzTP15QIoWfbmdnV0YQQQRlDrXAiyhK41AHlG+ho4pRgTMG5Oj7r5IazIxn/c52GL4ozIIUCJvPSacvnC72n6PrfhId86cMjWGxCw+xfsYdCSms9j3cT/tWrydpLLl0GnN9KkVY14/Qallxl1yX834fmdt0z/9tBLwi24Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ewt/4fWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ewt/4fWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2915DC4CEE7;
	Fri, 17 Oct 2025 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715889;
	bh=kfUZUg8I1NCaz9qppZ8EdQlm3BGu7jNKZgvJcK8aQaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ewt/4fWQDgR9FhbT96PHNUHGQzfTy1TPLb38h/wm3bxCsK9glstA6PRH6nJTEsYCo
	 4bwy703bLIuhRlbY3DzztwCnXJ5XyYeVPqUaW+B2mS+nn7v1JZcIM8wr0JRdNijWKp
	 4tQIko1dTPsiNLgNuQL8aaOIHq4xEoHWYz+EnwH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 371/371] mount: handle NULL values in mnt_ns_release()
Date: Fri, 17 Oct 2025 16:55:46 +0200
Message-ID: <20251017145215.505418259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6c7ca6a02f8f9549a438a08a23c6327580ecf3d6 ]

When calling in listmount() mnt_ns_release() may be passed a NULL
pointer. Handle that case gracefully.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index fc4cbbefa70e2..c8c2376bb2424 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -180,7 +180,7 @@ static void mnt_ns_tree_add(struct mnt_namespace *ns)
 static void mnt_ns_release(struct mnt_namespace *ns)
 {
 	/* keep alive for {list,stat}mount() */
-	if (refcount_dec_and_test(&ns->passive)) {
+	if (ns && refcount_dec_and_test(&ns->passive)) {
 		fsnotify_mntns_delete(ns);
 		put_user_ns(ns->user_ns);
 		kfree(ns);
-- 
2.51.0



