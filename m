Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E251A6195;
	Tue, 30 Jul 2024 16:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358495; cv=none; b=QHE361qn2TpI7uc3/Eb1RnzqTb0xJ6RVmNXqlRPOQW2A00NutzmNRIXgIsJMP32a2LyNBjNidzbN4jnYaj99wowzy18W+o8D4qOwBXN6y2hwwbXvbUf8+cfo9FGed9YVILqJVQfec/Z1nZDdUfZl61ONgGze7cp19zCM2fg7di8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358495; c=relaxed/simple;
	bh=MDUfCAGPPpeqDxvhK3ay/7rQVpIMXN+niaFEVZdIs/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0RIKmCWjN7Dn6glgG8xDC7WON4y+/BYwb+XlpAEYZIbIzTmpmvuLH6r3gs1wJaA+YL9cDgyRTQMJ3gOA2YXX333q9ISu++X/lI2F6w3sn6f6eZGo9ILFMV8RIu52moFktHbXNLo6eFo+/r+WGAbxYJUDL4N/2bRI/1wQc9e8p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvuv98+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvuv98+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B16C32782;
	Tue, 30 Jul 2024 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358494;
	bh=MDUfCAGPPpeqDxvhK3ay/7rQVpIMXN+niaFEVZdIs/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvuv98+SgG3V41DQVnBbCpTb32CO5lrIza8eZayaDYLYYSPQSXZYxDy8XYpWs6m9f
	 MnPEEIAq7RAzvNILZxdOzWTLhKdI7MxmenzfvwB6lHQGfnh5oatdr5pCU2W0hOE+0p
	 iBic69KavMAC5J+As0jKqfdTquE2IxowBCVhUwkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 364/809] perf intel-pt: Fix exclude_guest setting
Date: Tue, 30 Jul 2024 17:44:00 +0200
Message-ID: <20240730151739.028351526@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c8fa15f280d29..4b710e875953a 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -32,6 +32,7 @@
 #include "../../../util/tsc.h"
 #include <internal/lib.h> // page_size
 #include "../../../util/intel-pt.h"
+#include <api/fs/fs.h>
 
 #define KiB(x) ((x) * 1024)
 #define MiB(x) ((x) * 1024 * 1024)
@@ -428,6 +429,16 @@ static int intel_pt_track_switches(struct evlist *evlist)
 }
 #endif
 
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
@@ -620,6 +631,7 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 			}
 			evsel->core.attr.freq = 0;
 			evsel->core.attr.sample_period = 1;
+			evsel->core.attr.exclude_guest = intel_pt_exclude_guest();
 			evsel->no_aux_samples = true;
 			evsel->needs_auxtrace_mmap = true;
 			intel_pt_evsel = evsel;
-- 
2.43.0



