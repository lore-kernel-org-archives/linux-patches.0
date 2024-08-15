Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB90176ADE;
	Thu, 15 Aug 2024 13:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729469; cv=none; b=aLeI/epKWZPWkhrBUGhN6AkFJKA2sclc3PFl86PmtVp35YnUBBOZmlClwWefnmA0S6tz9FiYxDaMaJi4MnAVPWJpSGUpahRCRAsdTzWtNu1pdgvbbPLGeL4XcXb696Eme5Co6J2qDuKPNdl1xdddfzWRtWeNeCN/Tgf3ktbqdnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729469; c=relaxed/simple;
	bh=tyru1aZa9/sHMCx4gTEhchJj304zVc0xrx9Z8xkgmTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R73inVEBJnacQSrfjzbU2niJFkXCLzZchgLbbsX/4yJhOMs6YSvhdPYf3VR5vrTBcFP38Om4ViMXh8k8XsGkEbziFhOfcIvk4wP9Z+cVOrZQFvMvw8HTYlXVxOYkq0zYB4I9EWVfp4zD/bmBjL+iZbTCVh4SnTokeuAZzadhfak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZmHGQ/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZmHGQ/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D92C4AF0A;
	Thu, 15 Aug 2024 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729469;
	bh=tyru1aZa9/sHMCx4gTEhchJj304zVc0xrx9Z8xkgmTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZmHGQ/53avLvVwGKJvMJmAkNiomQze7mEq5iEF9tNDymEfo6Sfz+lq0oDto6pxn4
	 mlsdGqDhwKK7E3T/UUJCIGcASfAtUJUAGeuMOOBPtznb1S11hZ+reMqiQTUbZ38kLh
	 GCKPN5937k+79Y4jotfONPnjyMMCTzfwGf3aCCpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/484] perf intel-pt: Fix aux_watermark calculation for 64-bit size
Date: Thu, 15 Aug 2024 15:19:26 +0200
Message-ID: <20240815131945.465784161@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 36b4cd990a8fd3f5b748883050e9d8c69fe6398d ]

aux_watermark is a u32. For a 64-bit size, cap the aux_watermark
calculation at UINT_MAX instead of truncating it to 32-bits.

Fixes: 874fc35cdd55 ("perf intel-pt: Use aux_watermark")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240625104532.11990-2-adrian.hunter@intel.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/intel-pt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index 6df0dc00d73ab..99ae6d4d3ae3c 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -777,7 +777,8 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 	}
 
 	if (!opts->auxtrace_snapshot_mode && !opts->auxtrace_sample_mode) {
-		u32 aux_watermark = opts->auxtrace_mmap_pages * page_size / 4;
+		size_t aw = opts->auxtrace_mmap_pages * (size_t)page_size / 4;
+		u32 aux_watermark = aw > UINT_MAX ? UINT_MAX : aw;
 
 		intel_pt_evsel->core.attr.aux_watermark = aux_watermark;
 	}
-- 
2.43.0



