Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8106146582;
	Tue, 18 Jun 2024 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714878; cv=none; b=RJBhaH4fJLlh7aCkuOTWl2JT1RUs8mh24KkaYJoMOOj93PUYHqIbs5t/+ax1z5Xs0NBQ50qEjuh0Jp9mCPL0tFWxGYBs20BvqckUXMgyXJjch5BWABBk7WHdtJuA/+09QRV0gE63JcVUekMhRtf5d9kpxIqkugYzZzTki4y8AOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714878; c=relaxed/simple;
	bh=blmBFx/zoXcN/76w0uBEvzKVjyQATSXdScKSd3YFaN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igGcFGsAvjUZImIe4qIll5xabAE8cGQMD8ESOG257xi4iyNwfmsmYRzk3zwlW/MH7O5wvD7IhRA+iLC/Pbg+BEXo0TEP+JcfBpH2BhRK0OBGtC0zp26shZhz3uuBubSDzMMnocKXnt/utFjOVdrQdUFnbkPMD4Xxb6BmcMkWsvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJp8r3O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJp8r3O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E28C3277B;
	Tue, 18 Jun 2024 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714878;
	bh=blmBFx/zoXcN/76w0uBEvzKVjyQATSXdScKSd3YFaN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJp8r3O4G6qZjhq1VI+QtY8cRKAt1NYOl6HQVEUCbOv8pC9U/yw2Cri51BHf+0pyg
	 0ITxMPxB7owh8tQk/3787QZ0vpn9Sqe8yI0O52KgLZBnFlG5yBL/KLWmcdI7EfKl7w
	 QUFQW8nWR0hSwetdpsCjarIpo54IQqRUmPcz0ZHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/770] kcmp: In get_file_raw_ptr use task_lookup_fd_rcu
Date: Tue, 18 Jun 2024 14:29:33 +0200
Message-ID: <20240618123411.904189774@linuxfoundation.org>
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

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit ed77e80e14a3cd55c73848b9e8043020e717ce12 ]

Modify get_file_raw_ptr to use task_lookup_fd_rcu.  The helper
task_lookup_fd_rcu does the work of taking the task lock and verifying
that task->files != NULL and then calls files_lookup_fd_rcu.  So let
use the helper to make a simpler implementation of get_file_raw_ptr.

Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Link: https://lkml.kernel.org/r/20201120231441.29911-13-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcmp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index 5b2435e030472..5353edfad8e11 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -61,16 +61,11 @@ static int kcmp_ptr(void *v1, void *v2, enum kcmp_type type)
 static struct file *
 get_file_raw_ptr(struct task_struct *task, unsigned int idx)
 {
-	struct file *file = NULL;
+	struct file *file;
 
-	task_lock(task);
 	rcu_read_lock();
-
-	if (task->files)
-		file = files_lookup_fd_rcu(task->files, idx);
-
+	file = task_lookup_fd_rcu(task, idx);
 	rcu_read_unlock();
-	task_unlock(task);
 
 	return file;
 }
-- 
2.43.0



