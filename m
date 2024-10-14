Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD643BBF2;
	Mon, 14 Oct 2024 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917889; cv=none; b=Z/O0HGcl5riZ8jHq9xJ1Q9xY4RyCbBDKegcm4Rj7dyw7aCrYlxNMRsnr72Bl1+y1Hth9exFw6hSQduoqoRLfPA/tkxBB05V2LeeyPFb3yx9zOLbJ79f3+iXAHG7PdsO4H5jxgKYzBF5A7I5JIA0Kc3lM1MAD/PtKASm725MSCEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917889; c=relaxed/simple;
	bh=Q3/5aC9uID+nFPZvydrBHWFcInWtNYgS9jgdfDMIvFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/Yq6YNIO5h6CPXZo70PuY7pYxZb7wsx5HGoIshIoxEQsrtkS6wOxuEx+BE6FE6Lmgx33BpP4TxK0nH0mhdmGcETTexfNlEnnpCtXlTvwN+QqtUsAKUaWpFV4uTGY6GnS5CYtdcg01OsZNMh4YduxicCmxsk7JkDMkq20hJCkOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcTzDYY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcTzDYY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C4EC4CEC3;
	Mon, 14 Oct 2024 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917889;
	bh=Q3/5aC9uID+nFPZvydrBHWFcInWtNYgS9jgdfDMIvFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcTzDYY8vcQoWjyfhfE+fPz1yYEqYnblKlXVtOlYZS8fcXSL9tgX21GblhAA5NsGz
	 JdPgevXyxoRXRGInjbhyGpr2ybDURWRdcbY9+Ar+K9dv5KHUAkKkzngm3yJCgoGfmK
	 ESkFdAVXosIPbO3w/u3RuHD8CI9Zv6Mw6CBSXUVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/798] selftests/bpf: Fix error compiling test_lru_map.c
Date: Mon, 14 Oct 2024 16:11:50 +0200
Message-ID: <20241014141224.043064145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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



