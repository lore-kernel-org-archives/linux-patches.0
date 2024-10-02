Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE4B1D0488;
	Wed,  2 Oct 2024 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879723; cv=none; b=EwmW4YKNktzw5lvQH5oh+doqaZ9JjN3q/TShYFCwiEwPgpnBEGHmGAd8424KuQm4N2QTIKB+2fnpoWNadKv0GkXOOOEejRIKOh5C3pvfYl9IqAJIHVirQbzoWUC3EK5G7Rpezh+yZZVMwU9GZQLRQqln6/pIUgF/hqtD1VVDR7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879723; c=relaxed/simple;
	bh=C1NHnwJqqdShSDUnp+lgnzQ5Ca/yuaF/Jv5hrjHopUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMkZ0QHSJ2xjXY6wO+yjP8YHlC8qSmcdMiWcCxeTeZ6jsIQb34Z83MHqJ7pYsvWjytqKGnjPqBJyaX3uQdT+GtQdAX1fRYwXaEE2ToucPDa1c/en1CvPT9/cDBLgmRxJk+Em7UwLfciU39Z00AYg4eOJAgOFphCDKpT0fyBun3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNpo1m9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNpo1m9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7948C4CECD;
	Wed,  2 Oct 2024 14:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879723;
	bh=C1NHnwJqqdShSDUnp+lgnzQ5Ca/yuaF/Jv5hrjHopUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNpo1m9DsfEMFmHqrKv02+nsfSiz7FXf5E5loIWYuTj+usZEoagnlkIe6BNZgakMe
	 13kPx1tkTC7ztcEqJWn0gAjrSa9+RMMY354vndZRotrfcNUivUywA8PKdKLh1gxkL5
	 7Mkkq/fi0fdQOkoxqvVA7yIj0f8FRuw6J4V5Gmas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/538] selftests/bpf: Fix flaky selftest lwt_redirect/lwt_reroute
Date: Wed,  2 Oct 2024 14:57:35 +0200
Message-ID: <20241002125800.783269940@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit e7f31873176a345d72ca77c7b4da48493ccd9efd ]

Recently, when running './test_progs -j', I occasionally hit the
following errors:

  test_lwt_redirect:PASS:pthread_create 0 nsec
  test_lwt_redirect_run:FAIL:netns_create unexpected error: 256 (errno 0)
  #142/2   lwt_redirect/lwt_redirect_normal_nomac:FAIL
  #142     lwt_redirect:FAIL
  test_lwt_reroute:PASS:pthread_create 0 nsec
  test_lwt_reroute_run:FAIL:netns_create unexpected error: 256 (errno 0)
  test_lwt_reroute:PASS:pthread_join 0 nsec
  #143/2   lwt_reroute/lwt_reroute_qdisc_dropped:FAIL
  #143     lwt_reroute:FAIL

The netns_create() definition looks like below:

  #define NETNS "ns_lwt"
  static inline int netns_create(void)
  {
        return system("ip netns add " NETNS);
  }

One possibility is that both lwt_redirect and lwt_reroute create
netns with the same name "ns_lwt" which may cause conflict. I tried
the following example:
  $ sudo ip netns add abc
  $ echo $?
  0
  $ sudo ip netns add abc
  Cannot create namespace file "/var/run/netns/abc": File exists
  $ echo $?
  1
  $

The return code for above netns_create() is 256. The internet search
suggests that the return value for 'ip netns add ns_lwt' is 1, which
matches the above 'sudo ip netns add abc' example.

This patch tried to use different netns names for two tests to avoid
'ip netns add <name>' failure.

I ran './test_progs -j' 10 times and all succeeded with
lwt_redirect/lwt_reroute tests.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20240205052914.1742687-1-yonghong.song@linux.dev
Stable-dep-of: 16b795cc5952 ("selftests/bpf: Fix redefinition errors compiling lwt_reroute.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/lwt_helpers.h  | 2 --
 tools/testing/selftests/bpf/prog_tests/lwt_redirect.c | 1 +
 tools/testing/selftests/bpf/prog_tests/lwt_reroute.c  | 1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_helpers.h b/tools/testing/selftests/bpf/prog_tests/lwt_helpers.h
index 61333f2a03f91..68c08309dbc82 100644
--- a/tools/testing/selftests/bpf/prog_tests/lwt_helpers.h
+++ b/tools/testing/selftests/bpf/prog_tests/lwt_helpers.h
@@ -27,8 +27,6 @@
 			}                                                     \
 	})
 
-#define NETNS "ns_lwt"
-
 static inline int netns_create(void)
 {
 	return system("ip netns add " NETNS);
diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c b/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
index ea326e26656f5..7b458ae5f0f85 100644
--- a/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/lwt_redirect.c
@@ -53,6 +53,7 @@
 #include <stdbool.h>
 #include <stdlib.h>
 
+#define NETNS "ns_lwt_redirect"
 #include "lwt_helpers.h"
 #include "test_progs.h"
 #include "network_helpers.h"
diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_reroute.c b/tools/testing/selftests/bpf/prog_tests/lwt_reroute.c
index f4bb2d5fcae0a..c104f07f1b0bc 100644
--- a/tools/testing/selftests/bpf/prog_tests/lwt_reroute.c
+++ b/tools/testing/selftests/bpf/prog_tests/lwt_reroute.c
@@ -48,6 +48,7 @@
  *  For case 2, force UDP packets to overflow fq limit. As long as kernel
  *  is not crashed, it is considered successful.
  */
+#define NETNS "ns_lwt_reroute"
 #include "lwt_helpers.h"
 #include "network_helpers.h"
 #include <linux/net_tstamp.h>
-- 
2.43.0



