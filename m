Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42D61F7544;
	Wed,  6 Nov 2024 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898003; cv=none; b=Kfg4EQhrtiBZIf5sxYxxhKslY0x3jzuiE8PtxIX8ma391WBmWcUDtWwFhDF5r/+3Eo/QRj7Za6KDpByoVMSKSHBJgonMrcJ7KPavbdErnXf/cMLIhBso+8PfocwS8GnE2WIcArzVZTyixxUqxhikVVNqzsJabVFfIQ4gwUrgYFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898003; c=relaxed/simple;
	bh=ctH3GDyP6ZD5+zgEJ4f7r2oY7ygvYVXyf4f6G776DUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9x6tBqMLqT4iPkvj+CkS0t8hiLob3vXmKEebIIGRgsEZfVwRCKO2ObQe3ucpCs5MyePCk4/OkvTXJOlJTj1JvYjFhDKeU20UQmmJ5xsKHw3lAnMUSMOnRJ/doOK41NIvPvjFXBjmVgtUY1ZjDv0DO61UjbF1qqi0Ds2n7fHEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6axh+n+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6axh+n+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AD9C4CECD;
	Wed,  6 Nov 2024 13:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898003;
	bh=ctH3GDyP6ZD5+zgEJ4f7r2oY7ygvYVXyf4f6G776DUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6axh+n+wDz1Tbmd18L5IF8QE7cqBayl/81r5r/2B/4crN/Hs2K3+1vqQ1E8oLc+Y
	 /C/Pc2Sk46dEibQHz5tkp8XFMJ+Zn7pmnwlsPXxfnoaJWICQ+dMfAw3qTr06JezEo1
	 fvyNaFPgvIs/znNt5kHjAd4B7t9W9qqCQVY4XFCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/462] selftests/bpf: Fix error compiling test_lru_map.c
Date: Wed,  6 Nov 2024 12:59:44 +0100
Message-ID: <20241106120333.754961577@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6a5349f9eb148..7748d28e8b97a 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -137,7 +137,8 @@ static int sched_next_online(int pid, int *next_to_try)
 
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



