Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1597F1DFD1;
	Sun,  1 Sep 2024 16:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209484; cv=none; b=e0oEHrJ/mKEJKmAcLq+9MZBcMv+Fs+nWWiOctHNISKUqwKis9Jvc9HQ1jxi3fUQPK+XPuGg31vUIkrx4pJW/W/aqoiQoogwa37drolk2/OMKL/f7PwfSEAkhzA1gdBUgVLXfWLbG0GYC0jvDx8nJOBERdy54JnRw6vwIiKqWEW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209484; c=relaxed/simple;
	bh=BFocv+bkh+fThclmWQDwqGrW7oNJcwklvXPPFOSqXKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEfjAzufS9nPKjH2QXGBy8mXDy5mzaHEEL3XMKFRJEWPWBA42HAWsrKFh5NH2lH2UsL6AhxnumtgXsnh29qcdvhwf3tKtohC/uJkYGasM/9VapmC4D7qSltQ3GGQ2cn0aarD7zeLBhVSITY/XVY8hDVinWsvx1GaAPR4Ep0N3pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMv2XLcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMv2XLcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB1BC4CEC3;
	Sun,  1 Sep 2024 16:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209483;
	bh=BFocv+bkh+fThclmWQDwqGrW7oNJcwklvXPPFOSqXKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMv2XLcYRfTloNK51gCOTyYc7x0gTPNlQf6Z+yLFLkSqHoMLLOp3ew6jpkW3Qpo4Q
	 ddeIwejvhDpKIWmy7cvB74FdLJshdgIxwiJw9806CqOLwMyPoz1vf/iguu0LgJPXsG
	 QBOUOShAZsx0VzLqykaKW8KpV/H33vDjFd4ryg8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/151] quota: Remove BUG_ON from dqget()
Date: Sun,  1 Sep 2024 18:16:50 +0200
Message-ID: <20240901160816.001049920@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 249f374eb9b6b969c64212dd860cc1439674c4a8 ]

dqget() checks whether dquot->dq_sb is set when returning it using
BUG_ON. Firstly this doesn't work as an invalidation check for quite
some time (we release dquot with dq_sb set these days), secondly using
BUG_ON is quite harsh. Use WARN_ON_ONCE and check whether dquot is still
hashed instead.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 6a7b7d44753a3..9b8babbd1653c 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -997,9 +997,8 @@ struct dquot *dqget(struct super_block *sb, struct kqid qid)
 	 * smp_mb__before_atomic() in dquot_acquire().
 	 */
 	smp_rmb();
-#ifdef CONFIG_QUOTA_DEBUG
-	BUG_ON(!dquot->dq_sb);	/* Has somebody invalidated entry under us? */
-#endif
+	/* Has somebody invalidated entry under us? */
+	WARN_ON_ONCE(hlist_unhashed(&dquot->dq_hash));
 out:
 	if (empty)
 		do_destroy_dquot(empty);
-- 
2.43.0



