Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328CE28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C427C433EF;
	Mon, 30 Jan 2023 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087371;
	bh=WUtnCjGqhXJxgyeVV2uC+3CrYHlsH5C1UpVKgFfVc7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dP9xsSff/bEzxDePQ90bGuL3LsryYem0U3jeuC7BPS9QmqZTIWqs7wmDczq8YgCoi
	 hKpo+7D0Mn9zBGkIKTNt1JVLVzTU3r7eKr9ffhDijXUuoAFcMiqs+J2eezOBXSA2XN
	 BJrJeP6UTZioa+kgwvaKHI2K0k6/vRSJJzeF+nOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/313] tools/nolibc: fix missing includes causing build issues at -O0
Date: Mon, 30 Jan 2023 14:50:03 +0100
Message-Id: <20230130134344.484713606@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 55abdd1f5e1e07418bf4a46c233a92f83cb5ae97 ]

After the nolibc includes were split to facilitate portability from
standard libcs, programs that include only what they need may miss
some symbols which are needed by libgcc. This is the case for raise()
which is needed by the divide by zero code in some architectures for
example.

Regardless, being able to include only the apparently needed files is
convenient.

Instead of trying to move all exported definitions to a single file,
since this can change over time, this patch takes another approach
consisting in including the nolibc header at the end of all standard
include files. This way their types and functions are already known
at the moment of inclusion, and including any single one of them is
sufficient to bring all the required ones.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/ctype.h  | 3 +++
 tools/include/nolibc/errno.h  | 3 +++
 tools/include/nolibc/signal.h | 3 +++
 tools/include/nolibc/stdio.h  | 3 +++
 tools/include/nolibc/stdlib.h | 3 +++
 tools/include/nolibc/string.h | 3 +++
 tools/include/nolibc/sys.h    | 2 ++
 tools/include/nolibc/time.h   | 3 +++
 tools/include/nolibc/types.h  | 3 +++
 tools/include/nolibc/unistd.h | 3 +++
 10 files changed, 29 insertions(+)

diff --git a/tools/include/nolibc/ctype.h b/tools/include/nolibc/ctype.h
index e3000b2992d7..6f90706d0644 100644
--- a/tools/include/nolibc/ctype.h
+++ b/tools/include/nolibc/ctype.h
@@ -96,4 +96,7 @@ int ispunct(int c)
 	return isgraph(c) && !isalnum(c);
 }
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_CTYPE_H */
diff --git a/tools/include/nolibc/errno.h b/tools/include/nolibc/errno.h
index 06893d6dfb7a..9dc4919c769b 100644
--- a/tools/include/nolibc/errno.h
+++ b/tools/include/nolibc/errno.h
@@ -24,4 +24,7 @@ static int errno;
  */
 #define MAX_ERRNO 4095
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_ERRNO_H */
diff --git a/tools/include/nolibc/signal.h b/tools/include/nolibc/signal.h
index ef47e71e2be3..137552216e46 100644
--- a/tools/include/nolibc/signal.h
+++ b/tools/include/nolibc/signal.h
@@ -19,4 +19,7 @@ int raise(int signal)
 	return sys_kill(sys_getpid(), signal);
 }
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_SIGNAL_H */
diff --git a/tools/include/nolibc/stdio.h b/tools/include/nolibc/stdio.h
index a3cebc4bc3ac..96ac8afc5aee 100644
--- a/tools/include/nolibc/stdio.h
+++ b/tools/include/nolibc/stdio.h
@@ -303,4 +303,7 @@ void perror(const char *msg)
 	fprintf(stderr, "%s%serrno=%d\n", (msg && *msg) ? msg : "", (msg && *msg) ? ": " : "", errno);
 }
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_STDIO_H */
diff --git a/tools/include/nolibc/stdlib.h b/tools/include/nolibc/stdlib.h
index 92378c4b9660..a24000d1e822 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -419,4 +419,7 @@ char *u64toa(uint64_t in)
 	return itoa_buffer;
 }
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_STDLIB_H */
diff --git a/tools/include/nolibc/string.h b/tools/include/nolibc/string.h
index ad97c0d522b8..0932db3817d2 100644
--- a/tools/include/nolibc/string.h
+++ b/tools/include/nolibc/string.h
@@ -285,4 +285,7 @@ char *strrchr(const char *s, int c)
 	return (char *)ret;
 }
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_STRING_H */
diff --git a/tools/include/nolibc/sys.h b/tools/include/nolibc/sys.h
index ce3ee03aa679..78473d34e27c 100644
--- a/tools/include/nolibc/sys.h
+++ b/tools/include/nolibc/sys.h
@@ -1243,5 +1243,7 @@ ssize_t write(int fd, const void *buf, size_t count)
 	return ret;
 }
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
 
 #endif /* _NOLIBC_SYS_H */
diff --git a/tools/include/nolibc/time.h b/tools/include/nolibc/time.h
index d18b7661fdd7..84655361b9ad 100644
--- a/tools/include/nolibc/time.h
+++ b/tools/include/nolibc/time.h
@@ -25,4 +25,7 @@ time_t time(time_t *tptr)
 	return tv.tv_sec;
 }
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_TIME_H */
diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index f1d64fca7cf0..fbbc0e68c001 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -209,4 +209,7 @@ struct stat {
 })
 #endif
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_TYPES_H */
diff --git a/tools/include/nolibc/unistd.h b/tools/include/nolibc/unistd.h
index 1c25e20ee360..1cfcd52106a4 100644
--- a/tools/include/nolibc/unistd.h
+++ b/tools/include/nolibc/unistd.h
@@ -51,4 +51,7 @@ int tcsetpgrp(int fd, pid_t pid)
 	return ioctl(fd, TIOCSPGRP, &pid);
 }
 
+/* make sure to include all global symbols */
+#include "nolibc.h"
+
 #endif /* _NOLIBC_UNISTD_H */
-- 
2.39.0



