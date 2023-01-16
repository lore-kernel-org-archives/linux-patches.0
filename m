Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C48446B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CEFC433D2;
	Mon, 16 Jan 2023 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885478;
	bh=l4mdijT3DXLoB3FEQAQQT3XWHgMtUjdefbiHKLqvrG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBm87mI6N4i12Br9W4HFrtgS4pRXsRif99O9TJGUpXOVRd6Mxt1H3DeucPr/L3ZIK
	 LBKan9i0ewuSzvrtgUW/djd7lg/q5/a0w/cd4EGq7ayAv+1O6a8ERQG8GAVArn2ea8
	 WN7I38ln5HIiBwoH4/7zEDTWWC3mYGjQIklibqr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/658] proc: fixup uptime selftest
Date: Mon, 16 Jan 2023 16:42:27 +0100
Message-Id: <20230116154912.378055748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 5cc81d5c81af0dee54da9a67a3ebe4be076a13db ]

syscall(3) returns -1 and sets errno on error, unlike "syscall"
instruction.

Systems which have <= 32/64 CPUs are unaffected. Test won't bounce
to all CPUs before completing if there are more of them.

Link: https://lkml.kernel.org/r/Y1bUiT7VRXlXPQa1@p183
Fixes: 1f5bd0547654 ("proc: selftests: test /proc/uptime")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/proc/proc-uptime-002.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/proc/proc-uptime-002.c b/tools/testing/selftests/proc/proc-uptime-002.c
index e7ceabed7f51..7d0aa22bdc12 100644
--- a/tools/testing/selftests/proc/proc-uptime-002.c
+++ b/tools/testing/selftests/proc/proc-uptime-002.c
@@ -17,6 +17,7 @@
 // while shifting across CPUs.
 #undef NDEBUG
 #include <assert.h>
+#include <errno.h>
 #include <unistd.h>
 #include <sys/syscall.h>
 #include <stdlib.h>
@@ -54,7 +55,7 @@ int main(void)
 		len += sizeof(unsigned long);
 		free(m);
 		m = malloc(len);
-	} while (sys_sched_getaffinity(0, len, m) == -EINVAL);
+	} while (sys_sched_getaffinity(0, len, m) == -1 && errno == EINVAL);
 
 	fd = open("/proc/uptime", O_RDONLY);
 	assert(fd >= 0);
-- 
2.35.1



