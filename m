Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D114F8B0;
	Tue, 23 Jan 2024 01:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974644; cv=none; b=F9krwv+X7PCbPjG0ZhKosUjTnF7Fx3QdLtc3ziOr0hNjs6NBWvmmcmdheType8JOm9JM1ZrwP+oIznoSllhySFvuJ8bTAddZslpqGi4wr7m8Rm/MaSLvY9RggxX89b1Z2HxoD+vbKWt3vE84BLoA6eJOtrdHRRdZ2K4mPUN/+0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974644; c=relaxed/simple;
	bh=vTmtdlu8d+vyVWoxsY2W0FVSwwtBuEZxzpVslbcU3fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3nEd45/rSehZiGQFkAsxHozjpbWwiMTfGliJo/WeNG3HD8RL+HdtDsMvcZUalyJ/nZ6re9kUp8T/2uX+feu5uwSoLa4OMwMPBXVvrxjkwwZMuUYijNgaohGaerJj3G+lTHKaERnvWA80SfbUCDMQP85QyRDgSNliDoUsJNphkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeBqMtIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeBqMtIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED78C433F1;
	Tue, 23 Jan 2024 01:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974644;
	bh=vTmtdlu8d+vyVWoxsY2W0FVSwwtBuEZxzpVslbcU3fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeBqMtIGAyduE+xHzCCPgBCzfGak5GneBImi4yMQYyyFkNdPl7HgF+C2i5uxVoZ98
	 eVj47oGr7B850AzefhJVIKR8v1Rfx5w4B3WAe/OVWg5yU9egD6qGL70lFyQMKGp9Vt
	 gl1rpwznAoVcbmmF7gmWnE/C016ze80Hh7MvbOBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/583] NFS: Use parents objective cred in nfs_access_login_time()
Date: Mon, 22 Jan 2024 15:52:08 -0800
Message-ID: <20240122235814.517096813@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e6a51fd94fea..9fc5061d51b2 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2968,7 +2968,7 @@ static u64 nfs_access_login_time(const struct task_struct *task,
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



