Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BA719DF9C;
	Thu, 15 Aug 2024 13:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729472; cv=none; b=lpwJ6tjw5RN7i2BdOWTljdAvgOOSRhkCObOj062seifPh2iaI95Qic6SElMkqCh+2lzyAsMlc8fOWhM2R9gbgmm2XDwfNupT/QgOtKgknQsIoyAQqErQkyzeVg/0vZ4MnUaNT1hfUsi7pcqQreOHbnNtW9Swxc3wCR90XSnfzZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729472; c=relaxed/simple;
	bh=e4yXR1a4FZPY84QbeTe25RsKopmCBuGFVG8KYhQmgP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6PDIisBx0rf7E4u3RF3GbJ9ZhHqP4VhaZ8raMGqSI936VVac4Il17DNVg+HMtKS9segvrVHLXKOTHZ8HtGs01YEOkSWNIICUrL2rXAvoKFDjjIIGlkQMIuvckJgLUqiXFjCivP+EtuX87o2vrY9JwXgVj/GfV+G6u37Uv3FHeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqhL8e5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqhL8e5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD395C32786;
	Thu, 15 Aug 2024 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729472;
	bh=e4yXR1a4FZPY84QbeTe25RsKopmCBuGFVG8KYhQmgP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqhL8e5MWevN4EDeELyRGBFmf2AQe9J9rrvYV2An9WJMCkhAY3RKxSwQpRd0rp43S
	 hRKR8v94TRJWvg8hN0jgy16bktdjDzCwAz5kclbEkznix3Wb44hYOhhFYQ0vhjL+7k
	 mWNBICvbzEa6ec9+U2EQP9VNEiyJINUv8crK/rWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/484] perf intel-pt: Fix exclude_guest setting
Date: Thu, 15 Aug 2024 15:19:27 +0200
Message-ID: <20240815131945.504482319@linuxfoundation.org>
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

[ Upstream commit b40934ae32232140e85dc7dc1c3ea0e296986723 ]

In the past, the exclude_guest setting has had no effect on Intel PT
tracing, but that may not be the case in the future.

Set the flag correctly based upon whether KVM is using Intel PT
"Host/Guest" mode, which is determined by the kvm_intel module
parameter pt_mode:

 pt_mode=0	System-wide mode : host and guest output to host buffer
 pt_mode=1	Host/Guest mode : host/guest output to host/guest
                buffers respectively

Fixes: 6e86bfdc4a60 ("perf intel-pt: Support decoding of guest kernel")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240625104532.11990-3-adrian.hunter@intel.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/intel-pt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index 99ae6d4d3ae3c..7cb21803455a9 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -31,6 +31,7 @@
 #include "../../../util/tsc.h"
 #include <internal/lib.h> // page_size
 #include "../../../util/intel-pt.h"
+#include <api/fs/fs.h>
 
 #define KiB(x) ((x) * 1024)
 #define MiB(x) ((x) * 1024 * 1024)
@@ -438,6 +439,16 @@ static int intel_pt_track_switches(struct evlist *evlist)
 	return 0;
 }
 
+static bool intel_pt_exclude_guest(void)
+{
+	int pt_mode;
+
+	if (sysfs__read_int("module/kvm_intel/parameters/pt_mode", &pt_mode))
+		pt_mode = 0;
+
+	return pt_mode == 1;
+}
+
 static void intel_pt_valid_str(char *str, size_t len, u64 valid)
 {
 	unsigned int val, last = 0, state = 1;
@@ -641,6 +652,7 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 			}
 			evsel->core.attr.freq = 0;
 			evsel->core.attr.sample_period = 1;
+			evsel->core.attr.exclude_guest = intel_pt_exclude_guest();
 			evsel->no_aux_samples = true;
 			intel_pt_evsel = evsel;
 			opts->full_auxtrace = true;
-- 
2.43.0



