Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685AC3B6361;
	Thu,  2 Jul 2026 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010712; cv=none; b=Gq4wk45AsjxUkuRvSu55ItzdC2BDUPWY5gotz0emm0visd+itxwtJkkSxRexIUcEiiuO/NqBpd7eCXEGg9BQr40LJYK6Yx7jySqJzKZEdM3h87xw35nYIiSUxCUvvsCGFpv04Gqe6GdDSzOILX/CnBg6XdpFLJWqDPKCQGn/88E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010712; c=relaxed/simple;
	bh=qEqwHxIyqtP4GlL22LL7KqwJIj8wx5vo4L4uGlCKlNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ud63InLjXQ0cG6lrZ+sVY4NBJLOcaslFSrRrun1KByd1zh6sx67t4yE/ftxRugsrE15BsAnEpGj4eoVan+Q9xtujSzFER0F20Heus1Jjuh/OtguvNMXHFZO8zIcG63TZUd34mm95LLsiMXtC0ZnbamCn75bkJlLpJchHFDttRGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt4BwOhU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt4BwOhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7F81F000E9;
	Thu,  2 Jul 2026 16:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010711;
	bh=6eo64JpbOlR4+SSLoJjQA4RiroChyZSxmh7u1kwnSno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rt4BwOhU9JLd+ShuPM6neqCzq5Iv3iBVcFh4J20AWMooRxmq+PBDejBeuqy5Clbp+
	 +CjkWoc5KNxB+yGIS+oGC2LMK/UffKBHfqW6XWcEUvObCVsS6KDGnE+vQypLtkOvj7
	 f1GsUmsUQCKMGfnm7Zg9/WBuezaXQSJpWYmv1aTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/175] fuse: limit FUSE_NOTIFY_RETRIEVE to uptodate folios
Date: Thu,  2 Jul 2026 18:18:22 +0200
Message-ID: <20260702155115.800865083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 4e3d1b2c48ca6c55f1e9ca7f8dccc76f120f276c ]

FUSE_NOTIFY_RETRIEVE must be limited to uptodate folios; !uptodate folios
can contain uninitialized data.
Since FUSE_NOTIFY_RETRIEVE is intended to only return data that is already
in the page cache and not wait for data from the FUSE daemon, treat
!uptodate folios as if they weren't present.

This only has security impact on systems that don't enable automatic
zero-initialization of all page allocations via
CONFIG_INIT_ON_ALLOC_DEFAULT_ON or init_on_alloc=1.

Cc: stable@kernel.org
Fixes: 2d45ba381a74 ("fuse: add retrieve request")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260519-fuse-retrieve-uptodate-v1-1-a7a1912a37f9@google.com
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[adjusted for stable: page instead of folio]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 29a6c3a5829d83..a7705b5b22e09d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1722,6 +1722,10 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 		page = find_get_page(mapping, index);
 		if (!page)
 			break;
+		if (!PageUptodate(page)) {
+			put_page(page);
+			break;
+		}
 
 		this_num = min_t(unsigned, num, PAGE_SIZE - offset);
 		ap->pages[ap->num_pages] = page;
-- 
2.53.0



