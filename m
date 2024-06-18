Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBC21A2C28;
	Tue, 18 Jun 2024 13:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716646; cv=none; b=IL+8p/GGK38xmQKkK66erYXEA7UN4yJ74NrzZpaTYOF9Z3Oro51w21wGHZt4YY0wiQV3tnBkkFVFlzla11oj+cezC4/OPkLCOgAfLupQ711lKookmRFdYkYJmsIaFqLCJfLjvPQAaKosLmERespYm/02pOPs5Ww+OImoJhH3JSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716646; c=relaxed/simple;
	bh=1xLEt+9UEUCimElrH6By65p18u6F7XQCAxORLTMjsag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riJ5mqZwLn92OupOBfkCuPyeOsLDentbPVBNdKMwDtuB5xIXtGZW5gf9zeNUa0BMH1rU6X/ciEC0MjvLpeWXTHHxILZ+cKq3K9nxgqbNAOUnEDpOsKoDrSPglBJtTqMs/6fPZ8Ps/o4g64dxpyOCEELE1SkT1wGWsmyVbeYHRuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB0MRNZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB0MRNZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAA0C3277B;
	Tue, 18 Jun 2024 13:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716646;
	bh=1xLEt+9UEUCimElrH6By65p18u6F7XQCAxORLTMjsag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB0MRNZAKnEg2NCQ8vS5dWK2O7cJwm2YB6/3yqri842c5lXS6Ms66KLeZGjsIgz7t
	 RafNC86cG0itGqotgOJ8waSXPAuKVX4sMdi/fPoE+DCRasYDaZ037KJF3/WkbTIejm
	 Cdi2GjqS+ZC5l7zPHtPMaTKtOY4pNGlLXcT1apNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 714/770] lockd: fix file selection in nlmsvc_cancel_blocked
Date: Tue, 18 Jun 2024 14:39:27 +0200
Message-ID: <20240618123434.832874339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 9f27783b4dd235ef3c8dbf69fc6322777450323c ]

We currently do a lock_to_openmode call based on the arguments from the
NLM_UNLOCK call, but that will always set the fl_type of the lock to
F_UNLCK, and the O_RDONLY descriptor is always chosen.

Fix it to use the file_lock from the block instead.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svclock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 9eae99e08e699..4e30f3c509701 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -699,9 +699,10 @@ nlmsvc_cancel_blocked(struct net *net, struct nlm_file *file, struct nlm_lock *l
 	block = nlmsvc_lookup_block(file, lock);
 	mutex_unlock(&file->f_mutex);
 	if (block != NULL) {
-		mode = lock_to_openmode(&lock->fl);
-		vfs_cancel_lock(block->b_file->f_file[mode],
-				&block->b_call->a_args.lock.fl);
+		struct file_lock *fl = &block->b_call->a_args.lock.fl;
+
+		mode = lock_to_openmode(fl);
+		vfs_cancel_lock(block->b_file->f_file[mode], fl);
 		status = nlmsvc_unlink_block(block);
 		nlmsvc_release_block(block);
 	}
-- 
2.43.0



