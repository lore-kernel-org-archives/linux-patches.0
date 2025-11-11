Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B8A25EF9C;
	Tue, 11 Nov 2025 01:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825278; cv=none; b=RfSRYHvPNrCsRmdX7cWYL5leYGMKBAROaeJT0LotyHpkeEEMQ9ZLYnIk3HTdu8QsI5QeoBZ+1BB10+QeiLYpzrXtthui9M2ZvRsSD98udf2ErRNfQELjikhd+Uq1UNIWGqrBbPUHsnxdhb9l4dqCDYy46diZhV2g8XP5zdrY5DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825278; c=relaxed/simple;
	bh=FVbny0FRXhGt0nX/v/dx6gIcYbp9YCn3BlwKqKAntJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/C2xCtinaBMuyuYQ5DG1fZ9hfxKYq3FX2z9Cv/uwnjJtl6I+sFnLm3dSWllvMcKHAADEj4QO5bRvro9Fg3nSRYeQFS7vQYtnGGryQoRoyb0XW21wOKb6ZN4edb97wxdl2a2JKhjGSELgh/3Xw9s56GiyXpTLm5AI1Gv5S5EsJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMDT+2rL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMDT+2rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72795C113D0;
	Tue, 11 Nov 2025 01:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825277;
	bh=FVbny0FRXhGt0nX/v/dx6gIcYbp9YCn3BlwKqKAntJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMDT+2rLAZGFBznyz/tOSIxYKbaSYjo/eukhrNN8m985ha3sERtEllwOzez58JPj2
	 jOeIARpIbFbj6pn4itn7+vact7jzawKpgfxYCR/amiACRqdu4OtUbfFNDTQMCbWGRY
	 CMYa/T6xkVPuLgzoFuTJBUV99qcpFyuX4nZIQyBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 735/849] ceph: refactor wake_up_bit() pattern of calling
Date: Tue, 11 Nov 2025 09:45:05 +0900
Message-ID: <20251111004554.209138683@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

[ Upstream commit 53db6f25ee47cb1265141d31562604e56146919a ]

The wake_up_bit() is called in ceph_async_unlink_cb(),
wake_async_create_waiters(), and ceph_finish_async_create().
It makes sense to switch on clear_bit() function, because
it makes the code much cleaner and easier to understand.
More important rework is the adding of smp_mb__after_atomic()
memory barrier after the bit modification and before
wake_up_bit() call. It can prevent potential race condition
of accessing the modified bit in other threads. Luckily,
clear_and_wake_up_bit() already implements the required
functionality pattern:

static inline void clear_and_wake_up_bit(int bit, unsigned long *word)
{
	clear_bit_unlock(bit, word);
	/* See wake_up_bit() for which memory barrier you need to use. */
	smp_mb__after_atomic();
	wake_up_bit(word, bit);
}

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c  | 3 +--
 fs/ceph/file.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 32973c62c1a23..d18c0eaef9b7e 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1260,8 +1260,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 	spin_unlock(&fsc->async_unlink_conflict_lock);
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_UNLINK;
-	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT);
+	clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags);
 	spin_unlock(&dentry->d_lock);
 
 	synchronize_rcu();
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 978acd3d4b329..d7b943feb9320 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -579,8 +579,7 @@ static void wake_async_create_waiters(struct inode *inode,
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
-		ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
-		wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
+		clear_and_wake_up_bit(CEPH_ASYNC_CREATE_BIT, &ci->i_ceph_flags);
 
 		if (ci->i_ceph_flags & CEPH_I_ASYNC_CHECK_CAPS) {
 			ci->i_ceph_flags &= ~CEPH_I_ASYNC_CHECK_CAPS;
@@ -762,8 +761,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	}
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_CREATE;
-	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
+	clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_CREATE_BIT, &di->flags);
 	spin_unlock(&dentry->d_lock);
 
 	return ret;
-- 
2.51.0



