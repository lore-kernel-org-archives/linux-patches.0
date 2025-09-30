Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3A427B328;
	Tue, 30 Sep 2025 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245574; cv=none; b=PfzFOGmMEWfmnqkPNgojKm3A68PU6SFrhhwiPMQJREEKSrSJbSLyhTWUQZ15w+jy+WPgbXebs+hZc+X1puAB8DCAzHlFYsQMrla/oLP8eCKNrcLkkV6pwcpl9gYHbkdzbJEErNwOHDpyE1a89rCvB4AOCMdj/LmZ5M7saV4ztuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245574; c=relaxed/simple;
	bh=6AjZ7tKkzkXkwsZGLNFl3hbzKSthXp127RssM7ShYNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3snLjVBha5S7jG61boJ5XTXXzb6dDK5q9t0FUpT2HTfpYQGmaDDDFnUuA/eLkGXeS8+I0B0dncQoeqvsCpNDMQX573k0nObUKyg6DxT66F5lEOFXiGevfSZ3BsTwJBDLqOpIQYIjJkX/Ar9CjG8pZc8r7DUpgm0jC4yJIxt7rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muyramBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muyramBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB9CC4CEF0;
	Tue, 30 Sep 2025 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245574;
	bh=6AjZ7tKkzkXkwsZGLNFl3hbzKSthXp127RssM7ShYNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muyramBOZxxBN+ahSn1sXj8tmnSfHRzGyd07aXrHB7SdN1fJS/RVWa1OTIVqAVrOQ
	 blfXkwppBw00KxGbo8raY+zu1mLkJnAkJIoVIUnHl6Fqm19Xsz8hstjM5ezudN8yPr
	 ID90ESpAla/ruDUEp9UGK0Eu7Z0hpd3cPGgLha7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, linux-s390@vger.kernel.org,  Nathan Chancellor" <nathan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 57/73] s390/cpum_cf: Fix uninitialized warning after backport of ce971233242b
Date: Tue, 30 Sep 2025 16:48:01 +0200
Message-ID: <20250930143823.012991793@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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
@@ -552,15 +552,13 @@ static int cpumf_pmu_event_type(struct p
 static int cpumf_pmu_event_init(struct perf_event *event)
 {
 	unsigned int type = event->attr.type;
-	int err;
+	int err = -ENOENT;
 
 	if (type == PERF_TYPE_HARDWARE || type == PERF_TYPE_RAW)
 		err = __hw_perf_event_init(event, type);
 	else if (event->pmu->type == type)
 		/* Registered as unknown PMU */
 		err = __hw_perf_event_init(event, cpumf_pmu_event_type(event));
-	else
-		return -ENOENT;
 
 	if (unlikely(err) && event->destroy)
 		event->destroy(event);


