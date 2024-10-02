Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5065C1D0493;
	Wed,  2 Oct 2024 14:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879104; cv=none; b=dL1hNpbZcquJHTerDtGmfIJnxwiBrhlD5xo4nrPQIhFLDCr2DREzDGodJTLRDKTguGwP1KkMC/5tP7YNcZYPb+oMkMfShSQVQOHLVwEgikxv0KZrA+Ot7RKADb3D3lcsFHh8ga/zTlJ2QitGU0s76JkBk7wqGh8BqVftLADo/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879104; c=relaxed/simple;
	bh=7wyxMDf/oq9WYDG8tcNssZDb0XIYT54DygPINw+Ky+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN4YYxLZhiagqNdWDS9dGBTFBy+94vUpbzAMdHx7tESAuWNBnrZvTN/BBoaCDMYc8I9SVAK7M/Wew0y9LPrRomSfoVTDUqJkswGzf7lNszgR2NnYK/IAATKkZkMKLAZQRDbRoQCqwBFefqjHSru9jdIpnBUuRCNdgg3dLfTLPF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3fvcqmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3fvcqmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0059C4CEC2;
	Wed,  2 Oct 2024 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879104;
	bh=7wyxMDf/oq9WYDG8tcNssZDb0XIYT54DygPINw+Ky+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3fvcqmxwk6ODSR2I3wxHueYQXtKJ/czvo0PpRnZCi0wt7ZRY5mfR5DsJMpBP7G26
	 IwYs1X21X+SAxXiaWl43JbfivyxVOI7dKqGzBpjs0j3N/0MSp9b/D410bQtueB/1XS
	 vP4+a+5KY5YdqyYB0DdHfCXbaGrpoOMwQGk0oTjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 612/634] debugfs: Convert to new uid/gid option parsing helpers
Date: Wed,  2 Oct 2024 15:01:52 +0200
Message-ID: <20241002125835.274515375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 49abee5991e18f14ec822ef53acd173ae58ff594 ]

Convert to new uid/gid option parsing helpers

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Link: https://lore.kernel.org/r/b2f44ee0-3cee-49eb-a416-f26a9306eb56@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 3a987b88a425 ("debugfs show actual source in /proc/mounts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/inode.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 8fd928899a59e..91521576f5003 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -92,9 +92,9 @@ enum {
 };
 
 static const struct fs_parameter_spec debugfs_param_specs[] = {
-	fsparam_u32	("gid",		Opt_gid),
+	fsparam_gid	("gid",		Opt_gid),
 	fsparam_u32oct	("mode",	Opt_mode),
-	fsparam_u32	("uid",		Opt_uid),
+	fsparam_uid	("uid",		Opt_uid),
 	{}
 };
 
@@ -102,8 +102,6 @@ static int debugfs_parse_param(struct fs_context *fc, struct fs_parameter *param
 {
 	struct debugfs_fs_info *opts = fc->s_fs_info;
 	struct fs_parse_result result;
-	kuid_t uid;
-	kgid_t gid;
 	int opt;
 
 	opt = fs_parse(fc, debugfs_param_specs, param, &result);
@@ -120,16 +118,10 @@ static int debugfs_parse_param(struct fs_context *fc, struct fs_parameter *param
 
 	switch (opt) {
 	case Opt_uid:
-		uid = make_kuid(current_user_ns(), result.uint_32);
-		if (!uid_valid(uid))
-			return invalf(fc, "Unknown uid");
-		opts->uid = uid;
+		opts->uid = result.uid;
 		break;
 	case Opt_gid:
-		gid = make_kgid(current_user_ns(), result.uint_32);
-		if (!gid_valid(gid))
-			return invalf(fc, "Unknown gid");
-		opts->gid = gid;
+		opts->gid = result.gid;
 		break;
 	case Opt_mode:
 		opts->mode = result.uint_32 & S_IALLUGO;
-- 
2.43.0



