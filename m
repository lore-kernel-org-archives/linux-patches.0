Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6D9471257;
	Tue, 21 Jul 2026 18:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657508; cv=none; b=JCJWz31LwVGqMhOSphIor9EyvNSOoNrDT/5Bd7NRo2ZUIAgjM5E8wijXcYFoxciI8LGfaKvP0hVtbzpI+FywFkRA3HW9Y2rO0tO21sQbBx6gjdehqYGRJK+DrK2qPfFuxKd068tEwz6VMULzaJXgkRRTbLSjVCmvWu7TrCxX6Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657508; c=relaxed/simple;
	bh=jpq2Yv14+kkZ3wJzs+aiT5NzuvPf4rre/QE1slPtCWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tE6QJjmfPvDjwEqFgRgit7pFWUXiqoHWm/sFoimKL7ivIkzezn0HGpgP0TV7Brr3U1aFRVvaIj5pIXJ6sG5mNhjbKEpYPBbeqOeHttz2D2hdf8XHyv8hm0exyKvnF1Fmk/hwk8dgE+Yis31yUtnLPCcCphSlOfY+1Dxi+m/sVyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwlR+a7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwlR+a7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D961F000E9;
	Tue, 21 Jul 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657507;
	bh=yY4fuU02C1g1VHdggsT9DISi39KuzN94hVb+CducL60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwlR+a7da37eJ8yAeuKvPOAda9SUV7BqjlqpK+WUd61G0+6kaRC9og6xIM8JoemKK
	 j0tpDIc70pHoFvgXoG65s0MOzfH7c9YTbvcNJp+wnv7NIk68I8wBefoB6D8WIlUtAJ
	 RV4yea+ES2gHea/0NbaD1Sg0m72uYU3j6SseQFxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0748/1611] apparmor: dont audit files pointing to aa_null.dentry
Date: Tue, 21 Jul 2026 17:14:24 +0200
Message-ID: <20260721152532.198663804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit add2b70038bea194bcdef8a680f9153ee7f93ac0 ]

In
  commit 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
there was a change to not audit files pointing to
aa_null.dentry because they provide no value, but setting the error
variable instead of returning -EACCES was still causing them to be
audited.

Fixes: 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
Acked-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 7de23e85cd5d01..80e4ad2fca9c46 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -156,7 +156,7 @@ static int path_name(const char *op, const struct cred *subj_cred,
 
 	/* don't reaudit files closed during inheritance */
 	if (unlikely(path->dentry == aa_null.dentry))
-		error = -EACCES;
+		return -EACCES;
 	else
 		error = aa_path_name(path, flags, buffer, name, &info,
 				     labels_profile(label)->disconnected);
-- 
2.53.0



