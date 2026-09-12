Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD6532B125;
	Sat, 12 Sep 2026 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230230; cv=none; b=uRCT8S0d8sG/3cZbtzxyZ2Cz/pDj9xf8iub6Y3awLM8Mz8ZtXUOuerEdgADYCsmemN8ZbqOWCKXOmImByry29TrQovPVgAPEXMROXCA6/Nl+q9qYDPHIs3ryMLStBMxlg/Vky5rY+LeOqpJbLc+fa6pdKkCq/vKitDtzmpqM2HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230230; c=relaxed/simple;
	bh=N8mIgV5KDV9vXDQhqT7B8Wuu1fES6lTuBoLx8KFMSG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3KpKiyjgKcsLIO/NBGh8RnZb1ByzWEfZ9PxySVqaOtzmnXKQJED33JxZpZ2biOr0CxjQizfCNH67Lz7ENGNQvP1SnOvX+pJzrx4eGBPEFx3fLsedlo+M4o9CdZ8UfWQgDLcOVawzRcCnDQ0WEAJK094D5g8t3mOS/QdfX92fN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmxuMf2r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmxuMf2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E81F1F000FF;
	Sat, 12 Sep 2026 16:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230229;
	bh=qCme5Eyv3yb/zs0jFxJeofpYPQaOhph0pjUCo4GDFjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmxuMf2r4HIiSvb41nNH7q4bBm0Z+Hjh6vsal/Y68+03Z+PWP670fm2hWfndeGpRk
	 mJi1js9KvpY8XTDfLKLsUD9RJp43fwmZpHmW5nKOtG84NVe3+QBiabdZVQzTkcdz3L
	 +mlRTQ00B//l/4uN7H74sNsRf8ibe4V6EdGUatZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0752/1191] selftests/zram: fix kernel_gte() for POSIX sh
Date: Sat, 12 Sep 2026 08:58:00 +0200
Message-ID: <20260912065605.170073646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



