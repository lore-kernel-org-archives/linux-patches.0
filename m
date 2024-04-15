Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD3B2119;
	Mon, 15 Apr 2024 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192122; cv=none; b=N0Z0nbcc0u7evv/Al9DUWi9qGt0WOtbRhMGZKnpD+ggokndg+jW0R03K2eklFgAntggqHwrI/VytfCsliCxVgb+++38+YEK8ZAxT7/4JelUuFDrG26gXxEtaJWHV61EiO7I+A3IeRD0tPUD+Qrxwu9bcloXRw2vWEKtNoXTczX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192122; c=relaxed/simple;
	bh=josSVi1K8kY3IUDVUrBu2ANnj1lrr72nAFvGgX/r5eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPipk6rxe7u30qABI/Z7OJ0oHUUCburQZ5Dmxsz+KA0FdQLaNTl46fxXlxQli+K1QRkkOs8nieqR14UyhhqSv7xQHL00kIhTy/ygBmC4GW8sObuMBOx31SIK+Qe2gcpdWh8lfakVXJ/0THRgaeQ+E65fM54d90CqCzVS98bzDXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbmZT2ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbmZT2ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95577C113CC;
	Mon, 15 Apr 2024 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192122;
	bh=josSVi1K8kY3IUDVUrBu2ANnj1lrr72nAFvGgX/r5eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbmZT2ekLLn3dEX+TLeq1noRxErhZFzbfmLHXsRejV1qQr1N7tps+7fWmC+6iQcNG
	 6OBzGs28G6S0SjZ9ZvVD2JTjsCzkiPxP2/IqxzII9tiD5bTNlapXyQaAzW4dWCB2gw
	 EzuSG/rrEXfjkqpzdRzORf43wQsChLQo09kQAzv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 54/69] selftests: timers: Fix abs() warning in posix_timers test
Date: Mon, 15 Apr 2024 16:21:25 +0200
Message-ID: <20240415141947.796631590@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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


