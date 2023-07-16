Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A71F8F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25CEC433C8;
	Sun, 16 Jul 2023 20:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539470;
	bh=Km6hG8ZsTC5iv9Ltr1CUws0IQFbNQzRmKE6aMMqvH0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulql2otalMdBAiXcWVhnIRvg5Lmzv6O9fnbWwUpOMmeUvmasoqRQpLXos0q5WrOrU
	 Sc0OSxOPJloIlXUUxbufaaegYRmtTIxbiey/A59j9NSAbUHPHLfjg7smb6qSV5aCu3
	 rziZZ2GFO8l7AUOT2xq0Q3+hdVuDUOFVhIGVe1aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Wang <shawnwang@linux.alibaba.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/591] x86/resctrl: Only show tasks pid in current pid namespace
Date: Sun, 16 Jul 2023 21:42:28 +0200
Message-ID: <20230716194924.104509818@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shawn Wang <shawnwang@linux.alibaba.com>

[ Upstream commit 2997d94b5dd0e8b10076f5e0b6f18410c73e28bd ]

When writing a task id to the "tasks" file in an rdtgroup,
rdtgroup_tasks_write() treats the pid as a number in the current pid
namespace. But when reading the "tasks" file, rdtgroup_tasks_show() shows
the list of global pids from the init namespace, which is confusing and
incorrect.

To be more robust, let the "tasks" file only show pids in the current pid
namespace.

Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Signed-off-by: Shawn Wang <shawnwang@linux.alibaba.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Fenghua Yu <fenghua.yu@intel.com>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/all/20230116071246.97717-1-shawnwang@linux.alibaba.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index c7f1c7cb1963b..15ee89ce8c68c 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -731,11 +731,15 @@ static ssize_t rdtgroup_tasks_write(struct kernfs_open_file *of,
 static void show_rdt_tasks(struct rdtgroup *r, struct seq_file *s)
 {
 	struct task_struct *p, *t;
+	pid_t pid;
 
 	rcu_read_lock();
 	for_each_process_thread(p, t) {
-		if (is_closid_match(t, r) || is_rmid_match(t, r))
-			seq_printf(s, "%d\n", t->pid);
+		if (is_closid_match(t, r) || is_rmid_match(t, r)) {
+			pid = task_pid_vnr(t);
+			if (pid)
+				seq_printf(s, "%d\n", pid);
+		}
 	}
 	rcu_read_unlock();
 }
-- 
2.39.2



