Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A0754F87;
	Tue, 14 May 2024 11:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685513; cv=none; b=Fofqosku4RQcaenfnBwUanPno8BAh2/ZffduW1yA+AX6VjPZ0EM7xtbF/59qVVIuR+IazCgceGSBbfPxLrMvapG0C6b8YD2ewVZ7+eUAKv+M3f2aa6Ny81zJDIwi1nIT+E/gf5BAfxplIEbnnBirqg00J1x5EaB0ogpHcRP51Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685513; c=relaxed/simple;
	bh=XrLxzDyI/EJljwO7/9Y2/+XWkG7zmQxJuxYa7UXrpR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8cXiFKY9cuWoAfDqKMazchlI1FbkmQwqVzyh4DPjPu/Hd1JrYdsMO+KEmbCoW7LOyWpuoOVrja3QnDmrZip7mwbVQPDqyyufeIu2PFmLUfYvOvZVofcpaf/hwC25llexDUoC0Lp1eTx3rGOTwfuBAKknNZn0/b4iLrqhLfLHLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Po7bsJZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Po7bsJZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35322C2BD10;
	Tue, 14 May 2024 11:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685513;
	bh=XrLxzDyI/EJljwO7/9Y2/+XWkG7zmQxJuxYa7UXrpR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Po7bsJZQePpMfMG0Hejyvs9Yqs+/ArO1N+Y+2ZgNiFKtXSjkGtE9X9cApJFVrJgiy
	 V2YQ4wIc2EeJ0X0e8rmon+mAMoQ1aVor40QMrDmd424aAtpA34VJFsrDJo+uNUre/Y
	 VXH4MFtb8nGlJS690xdfhE6VWpMyAQ2HsZ9/Em4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/301] fs/9p: fix the cache always being enabled on files with qid flags
Date: Tue, 14 May 2024 12:17:11 +0200
Message-ID: <20240514101038.298813310@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit 4e5d208cc9bd5fbc95d536fa223b4b14c37b8ca8 ]

I'm not sure why this check was ever here. After updating to 6.6 I
suddenly found caching had been turned on by default and neither
cache=none nor the new directio would turn it off. After walking through
the new code very manually I realized that it's because the caching has
to be, in effect, turned off explicitly by setting P9L_DIRECT and
whenever a file has a flag, in my case QTAPPEND, it doesn't get set.

Setting aside QTDIR which seems to ignore the new fid->mode entirely,
the rest of these either should be subject to the same cache rules as
every other QTFILE or perhaps very explicitly not cached in the case of
QTAUTH.

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/fid.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index 29281b7c38870..0d6138bee2a3d 100644
--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -49,9 +49,6 @@ static inline struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
 static inline void v9fs_fid_add_modes(struct p9_fid *fid, unsigned int s_flags,
 	unsigned int s_cache, unsigned int f_flags)
 {
-	if (fid->qid.type != P9_QTFILE)
-		return;
-
 	if ((!s_cache) ||
 	   ((fid->qid.version == 0) && !(s_flags & V9FS_IGNORE_QV)) ||
 	   (s_flags & V9FS_DIRECT_IO) || (f_flags & O_DIRECT)) {
-- 
2.43.0



