Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227071F7574;
	Tue, 17 Dec 2024 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456283; cv=none; b=HSmCJE8u9EqrIiPdyDbQiOJW2nPzPW7mGUgKSmbQDuZ/VmJz5lpkKmBmqxDo6w00Cmj7PZc69o20DJiJxTdIFWTmEu3vzxZN/BQ/XkZygRRoED0PnnIq99/QV4LFBwVSZdoAySEfgMqK7caGunGCqeZQbMF9Ohu08H3h65lgjYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456283; c=relaxed/simple;
	bh=GRwTU/SS9mylYrBxHsCMVm1e9so/tKOB3pMSPvJdtaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZZj3I+7TyyL9gaDw05VwLalEg2DAn/8ZIsrq9852GeuoT0VKwq5znkCzF7FSJ/hyumaA9/kXLKL/YRc8Ql/oneaDG1JJr7bdXE3K/HOdw0tF1G2CNch+EgbSgr66luj7aMSJ1ms21GGngzXrgHPxsy3C4kMXCV/e8RaPtaclxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0qmR8BX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0qmR8BX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E1FC4CED7;
	Tue, 17 Dec 2024 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456283;
	bh=GRwTU/SS9mylYrBxHsCMVm1e9so/tKOB3pMSPvJdtaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0qmR8BXWIRHSyaJEl6A2RCmUmE5+yGGRCFAGvc3e5nGbWpEWJeD1x6/wy4UO6EoG
	 +JEmM4cEJdV/i57LtbSDgnaD2Ycpcszp0jUSIoceMYileN/w8Aoq7U2j6KUTkdLlZn
	 y5lo/qSMOWJyzbY5QrZL0BdXNWAEUiZBp4olR4As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	jserv@ccns.ncku.edu.tw,
	chuang@cs.nycu.edu.tw
Subject: [PATCH 6.12 010/172] perf ftrace: Fix undefined behavior in cmp_profile_data()
Date: Tue, 17 Dec 2024 18:06:06 +0100
Message-ID: <20241217170546.676307365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 246dfe3dc199246bd64635163115f2691623fc53 upstream.

The comparison function cmp_profile_data() violates the C standard's
requirements for qsort() comparison functions, which mandate symmetry
and transitivity:

* Symmetry: If x < y, then y > x.
* Transitivity: If x < y and y < z, then x < z.

When v1 and v2 are equal, the function incorrectly returns 1, breaking
symmetry and transitivity. This causes undefined behavior, which can
lead to memory corruption in certain versions of glibc [1].

Fix the issue by returning 0 when v1 and v2 are equal, ensuring
compliance with the C standard and preventing undefined behavior.

Link: https://www.qualys.com/2024/01/30/qsort.txt [1]
Fixes: 0f223813edd0 ("perf ftrace: Add 'profile' command")
Fixes: 74ae366c37b7 ("perf ftrace profile: Add -s/--sort option")
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: jserv@ccns.ncku.edu.tw
Cc: chuang@cs.nycu.edu.tw
Link: https://lore.kernel.org/r/20241209134226.1939163-1-visitorckw@gmail.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-ftrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 272d3c70810e..a56cf8b0a7d4 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -1151,8 +1151,9 @@ static int cmp_profile_data(const void *a, const void *b)
 
 	if (v1 > v2)
 		return -1;
-	else
+	if (v1 < v2)
 		return 1;
+	return 0;
 }
 
 static void print_profile_result(struct perf_ftrace *ftrace)
-- 
2.47.1



