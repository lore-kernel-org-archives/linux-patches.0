Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8CF38F620;
	Sat, 12 Sep 2026 19:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242831; cv=none; b=gJkV/tWd6PryEyZXe9O7vCemTklSXW1/RKdgLTajvkgXrBPAPvn4ocFkds0Q+W+i72p/ltBUZw2zKfuk7I1sbzHBlffcpFxjKawyLEEV/4zzJpgMIlNcf+bW6POSWzwp7WRtqhkKHE+nRg1xDNd4wFnlLCQbGnKi1rkpMsTI5eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242831; c=relaxed/simple;
	bh=A17nRqP0BCFxlXzus8UV8TrXBpfXsDsI723mz8eMnwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eU8jmMCOfGqf5mk/4iDRfg7elZ9v50gP4FaI/cWGfNdo5uQRxYcmLSDJuKo2YTvyN8yBJEJ8TRIyIprhMkl8yc6+vBywnjw9abDOYDPBgBmgZRWKd9eyHAK7Wi4VGdXXj1ghi5aF+qis3shUHDnPk5Su/iQN0ErNMwh91YpQp6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8yDpx2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8yDpx2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245171F000FF;
	Sat, 12 Sep 2026 19:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242830;
	bh=95cQPZv7u98GfTzur8syzY7F1oKOrjVBQFsg6VL0fhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8yDpx2nXMHFlRTJ+J8zZwVsJ/X+Qwqa+4eaoz02UYNOXe0YcDE1QI2e0kWHIZTfE
	 5tSyyzZtvEoWZjcmmceXBjzWCQUG37fCAKZyszTLfvQsP3kv94qd/5tqeedZhphIhN
	 3E5KI4Kz6b0B4rOAccoa5iOvZh0QXoB+ZLHkfAbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 542/798] selftests/zram: fix kernel_gte() for POSIX sh
Date: Sat, 12 Sep 2026 09:02:50 +0200
Message-ID: <20260912065529.549901085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng-Han Wu <hank20010209@gmail.com>

[ Upstream commit 649ba27dfac784427a01f9c95c09ecbcb88900d8 ]

Commit fc4eb486a59d ("selftests/zram: Skip max_comp_streams
interface on newer kernel") added kernel_gte() to zram_lib.sh.
The function uses the bash-specific [[ ... ]] conditional, but
zram selftests source this file while running under /bin/sh.

On systems where /bin/sh is dash, such as Debian, the following
test fails:

  dash -c '
  kernel_major=6; kernel_minor=1; major=6; minor=0
  if [ $kernel_major -gt $major ]; then
      echo ok
  elif [[ $kernel_major -eq $major && $kernel_minor -ge $minor ]]; then
      echo ok
  fi'

with:

  dash: 5: [[: not found

Use separate POSIX test expressions joined by && instead.

Fixes: fc4eb486a59d ("selftests/zram: Skip max_comp_streams interface on newer kernel")
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/zram/zram_lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/zram/zram_lib.sh b/tools/testing/selftests/zram/zram_lib.sh
index 21ec1966de76c..0d44d83888f9d 100755
--- a/tools/testing/selftests/zram/zram_lib.sh
+++ b/tools/testing/selftests/zram/zram_lib.sh
@@ -37,7 +37,7 @@ kernel_gte()
 
 	if [ $kernel_major -gt $major ]; then
 		return 0
-	elif [[ $kernel_major -eq $major && $kernel_minor -ge $minor ]]; then
+	elif [ $kernel_major -eq $major ] && [ $kernel_minor -ge $minor ]; then
 		return 0
 	fi
 
-- 
2.53.0



