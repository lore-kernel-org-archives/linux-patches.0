Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A529034D915;
	Sat, 12 Sep 2026 10:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208625; cv=none; b=cZnSibLFzYmMAY+Z3QAetzul3fEF/6Z9sQ4DJv8dXKVP17sg7secb9yVA0bcPfVNS/dbj4ZNAxRLUhf3Gc2mNifTWqHIDqU/9zQtg59XNcTsZjsEJM7p47xZImRYWaFID4OlnfGUn3jLJmU/J0Glb6Buzcn2jzSTpJfN+CvWyEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208625; c=relaxed/simple;
	bh=RSTP1p+Cn7E0jdr8zP9s5V1ObkMwAXctlUUlLv7DA3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6iPteun9nXH+VeZID41v8JO4EQRYsIlxDREA+vHL0/z4FogrQD14O0KNZYQpLDQbti+GcQxwB2PPHjyjttDBy65wbKXy4L34UfsISS4DpY/h9hAI2NF6L3N10XsLhLAHg+d78n94gA5PmSn6JsTvXvJx2lhqCfOeIUqcTzF1A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU25kiTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU25kiTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084061F000FF;
	Sat, 12 Sep 2026 10:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208624;
	bh=SVQiVy2tHCO9jwywsVFFq9EKEUKRGEZvgJAJ/m7DF10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AU25kiTp/gIRo7aofLwO4BABYszUi4jRWbX7uOMQJR/TTNqLB2w6DZRfo+o4s4OiC
	 A9t916HIc+9G39saC8T5cDMRXp8ZTs3jHsDSZAX5jS/ZSUHbE2GgvqzrvmcOVVSIaw
	 V9yZWapsZYukH7egirYp7rTiYObJtFogLOuICdVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0656/1518] selftests/zram: fix kernel_gte() for POSIX sh
Date: Sat, 12 Sep 2026 08:47:05 +0200
Message-ID: <20260912065638.268907334@linuxfoundation.org>
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



