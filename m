Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237FD1D5AD7;
	Wed,  6 Nov 2024 12:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894983; cv=none; b=IhbKozHmdNtpWLr0GpdUnfNBlMy1O34/UGEtU82au3WhLOXTba4kfL85+GqQapeO9JI/xErgFSxyO8OGY3K+G0uJPvrl7LpLaxBGwyWD5gojT+cevqbeuaM++rWdZYn95gyCnSRvnfRQfVlQGslcyaN2aI4sG1h8MPCs2oVfL/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894983; c=relaxed/simple;
	bh=3gjhrw4eR8C281VqHqIz1cViHRRLmjQmDa2PI0oOJ5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzYzOqneF8zNHYG3dGxs3zFkM8/Ep3rsv9eDJ49nEtRyjlX1HiY8WTLKIB8f+N2yhwr2C868hurbzTMHFGRmmxp3PhGo0ABOxCxXQ6lHljKBzfQ0QQ64Wq+L1kSIiwG90FP4M4DtYKtr50MJ/1ony+nIrkDUBrIyjj1C0GQb7SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OePwHzvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OePwHzvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8C4C4CECD;
	Wed,  6 Nov 2024 12:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894983;
	bh=3gjhrw4eR8C281VqHqIz1cViHRRLmjQmDa2PI0oOJ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OePwHzvvtFfS0IejV38x7RuqgOXkwAoLu9E85et3JnSM6q92YFLcUl5piwFEiLxog
	 PIkeN3sGcROBNGgbWjWFuZs9YOlo77WPpol+lhsc14LLOXYLDs6jYqE2HILk4yrdi5
	 Pitzs2qCTo6OkaujIDIjMlhlwTRRHU2yVFWUpvq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/350] selftests/bpf: Fix error compiling test_lru_map.c
Date: Wed,  6 Nov 2024 12:59:54 +0100
Message-ID: <20241106120322.524969074@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 781c7de343be0..a9ed4b58c0879 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -76,7 +76,8 @@ static int sched_next_online(int pid, int *next_to_try)
 
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



