Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A163A1D07B8;
	Wed,  2 Oct 2024 14:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877968; cv=none; b=HcPpU9FOGnVtG2H1CEpjW2ZeGVENBFfX0uBEhQu3ktEcgxvWInrKNF4k68wcJJemfCBqkEjNbgib4G98W44P4p92TvD0/eeidTXZNjGHYIgolsxWRUozlQ1gfJAyUXFFY3IjmUcAnsJInwXSdLe9x9L5u8COKyddnIMLiBYisYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877968; c=relaxed/simple;
	bh=TiyaweSHWFD2/cylcHyVIjW4u45108vbuY2pO4oDta4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbD8PFjTpmRhGW3wZ399UJ8gZ5RpYzvBKZEJ9IpDpz91P1j9a08Sz0TiKoxIDmWfS/8BDYmLgkrZSBhmtq9LmErOQfV+Cd78pObJqrP4z14k/sYzowe83miarYQmYe5Rpphv8Pen+Wb1o46yhRcmysZ/Z+W3z3AdmsX4O+geLs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+HC5GUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+HC5GUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29280C4CEC2;
	Wed,  2 Oct 2024 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877968;
	bh=TiyaweSHWFD2/cylcHyVIjW4u45108vbuY2pO4oDta4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+HC5GUTGWiE9nuLak/zJ+AVBC6iEFfeehGeZeYXQFfXEqsYMkR6eh9aJwy2266LG
	 WxnMcHa1HetlyZPCVXKQqDwzU79sGB1sY7LbjX2RTK2G59dfiLlnvfK4Jlk6CPzJIB
	 iV5oizAH02lhbr7ptv8ibwPIkKthUe4wUEtaumLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 256/634] selftests/bpf: Fix error compiling test_lru_map.c
Date: Wed,  2 Oct 2024 14:55:56 +0200
Message-ID: <20241002125821.204369483@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit cacf2a5a78cd1f5f616eae043ebc6f024104b721 ]

Although the post-increment in macro 'CPU_SET(next++, &cpuset)' seems safe,
the sequencing can raise compile errors, so move the increment outside the
macro. This avoids an error seen using gcc 12.3.0 for mips64el/musl-libc:

  In file included from test_lru_map.c:11:
  test_lru_map.c: In function 'sched_next_online':
  test_lru_map.c:129:29: error: operation on 'next' may be undefined [-Werror=sequence-point]
    129 |                 CPU_SET(next++, &cpuset);
        |                             ^
  cc1: all warnings being treated as errors

Fixes: 3fbfadce6012 ("bpf: Fix test_lru_sanity5() in test_lru_map.c")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/22993dfb11ccf27925a626b32672fd3324cb76c4.1722244708.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lru_map.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
index 4d0650cfb5cd8..fda7589c50236 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -126,7 +126,8 @@ static int sched_next_online(int pid, int *next_to_try)
 
 	while (next < nr_cpus) {
 		CPU_ZERO(&cpuset);
-		CPU_SET(next++, &cpuset);
+		CPU_SET(next, &cpuset);
+		next++;
 		if (!sched_setaffinity(pid, sizeof(cpuset), &cpuset)) {
 			ret = 0;
 			break;
-- 
2.43.0



