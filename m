Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0463329D26E;
	Wed, 20 May 2026 17:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298356; cv=none; b=e9sa7M6nV8w0lozALC7UIMYiVyY8A2NfDMhw0k2WoAxOGHK3Msu0WWosW6z1ZCc0w+QTYlMjkQlhDauHK9zya6M/Ff1Q4j7LTYtMq4t6p4ClalLkt0eFjK7SZ0GGkBHqHb8imerYcNPMnZYDmypqS3zE+Foa2+py+PFhnU31PEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298356; c=relaxed/simple;
	bh=k1XDkYqeyGI0FnNd/BfleVPsI0RnRy+u4zqdplCdkhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsDWy0KynSBdrimf50Wf69LVE9gniCM+OJtR262g/OvbrWRhiQWwnxoG09Can3kfhM83zYCShG3Mczy3XyGQVFORaYukkbu3IbAi4sdEoXN2/bBEm6XQq3Ezq1BVDsoCJWu/x50v+dMV268ApMdx1CxX6RhGuxbzNdSJP0w7BtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgNiWWZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgNiWWZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6572A1F000E9;
	Wed, 20 May 2026 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298354;
	bh=/M829w2uEgTx/MUcfNsk/RYEedevuFw07XVgTa1/b0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgNiWWZwTK7jb3NWu1oz14/lkpDSuX36QeYISRmKWFybgGa6d/vHtvFk+2bGpEUaL
	 yuKjEJFIf5EiJFKeJ+DHky62nAJYhZn2MTv0+1oZBoaVy2dr6rfxotAEu6lc+rYXng
	 NC3whwfkMx/Yz9sg5hNofCJJIegLTy46ztf3FHPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 352/957] rtla: Replace atoi() with a robust strtoi()
Date: Wed, 20 May 2026 18:13:55 +0200
Message-ID: <20260520162142.164769391@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit 7e9dfccf8f11c26208211457c4597a466135b56a ]

The atoi() function does not perform error checking, which can lead to
undefined behavior when parsing invalid or out-of-range strings. This
can cause issues when parsing user-provided numerical inputs, such as
signal numbers, PIDs, or CPU lists.

To address this, introduce a new strtoi() helper function that safely
converts a string to an integer. This function validates the input and
checks for overflows, returning a negative value on  failure.

Replace all calls to atoi() with the new strtoi() function and add
proper error handling to make the parsing more robust and prevent
potential issues.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260106133655.249887-5-wander@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Stable-dep-of: 5b6dc659ad79 ("rtla/utils: Fix resource leak in set_comm_sched_attr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/actions.c |  7 +++---
 tools/tracing/rtla/src/utils.c   | 40 ++++++++++++++++++++++++++++----
 tools/tracing/rtla/src/utils.h   |  2 ++
 3 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/tools/tracing/rtla/src/actions.c b/tools/tracing/rtla/src/actions.c
index 15986505b4376..4274fa0894b04 100644
--- a/tools/tracing/rtla/src/actions.c
+++ b/tools/tracing/rtla/src/actions.c
@@ -181,12 +181,13 @@ actions_parse(struct actions *self, const char *trigger, const char *tracefn)
 		/* Takes two arguments, num (signal) and pid */
 		while (token != NULL) {
 			if (strlen(token) > 4 && strncmp(token, "num=", 4) == 0) {
-				signal = atoi(token + 4);
+				if (strtoi(token + 4, &signal))
+					return -1;
 			} else if (strlen(token) > 4 && strncmp(token, "pid=", 4) == 0) {
 				if (strncmp(token + 4, "parent", 7) == 0)
 					pid = -1;
-				else
-					pid = atoi(token + 4);
+				else if (strtoi(token + 4, &pid))
+					return -1;
 			} else {
 				/* Invalid argument */
 				return -1;
diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index bd5f34b446480..6b7717fcd142b 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -17,6 +17,7 @@
 #include <fcntl.h>
 #include <sched.h>
 #include <stdio.h>
+#include <limits.h>
 
 #include "utils.h"
 
@@ -112,16 +113,18 @@ int parse_cpu_set(char *cpu_list, cpu_set_t *set)
 	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
 
 	for (p = cpu_list; *p; ) {
-		cpu = atoi(p);
-		if (cpu < 0 || (!cpu && *p != '0') || cpu >= nr_cpus)
+		if (strtoi(p, &cpu))
+			goto err;
+		if (cpu < 0 || cpu >= nr_cpus)
 			goto err;
 
 		while (isdigit(*p))
 			p++;
 		if (*p == '-') {
 			p++;
-			end_cpu = atoi(p);
-			if (end_cpu < cpu || (!end_cpu && *p != '0') || end_cpu >= nr_cpus)
+			if (strtoi(p, &end_cpu))
+				goto err;
+			if (end_cpu < cpu || end_cpu >= nr_cpus)
 				goto err;
 			while (isdigit(*p))
 				p++;
@@ -322,6 +325,7 @@ int set_comm_sched_attr(const char *comm_prefix, struct sched_attr *attr)
 	struct dirent *proc_entry;
 	DIR *procfs;
 	int retval;
+	int pid;
 
 	if (strlen(comm_prefix) >= MAX_PATH) {
 		err_msg("Command prefix is too long: %d < strlen(%s)\n",
@@ -341,8 +345,12 @@ int set_comm_sched_attr(const char *comm_prefix, struct sched_attr *attr)
 		if (!retval)
 			continue;
 
+		if (strtoi(proc_entry->d_name, &pid)) {
+			err_msg("'%s' is not a valid pid", proc_entry->d_name);
+			goto out_err;
+		}
 		/* procfs_is_workload_pid confirmed it is a pid */
-		retval = __set_sched_attr(atoi(proc_entry->d_name), attr);
+		retval = __set_sched_attr(pid, attr);
 		if (retval) {
 			err_msg("Error setting sched attributes for pid:%s\n", proc_entry->d_name);
 			goto out_err;
@@ -985,3 +993,25 @@ char *parse_optional_arg(int argc, char **argv)
 		return NULL;
 	}
 }
+
+/*
+ * strtoi - convert string to integer with error checking
+ *
+ * Returns 0 on success, -1 if conversion fails or result is out of int range.
+ */
+int strtoi(const char *s, int *res)
+{
+	char *end_ptr;
+	long lres;
+
+	if (!*s)
+		return -1;
+
+	errno = 0;
+	lres = strtol(s, &end_ptr, 0);
+	if (errno || *end_ptr || lres > INT_MAX || lres < INT_MIN)
+		return -1;
+
+	*res = (int) lres;
+	return 0;
+}
diff --git a/tools/tracing/rtla/src/utils.h b/tools/tracing/rtla/src/utils.h
index d8d83abf0f0d0..f11d27927223c 100644
--- a/tools/tracing/rtla/src/utils.h
+++ b/tools/tracing/rtla/src/utils.h
@@ -3,6 +3,7 @@
 #include <stdint.h>
 #include <time.h>
 #include <sched.h>
+#include <stdbool.h>
 
 /*
  * '18446744073709551615\0'
@@ -81,6 +82,7 @@ static inline int set_deepest_cpu_idle_state(unsigned int cpu, unsigned int stat
 static inline int have_libcpupower_support(void) { return 0; }
 #endif /* HAVE_LIBCPUPOWER_SUPPORT */
 int auto_house_keeping(cpu_set_t *monitored_cpus);
+__attribute__((__warn_unused_result__)) int strtoi(const char *s, int *res);
 
 #define ns_to_usf(x) (((double)x/1000))
 #define ns_to_per(total, part) ((part * 100) / (double)total)
-- 
2.53.0



