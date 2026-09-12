Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C109339022B;
	Sat, 12 Sep 2026 19:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242972; cv=none; b=s40IcaQ4o738GCJ110RPN6WoiG7pKGPAZDCDDH2X4fiykbSptD1xTsVN1n8RfZXb26t5EfYYs7NX/T882qlZiHIc5RpvgGGeOujxfPtUSMy6SEvmERm0nk5J/wIe4dHC41dLR5E4JHClNrH3BHGOCcUn8PD47aM/T+Lfvdjrdog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242972; c=relaxed/simple;
	bh=ZYj4J9nPhcpy5WYa2oeYWFGjr/qvfNw2zqOe62DfibY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWMRBV6imFFYT0pp15ITuPynEM0DEJMPBX3YQLqHG8pUMiM5K5fBnzENf1X64KMxDPfFHOwUIu2KAjqIuhSo5oKWovqs6huqIhiDet6sij8hIvC/O6GOmepmBo8Nln5yjs1GfOnxdFoCYc539LtKFq2eaoE0c2JZpG7Tie0guwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmgWhzca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmgWhzca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1D81F000FF;
	Sat, 12 Sep 2026 19:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242964;
	bh=+wVdWo+BPDGziFigGNdVfKK8vkFAUjucplUwVFALXRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmgWhzcajzyyIFesJHxZ7GbWnoDBMqjQYsJN8Y2PRwcC2q8c3oIVdEvdiyZ4LyKUo
	 G8Lei8r34qFRdDs0qYMZcVs8H1rO3KY4sy8NxjxlAnBecVeyqC++dCP0NvGWIZquCV
	 8TqrsajEehPqJZDYDhra5N6I2OqvE9I6+MD90po8=
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
Subject: [PATCH 5.10 588/798] perf intel-pt: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 09:03:36 +0200
Message-ID: <20260912065530.602200207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 453773ce6f455..8921ea9df671e 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -3320,7 +3320,7 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
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



