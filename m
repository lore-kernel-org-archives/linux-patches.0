Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7466299920;
	Sat, 12 Sep 2026 11:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212333; cv=none; b=B0rwPGzuH5Rv1oTf7aOYZ/5IZq8EjVp/HKweIk6DNm4X03ZqADjJTiBlcVic3159Esh3Nr9dyzhsTWIBMdfRuWGOGgSA0WQf2H2GprImtLYNg73JpMaOeRB41WzkogJ4tkThNUpkkDNsWoHpZDVsIH+ia6cfEXV9sP3OtUbBvCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212333; c=relaxed/simple;
	bh=S1xa96Dfm4ETf+VmtJ4Z9O6SXtr80lBMqeaLyMTPMQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9b096Kypw32yAc1Cvb7JAKMG01rHpkhgYpuvMDezw8YZ2fab1lbL4fKSAZQX6ustpPt9jkWPJAnHTE8eyF/bi8S10++C1nO0ffnQfVGTVonVOSsO4mcQKn95a8ZVyjJIZpmYxKjeE01H4pr33swYUNNLQcGzl1Tq092qXOgfpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewtnpkHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewtnpkHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA68D1F000FF;
	Sat, 12 Sep 2026 11:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212331;
	bh=7BIbAHzplZnDSAR9ZLpuH6Y/RFSWfoequGITZxpcuKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewtnpkHvvtDfquVEiGpH0hDRC5K9kRJ/MygreyL/fakRYgkqtguINaX7xfOVf77y/
	 b1OGwJDdw13t4LuhIAz1bNPUgTL8ESWDSob7l6aVb0pBXCdEK5zYVvvwMvyDuhio4q
	 89P72iU+g9yJHvGTlRNgYnaPlxNeMP1f+DMo4t7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1414/1518] selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC
Date: Sat, 12 Sep 2026 08:59:43 +0200
Message-ID: <20260912065655.538096078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 0685630fdccb62dcb0e3f44525a40578da5f6dc8 ]

test_maps_tearing_from_split times out when READ_IMPLIES_EXEC is set.
This happens by default on pre-ARMv6 CPUs, which lack no-execute support.

split_vma() re-maps the first page with mod_info->prot | PROT_EXEC to make
it differ from its neighbours.  With READ_IMPLIES_EXEC the original
mapping is already executable, so no split occurs and the test hangs
waiting for the modifier child.

Use PROT_NONE for the split mapping, which always differs from its
readable neighbours.

Link: https://lore.kernel.org/20260808200312.6326-1-kmehltretter@gmail.com
Fixes: beb69e817246 ("selftests/proc: add /proc/pid/maps tearing from vma split test")
Assisted-by: Codex:gpt-5.6-terra
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/proc/proc-maps-race.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index a546475db5502..7de87221bf27e 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -340,7 +340,8 @@ static bool query_addr_at(int maps_fd, void *addr,
 
 static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
 {
-	return mmap(self->mod_info->addr, self->page_size, self->mod_info->prot | PROT_EXEC,
+	/* PROT_NONE differs from both readable neighbors. */
+	return mmap(self->mod_info->addr, self->page_size, PROT_NONE,
 		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0) != MAP_FAILED;
 }
 
-- 
2.53.0



