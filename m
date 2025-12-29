Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139BB32FA16;
	Mon, 29 Dec 2025 16:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024954; cv=none; b=MykzZ7DYZji6DLjfNEMPoCowiNKkezaFQ6XWyhsklEjR1ljTyzYMc4p+d/+/C8miO4VJrEEo4NokMZyP9H2gOh4SSPlp5KQxCrVovAOeSYKO7iuM5zBInVchyWgSE5k/8UhQ257lCyKffDu9+Pi/qTRGZbo4jjHzGm3WJkGrvqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024954; c=relaxed/simple;
	bh=J6jwGLL+gsQYZwTSvwd0ou2ws7ZUMau+M9PgO8f0NR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbHiPhiJv7uDtApX3pyu0YiZZI9qTq5CuC5q52lsz7M85B9FWLfJUAZgBuiy1vNrvvU2b13BuNSr/C6G4vftGlz7gNILOvwLJWEIRB/EnxIZtXlKlGsBLj1SoIgisa7KcmUlzEOQEjabi9cmS7waVSJokL9Fz5w/2m32YMerPGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Vd26iyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Vd26iyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D7AC4CEF7;
	Mon, 29 Dec 2025 16:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024953;
	bh=J6jwGLL+gsQYZwTSvwd0ou2ws7ZUMau+M9PgO8f0NR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Vd26iyIUZfu4XvaWe2QGtiphmSWpicQM5Qskgs54+5qJwrKghT3gx3BFh0QX5eV5
	 kroZsaApvAC6/LxUFX6ztDZv54ZKCUxp3wGtleYnjeuYbB6ehhKlDuIIzVA0zdZ36C
	 Z9w8jm+VYRjhfA9EjlC6vJZ/TAH6drgn7hkt/Oyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/430] gfs2: Fix "gfs2: Switch to wait_event in gfs2_quotad"
Date: Mon, 29 Dec 2025 17:07:24 +0100
Message-ID: <20251229160725.914881936@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit dff1fb6d8b7abe5b1119fa060f5d6b3370bf10ac ]

Commit e4a8b5481c59a ("gfs2: Switch to wait_event in gfs2_quotad") broke
cyclic statfs syncing, so the numbers reported by "df" could easily get
completely out of sync with reality.  Fix this by reverting part of
commit e4a8b5481c59a for now.

A follow-up commit will clean this code up later.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 2298e06797ac3..f2df01f801b81 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1616,7 +1616,7 @@ int gfs2_quotad(void *data)
 
 		t = min(quotad_timeo, statfs_timeo);
 
-		t = wait_event_freezable_timeout(sdp->sd_quota_wait,
+		t -= wait_event_freezable_timeout(sdp->sd_quota_wait,
 				sdp->sd_statfs_force_sync ||
 				gfs2_withdrawing_or_withdrawn(sdp) ||
 				kthread_should_stop(),
-- 
2.51.0



