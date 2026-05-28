Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE96E33372A;
	Thu, 28 May 2026 20:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001546; cv=none; b=ofRhQHLX2AIw2q6NT0sEZJApycTPK8cw4ylo3MVvwM5EmryotGvyB4q06Uj6CWVHuRrPihoYEOrmykuHDQD9UpjW5JGpetde5ZxmJIURrZU2BsaUkEMZ04CbVCXYMyKHiuYji2X0V7bRTX4Gq+w7gVRNNFar0LNNuozfJue+3kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001546; c=relaxed/simple;
	bh=T5jJjhs1dh/ap1IFwXrSbic8DQSS7Hp0hNt5pb7JBkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4SO3mr0USA/+jcYTma9jElKjJ5aMxexzeI4cVeVjXhirmiDW3l508QpKI9C/kikBRyd3h313iE5lK9NfCxbuqR5jd/tOkUlx2jKTs28zG/W3TUA/fWklNwXu/WGqMng+wUwZH5snrM1NssM8kcYaIY5Lxtvu0pJ080Ra9sVhRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1UpG7TB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1UpG7TB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486F71F000E9;
	Thu, 28 May 2026 20:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001545;
	bh=qLqvt7l8f33cTYyVBDtL+d4r5tUFizSpBY6uI6g86/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1UpG7TBwSUb+vBF/C/tTjVj13Mhp+TuMKU3JpmGeUy5Ej4Im5LpyXQvmmYfVL5Mn
	 b/gF+5JZLCC+El+Im/YtxBHj+G3TaVN8PmMBu5Fw5/34TpDNSVNjT3mlli9saPKzC9
	 8Y1iInG0/b7Cg2WD6ILggaNxPGQF+NoCeCqJlQiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/186] pds_core: fix debugfs_lookup dentry leak and error handling
Date: Thu, 28 May 2026 21:50:46 +0200
Message-ID: <20260528194933.446373341@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit dc416e32baaeb620b9809e9e25fc7b30889686e9 ]

debugfs_lookup() returns a dentry with an elevated reference count that
must be released with dput(). The current code discards the returned
dentry without calling dput(), causing a reference leak on every
firmware reset recovery.

Additionally, when CONFIG_DEBUG_FS is disabled, debugfs_lookup()
returns ERR_PTR(-ENODEV), not NULL. The current check passes for error
pointers and would call dput() on an invalid pointer, causing a crash.

Fixes: bc90fbe0c318 ("pds_core: Rework teardown/setup flow to be more common")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260515212907.998028-3-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/debugfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index 51f3f73a839a9..33b8e8d1fd4c6 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -64,9 +64,14 @@ DEFINE_SHOW_ATTRIBUTE(identity);
 
 void pdsc_debugfs_add_ident(struct pdsc *pdsc)
 {
+	struct dentry *dentry;
+
 	/* This file will already exist in the reset flow */
-	if (debugfs_lookup("identity", pdsc->dentry))
+	dentry = debugfs_lookup("identity", pdsc->dentry);
+	if (!IS_ERR_OR_NULL(dentry)) {
+		dput(dentry);
 		return;
+	}
 
 	debugfs_create_file("identity", 0400, pdsc->dentry,
 			    pdsc, &identity_fops);
-- 
2.53.0



