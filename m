Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345CA7F4
	for <patches@lists.linux.dev>; Wed,  3 May 2023 02:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gZLowJ+U8tFe9A6tdq+4RG9BmgHRQCFQgaNSl8HIKis=; b=SKXJ5IgU6w8xBXNodKYmsbADQa
	cb8ozKk18M/mDru7G0yM6uTr6c/OC29VFiVzDJFlrCzh+KqsLYMvsJ2QqWMtJtBP+n+Dv5MrGU6H/
	4TFC1mmuf/viW0hG9+M3JdQRLC+PE5V4O/NK8QS5F89gnuqOWWeLLaoaWwafmOC3SBHDT/frGe8i1
	Unp/Po+yuLJuV2XbXmIVwtIMbgLumgGqUOCoGSsXI9YLiiErK6K1CRpfqBoMaXaw9xWr6hedF0dTZ
	PqpMAE1NGqiSUWsRqxYMsFN7qd6/4OvnpvS12cc8+yqPZ8JjPEiv4Yhk4E4mXyTY0XmPBJphzMb7s
	UdzsfPSw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pu2J8-0039fH-2V;
	Wed, 03 May 2023 02:33:30 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: torvalds@linux-foundation.org
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	ebiggers@kernel.org,
	jeffxu@google.com,
	akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 1/2] kernel: pid_namespace: simplify sysctls with register_sysctl()
Date: Tue,  2 May 2023 19:33:28 -0700
Message-Id: <20230503023329.752123-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230503023329.752123-1-mcgrof@kernel.org>
References: <20230503023329.752123-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

register_sysctl_paths() is only required if your child (directories)
have entries and pid_namespace does not. So use register_sysctl_init()
instead where we don't care about the return value and use
register_sysctl() where we do.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Jeff Xu <jeffxu@google.com>
Link: https://lore.kernel.org/r/20230302202826.776286-9-mcgrof@kernel.org
---
 kernel/pid_namespace.c | 3 +--
 kernel/pid_sysctl.h    | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 46e0d5a3f91f..b43eee07b00c 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -314,7 +314,6 @@ static struct ctl_table pid_ns_ctl_table[] = {
 	},
 	{ }
 };
-static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
 #endif	/* CONFIG_CHECKPOINT_RESTORE */
 
 int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
@@ -473,7 +472,7 @@ static __init int pid_namespaces_init(void)
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC | SLAB_ACCOUNT);
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
-	register_sysctl_paths(kern_path, pid_ns_ctl_table);
+	register_sysctl_init("kernel", pid_ns_ctl_table);
 #endif
 
 	register_pid_ns_sysctl_table_vm();
diff --git a/kernel/pid_sysctl.h b/kernel/pid_sysctl.h
index e22d072e1e24..d67a4d45bb42 100644
--- a/kernel/pid_sysctl.h
+++ b/kernel/pid_sysctl.h
@@ -46,10 +46,9 @@ static struct ctl_table pid_ns_ctl_table_vm[] = {
 	},
 	{ }
 };
-static struct ctl_path vm_path[] = { { .procname = "vm", }, { } };
 static inline void register_pid_ns_sysctl_table_vm(void)
 {
-	register_sysctl_paths(vm_path, pid_ns_ctl_table_vm);
+	register_sysctl("vm", pid_ns_ctl_table_vm);
 }
 #else
 static inline void initialize_memfd_noexec_scope(struct pid_namespace *ns) {}
-- 
2.39.2

