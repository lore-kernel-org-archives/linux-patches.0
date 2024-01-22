Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3151914A4E5;
	Tue, 23 Jan 2024 00:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969224; cv=none; b=hceOQMCsMtFou6G/BGmGTin+doFAVq863FGzNJJA0zNPAc76bBOJKtln0k0IFwQkb60T2B4qm+zuvfcQAjTGpowsjiJKssSL0KhnDJajV6/M6Eta35bvOJRQ4LYcK3Id+gR/QePrUz5DT4iyt8xqIEhm1P6kGx2A2JjTYEoN05Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969224; c=relaxed/simple;
	bh=33qGrX9gqL2n0t8qcOWlfJ6aUXAlPvbxAIeojco+XYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4POGuD47HUqMX2m36+/+i+30/0y+850MtVP6m8w+V5JpJwJMfQkSbCnf4aTyzR1OYhmA7v6rpzO7ZV1ZGBIGzY2k9xfLyb8h2RqIo7jdj+rG90f/SnsBBLqZNXpgfA/mhT0PhOktlotcCiomaAXBEyUAPa5SUWo2C+NYjL0stQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dl1L8VK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl1L8VK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9484C43394;
	Tue, 23 Jan 2024 00:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969224;
	bh=33qGrX9gqL2n0t8qcOWlfJ6aUXAlPvbxAIeojco+XYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dl1L8VK2+c2p9xaysnPwOtvu3JcOzZ549JZu8zfFgDLTesoPENWu3tmCk2y0yo72d
	 rZbulpEvgIgDLfiY73LQAzBDvf2+UwpYxVbD0uymFtKOwO1uoJvGuM81yWXc70Jg1B
	 UloC8Kt1rFdvuB1YzzSGz8L1VR3rU67yvQs/LS0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 086/641] NFS: Use parents objective cred in nfs_access_login_time()
Date: Mon, 22 Jan 2024 15:49:50 -0800
Message-ID: <20240122235820.723845607@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit a10a9233073d984b239e22358ba21825e27e2e88 ]

The subjective cred (task->cred) can potentially be overridden and
subsquently freed in non-RCU context, which could lead to a panic if we
try to use it in cred_fscmp().  Use __task_cred(), which returns the
objective cred (task->real_cred) instead.

Fixes: 0eb43812c027 ("NFS: Clear the file access cache upon login")
Fixes: 5e9a7b9c2ea1 ("NFS: Fix up a sparse warning")

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 13dffe4201e6..273c0b68abf4 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2963,7 +2963,7 @@ static u64 nfs_access_login_time(const struct task_struct *task,
 	rcu_read_lock();
 	for (;;) {
 		parent = rcu_dereference(task->real_parent);
-		pcred = rcu_dereference(parent->cred);
+		pcred = __task_cred(parent);
 		if (parent == task || cred_fscmp(pcred, cred) != 0)
 			break;
 		task = parent;
-- 
2.43.0



