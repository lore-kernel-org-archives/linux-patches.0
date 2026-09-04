Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5CC414DF6;
	Fri,  4 Sep 2026 06:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501816; cv=none; b=NFWLJxwHYWWdei8L9pvqmTh/BIX3vr4gwjh1O/YHHxHnVdAltmmG/R859QXAYrSk+bAoY6BpKizq/d7dJLZy2KVRZY1vNI8l00hkop6efDPxQgV1UA48wdt2IGe/cRjOp8CZKAOZIx8KhBkLfSuqUu6WWXcGU9brYGAtQb3ZQ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501816; c=relaxed/simple;
	bh=hrG2xd2jq9O916g+vHkvSFmCRQamNtW6CKBQN96xvtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBroCdwWrlSwjFM9LDCuhcGDhndOUsWUbCSxcY0nV2URMQuC75KC8Ao9v/cOXYCqU5tN7rcG9ZAVmAjhwn/wPbBzXpy5OaTokZICokGvJwc5T33DVICw0cAI3FLif0lMfwv3A9tswtHgvdaQLYbWIEJj+3P+iKUtqWQvmtdXEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Bilv2Nf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Bilv2Nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0281F00A3D;
	Fri,  4 Sep 2026 06:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501814;
	bh=6/46i5kt24y0hjXPNNcxHUd3j6iYlXCPOPXEgigxvZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Bilv2NfROVDMlDxhEv/tgv2FfGN9xgMTmtPaV2tKBMgPFNU+Rvxs+VEFQXiThEEq
	 Td1PSBzHv4SmPxismOuY+S3d/XnHegSmIRTHRcmeJ0WcT1S/7ClUAMCk53rV1O5oS3
	 YdHkV/AFAluseoMXkhgFs1QkBdiTp2c2El0lFAwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Bradley Morgan <include@grrlz.net>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Joel Granados <joel.granados@kernel.org>
Subject: [PATCH 6.18 543/552] sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]
Date: Fri,  4 Sep 2026 07:01:40 +0200
Message-ID: <20260904045802.917519270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -715,29 +715,6 @@ static struct ctl_table_root pid_table_r
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
@@ -748,14 +725,6 @@ static const struct ctl_table pid_table[
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


