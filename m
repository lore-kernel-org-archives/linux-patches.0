Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EB92C08D0;
	Sat, 12 Sep 2026 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239492; cv=none; b=AzYjkDHxe2gbwNa1O/n73fB1Mx9eNkpXH4kb3d+whN7ss0Z81KMN1eXdGmwPNAVUARL+odRBmBcY+jNqOK1dGnB2Mo54vv0ijqRV84s1LwVI274jpuCJ3gB5JlftLwD741QC6BSHSoKVsxbMYlIX0zyQdf8W9dv0L/ot9gN/hhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239492; c=relaxed/simple;
	bh=9S5ergFDYCuc8Zey5Fg5E+J/CkKGlc7eoPt45opjJ5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFM+VZeuC2HNE/Z8j2UDUpBMhPA7rQ1ZuAGsrhQg4DOLJDgbn13nJn6BG5Uc5+fixuqqvo38AmBFYTi3j65Fs+MaoqfTJKnMv89Q8d6KlfqA7QlR6kIpTLw4W+k8bBTf2vPoMOFhQPBMCuPtdaiucRdzpjs41UPNxx3bj/IgYhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dh/I3TlJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dh/I3TlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580B81F000FF;
	Sat, 12 Sep 2026 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239491;
	bh=Ifugz+9/7ZtNzwZme/53Q+nnZdoxsuJVpCf+BtYUrO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh/I3TlJ3iYVZ7ZsYCKz5KPjb4Sn9Nl+pXxzfDhmGqCtaOSF0qQTxtDSwXynMMEsf
	 jx4UbRRFjYJmeejO2LXTVT8JRsIWIAwtZioiB0YadwObvEl683xMP7GtHOCzcGSs1+
	 g45bkhf+N8my07YwEeHtH/vvO6uo4uo8vntre0Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 633/935] selftests/zram: fix kernel_gte() for POSIX sh
Date: Sat, 12 Sep 2026 09:01:03 +0200
Message-ID: <20260912065541.358949974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



