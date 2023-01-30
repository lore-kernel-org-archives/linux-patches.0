Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB7728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CD2C433EF;
	Mon, 30 Jan 2023 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087337;
	bh=BVfgJYf8DdIXe/cFOZ4IcMp89+q2M0YekY2x0j9Us7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1s5QwOSK204pxx9+tytqBqUug4E+KHzI7qOSmq3MbjMeJaaodLdPHMIbUOQ6nsp/
	 O9eHHkuKyrKfYrAF8ZvxRTZjpKXy8iNqXjYzO0RPuoAH+MXI3Ty8EOAdLKEd1ruM2R
	 17ClT3T/rCKBTvjHsPKOagYfkMVfdxB13oH0tbrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Warner Losh <imp@bsdimp.com>,
	Willy Tarreau <w@1wt.eu>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/313] tools/nolibc: Fix S_ISxxx macros
Date: Mon, 30 Jan 2023 14:50:02 +0100
Message-Id: <20230130134344.432835315@linuxfoundation.org>
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

From: Warner Losh <imp@bsdimp.com>

[ Upstream commit 16f5cea74179b5795af7ce359971f5128d10f80e ]

The mode field has the type encoded as an value in a field, not as a bit
mask. Mask the mode with S_IFMT instead of each type to test. Otherwise,
false positives are possible: eg S_ISDIR will return true for block
devices because S_IFDIR = 0040000 and S_IFBLK = 0060000 since mode is
masked with S_IFDIR instead of S_IFMT. These macros now match the
similar definitions in tools/include/uapi/linux/stat.h.

Signed-off-by: Warner Losh <imp@bsdimp.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/types.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index 300e0ff1cd58..f1d64fca7cf0 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -26,13 +26,13 @@
 #define S_IFSOCK       0140000
 #define S_IFMT         0170000
 
-#define S_ISDIR(mode)  (((mode) & S_IFDIR)  == S_IFDIR)
-#define S_ISCHR(mode)  (((mode) & S_IFCHR)  == S_IFCHR)
-#define S_ISBLK(mode)  (((mode) & S_IFBLK)  == S_IFBLK)
-#define S_ISREG(mode)  (((mode) & S_IFREG)  == S_IFREG)
-#define S_ISFIFO(mode) (((mode) & S_IFIFO)  == S_IFIFO)
-#define S_ISLNK(mode)  (((mode) & S_IFLNK)  == S_IFLNK)
-#define S_ISSOCK(mode) (((mode) & S_IFSOCK) == S_IFSOCK)
+#define S_ISDIR(mode)  (((mode) & S_IFMT) == S_IFDIR)
+#define S_ISCHR(mode)  (((mode) & S_IFMT) == S_IFCHR)
+#define S_ISBLK(mode)  (((mode) & S_IFMT) == S_IFBLK)
+#define S_ISREG(mode)  (((mode) & S_IFMT) == S_IFREG)
+#define S_ISFIFO(mode) (((mode) & S_IFMT) == S_IFIFO)
+#define S_ISLNK(mode)  (((mode) & S_IFMT) == S_IFLNK)
+#define S_ISSOCK(mode) (((mode) & S_IFMT) == S_IFSOCK)
 
 /* dirent types */
 #define DT_UNKNOWN     0x0
-- 
2.39.0



