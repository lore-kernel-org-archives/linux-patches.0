Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234FA34EF0A;
	Tue, 16 Dec 2025 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887853; cv=none; b=gzjRRwH4ojfDgSfZEjA+VXJxXDNi323oOzzaY8KYsYpCpZKbQPIgY2ijVsSdEWYwp87P4Le7Rvm/l9cDrZbCu+o0J/+6DctHj4v62m5VYDGKyULu++0nMlUy6absijSKcmIgAsas9+PjPUYdcnSWby94WARZSobM+5CKqqVGMN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887853; c=relaxed/simple;
	bh=gd5bl14FfRjXtDkrz3Fi5vchbOUzpEV2hpae6LLBzfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyRInZq/vbQ4wFmrV14ESUikL/k8Z3VIiArv/WrXQIFvEwEmsyv+jBXx3hpKqehIfkGEwonebo/7L+wlXiShmK29C+UhFD7zUClsGpThNeboUo1b1OnQtaKSrjcStiFNFpMvrezf8jmXOE/ED4muTq7QYySYRXmqfBl58Queq8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMBAOFJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMBAOFJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D85C4CEF1;
	Tue, 16 Dec 2025 12:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887853;
	bh=gd5bl14FfRjXtDkrz3Fi5vchbOUzpEV2hpae6LLBzfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMBAOFJ82b92pFvB4m4kn7/Gb6ublVSwaWXjVpHoHrmsgH3Vs8I6pq87I4YYZld96
	 LiOgDERu//DtfYVWCtFBNA0NBKhqAuwB/T7GiDjUTmUfHrt6xCn/arweA54XeZ0Co+
	 y+2ax4m3U/hKPc7soEWABzEJ9kiRaXNFZSALTUTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/614] rtla/tests: Extend action tests to 5s
Date: Tue, 16 Dec 2025 12:12:05 +0100
Message-ID: <20251216111414.332434252@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit d649e9f04cb0224817dac8190461ef1674e32b37 ]

In non-BPF mode, it takes up to 1 second for RTLA to notice that tracing
has been stopped. That means that action tests cannot have a 1 second
duration, as the SIGALRM will be racing with the threshold overflow.

Previously, non-BPF mode actions were buggy and always executed
the action, even when stopping on duration or SIGINT, preventing
this issue from manifesting. Now that this has been fixed, the tests
have become flaky, and this has to be adjusted.

Fixes: 4e26f84abfbb ("rtla/tests: Add tests for actions")
Fixes: 05b7e10687c6 ("tools/rtla: Add remaining support for osnoise actions")
Reviewed-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20251007095341.186923-2-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/tests/osnoise.t  | 4 ++--
 tools/tracing/rtla/tests/timerlat.t | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/tracing/rtla/tests/osnoise.t b/tools/tracing/rtla/tests/osnoise.t
index e3c89d45a6bb0..08196443fef16 100644
--- a/tools/tracing/rtla/tests/osnoise.t
+++ b/tools/tracing/rtla/tests/osnoise.t
@@ -39,9 +39,9 @@ check "hist stop at failed action" \
 check "top stop at failed action" \
 	"timerlat top -T 2 --on-threshold shell,command='echo -n abc; false' --on-threshold shell,command='echo -n defgh'" 2 "^abc" "defgh"
 check "hist with continue" \
-	"osnoise hist -S 2 -d 1s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
+	"osnoise hist -S 2 -d 5s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
 check "top with continue" \
-	"osnoise top -q -S 2 -d 1s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
+	"osnoise top -q -S 2 -d 5s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
 check "hist with trace output at end" \
 	"osnoise hist -d 1s --on-end trace" 0 "^  Saving trace to osnoise_trace.txt$"
 check "top with trace output at end" \
diff --git a/tools/tracing/rtla/tests/timerlat.t b/tools/tracing/rtla/tests/timerlat.t
index b5d1e7260a9be..b550a6ae24456 100644
--- a/tools/tracing/rtla/tests/timerlat.t
+++ b/tools/tracing/rtla/tests/timerlat.t
@@ -60,9 +60,9 @@ check "hist stop at failed action" \
 check "top stop at failed action" \
 	"timerlat top -T 2 --on-threshold shell,command='echo -n 1; false' --on-threshold shell,command='echo -n 2'" 2 "^1ALL"
 check "hist with continue" \
-	"timerlat hist -T 2 -d 1s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
+	"timerlat hist -T 2 -d 5s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
 check "top with continue" \
-	"timerlat top -q -T 2 -d 1s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
+	"timerlat top -q -T 2 -d 5s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
 check "hist with trace output at end" \
 	"timerlat hist -d 1s --on-end trace" 0 "^  Saving trace to timerlat_trace.txt$"
 check "top with trace output at end" \
-- 
2.51.0



