Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E5E18B498;
	Tue, 10 Sep 2024 09:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962243; cv=none; b=shgoSFOC49x74/aiod9oqL4R8feXdH57uM1BmeNQ6HBBldcZJ57FA8H14p0SVZJAyCv89KIbd155KTTvPjh4jMKCB9LT7/hh1xyRnfGetgcdryhEBUwbDPb79p25lOjhXuhgquO8P8MtCiUfzafKxpl4oEQrYYT2VjIpyYdY6mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962243; c=relaxed/simple;
	bh=BKjrD8VWfbwMpvH5sRKYdQA9CGcm4GwAbD476j5TNfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ullACT8dQc231N4lkCdwxZQHHHIRJMyx/Q5RP48yhuuSfJ67Awdsw9W6sMhJpj6kBarNsBK96hdVjM30XsBbRdT71ZP+rEGMNVWO+wYd9Agi1K73sPhIq57v5ueW1T00C1XYZlPASltw1/o84RgeKUIzGrJydnRKIzCN9clSbhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9AIN0lo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9AIN0lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87D9C4CEC6;
	Tue, 10 Sep 2024 09:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962243;
	bh=BKjrD8VWfbwMpvH5sRKYdQA9CGcm4GwAbD476j5TNfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9AIN0loYAOr3gIFbUH18ang83n0GlRisylacZbGSYOilAldEkgv4hu7OQ13mX/ip
	 dl/dUcvvoJ4BVH6iJsUN96wVs70WeZlz+zv1CpNCUkhhY8gRD8MfoMuz/b/Wp4KObD
	 bg8pP5s6xMR8PkWWcxRKO9tLno6Z00hMJFgu6Lmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 316/375] fs: relax permissions for listmount()
Date: Tue, 10 Sep 2024 11:31:53 +0200
Message-ID: <20240910092633.176735718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit dd7cb142f467c4660698bcaa4a48c688b443ab81 ]

It is sufficient to have capabilities in the owning user namespace of
the mount namespace to list all mounts regardless of whether they are
reachable or not.

Link: https://lore.kernel.org/r/8adc0d3f4f7495faacc6a7c63095961f7f1637c7.1719243756.git.josef@toxicpanda.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ef7b202f8e85..e1ced589d835 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5074,7 +5074,7 @@ static ssize_t do_listmount(u64 mnt_parent_id, u64 last_mnt_id, u64 *mnt_ids,
 	 * mounts to show users.
 	 */
 	if (!is_path_reachable(real_mount(orig.mnt), orig.dentry, &root) &&
-	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
+	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	ret = security_sb_statfs(orig.dentry);
-- 
2.43.0



