Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC058189537;
	Tue, 30 Jul 2024 16:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356194; cv=none; b=G432MLsQJIe0bKPINEM1QlzZynb0nadwFwIDkc6Tl7Au5TijWr1MUqHI0n0zxpl9P1S58FczvGOJRqkxkmHlo5FXEvTY5OjSZQsRCL6gZUTziBOaOhv8yK6UxkrAJBRPN4HaZ2LJ/MvDJWmlBZ+2nF54t30nG41ULKV3DnJzfN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356194; c=relaxed/simple;
	bh=IiAMLIa42IE0xtAT/EFnZQripv/F/g4bc57bPioQxr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGmGxRbPk7powb2I4aiH1FcVOv0Jxpm5g6x3D41kkUxkdUnoP8keEXS7eUj80nOkNqwalRkOy8tUwRHQ16vrV6B1U6cT6nZN0IcsipyfrOMJtOQUMZMkTG453FJXP26LUQ8ULiYTjLho0wZoIDdys+LOV2sX1dTkRq/8orfKIJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muac6Y69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muac6Y69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DFFC32782;
	Tue, 30 Jul 2024 16:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356194;
	bh=IiAMLIa42IE0xtAT/EFnZQripv/F/g4bc57bPioQxr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muac6Y69vwYsdSXXK4l4tKn3nxEoDaPv5WZ3r3E4062USbmxPq3WispS7EYmmJ5Yl
	 gxSSV+mdz/WgUlxGWh6HEVS8KJMvWUcxKBb6+JKeMOjFyN/BSUBqH7/H15iBPC+eAf
	 R9n1+jnojp1t8l0yiOO7kEqz795t/JxlcIIynXNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/440] perf intel-pt: Fix exclude_guest setting
Date: Tue, 30 Jul 2024 17:46:40 +0200
Message-ID: <20240730151622.393824272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 357eef045f3be..9daec588103bc 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -32,6 +32,7 @@
 #include "../../../util/tsc.h"
 #include <internal/lib.h> // page_size
 #include "../../../util/intel-pt.h"
+#include <api/fs/fs.h>
 
 #define KiB(x) ((x) * 1024)
 #define MiB(x) ((x) * 1024 * 1024)
@@ -440,6 +441,16 @@ static int intel_pt_track_switches(struct evlist *evlist)
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
@@ -643,6 +654,7 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 			}
 			evsel->core.attr.freq = 0;
 			evsel->core.attr.sample_period = 1;
+			evsel->core.attr.exclude_guest = intel_pt_exclude_guest();
 			evsel->no_aux_samples = true;
 			evsel->needs_auxtrace_mmap = true;
 			intel_pt_evsel = evsel;
-- 
2.43.0



