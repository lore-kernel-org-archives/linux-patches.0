Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B8B190477;
	Fri, 21 Nov 2025 13:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731775; cv=none; b=FUvVkLC8IQihVNqlQcgquyGx3VicWG3cMzj8zVslUT7b02zh/yazG3UDbXcTqD2DtN1JeNcGAmstSVFP7Rx4eG7g1/+a/F56jr72nPdXoQpB3giHykFJczR3NScTV29q3/sUTAuoHyQO8xhVJ8hF0WyfyBhtVNVHselqRMAkyDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731775; c=relaxed/simple;
	bh=iUa/w9L37OdPqyLGwc4R8edkpl20XaqEo1L1PTeN14U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA6wI4kipHABlaZWakCoJK6+ee2Inpu+KtpJk9aOT/Az9lWujgHBwYDJ08cyN6X+x1paWOQw9j3dix01jFIzbsdNxky3VUcZ0fdxUMJAWUZjWWW85qw5N1Q64eCWonjJPAjAkfOSPSM6Ml16WKMeEK7R2kSd2XdSmKc/CIvehRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mc0ZS5ab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mc0ZS5ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE78C4CEF1;
	Fri, 21 Nov 2025 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731774;
	bh=iUa/w9L37OdPqyLGwc4R8edkpl20XaqEo1L1PTeN14U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mc0ZS5abBZoXxad0SQTmJ8Vjuj3D0aB3528FJv1EpDhqn7bzaZIQOxckUfXEpMqzU
	 /uuTw+yCLr5es3ftsT0e1JYZ9jrpsc1DJ4IM4wvXXvQqXluLqJwtsQXUTC2XDpil1V
	 EY5/STph3p/orN/pL3Pvw6PlFM/VsJALQyEOGF5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Abbene <sabbene87@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/185] NFSv2/v3: Fix error handling in nfs_atomic_open_v23()
Date: Fri, 21 Nov 2025 14:11:43 +0100
Message-ID: <20251121130146.614996414@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 85d2c2392ac6348e1171d627497034a341a250c1 ]

When nfs_do_create() returns an EEXIST error, it means that a regular
file could not be created. That could mean that a symlink needs to be
resolved. If that's the case, a lookup needs to be kicked off.

Reported-by: Stephen Abbene <sabbene87@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220710
Fixes: 7c6c5249f061 ("NFS: add atomic_open for NFSv3 to handle O_TRUNC correctly.")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index c05c737ac5282..048ce25ebfb70 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2280,11 +2280,12 @@ int nfs_atomic_open_v23(struct inode *dir, struct dentry *dentry,
 		return -ENAMETOOLONG;
 
 	if (open_flags & O_CREAT) {
-		file->f_mode |= FMODE_CREATED;
 		error = nfs_do_create(dir, dentry, mode, open_flags);
-		if (error)
+		if (!error) {
+			file->f_mode |= FMODE_CREATED;
+			return finish_open(file, dentry, NULL);
+		} else if (error != -EEXIST || open_flags & O_EXCL)
 			return error;
-		return finish_open(file, dentry, NULL);
 	}
 	if (d_in_lookup(dentry)) {
 		/* The only flags nfs_lookup considers are
-- 
2.51.0



