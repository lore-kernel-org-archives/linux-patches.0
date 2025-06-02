Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EBC233D64;
	Mon,  2 Jun 2025 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876753; cv=none; b=MH1oQQiPksxhfD065YjbIBHMH6jR7G8HCjqgGw9G8hnN0N6SQOmrV/BDFrGwFFzJrFnmtCLdSRI5xRURP+MJSHeEtRkSFxGx0kwgQW3TLXnsp+MKx1QK53mLmGqKj/O4632Ng5q7J4YqHNa308/CvHRNvBVSC6ON9zEl2g9qpTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876753; c=relaxed/simple;
	bh=hHhqeot/t7UTXSd1n2tTXx6gO2cM7r9ZQod3YUopgfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQHkxFtGnA3qTkbnvkx8MXmqseYBVdFu1I+F7KENEU3GQweFrQuMYm/yj9BZMfPZJE9XW8mKRxFAsJvphZBFem4rId9XsO7q50vlddB9W4BtDiC8Biv1bPaIXieJYrOtQdh4SAB6Bwbu9vJyMMgn5p/NSB04Y/LQPRKAZX9ed/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hH2mVt1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hH2mVt1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE8AC4CEEE;
	Mon,  2 Jun 2025 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876751;
	bh=hHhqeot/t7UTXSd1n2tTXx6gO2cM7r9ZQod3YUopgfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hH2mVt1XooV5Qq2D/1X2bqBMqvcnw5KwL1j+w1wvzr8xrsTXdai9YHyuRegL+iaKK
	 WSpz3zp4cuAUDXhmDITaWfR2mIGWEL6TEFjHRfAPPDkXBI624ri+bLNy7DV8LPmSie
	 9ahTkdDk8rY+KwLNJuk6FkHDwsQQvFV00CNVO17s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Serge Hallyn <serge@hallyn.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/325] ext4: reorder capability check last
Date: Mon,  2 Jun 2025 15:45:38 +0200
Message-ID: <20250602134322.283466003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit 1b419c889c0767a5b66d0a6c566cae491f1cb0f7 ]

capable() calls refer to enabled LSMs whether to permit or deny the
request.  This is relevant in connection with SELinux, where a
capability check results in a policy decision and by default a denial
message on insufficient permission is issued.
It can lead to three undesired cases:
  1. A denial message is generated, even in case the operation was an
     unprivileged one and thus the syscall succeeded, creating noise.
  2. To avoid the noise from 1. the policy writer adds a rule to ignore
     those denial messages, hiding future syscalls, where the task
     performs an actual privileged operation, leading to hidden limited
     functionality of that task.
  3. To avoid the noise from 1. the policy writer adds a rule to permit
     the task the requested capability, while it does not need it,
     violating the principle of least privilege.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250302160657.127253-2-cgoettsche@seltendoof.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/balloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index fbd0329cf254e..9efe97f3721bc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -638,8 +638,8 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 	/* Hm, nope.  Are (enough) root reserved clusters available? */
 	if (uid_eq(sbi->s_resuid, current_fsuid()) ||
 	    (!gid_eq(sbi->s_resgid, GLOBAL_ROOT_GID) && in_group_p(sbi->s_resgid)) ||
-	    capable(CAP_SYS_RESOURCE) ||
-	    (flags & EXT4_MB_USE_ROOT_BLOCKS)) {
+	    (flags & EXT4_MB_USE_ROOT_BLOCKS) ||
+	    capable(CAP_SYS_RESOURCE)) {
 
 		if (free_clusters >= (nclusters + dirty_clusters +
 				      resv_clusters))
-- 
2.39.5



