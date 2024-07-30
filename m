Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC081A6195;
	Tue, 30 Jul 2024 16:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357379; cv=none; b=hSLSJJBqmxyjX9eQQF9Q+vgBdM8noafyqzf/EMKqtTqJ7mH+ii9jUEk9clzddD35posa1eToW0k8X/exud6AfBejOXWeVsRu/zTSLYdR+FSTZDe7fICU4IknGP2gsH2yhhMuBY8XmQsKr+6NC/TyBo6eLbJf0Rfq7RWRZNSUtIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357379; c=relaxed/simple;
	bh=0hjQrnfGwSTvsIJasNFpuACxWUo91dxi4GYybJjg1u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4pqGHMLXn3QtMxPknenOPo3dWLSoFFMMhO7rKr7aP5DrgcTH5U+Oc5HqDw2vpJvm2Hy+HYfFeRljqUyMmzZpfjhi5tNwL7fvmWZeGhzFAv7IPbFPTpevRgbaN3yudfjTOdY1kDN4wno3ntY7xLrQ576ZYfnfIcrQHL2zHaHRgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOtjR66t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOtjR66t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428AFC4AF0A;
	Tue, 30 Jul 2024 16:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357379;
	bh=0hjQrnfGwSTvsIJasNFpuACxWUo91dxi4GYybJjg1u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOtjR66tX0+dorB3KQCyvd0MyWyjm92FLUaIsrLo1b1j44aWejmdfS7rbRTH4w2AC
	 hxuFIXruVxys/Og/Db7t90xwmwmHbhN0iyx7fM7/9BQ2jB0+6FZP+EpMXNTlQsZeF5
	 sCkVQ7/R1RUlv6zm0O7bchPcLk6gQVsHlP33JrI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Evers <florian-evers@gmx.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 248/809] nfsd: nfsd_file_lease_notifier_call gets a file_lease as an argument
Date: Tue, 30 Jul 2024 17:42:04 +0200
Message-ID: <20240730151734.394145550@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 769d20028f45a4f442cfe558a32faba357a7f5e2 ]

"data" actually refers to a file_lease and not a file_lock. Both structs
have their file_lock_core as the first field though, so this bug should
be harmless without struct randomization in play.

Reported-by: Florian Evers <florian-evers@gmx.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219008
Fixes: 05580bbfc6bc ("nfsd: adapt to breakup of struct file_lock")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Florian Evers <florian-evers@gmx.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index ad9083ca144ba..f4704f5d40867 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -664,7 +664,7 @@ static int
 nfsd_file_lease_notifier_call(struct notifier_block *nb, unsigned long arg,
 			    void *data)
 {
-	struct file_lock *fl = data;
+	struct file_lease *fl = data;
 
 	/* Only close files for F_SETLEASE leases */
 	if (fl->c.flc_flags & FL_LEASE)
-- 
2.43.0



