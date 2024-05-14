Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1C222094;
	Tue, 14 May 2024 11:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686387; cv=none; b=QEeXgV0UOdsqELzmv/Hb+2smpBgh7TV5T0ysv7hlGsKGjz6LntZfCpzooeThPBUnEUuI7Bcu1pSL5/KR0NVs/opFnI9vGJ5wuNfWCu8ZXaIuUArfG+53WIp3BZmtGpCHb7fZJVtn+X5zezEQaENXMzzkbDRieZtIqY3at7fyiRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686387; c=relaxed/simple;
	bh=DknQsIefrZgZfTl0DWFflmCzKo3xdVrKJcE4D8Tjo+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYoBxf6nN3ZAZJJPS44upZs+vCbj6keG7ON4nC1eHlLu50bHGPyXVnQrXjZtJ7+pnsxzp6nv+gs6I0VtQvu1GdzFd8V9+Wu2KU/lCOCxLDaDbOMpuE2GCglNC4SWzmtuKaCfKKom+CPxb6dc/OkxCKYjwICO3bRwcTUWxFLPLIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wd3JvjQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wd3JvjQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98DDC2BD10;
	Tue, 14 May 2024 11:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686387;
	bh=DknQsIefrZgZfTl0DWFflmCzKo3xdVrKJcE4D8Tjo+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wd3JvjQ1WfI9cLdXed8M9vvajoAJYOXjxIHnR8UcDfMKiZ/TUUOZib0E2KpkjiuCS
	 mmRvTR0YOLpEg1GhinkaSlLcT8O8ByLEt4ffBbnB6cuWBIbPharJMeHwhCmTO7T+nx
	 6zgxV62wJipGwyGicRX851vOrLBuQb0fI/2PlLn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Smythies <dsmythies@telus.net>,
	Wyes Karny <wyes.karny@amd.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/236] tools/power turbostat: Increase the limit for fd opened
Date: Tue, 14 May 2024 12:17:55 +0200
Message-ID: <20240514101024.664348549@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wyes Karny <wyes.karny@amd.com>

[ Upstream commit 3ac1d14d0583a2de75d49a5234d767e2590384dd ]

When running turbostat, a system with 512 cpus reaches the limit for
maximum number of file descriptors that can be opened. To solve this
problem, the limit is raised to 2^15, which is a large enough number.

Below data is collected from AMD server systems while running turbostat:

|-----------+-------------------------------|
| # of cpus | # of opened fds for turbostat |
|-----------+-------------------------------|
| 128       | 260                           |
|-----------+-------------------------------|
| 192       | 388                           |
|-----------+-------------------------------|
| 512       | 1028                          |
|-----------+-------------------------------|

So, the new max limit would be sufficient up to 2^14 cpus (but this
also depends on how many counters are enabled).

Reviewed-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 9018e47e0bc26..a674500e7e63d 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -53,6 +53,8 @@
 #define	NAME_BYTES 20
 #define PATH_BYTES 128
 
+#define MAX_NOFILE 0x8000
+
 enum counter_scope { SCOPE_CPU, SCOPE_CORE, SCOPE_PACKAGE };
 enum counter_type { COUNTER_ITEMS, COUNTER_CYCLES, COUNTER_SECONDS, COUNTER_USEC };
 enum counter_format { FORMAT_RAW, FORMAT_DELTA, FORMAT_PERCENT };
@@ -6719,6 +6721,22 @@ void cmdline(int argc, char **argv)
 	}
 }
 
+void set_rlimit(void)
+{
+	struct rlimit limit;
+
+	if (getrlimit(RLIMIT_NOFILE, &limit) < 0)
+		err(1, "Failed to get rlimit");
+
+	if (limit.rlim_max < MAX_NOFILE)
+		limit.rlim_max = MAX_NOFILE;
+	if (limit.rlim_cur < MAX_NOFILE)
+		limit.rlim_cur = MAX_NOFILE;
+
+	if (setrlimit(RLIMIT_NOFILE, &limit) < 0)
+		err(1, "Failed to set rlimit");
+}
+
 int main(int argc, char **argv)
 {
 	outf = stderr;
@@ -6731,6 +6749,9 @@ int main(int argc, char **argv)
 
 	probe_sysfs();
 
+	if (!getuid())
+		set_rlimit();
+
 	turbostat_init();
 
 	msr_sum_record();
-- 
2.43.0



