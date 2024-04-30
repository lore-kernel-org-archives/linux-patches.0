Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1494E7464;
	Tue, 30 Apr 2024 10:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474761; cv=none; b=cFOWCVHhtFC6WuN3W++ul1td8k6+qHhoat0zTByuhlD2WVGrkubmF8F5Dg0Cr+dUtAHIRHdSszrvicCFd8IRyajRuhE88fB6Bx4qvCTkeqa/mXvSz7PwFFX+VqiB1AW9jYpdjiA1TBaj+edHX9OilcQ5uO7mXsVSmvbUiHcxd0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474761; c=relaxed/simple;
	bh=ckUMgd4n1R3MUFAunHLxQURgk3l76KQJPADHGkEqbUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1EjUrp6CTOBQwwFXcq7o9V+jhH3/C8F6ccARRuO6R7IpcBaw3nitUemoJd+4BXNe1XD6K+LpvB2lmJFFgVl+0ojl0e7MVyr8le7Bm+315KBiWdS+oRQT43/MX3mC/K/0mzkj9HTGgTRpUbE7qaacf9yk98ombSsvIOyYRtKlSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpLFOTvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpLFOTvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71387C2BBFC;
	Tue, 30 Apr 2024 10:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474760;
	bh=ckUMgd4n1R3MUFAunHLxQURgk3l76KQJPADHGkEqbUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpLFOTvm5xx+tEZ4R9VbgtWXH35Y+fT8BVcUo0BRadpTR7kIcCkLHf/O7ndhzU01h
	 DGodzcN5CGaaBR1XwkogXbdh9kuHCtybUz/Upcpx9HZgluM8++MQzY5aYIghchUdzk
	 gR6bch6QiGtZRLsi13GiRSsbzYnEwDLcMHPoZKLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 027/138] selftests: timers: Fix abs() warning in posix_timers test
Date: Tue, 30 Apr 2024 12:38:32 +0200
Message-ID: <20240430103050.229200757@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <jstultz@google.com>

commit ed366de8ec89d4f960d66c85fc37d9de22f7bf6d upstream.

Building with clang results in the following warning:

  posix_timers.c:69:6: warning: absolute value function 'abs' given an
      argument of type 'long long' but has parameter of type 'int' which may
      cause truncation of value [-Wabsolute-value]
        if (abs(diff - DELAY * USECS_PER_SEC) > USECS_PER_SEC / 2) {
            ^
So switch to using llabs() instead.

Fixes: 0bc4b0cf1570 ("selftests: add basic posix timers selftests")
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240410232637.4135564-3-jstultz@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/timers/posix_timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/timers/posix_timers.c
+++ b/tools/testing/selftests/timers/posix_timers.c
@@ -66,7 +66,7 @@ static int check_diff(struct timeval sta
 	diff = end.tv_usec - start.tv_usec;
 	diff += (end.tv_sec - start.tv_sec) * USECS_PER_SEC;
 
-	if (abs(diff - DELAY * USECS_PER_SEC) > USECS_PER_SEC / 2) {
+	if (llabs(diff - DELAY * USECS_PER_SEC) > USECS_PER_SEC / 2) {
 		printf("Diff too high: %lld..", diff);
 		return -1;
 	}


