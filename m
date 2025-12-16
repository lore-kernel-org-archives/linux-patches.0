Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E02B354AD6;
	Tue, 16 Dec 2025 12:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886472; cv=none; b=HOAZUKj9cPZ1whjorgujRTM3qF+kkzP6VNTOWQW1E49SrVqilIVrkyxhXdNCj76e7rCIqHjARMGyPa3+q5g1WjOVcY+DV7JATzkDz1KJ3DiELkwtdI3Wef4uYtSuTGV0QHAYx37LcFMjWbozbV4DJtm/Nc6YpibT+/I8ZFwHEUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886472; c=relaxed/simple;
	bh=CD3eXij185Am3RCPWPQVu0mlFoVdPA1IjVYTL57Cvnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7tpYZNU0ia0z6y4FyBpxNfaCOWqeifd+fQM8gR8q2/hWpHvpDWsEh4xSK0nVq+S3suMqbj50K6meXSYebC80FIDojKvQm1OAyNkYdpIPQvyyX6gX86NS2KfeiUX0ZUL2u/nnhRNgNh0tlleU1JQuY0YBcQaMYtxHsc7y2R/i8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=er1XFvcR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="er1XFvcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95686C4CEF1;
	Tue, 16 Dec 2025 12:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886472;
	bh=CD3eXij185Am3RCPWPQVu0mlFoVdPA1IjVYTL57Cvnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=er1XFvcR3cSczu5cazfZ05YfDxQU8V6xcFEj6xptba4I50KwSncMQD2Ex5Gaigt5h
	 XrIXPUf6chZFCcIqRHY2gxtZ/zbXwTpb0WyW5z3idTjBwNnFpJe26hghld1n5q2atm
	 Di+Ixo/GXbw8euYOXPOpvfiVUpS+NOjeF861McaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 446/507] panthor: save task pid and comm in panthor_group
Date: Tue, 16 Dec 2025 12:14:47 +0100
Message-ID: <20251216111401.612331658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 33b9cb6dcda2520600ac4fec725946af32c2e586 ]

We would like to report them on gpu errors.

We choose to save the info on panthor_group_create rather than on
panthor_open because, when the two differ, we are more interested in the
task that created the group.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250718063816.1452123-3-olvaffe@gmail.com
Stable-dep-of: eec7e23d848d ("drm/panthor: Prevent potential UAF in group creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 99ce0948f2bae..35c4a86fe3052 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -641,6 +641,15 @@ struct panthor_group {
 		size_t kbo_sizes;
 	} fdinfo;
 
+	/** @task_info: Info of current->group_leader that created the group. */
+	struct {
+		/** @task_info.pid: pid of current->group_leader */
+		pid_t pid;
+
+		/** @task_info.comm: comm of current->group_leader */
+		char comm[TASK_COMM_LEN];
+	} task_info;
+
 	/** @state: Group state. */
 	enum panthor_group_state state;
 
@@ -3391,6 +3400,14 @@ group_create_queue(struct panthor_group *group,
 	return ERR_PTR(ret);
 }
 
+static void group_init_task_info(struct panthor_group *group)
+{
+	struct task_struct *task = current->group_leader;
+
+	group->task_info.pid = task->pid;
+	get_task_comm(group->task_info.comm, task);
+}
+
 static void add_group_kbo_sizes(struct panthor_device *ptdev,
 				struct panthor_group *group)
 {
@@ -3542,6 +3559,8 @@ int panthor_group_create(struct panthor_file *pfile,
 	add_group_kbo_sizes(group->ptdev, group);
 	spin_lock_init(&group->fdinfo.lock);
 
+	group_init_task_info(group);
+
 	return gid;
 
 err_put_group:
-- 
2.51.0



