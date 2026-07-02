Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158883382DA;
	Thu,  2 Jul 2026 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009328; cv=none; b=jWpvEDsC1lS8digPybz4DbwYhtdqJS+j2ovhVA5sv3m8bXi4fyVKzmb+g2Ar8T1S+0ktgQNsg8xTRQsp5EoCNGlM/bjX8t3aZw2mK4H6iB4cb7cXhyhjsUVODthTAyGITRvswRN2XdoDsTgXqr31/HBhYyKvHt/u8zNwiKoTDvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009328; c=relaxed/simple;
	bh=LrDUDcU3XLyfTPR385wS5eZWjTDL1JCaftzDAs3vNwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZB+OjAOXOLdOZnZjbi2rOwPbceUgKLuRb/RRPDsPTRLzlRhqQPmHaUCWczKQ3A8SwJgTSoynqF3zVpKAiS4J3Tl0fQlFnQMyfwua8qS6kv11njHnpalLDXG/EvJ610+u094lH6qsHejugcVKNpYC78yq43FLpDWvFCOqtrSmkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zau/xWIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zau/xWIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366401F000E9;
	Thu,  2 Jul 2026 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009326;
	bh=MzHFzKZngxwwR6fQzabMUUEpCh5BvKHMYkXnuSFI/Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zau/xWICnpJsREAqJAcQmsuF18smkKZY8ziloKo4FBEs9p/FURazQjlKI4t2w9LCG
	 WKjAMf2Dkz2IjxYdEEn9N8py7/4tRZfpmPZ0psJO1M8LXMC3I5fkbQYGTOM1oHPzGA
	 cc8tz5tq7cU5A/IhfLVg8o8vvpWsg6PG77yIds2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/96] fuse: limit FUSE_NOTIFY_RETRIEVE to uptodate folios
Date: Thu,  2 Jul 2026 18:19:02 +0200
Message-ID: <20260702155109.194178793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9c8a7fdb34dd1a..fc93beee0719d9 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1728,6 +1728,10 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
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



