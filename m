Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE78BE8;
	Tue, 30 Jul 2024 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357268; cv=none; b=OTQqMCvSUbm7YwuJMd7dJaSCPmoploeoyMKMxaSieNJvJjaaSsGqmmRxQDg0sPZ8AJ6AZI7++IJ2+iUoMWjyAUgEEhcG8tGsOTElZwoSONHIXOWyTpd8SAPt/h7k67wZ9RtF3E6KQKFaxdXvbB/STqabTAj3f0VPQrc4MYZyK7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357268; c=relaxed/simple;
	bh=5ezy+ynzc6/1F00oGzomGjjwX6NSUzrMYU0VaQmIs0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX58bkksiSjnqxgZsKQRth005DjhewrR8+AuSo2VuVXZyC4te0Rv7Go252ZZ51RTRmbRhCWU5DwOcTvKV+kKOI75GmGY4Al8d1b2X5JtWk4wWhO04rnNrJJTcWepbAUFGG1EkNuGGOEYlLrN5CRbe8/UxfeugIDC6FO/odLXJsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJFx7Gqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJFx7Gqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE6EC4AF0A;
	Tue, 30 Jul 2024 16:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357268;
	bh=5ezy+ynzc6/1F00oGzomGjjwX6NSUzrMYU0VaQmIs0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJFx7Gqex4iL4TZ022r5F4CzAJUil85JEj4C9e+jhDmDyjxrR1HmYvcZDy22IoR7j
	 61O14qkJb0+YJCA6T9ELG7WgJdfjOMijpKi/fTgUewjYoxAVAw7GcjJJrQPxkFbfo3
	 J2SxxsxOwIKX+hII+RviX4kPL9HV31D0AYQDEnvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/568] perf intel-pt: Fix aux_watermark calculation for 64-bit size
Date: Tue, 30 Jul 2024 17:45:42 +0200
Message-ID: <20240730151649.065027094@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 31807791589ee..5161a9a6b853a 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -766,7 +766,8 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 	}
 
 	if (!opts->auxtrace_snapshot_mode && !opts->auxtrace_sample_mode) {
-		u32 aux_watermark = opts->auxtrace_mmap_pages * page_size / 4;
+		size_t aw = opts->auxtrace_mmap_pages * (size_t)page_size / 4;
+		u32 aux_watermark = aw > UINT_MAX ? UINT_MAX : aw;
 
 		intel_pt_evsel->core.attr.aux_watermark = aux_watermark;
 	}
-- 
2.43.0



