Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F812BDC0E;
	Sat, 12 Sep 2026 07:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197664; cv=none; b=SlgBnsJ3Mv3xPg6xU57CuTPqIkB2mdAynYTCx7Q19oNuIFS8635D0hgEJuWst0T+ZDZ0LVWFu5raJx1OB6aMRXIDxXW/ZLIgXbP8NrVvv7EOJIXDYQxDQGaHyac+GQ/n7H9K03T6+h4aBTA0VWTXMjsTCy5RlCrexCZBvD4MkzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197664; c=relaxed/simple;
	bh=oGcX/WHtC9+x/Xg9jyrPojCHCsIIo2EPMqy7GiifyDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sytgUqCeALu93CiIeqzlVsIqudx+geuUFtAmNFrg4JwLO2gfJXbCP+gR/xHfcbux+K2/vmLk7guMwokon7JPd0W+a4NItD7XEPCgJAITQbEtUUv8vkrBnrQVnSUOJWC4WT/kE15+hLTmjzfF3+wKxfwVhsdiGybv7ghy1f4MEbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taifl1x8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taifl1x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7059F1F000FF;
	Sat, 12 Sep 2026 07:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197662;
	bh=+0lONlo++ttuCbb+CdlWEx6ESTlnQZVXebdXoANIxjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taifl1x8YXZeV2l+HqgRTTEsEQZH684dtyp/LWBCnde0VMWrMJWieGdLaiD0jDQze
	 eMi88SkRMwKKGo2noTyIFug1NbZ7ECYobVP8V9aQoxFZJYU8TtXpFVQRA7EK+KvgK/
	 KFl9WZ/sYQL5j0D7nRK5SkmLYF5H3YDpAVbUmhww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0184/1815] perf test amd ibs: avoid using executable heap
Date: Sat, 12 Sep 2026 08:32:14 +0200
Message-ID: <20260912065653.323450743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit e34006e7435fdd2c8d15e89d2137a4bf22c16401 ]

Making [parts of] the heap executable is dangerous and is blocked by
SELinux on Fedora/RHEL even for an unconfined user. Replace the malloc()
+ mprotect() combo with just mmap(), creating a private anonymous rwx
mapping, which only requires the more commonly allowed "execmem"
permission under SELinux (things like JIT or regex compilation need it
as well). mmap() with MAP_ANONYMOUS will give us a zeroed mapping that
begins on a page boundary, so the result is equivalent to the original
code even without a memset() or the page-alignment dance.

Verified that the test still passes on a machine with an AMD CPU that
has the "ibs" CPU flag.

Fixes: 35db59fa8ea2 ("perf test amd ibs: Add sample period unit test")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/tests/amd-ibs-period.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/tools/perf/arch/x86/tests/amd-ibs-period.c b/tools/perf/arch/x86/tests/amd-ibs-period.c
index 6a92b3a23ed7a..32713f8fcd5c8 100644
--- a/tools/perf/arch/x86/tests/amd-ibs-period.c
+++ b/tools/perf/arch/x86/tests/amd-ibs-period.c
@@ -46,7 +46,6 @@ static int dummy_workload_1(unsigned long count)
 {
 	int (*func)(void);
 	int ret = 0;
-	char *p;
 	char insn1[] = {
 		0xb8, 0x01, 0x00, 0x00, 0x00, /* mov 1,%eax */
 		0xc3, /* ret */
@@ -59,18 +58,11 @@ static int dummy_workload_1(unsigned long count)
 		0xcc, /* int 3 */
 	};
 
-	p = calloc(2, page_size);
-	if (!p) {
-		printf("malloc() failed. %m");
-		return 1;
-	}
-
-	func = (void *)((unsigned long)(p + page_size - 1) & ~(page_size - 1));
-
-	ret = mprotect(func, page_size, PROT_READ | PROT_WRITE | PROT_EXEC);
-	if (ret) {
-		printf("mprotect() failed. %m");
-		goto out;
+	func = mmap(NULL, page_size, PROT_READ | PROT_WRITE | PROT_EXEC,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (func == MAP_FAILED) {
+		pr_debug("mmap() failed. %m\n");
+		return -1;
 	}
 
 	if (count < 100000)
@@ -93,7 +85,7 @@ static int dummy_workload_1(unsigned long count)
 	}
 
 out:
-	free(p);
+	munmap(func, page_size);
 	return ret;
 }
 
-- 
2.53.0



