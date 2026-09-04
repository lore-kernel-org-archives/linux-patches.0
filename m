Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AEA4CCDC7;
	Fri,  4 Sep 2026 05:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500249; cv=none; b=aKpR06LaSji1SP8kyMnQv1P6uTlVC07Z9XRZcQwqJ2+AtTS/3v+fWR488fepPBdyeQYVMPwPycYQ5Eq2iMsYY4n0P9WFKSBxStB//8XBnWQMb0Xs76SpqtNfVTY6JDsVTVErU6MG063ArR+pi/LbxjORa7xN+RnSg1gwXHNd7hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500249; c=relaxed/simple;
	bh=PIUKwPFHRxZhcMALnm4KtBvtaNipzkJV6nKJx2P0UfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugbowKslSB6zTAPyCjTY+X+S2S013TrgXdBXASCc1mtaALFEuJfUtdmG3APA6AUTxgsh7cx+2q32VQik8VvVK1yhp0NmOJi4XSlvPoiP7kd3D97UywQ2RxnErMBVr5T4pWX2zpR4Gevln2CGjFV3GyZ3Kvgnf+SW56i/Zp1ljGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oilQAR5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oilQAR5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EEB1F00A3D;
	Fri,  4 Sep 2026 05:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500247;
	bh=amtz/JLz9+ByXrx5V6olXeH6HbpQnipPpOupT3h7c9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oilQAR5+gAls+uquEJ25eQQx1KYvKc4m7jmWxmNKDlOB3ZkJUkJmQwS6PHgkX231l
	 mCCs/SF/pfpJTX39h324hgzL81j2Ml5OHqDx4Cc3+Tiv1X9vxyhZ0alvvtIJavi6Ek
	 EPkG3k2IMf03raV0X+1TE7yqLjet14CnB0JdvI6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Bradley Morgan <include@grrlz.net>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Joel Granados <joel.granados@kernel.org>
Subject: [PATCH 7.2 703/713] sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]
Date: Fri,  4 Sep 2026 07:01:11 +0200
Message-ID: <20260904045819.603933055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 7170ca01623b399c97f2ae9d3e228badc1f25ea3 upstream.

cad_pid is global, and kill_cad_pid() is only used in the root namespace.

However, due to pid_table_root_permissions(), a non-root user can unshare
pid/user namespaces and modify it from the child namespace. This makes no
sense and is simply wrong.

Move it to kern_reboot_table[] where it logically belongs; this ensures
that only GLOBAL_ROOT_UID can read/modify this sysctl.

Note that this patch doesn't preserve "#ifdef CONFIG_PROC_SYSCTL" around
the "cad_pid"; CONFIG_PROC_SYSCTL selects CONFIG_SYSCTL, so it is always
set when kern_reboot_table[] is compiled.

Cc: stable@vger.kernel.org
Fixes: e054bcbe7e7a ("sysctl: move cad_pid into kernel/pid.c")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/pid.c    |   31 -------------------------------
 kernel/reboot.c |   29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 31 deletions(-)

--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -766,29 +766,6 @@ static struct ctl_table_root pid_table_r
 	.set_ownership	= pid_table_root_set_ownership,
 };
 
-static int proc_do_cad_pid(const struct ctl_table *table, int write, void *buffer,
-		size_t *lenp, loff_t *ppos)
-{
-	struct pid *new_pid;
-	pid_t tmp_pid;
-	int r;
-	struct ctl_table tmp_table = *table;
-
-	tmp_pid = pid_vnr(cad_pid);
-	tmp_table.data = &tmp_pid;
-
-	r = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
-	if (r || !write)
-		return r;
-
-	new_pid = find_get_pid(tmp_pid);
-	if (!new_pid)
-		return -ESRCH;
-
-	put_pid(xchg(&cad_pid, new_pid));
-	return 0;
-}
-
 static const struct ctl_table pid_table[] = {
 	{
 		.procname	= "pid_max",
@@ -799,14 +776,6 @@ static const struct ctl_table pid_table[
 		.extra1		= &pid_max_min,
 		.extra2		= &pid_max_max,
 	},
-#ifdef CONFIG_PROC_SYSCTL
-	{
-		.procname	= "cad_pid",
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_do_cad_pid,
-	},
-#endif
 };
 #endif
 
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -1366,6 +1366,29 @@ static struct attribute *reboot_attrs[]
 };
 
 #ifdef CONFIG_SYSCTL
+static int proc_do_cad_pid(const struct ctl_table *table, int write, void *buffer,
+			   size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp_table = *table;
+	struct pid *new_pid;
+	pid_t tmp_pid;
+	int r;
+
+	tmp_pid = pid_vnr(cad_pid);
+	tmp_table.data = &tmp_pid;
+
+	r = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (r || !write)
+		return r;
+
+	new_pid = find_get_pid(tmp_pid);
+	if (!new_pid)
+		return -ESRCH;
+
+	put_pid(xchg(&cad_pid, new_pid));
+	return 0;
+}
+
 static const struct ctl_table kern_reboot_table[] = {
 	{
 		.procname       = "poweroff_cmd",
@@ -1381,6 +1404,12 @@ static const struct ctl_table kern_reboo
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+	{
+		.procname	= "cad_pid",
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_do_cad_pid,
+	},
 };
 
 static void __init kernel_reboot_sysctls_init(void)


