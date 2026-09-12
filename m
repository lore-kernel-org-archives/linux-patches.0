Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D484189B9;
	Sat, 12 Sep 2026 09:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205105; cv=none; b=T8X7hS4NObbhDPhjU7ReAJF5VsDP6vP8Z9G8LpgFVHtvXfmi/PQ7aNxtW/2tceC3u3ek3k3jmAdzEZ+yfmiokfuvOi8DvxWqhQdbVeH+g3+7I5fX4vHBuLNHR3FhgNiRz2pFhDGLwBR61JElR7tpYeFeItNAja+wCxqBJjvWwTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205105; c=relaxed/simple;
	bh=fgDAY8cA8fahYvd2Agj7pp/qs2Op+9qIh+ImTTAhdRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbP5MVGDGq0Dm2DQW6HYh10C4HVURays1lNO9Qz6N+WFuDj8w0v6xloZGGFu5v7a5jFoLijR78HxtPoo6Yu1DPHlaeCKjArOOFCsTe0hiwWtDWOATU2YTptqhWKrgyfL379b1uSzgMmrXy1/XCxdhXunnWD0/OaC1dE5Y+gl9EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7l73OcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7l73OcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBDD1F000FF;
	Sat, 12 Sep 2026 09:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205102;
	bh=w5j5jWBeMV2MjRo2LPGtMOMUm3jpAJ5AiFJXHOuoOj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7l73OcUH7gK3wSRIlMyLPYxX88Cud4+s/Yd/M+6fEpyhLCOu+mrgBH764g7XuRd6
	 n7P0RsAL0q1T/4JAVG1E+gXxbLXAqVc7SLzArrhWqlzmwc4o6icY6H7gF7bDVqpzWd
	 uxQZcTBWCumdKwzm6OgUWJmkE+6hi07/sTGnmEmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1750/1815] selftests/mm: fix read_file() return value check
Date: Sat, 12 Sep 2026 08:58:20 +0200
Message-ID: <20260912065730.067557448@linuxfoundation.org>
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

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 4050b5b0b60c93160a816d68ea1eb9ae92739a73 ]

read_file() returns 0 on open/read failures and never returns negative
values.  Existing < 0 error checks never trigger, so read failures are
silently ignored.  Check for zero return to detect read_file() failures.

Also fix misleading error message in get_finfo().  The error string
incorrectly references read_num when reading uevent files.

Link: https://lore.kernel.org/20260807013555.36525-1-hongfu.li@linux.dev
Fixes: e0c13f9761df ("khugepaged: add self test")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 4 ++--
 tools/testing/selftests/mm/vm_util.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087d..506310d4b4d5c 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -138,8 +138,8 @@ static void get_finfo(const char *dir)
 		     major(path_stat.st_dev), minor(path_stat.st_dev))
 	    >= sizeof(path))
 		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
-	if (read_file(path, buf, sizeof(buf)) < 0)
-		ksft_exit_fail_perror("read_file(read_num)");
+	if (!read_file(path, buf, sizeof(buf)))
+		ksft_exit_fail_perror("read_file(uevent)");
 	if (strstr(buf, "DEVTYPE=disk")) {
 		/* Found it */
 		if (snprintf(finfo.dev_queue_read_ahead_path,
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index ef1ea11981a74..2697d50d07f4f 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -755,7 +755,7 @@ unsigned long read_num(const char *path)
 {
 	char buf[21];
 
-	if (read_file(path, buf, sizeof(buf)) < 0)
+	if (!read_file(path, buf, sizeof(buf)))
 		ksft_exit_fail_perror("read_file()");
 
 	return strtoul(buf, NULL, 10);
-- 
2.53.0



