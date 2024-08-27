Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32571BFE06;
	Tue, 27 Aug 2024 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770316; cv=none; b=S45qru7o614BE6Asm7Yh5SiCcEfbwIfUpvD0TdCM+Azhr1FkaVKb47BZKTxoCZDvwDONXmAGrjEYLvRAdfkxkj7UWUXZ5KTYK/5J6/+DfjvK/fd0HOyYV0mK6OO7bXLHjdaw+iijsxCR1BKItK1yaLROACr5sgx3bajhq1p3eZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770316; c=relaxed/simple;
	bh=uNXHDFxRWk+ZIlCuA+YxIwo+XuLlo+B/9twsmqn7zHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUBdwDkTgc20PRUPmx0jLlSiiI14QywGl6wNgwOe0zO2t+ejWzN2GFph0kuxuhN9wGREbhIytpJMn8IKnaxTy1wlP5+DaxGBGVf+rFF7A80HPgMiBpyNl4dojSrjlmivws172T5uGAE8v3eS+mquB4O1JzIhQysdFwKwIFW4BeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+d8Q5dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+d8Q5dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6093FC4DE06;
	Tue, 27 Aug 2024 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770315;
	bh=uNXHDFxRWk+ZIlCuA+YxIwo+XuLlo+B/9twsmqn7zHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+d8Q5dg0AthsXUDZ5nDKQD/FyTjgsk/ZVohFZrnRRScLB0z7bIqaUniBbdH3ba9I
	 R9k6Q4fNTiI6pecul8Mhs7jnzBpzMWbpiHfNUJ7wBRB+l9xObUW47CREyuo072gsrF
	 ur50or5Mf+qAofvDtdm2m2G2vBEhwPI66IG8zcns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/341] gfs2: Refcounting fix in gfs2_thaw_super
Date: Tue, 27 Aug 2024 16:36:22 +0200
Message-ID: <20240827143849.164517534@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 4e58543e7da4859c4ba61d15493e3522b6ad71fd ]

It turns out that the .freeze_super and .thaw_super operations require
the filesystem to manage the superblock refcount itself.  We are using
the freeze_super() and thaw_super() helpers to mostly take care of that
for us, but this means that the superblock may no longer be around by
when thaw_super() returns, and gfs2_thaw_super() will then access freed
memory.  Take an extra superblock reference in gfs2_thaw_super() to fix
that.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 8b34c6cf9293f..1200cb8059995 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -819,6 +819,7 @@ static int gfs2_thaw_super(struct super_block *sb, enum freeze_holder who)
 	if (!test_bit(SDF_FREEZE_INITIATOR, &sdp->sd_flags))
 		goto out;
 
+	atomic_inc(&sb->s_active);
 	gfs2_freeze_unlock(&sdp->sd_freeze_gh);
 
 	error = gfs2_do_thaw(sdp);
@@ -829,6 +830,7 @@ static int gfs2_thaw_super(struct super_block *sb, enum freeze_holder who)
 	}
 out:
 	mutex_unlock(&sdp->sd_freeze_mutex);
+	deactivate_super(sb);
 	return error;
 }
 
-- 
2.43.0



