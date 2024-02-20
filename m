Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BE8151CC4;
	Tue, 20 Feb 2024 21:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463138; cv=none; b=fm6hiJMTJAEtJLkefVrOxaKshtxofOjpW9YHnRg5nXQp4mvNjpOwuP9oqOCtgoX7E74Kw0fsE1wyHimOaBYW7P7eiRLm4Xgwl1tqVPZOE4XtbHm0fFVr7wRaBO3ZKXCctCRYF0FZklTqbZblX+iSBYpycqI6swp6wcw5tUo1CXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463138; c=relaxed/simple;
	bh=D8noong+jMzPSRzACZKIzc05RLOmOUJOoh4720vhaPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LejzpaSnfks6kpZjQtgyEyD5XmmzyEKHuQ1EWWX91enoBEHe7WPNppDtV4cgYeij9mBMXV8M35D4MntnFJsNoY+uO8eD4YX5GZVra6on2TH/7Zv+CXyTDhkC4uFBIHxA3Ie5OX8SexBZC+vFn8b9nYWooaUveAhnNyTqt+dFrHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5wNJ60T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5wNJ60T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2C2C433F1;
	Tue, 20 Feb 2024 21:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463138;
	bh=D8noong+jMzPSRzACZKIzc05RLOmOUJOoh4720vhaPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5wNJ60TSq0ST2q0aWEUvutXDlfHgSAH4FcbmkqRe70uTue7+O3M9WjdDLW7Nx19u
	 dOYT6RxbNshEGdVK4h6eC9oslkD5S85jCZc6QuXFQLB97UjaTuppR0NSiEYIXuGEIZ
	 Scb89s8IzAqNuRgM0/WLQOWijG7AJycpgkfLXWFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	limingming3 <limingming3@lixiang.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 6.1 148/197] tools/rtla: Replace setting prio with nice for SCHED_OTHER
Date: Tue, 20 Feb 2024 21:51:47 +0100
Message-ID: <20240220204845.502768378@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: limingming3 <limingming890315@gmail.com>

commit 14f08c976ffe0d2117c6199c32663df1cbc45c65 upstream.

Since the sched_priority for SCHED_OTHER is always 0, it makes no
sence to set it.
Setting nice for SCHED_OTHER seems more meaningful.

Link: https://lkml.kernel.org/r/20240207065142.1753909-1-limingming3@lixiang.com

Cc: stable@vger.kernel.org
Fixes: b1696371d865 ("rtla: Helper functions for rtla")
Signed-off-by: limingming3 <limingming3@lixiang.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/utils.c |    6 +++---
 tools/tracing/rtla/src/utils.h |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -478,13 +478,13 @@ int parse_prio(char *arg, struct sched_a
 		if (prio == INVALID_VAL)
 			return -1;
 
-		if (prio < sched_get_priority_min(SCHED_OTHER))
+		if (prio < MIN_NICE)
 			return -1;
-		if (prio > sched_get_priority_max(SCHED_OTHER))
+		if (prio > MAX_NICE)
 			return -1;
 
 		sched_param->sched_policy   = SCHED_OTHER;
-		sched_param->sched_priority = prio;
+		sched_param->sched_nice = prio;
 		break;
 	default:
 		return -1;
--- a/tools/tracing/rtla/src/utils.h
+++ b/tools/tracing/rtla/src/utils.h
@@ -7,6 +7,8 @@
  */
 #define BUFF_U64_STR_SIZE	24
 #define MAX_PATH		1024
+#define MAX_NICE		20
+#define MIN_NICE		-19
 
 #define container_of(ptr, type, member)({			\
 	const typeof(((type *)0)->member) *__mptr = (ptr);	\


