Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540E535F184;
	Sat, 12 Sep 2026 08:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200355; cv=none; b=Ocm6rM6ZgTgSvZtTCyAX+LADXb28Sz95NouEUFbympL3hKVPcqaIXr2uOaGiWa21iuZ/ovQUbP/RLAubfBKXjZOdigfS39Pw5ou+34iBLHVqSoeTcaY6bMMBoIsn+3VqbvpETbF0Bq9UGG4DkJNPQNUIY8ggE0RtyFDyJiJ6Tuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200355; c=relaxed/simple;
	bh=fuCVqipKN92k5e7tjGIc3EdwtREAtQBiE1gWf4Vkxpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIJi2WiVX4aXd5fUHiKBBS7UQCBQ3zNazgz53AnSbzL1pcl5ImWYqv1jOqPxyHIFx/fb45RKP4SsOdBh3cZrKsre8gjUHTq4WBdxOLM7ez11gjWUxQLxEywVrUKw3UzkajrqOf0GdWXuN29vBE2FGqIHucGy3D6VxMBPTzArtig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAKwVI1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAKwVI1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A2B1F00898;
	Sat, 12 Sep 2026 08:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200354;
	bh=qUX5C3gn3GzpnBy5mtYRL3++vKjTNqDdzNYNC+2aMP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAKwVI1yXf7u0y8QwtPr8gbni+CjtgmATSfXvyXo65lIO6+534Cptdjz573W1p/dH
	 PlX13dGciDC4Z3gyGgs88mr+QR1zgyg64RBapExON3g4CcHVYv0yHVQQyloZK8cGSi
	 +Ptb+VHY8qo+V0ESVCSw9P9+iCgTaiSI6UjdY0dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0771/1815] selftests/zram: fix kernel_gte() for POSIX sh
Date: Sat, 12 Sep 2026 08:42:01 +0200
Message-ID: <20260912065707.008798503@linuxfoundation.org>
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



