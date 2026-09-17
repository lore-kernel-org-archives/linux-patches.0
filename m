Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D485C403E9D;
	Thu, 17 Sep 2026 19:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671700; cv=none; b=fNbbEGPnT6btbGZzt++w2RkFncmDRbT7UDAq/VEj1YKb8BhRywM8BlUWvPY0BsRS7nSUqgyFoWHAozA2mG8qhmgXpvAtVcLF1EADphHLftNrDO6f0J0yvrC8DNkeitalaaz2+E248Di5GJax9XkhYwZ7lPSk2yWq972V7GKe2Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671700; c=relaxed/simple;
	bh=9oTkyMYEOWDhkAZ+ZDTw3w2kdWdSotVmmEToitazbpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl5E6mUYN6Mes7BCMHO5bB424vV8ibYlQQAngFhEfMtMxslN+cSzxJoUTyVzD+puPAlvX0sb5x5Un2ndykswh64lq7gqfxgL2VdP+7z+t+SvavsfCQnepkYG+jRK0GbsJv1jxgDgHZKXN4XYEBnErEQ8+nYcUWfEtcBnEqTB/mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuyYTgm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuyYTgm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74441F000FF;
	Thu, 17 Sep 2026 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671698;
	bh=RExiqgThTUCmcdYXZ/lkcNEefVHZdYtlVnwU4otx5jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuyYTgm0zkmr3yBUNxiH3aTtUv+GSVXIV1ap3m7Igyy9xf01nm2oyY7vmuU5KE3ED
	 38jl+hZpgx0g4OtgG5XdMKLXUbq1IxZsYtLTsR0YpYce85aSxsj0llZIYD/uyUWgL4
	 NTHT6Jae/cMENQGDZCk6Hpc/LT9j9vjjZPsYwt7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gurudasani <nikhilgurudasani314@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1062/1102] erofs: skip sufficiently large global buffers when resizing
Date: Thu, 17 Sep 2026 16:16:45 +0100
Message-ID: <20260917151607.476354715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>

[ Upstream commit a7d097cf01301c5da37927c8f26123d006f0fd8a ]

z_erofs_gbuf_nrpages is advanced only after every global buffer has been
grown. If a resize fails after some buffers were enlarged, a retry
revisits those enlarged buffers.

Retrying the same size then returns -ENOMEM because alloc_pages_bulk()
has no pages to add and the unchanged return value is treated as a
failure. Retrying an intermediate size allocates a temporary pointer
array smaller than gbuf->nrpages and copies more existing pointers than
the array can hold.

Skip buffers that already satisfy the request. Once all remaining
buffers have caught up, advancing z_erofs_gbuf_nrpages again describes
the guaranteed minimum size across the pool.

Fixes: d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
Cc: stable@vger.kernel.org # 6.10+
Signed-off-by: Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
[ preserved the existing kcalloc() allocation instead of upstream kzalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zutil.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -79,6 +79,8 @@ int z_erofs_gbuf_growsize(unsigned int n
 
 	for (i = 0; i < z_erofs_gbuf_count; ++i) {
 		gbuf = &z_erofs_gbufpool[i];
+		if (gbuf->nrpages >= nrpages)
+			continue;
 		tmp_pages = kcalloc(nrpages, sizeof(*tmp_pages), GFP_KERNEL);
 		if (!tmp_pages)
 			goto out;


