Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E493FFFAF;
	Tue, 21 Jul 2026 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657641; cv=none; b=azBzSHiCr7CFJGvxFCeHIu6BzThY+dr0+AKEOwQgzUSjgzIbhlCAzyCzXKNxXak7QhhMFa+DEfFx6o/AjO9Ta0JptOWvhIe6q6UXH2dPckcJ0LmyC06wmsDr8WJEWwrSiDi09LYdM+i1PeEyS01PP4j3bQ1HyZ9LocTEzC1WxPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657641; c=relaxed/simple;
	bh=w1uZ2cfnap0bvWFJkzYHtj5o/ucaVLuajckpdt4StkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIA4ywNW681W+AEWZVq3d5CgEkW0YFDkaG41pKMwd9G3SZflYKW8LtMAKPBVgGojHzz2tZUF6U3Lt9lEK4O4tL7PNW57pFr8mrfTO4kuVZ4hJgfq1KEoH8GiO5agBeSTNWwzJMbEOimlaLcdE0qo+PC7SqzYo219MEv6g0zmrFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xd0qj4sM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xd0qj4sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A211F00A3A;
	Tue, 21 Jul 2026 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657640;
	bh=8gLRYPfNc0ReXYQx6TB1LuWqow5Vkc9sOVDhEmRA/Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xd0qj4sMkNk6auQpgTPXKP+UohlgZ1myTkhL44vKaQ9hg19tQKnaF3/s+mnymt0y7
	 EYLXFn5HywD/8j9dRgJAKQleSW6g9nvdn8K35ljfbxSgGzKOw7y4JAaeU+Xn759yQL
	 4IJqJYzDYO8ZDv0FoY6/R6o2kald6B7Bp0KgNSG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@arm.com>,
	Leo Yan <leo.yan@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0797/1611] perf cs-etm: Require full global header in auxtrace_info size check
Date: Tue, 21 Jul 2026 17:15:13 +0200
Message-ID: <20260721152533.314290105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 78d8ba680126f3545e8d0fba667e12d79fd4353b ]

cs_etm__process_auxtrace_info() checks that header.size covers
event_header_size + INFO_HEADER_SIZE (16 bytes total), but then
accesses ptr[CS_PMU_TYPE_CPUS] at offset 24 from the start of the
event.  A crafted 16-byte auxtrace_info event passes the size check
but reads out-of-bounds.

Include CS_ETM_HEADER_SIZE in the minimum size check so that the
global header entries (version, pmu_type_cpus, snapshot) are
guaranteed to fit within the event.

Fixes: 55c1de9973d66516 ("perf cs-etm: Print auxtrace info even if OpenCSD isn't linked")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm-base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/cs-etm-base.c b/tools/perf/util/cs-etm-base.c
index 4abe416e3febd2..aebef71d3a0a1d 100644
--- a/tools/perf/util/cs-etm-base.c
+++ b/tools/perf/util/cs-etm-base.c
@@ -170,7 +170,9 @@ int cs_etm__process_auxtrace_info(union perf_event *event,
 	u64 *ptr = NULL;
 	u64 hdr_version;
 
-	if (auxtrace_info->header.size < (event_header_size + INFO_HEADER_SIZE))
+	/* Ensure priv[] is large enough for the global header entries */
+	if (auxtrace_info->header.size < (event_header_size + INFO_HEADER_SIZE +
+					  CS_ETM_HEADER_SIZE))
 		return -EINVAL;
 
 	/* First the global part */
-- 
2.53.0



