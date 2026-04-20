Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B712C313547;
	Mon, 20 Apr 2026 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700222; cv=none; b=VkgzQRTeRmK704ikelMElGM7ZG+brVZEj9DEag9OPrSL8cp2FQfFedS0t51Fg+RIFFP3NpSajaATju3jDhxTK3ctkgEHBP0ttcUlopq78c4f6YZZt6kgxFCyx2ZFGmpUk/f48w4f1YgNze+S5+eFJQ/x8lTagGp87Ff4vhfMCTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700222; c=relaxed/simple;
	bh=oi/6yhgKy2wkgLnkEwnLO7sfj1hEdfzpKwDsjscZaVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpX1PnpS2JwlGkrS1uASFO1Ks2oQ292W2AWQZ4R9ijMmi6ff8Aq/YrYnjZlO66aXXjPTke32+HyoqKcqaVfSl5ZTff6k2OkJDCtl5v4RWzzrF2J2UqWzs/FnYW1H5ZPstAynpALj0RBoh0S564SxcK7UIs07ws7ekWllTubdWpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiS2h8+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiS2h8+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED30C19425;
	Mon, 20 Apr 2026 15:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700222;
	bh=oi/6yhgKy2wkgLnkEwnLO7sfj1hEdfzpKwDsjscZaVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiS2h8+Lj9eLRfEwsLzujQP4d3cfhDbLWR4yfp8bLHqdB/7H4kItmU4heWiLfpCkB
	 01m/njNh8qgPlAQlc9l8KVYdoQr6Vw7cwUFuf82M5fz8HnvJxVj2veEi2WlOUKJimK
	 6YOkiZhY+c88YcJBo+cXqrnawe1vJpcs3L/LlDH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	NeilBrown <neil@brown.name>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 071/220] cachefiles: fix incorrect dentry refcount in cachefiles_cull()
Date: Mon, 20 Apr 2026 17:40:12 +0200
Message-ID: <20260420153936.595484878@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@ownmail.net>

[ Upstream commit 1635c2acdde86c4f555b627aec873c8677c421ed ]

The patch mentioned below changed cachefiles_bury_object() to expect 2
references to the 'rep' dentry.  Three of the callers were changed to
use start_removing_dentry() which takes an extra reference so in those
cases the call gets the expected references.

However there is another call to cachefiles_bury_object() in
cachefiles_cull() which did not need to be changed to use
start_removing_dentry() and so was not properly considered.
It still passed the dentry with just one reference so the net result is
that a reference is lost.

To meet the expectations of cachefiles_bury_object(), cachefiles_cull()
must take an extra reference before the call.  It will be dropped by
cachefiles_bury_object().

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Fixes: 7bb1eb45e43c ("VFS: introduce start_removing_dentry()")
Signed-off-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/177456350181.1851489.16359967086642190170@noble.neil.brown.name
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index e5ec90dccc27f..eb9eb7683e3cc 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -810,6 +810,11 @@ int cachefiles_cull(struct cachefiles_cache *cache, struct dentry *dir,
 	if (ret < 0)
 		goto error_unlock;
 
+	/*
+	 * cachefiles_bury_object() expects 2 references to 'victim',
+	 * and drops one.
+	 */
+	dget(victim);
 	ret = cachefiles_bury_object(cache, NULL, dir, victim,
 				     FSCACHE_OBJECT_WAS_CULLED);
 	dput(victim);
-- 
2.53.0



