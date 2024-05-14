Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42BA13D625;
	Tue, 14 May 2024 10:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683396; cv=none; b=aKYVuB9AGuRcxcHk4pemEzHAWKx4O06KEbBmuWE7p6bDOLPjKRE92sXPFI/+w2KeHUlVuUFwQ568hqZAVs5Fqak9YpCvADQAaRZcd8UYfCXt42cjIQR/EKlBU3SvebNeKbnI6OOsPDMahQThN8UzcE3WcvOXOPnGRca8At/XIUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683396; c=relaxed/simple;
	bh=VjY/4/XLA1tA+D7CXFZpEufgBVaQbdvE7uFe2TvdlKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j49I9mjUW32q6VcS2FHLfCZmEroKghNBbCc8EK1GlKnTzULxbg1JNNZ2nrz6p4JoWsTq/beoEnlx6iM79vAIT3prC02McsYjkOfq8aNJOkhUy3N54ukMXDPbKPYsm/ssuU0bypIXb3Pc8tigG/pRCZa0EiwJSYfVDWVjLVfSbGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFVsBybT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFVsBybT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87345C2BD10;
	Tue, 14 May 2024 10:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683396;
	bh=VjY/4/XLA1tA+D7CXFZpEufgBVaQbdvE7uFe2TvdlKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFVsBybTfc9c67A/GoSqM+OQzzxfsIq72sFlW2lhr+maQ840EaPbkphaKjmuQg6t/
	 3Hg425Y6UNcEXr7okTWcF6xpYhEduP6CbRkMbto3x0hIkHKpFRNcM7CYGMj7EfkgsS
	 pZZtASWR0oyWeAz9JL+tcImQLgO2t1CwmzGDJ7kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 179/336] fs/9p: fix the cache always being enabled on files with qid flags
Date: Tue, 14 May 2024 12:16:23 +0200
Message-ID: <20240514101045.362482874@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



