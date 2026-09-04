Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71E23815E1;
	Fri,  4 Sep 2026 05:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500359; cv=none; b=LWj2sJTkT7BG2rz0Wxx9shx78RunIacOrDzUUAo7loIN7gomcH35eYHSyPFbH4HVx525qHqneOONZKjD4Y2anNi8rkf1V0xsoqAB3Vf7/SNUBaWNEb6NYHsf92nmdIHJoKUE1AMBJ4sLUtQ3g5+rj4D/GvPHSehpSU0l38YsXPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500359; c=relaxed/simple;
	bh=NQFdY45Fp0o7d9SGWBqgL3/9Mdcxtg+fsainHlcMHlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUefkNJuZ3YvPR6uREr2TTvZuR/WU6iOYgYtM0zfy+QDNZRuQrpiY3HfsH8phNDAXrECrz0ouyyXup0CuCYR00P3aRhBdVkA/2vDRx9WfwA3bLDkaKnr5C6PifBrOSPHrFHJWVwdoK6riv0ef9WIq3+BYaI3pcDBEdm4Ve8d7sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjHxCE25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjHxCE25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437A01F00A3D;
	Fri,  4 Sep 2026 05:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500357;
	bh=3Mm4o4vIfWpGCAfxNK7re1lWU3BHCJP3Nq9TaCFCsxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjHxCE25xE7scIwj00jiNP6+Ee/9WysNuB7Cvg/eCOjVPuTX2xxZ/BNwRiJJluqUV
	 RwFXf2N+rpIx40XJ+VubYY/tRJX80sLpNR5L46yrMWdXoX5kXa7na/HAvx7TdqqpXW
	 j+LI2JNrD/75Z0f0ZZ2nLNvEbYBrsLGQnHyeEJsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 007/552] nsfs: tighten permission checks for handle opening
Date: Fri,  4 Sep 2026 06:52:44 +0200
Message-ID: <20260904045747.992308360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit d2324a9317f00013facb0ba00b00440e19d2af5e ]

Even privileged services should not necessarily be able to see other
privileged service's namespaces so they can't leak information to each
other. Use may_see_all_namespaces() helper that centralizes this policy
until the nstree adapts.

Link: https://patch.msgid.link/20260226-work-visibility-fixes-v1-2-d2c2853313bd@kernel.org
Fixes: 5222470b2fbb ("nsfs: support file handles")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@kernel.org # v6.18+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index e2f9a725883c7..4dee1e728569d 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -566,7 +566,7 @@ static struct dentry *nsfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
-	if (owning_ns && !ns_capable(owning_ns, CAP_SYS_ADMIN)) {
+	if (owning_ns && !may_see_all_namespaces()) {
 		ns->ops->put(ns);
 		return ERR_PTR(-EPERM);
 	}
-- 
2.53.0



