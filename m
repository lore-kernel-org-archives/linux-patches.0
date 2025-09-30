Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC47D1F3FED;
	Tue, 30 Sep 2025 15:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245856; cv=none; b=nbmpenbklVwFhMHrSpSLGu+RyFQvC1klMnvsXE4w5G8bYyTLuIICKxc62R9S49g5IC7fZiALTL9/Rl3hmHU1zrBVA27AGv8fDiOq1c8fcaZe6AQDKfez3YtnzwbtJNrCgUF43Kj+sReWgcS4mk4Y62u37gATecV8a+zDGnym6NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245856; c=relaxed/simple;
	bh=JadtmOKpAJ5Sx4W5WhuXmwtjAFWIV7JFwu/XxKteJSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q65bXXwY4TIN2I8A4LG9s5BSmNE4WhiE3xRT+9brORjBMOPYsv04W2UaeBKTfCJtoKFvofczW1K1stDOXxXT+0HLYrxiUwHHu+4mPfj114Y7ZARVUXZIDl26BGuZCPA5G0lGZwbYIVAEHjpibGypo7uaDgFyLF0eTVk6ayIL3jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRAcCi+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRAcCi+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A814C4CEF0;
	Tue, 30 Sep 2025 15:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245856;
	bh=JadtmOKpAJ5Sx4W5WhuXmwtjAFWIV7JFwu/XxKteJSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRAcCi+QXoZDbEvLXU7sFKORJDH1CxFY9Tn7bpAQhhN5Ft3AbFfzBFxGLOvEq/+Bd
	 TETWsGGHxFs1P7BLlZesLKJgvatXMMkwxxeTDs8eeZAnd6ngNvpxRsdHJVpSKKZQaJ
	 7nuLY1JucIlI49u7qqM1QKc69ovsuANNDZks3ckk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, linux-s390@vger.kernel.org,  Nathan Chancellor" <nathan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.6 71/91] s390/cpum_cf: Fix uninitialized warning after backport of ce971233242b
Date: Tue, 30 Sep 2025 16:48:10 +0200
Message-ID: <20250930143824.138522479@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

Upstream commit ce971233242b ("s390/cpum_cf: Deny all sampling events by
counter PMU"), backported to 6.6 as commit d660c8d8142e ("s390/cpum_cf:
Deny all sampling events by counter PMU"), implicitly depends on the
unconditional initialization of err to -ENOENT added by upstream
commit aa1ac98268cd ("s390/cpumf: Fix double free on error in
cpumf_pmu_event_init()"). The latter change is missing from 6.6,
resulting in an instance of -Wuninitialized, which is fairly obvious
from looking at the actual diff.

  arch/s390/kernel/perf_cpum_cf.c:858:10: warning: variable 'err' is uninitialized when used here [-Wuninitialized]
    858 |                 return err;
        |                        ^~~

Commit aa1ac98268cd ("s390/cpumf: Fix double free on error in
cpumf_pmu_event_init()") depends on commit c70ca298036c ("perf/core:
Simplify the perf_event_alloc() error path"), which is a part of a much
larger series unsuitable for stable.

Extract the unconditional initialization of err to -ENOENT from
commit aa1ac98268cd ("s390/cpumf: Fix double free on error in
cpumf_pmu_event_init()") and apply it to 6.6 as a standalone change to
resolve the warning.

Fixes: d660c8d8142e ("s390/cpum_cf: Deny all sampling events by counter PMU")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_cf.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -852,7 +852,7 @@ static int cpumf_pmu_event_type(struct p
 static int cpumf_pmu_event_init(struct perf_event *event)
 {
 	unsigned int type = event->attr.type;
-	int err;
+	int err = -ENOENT;
 
 	if (is_sampling_event(event))	/* No sampling support */
 		return err;
@@ -861,8 +861,6 @@ static int cpumf_pmu_event_init(struct p
 	else if (event->pmu->type == type)
 		/* Registered as unknown PMU */
 		err = __hw_perf_event_init(event, cpumf_pmu_event_type(event));
-	else
-		return -ENOENT;
 
 	if (unlikely(err) && event->destroy)
 		event->destroy(event);


