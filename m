Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86991DAC9F;
	Tue,  3 Dec 2024 15:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241101; cv=none; b=dwtL3HB/SXh2DD0rEvORjRpAWxt8s8n/s5eCWB56BFAju/dJk4doZ6ys6P/2p/LsGqSL6Xf17R3eUnDpfhKEz1C5JAvH4SuG9SypppJYpd+Ps4K0VM3x6Qxh60espHHSPFHWbSfthQzDgI0ZpfANvcE3zMOoq7xgmzE0IHQUXHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241101; c=relaxed/simple;
	bh=QoiQAj+wL0l6d5ggwjSK5ucxrROsOeQKUaZlsdO43qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+2EhirU1sHK8LJrc2MYPOxNjCjpn0VLQJ2D/+wdfXmUaD3itoEcgUvGC96B51vxJmfe6E1GBi/TLbuAwwkYHx98uTtiUJLJBHbhjuvVrs4sOVpFjpkJOfyIYEXjP/jjbzk92ZaTWNbUQFOdCTzmbQ7Ym3seXrRQcDs/xaJHMGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyXPEky2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyXPEky2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4370EC4CECF;
	Tue,  3 Dec 2024 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241101;
	bh=QoiQAj+wL0l6d5ggwjSK5ucxrROsOeQKUaZlsdO43qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyXPEky2zIs4R2zzPohB9zakROcoaI8ebHyL2zm3NOsmZnQCudq4NwH6GfEiHPADR
	 HmI2TTy89LN0HfbZ2P2t4vaRoPFt/ePlhNe1rcI2cB77LwUraF+y7UNWHIWP2gth6w
	 TppnCWLUn8U8h4VN8wzaZbnb5TvdFDpLP4YdD3Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Philo Lu <lulie@linux.alibaba.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/826] selftests/bpf: skip the timer_lockup test for single-CPU nodes
Date: Tue,  3 Dec 2024 15:40:52 +0100
Message-ID: <20241203144756.439080241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit 937a1c29a287e8f48c4cea714c76a13e14d989ac ]

The timer_lockup test needs 2 CPUs to work, on single-CPU nodes it fails
to set thread affinity to CPU 1 since it doesn't exist:

    # ./test_progs -t timer_lockup
    test_timer_lockup:PASS:timer_lockup__open_and_load 0 nsec
    test_timer_lockup:PASS:pthread_create thread1 0 nsec
    test_timer_lockup:PASS:pthread_create thread2 0 nsec
    timer_lockup_thread:PASS:cpu affinity 0 nsec
    timer_lockup_thread:FAIL:cpu affinity unexpected error: 22 (errno 0)
    test_timer_lockup:PASS: 0 nsec
    #406     timer_lockup:FAIL

Skip the test if only 1 CPU is available.

Signed-off-by: Viktor Malik <vmalik@redhat.com>
Fixes: 50bd5a0c658d1 ("selftests/bpf: Add timer lockup selftest")
Tested-by: Philo Lu <lulie@linux.alibaba.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241107115231.75200-1-vmalik@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/timer_lockup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/timer_lockup.c b/tools/testing/selftests/bpf/prog_tests/timer_lockup.c
index 871d16cb95cfd..1a2f99596916f 100644
--- a/tools/testing/selftests/bpf/prog_tests/timer_lockup.c
+++ b/tools/testing/selftests/bpf/prog_tests/timer_lockup.c
@@ -5,6 +5,7 @@
 #include <test_progs.h>
 #include <pthread.h>
 #include <network_helpers.h>
+#include <sys/sysinfo.h>
 
 #include "timer_lockup.skel.h"
 
@@ -52,6 +53,11 @@ void test_timer_lockup(void)
 	pthread_t thrds[2];
 	void *ret;
 
+	if (get_nprocs() < 2) {
+		test__skip();
+		return;
+	}
+
 	skel = timer_lockup__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "timer_lockup__open_and_load"))
 		return;
-- 
2.43.0



