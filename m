Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8D2343D9E;
	Tue, 11 Nov 2025 01:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824663; cv=none; b=aWd2sG4vVIaqbvCsRsXdBObbarvXyq28Fuf7TMYu0FLdWbGkFb3vxY5nC5sL6FQ1fcEeQUqJFgVEjFpo+DXc/7wsWtGvhLggrbCiCufng/p5KPv346tBloYml0uMOZieel11Ql7sPOZ4wwPugGKuBB8KmcmDDAzp1VGr7jsqFnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824663; c=relaxed/simple;
	bh=nO8REVMcAOF44XwLiJM2T7QNhQlZCdPAam1juqmJMUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRNk5zKSD5XqFk+0vO3wZoCV3rQrpCyNtWjoul8UJFVfwSyOZI1aSycRA/4uh8QyYc+Dn0nbYAoqjPLPCY04dBlW6sBsCxJy/egym1lqtg7UcbDhKqhGNEYcZNzW9+a2Hc/AI+TxgfY88c82z/LBt3ZuRuThx5MI+EBnKzrO5gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gdua0/R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gdua0/R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129F9C4CEFB;
	Tue, 11 Nov 2025 01:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824663;
	bh=nO8REVMcAOF44XwLiJM2T7QNhQlZCdPAam1juqmJMUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gdua0/R3Yg1siZ12DGuI2N1hZ8vn1hiDjKJasjptwQw3aX7cI1Zqcv6f3IOIRxWfa
	 8HDuSbLTCLWqlTAjxdU10YTayvpLA3eJnrUN0/WJelIlRJI1zqkwpIOJTDRyic1QUk
	 VHfiUYnSeClbVrXp7KMs1jixcbzUiaqLjMihb/B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 494/565] ceph: refactor wake_up_bit() pattern of calling
Date: Tue, 11 Nov 2025 09:45:50 +0900
Message-ID: <20251111004538.047384349@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16c25c48465e5..ba960a9bfbc8b 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1252,8 +1252,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 	spin_unlock(&fsc->async_unlink_conflict_lock);
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_UNLINK;
-	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT);
+	clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags);
 	spin_unlock(&dentry->d_lock);
 
 	synchronize_rcu();
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6587c2d5af1e0..147126d2fa0c7 100644
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



