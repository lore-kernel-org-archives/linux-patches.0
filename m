Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057D4F9E8;
	Tue,  8 Jul 2025 16:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992863; cv=none; b=Byvc+afMCGgaK7Y1Hhco9J/2+LeuytZP2pOPye+WynzJ47zWGjsAeO4GwkWu4ESY2/WoDMLlHXiRY8YHVwD1hLJ5ks3uaxFvEqqaI/uj6NoyzM79t2rEaTUqweEy1NrSgc6BduJFgbxRgs8qzfxVhon5VVxlMMJN1csVQbM7pMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992863; c=relaxed/simple;
	bh=WMIIGcE1tpQW8o5cSLFlT+4qCveyIkUnXEF5XlY9uwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKGcmzvOV1qyPoA0BDZ25tdzkD6wv/vcqT3j2vamop1bAAGDY+mstKznkj/Y8rNliLhkI5FRiJlBTtOCZDuwwUg4XKnFCD0r4Jr28yUv33OBYmfRK6hCEf7dac8ivp65dimlUpChBMcAnKHdKvvQ1BX+bb/zg3iUST9vVmxLmY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kysFVVAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kysFVVAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850FEC4CEED;
	Tue,  8 Jul 2025 16:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992862;
	bh=WMIIGcE1tpQW8o5cSLFlT+4qCveyIkUnXEF5XlY9uwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kysFVVAqQJov7GoeeI+afU1fgZmFtvGgucuQA02XmE/Y66GajQx+BGLw8NJDWtcPA
	 xteJw7yvdwzQ64DI7Qa1XC6QzvU3x7zNrhQnsTwyOb4CSbG5k0ZzWYxlhqvVxK62tR
	 oXsNvfnYAyhIoa2BSMIk6LDUeUC6Oqit6WSfVn9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/232] gfs2: Replace GIF_DEFER_DELETE with GLF_DEFER_DELETE
Date: Tue,  8 Jul 2025 18:21:43 +0200
Message-ID: <20250708162244.239701983@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 3774f53d7f0b30a996eab4a1264611489b48f14c ]

Having this flag attached to the iopen glock instead of the inode is
much simpler; it eliminates a protential weird race in gfs2_try_evict().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c      | 6 ++++--
 fs/gfs2/incore.h     | 2 +-
 fs/gfs2/super.c      | 3 ++-
 fs/gfs2/trace_gfs2.h | 3 ++-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ec043aa71de8c..161fc76ed5b0e 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -994,15 +994,15 @@ static bool gfs2_try_evict(struct gfs2_glock *gl)
 		}
 	}
 	if (ip) {
-		set_bit(GIF_DEFER_DELETE, &ip->i_flags);
+		set_bit(GLF_DEFER_DELETE, &gl->gl_flags);
 		d_prune_aliases(&ip->i_inode);
 		iput(&ip->i_inode);
+		clear_bit(GLF_DEFER_DELETE, &gl->gl_flags);
 
 		/* If the inode was evicted, gl->gl_object will now be NULL. */
 		spin_lock(&gl->gl_lockref.lock);
 		ip = gl->gl_object;
 		if (ip) {
-			clear_bit(GIF_DEFER_DELETE, &ip->i_flags);
 			if (!igrab(&ip->i_inode))
 				ip = NULL;
 		}
@@ -2389,6 +2389,8 @@ static const char *gflags2str(char *buf, const struct gfs2_glock *gl)
 		*p++ = 'e';
 	if (test_bit(GLF_VERIFY_DELETE, gflags))
 		*p++ = 'E';
+	if (test_bit(GLF_DEFER_DELETE, gflags))
+		*p++ = 's';
 	*p = 0;
 	return buf;
 }
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index f6aee2c9b9118..142f61228d15e 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -331,6 +331,7 @@ enum {
 	GLF_TRY_TO_EVICT		= 17, /* iopen glocks only */
 	GLF_VERIFY_DELETE		= 18, /* iopen glocks only */
 	GLF_PENDING_REPLY		= 19,
+	GLF_DEFER_DELETE		= 20, /* iopen glocks only */
 };
 
 struct gfs2_glock {
@@ -377,7 +378,6 @@ enum {
 	GIF_SW_PAGED		= 3,
 	GIF_FREE_VFS_INODE      = 5,
 	GIF_GLOP_PENDING	= 6,
-	GIF_DEFER_DELETE	= 7,
 };
 
 struct gfs2_inode {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 6a0c0f3780b4c..d982db129b2b4 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1326,7 +1326,8 @@ static enum evict_behavior evict_should_delete(struct inode *inode,
 	if (unlikely(test_bit(GIF_ALLOC_FAILED, &ip->i_flags)))
 		goto should_delete;
 
-	if (test_bit(GIF_DEFER_DELETE, &ip->i_flags))
+	if (gfs2_holder_initialized(&ip->i_iopen_gh) &&
+	    test_bit(GLF_DEFER_DELETE, &ip->i_iopen_gh.gh_gl->gl_flags))
 		return EVICT_SHOULD_DEFER_DELETE;
 
 	/* Deletes should never happen under memory pressure anymore.  */
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 09121c2c198ba..43de603ab347e 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -64,7 +64,8 @@
 	{(1UL << GLF_INSTANTIATE_NEEDED),	"n" },		\
 	{(1UL << GLF_INSTANTIATE_IN_PROG),	"N" },		\
 	{(1UL << GLF_TRY_TO_EVICT),		"e" },		\
-	{(1UL << GLF_VERIFY_DELETE),		"E" })
+	{(1UL << GLF_VERIFY_DELETE),		"E" },		\
+	{(1UL << GLF_DEFER_DELETE),		"s" })
 
 #ifndef NUMPTY
 #define NUMPTY
-- 
2.39.5



