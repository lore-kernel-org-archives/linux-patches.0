Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAC0223328;
	Thu, 28 May 2026 20:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000222; cv=none; b=jIllb9oXPYlvm96ZLYbuaNRd4X9gL5vAR1mDCnZCOVjvU8mC7CI+471XKVanAPzKvfZqEx/i4k8UX+HnpIfjnvrLWVRmE9UB3AKfGVyPvrtafZpQNX3oYrlsxnLqMM+YfzIcQgi/EWA7pcLSvkEXOemEZyg9/yAdf6N0Z8XNlYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000222; c=relaxed/simple;
	bh=2YaYhrmNjZsbZRK0GkVy4oFH4ZhYey44bztR4R0ZbAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0GlF8yf0uN3bRbDHRi4PZF+10Hh/swTkniNeJhNqxTsSYqiZlAWrw3zTn3PXHLzRWApR26Kl3Dzvd1cLMTVflpqAw5OeLek8j7vCCEsDgWA8Kn1R5oZxugvmgPdtI5nEB1yVuwOQjHCEktkrjS8pg3FQaVIdNjpyeH++MRPKtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7RYYYiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7RYYYiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE591F000E9;
	Thu, 28 May 2026 20:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000221;
	bh=dGHvpUvW//ivg9XtiPfrP3oJGhKwt56mxBCqLq2NeLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7RYYYiHLdlSQuAl7Pd+TPkM752JQG5xNtLqeanP5kqynpe5fuU9sjI3976C1tmVP
	 G4fIeyzrTShuAxdwXeAEZoDnS2Eyrca10U35mbT56hL9u949W8ztoZYdNNt0ZIX1/r
	 BHlAQ3og/KIZ//RIGaCD6X7jPVd5Oo5woPWl9ml8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 344/377] pds_core: fix debugfs_lookup dentry leak and error handling
Date: Thu, 28 May 2026 21:49:42 +0200
Message-ID: <20260528194648.382800103@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index 04c5e3abd8d70..810a0cd9bcac8 100644
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



