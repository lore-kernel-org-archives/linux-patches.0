Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2539228E0;
	Sat, 12 Sep 2026 16:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230684; cv=none; b=Kp4cFPZEoR3SBIF/o5gxwqdWXE97YCVA5kTX3JLbj407Gk4b/9HCvk1RzuRJ6+L4eX1JtGQzTsfkQjBgVFaPehN99C5WrHOlF3xdCCl2Ius+BeNtgpcY+K+NiQLYv7m4BuSU2r2Vu2oADUcoqpZ2yggMvN6f1FioPbnBW/Jj1+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230684; c=relaxed/simple;
	bh=I28sYRBO67UtjxFlrY10fzdWRMIA23egx7vVL1T4UHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MamvJZvjDCYQjYcKpV+HZOi0gNYYolpUElntFRCfPaQp7g+yuk7frVlHqHmreP/lz0CHuFhMaRB7FNRXCxzpMaRE5ogRZESeIFc9fkjqGvIB66XYR1X4qPAawZf6PxW96w7fAa+nrEQzyjEQtrH0YJhK8sYNqXQlXAq0y7ji3E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4wSZZaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4wSZZaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425231F000FF;
	Sat, 12 Sep 2026 16:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230683;
	bh=Z3O7fBrhqt/rA+ruePuT129pf3wmYGIArYZ0r1/ghnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4wSZZaC8B7cwAaWzPU5j1+ZD2LnTFzXEqRjZtMyDxB7eCunms7xd1ob6nuGY2RNC
	 fZ5HNe5QpgOuTWg4ky7+UvLaWkT3DI20k5bJCs2GJAP/ae9DvP995zwFzb/bhPST31
	 fIDV7nToMSi+aGj2HPe/BxpAsAB1LRoiMSYHmD8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0845/1191] perf intel-pt: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 08:59:33 +0200
Message-ID: <20260912065607.236328504@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit c4362d5e1a5ed4ce2098798f655a636c4340fa20 ]

min_sz is set to sizeof(u64) * INTEL_PT_PER_CPU_MMAPS, but the code
accesses auxtrace_info->priv[INTEL_PT_PER_CPU_MMAPS], which requires
at least INTEL_PT_PER_CPU_MMAPS + 1 elements.  A file with exactly
min_sz bytes of priv data passes the size check but the access reads
one u64 past the validated region.

Use (INTEL_PT_PER_CPU_MMAPS + 1) to ensure the highest accessed index
is within bounds.

Fixes: 90e457f7be087005 ("perf tools: Add Intel PT support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 018eaddd4e6af..3a1dd70ccd2f9 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -4290,7 +4290,7 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 				   struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * INTEL_PT_PER_CPU_MMAPS;
+	size_t min_sz = sizeof(u64) * (INTEL_PT_PER_CPU_MMAPS + 1);
 	struct intel_pt *pt;
 	void *info_end;
 	__u64 *info;
-- 
2.53.0



