Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DB53B83FC;
	Tue, 21 Jul 2026 20:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666859; cv=none; b=slicTta/lCfEW1FXSlJu6FQrrryrfPFf2AwYqhs/iKU5XjFIMB7vrh/TdA0QalTAsZ6E+QmjEUGpFNNzFFHSWC30snedGMYrJoVxIiagy3n/Bm61kD/3bTori1UMYGxIRqVoDUlFwJQBNMSIIdFja2w4suKEdJSs1PerefsH3NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666859; c=relaxed/simple;
	bh=BGPFbFJL9M+GinBgcQNDHVWvlXYXHwBk535BT39aziU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9dsudmGEiCoUDSLOch9++It+XsJhSROseE0Ta1O06P7s3EdbweIVrrd/nSR6UtiDTR/tXrVxJlIZfyIzavhYYiBmBjD9hZfqDXwOhNCqjq0a+v+1DRLVsxb7BtM5IuKGH4QujI5kNgUXqZimo1n2alui7aSmmXXHAoj/mQ/c2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcqYkICg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcqYkICg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7BF1F000E9;
	Tue, 21 Jul 2026 20:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666858;
	bh=yYlotP1Yc+4+id37gFwD/7hXQcS5FPhkSN29Jpk4qYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcqYkICgoKmQA3Jd981t1dEA0+LzTmawspTaWKdT6farbGUvIA5dMGOaUiHr7pGWU
	 cIG+yYWFk6rGEvgngVcSvVfuizTAgfrDg0c2tqeQ+XogtknY6pEwmdk7ZOo4ernixi
	 Ska/Crhx+n/cyTLs2SHqGp6mzhpHLKIwUQNPzqFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 6.6 0843/1266] selftests/hid: ensure we can compile the tests on kernels pre-6.3
Date: Tue, 21 Jul 2026 17:21:20 +0200
Message-ID: <20260721152500.718809716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit ae7487d112cf9f310d32f27d5956f53d9f143fea ]

For the hid-bpf tests to compile, we need to have the definition of
struct hid_bpf_ctx. This definition is an internal one from the kernel
and it is supposed to be defined in the generated vmlinux.h.

This vmlinux.h header is generated based on the currently running kernel
or if the kernel was already compiled in the tree. If you just compile
the selftests without compiling the kernel beforehand and you are running
on a 6.2 kernel, you'll end up with a vmlinux.h without the hid_bpf_ctx
definition.

Use the clever trick from tools/testing/selftests/bpf/progs/bpf_iter.h
to force the definition of that symbol in case we don't find it in the
BTF and also add __attribute__((preserve_access_index)) to further
support CO-RE functionality for these tests.

Signed-off-by: Justin Stitt <justinstitt@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com> # Build
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20230825-wip-selftests-v3-1-639963c54109@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: eebbef7c468a ("selftests/hid: Cover hid_bpf_get_data() size overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/hid/progs/hid.c       |  3 -
 .../selftests/hid/progs/hid_bpf_helpers.h     | 77 +++++++++++++++++++
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/hid/progs/hid.c b/tools/testing/selftests/hid/progs/hid.c
index 88c593f753b529..1e558826b809e1 100644
--- a/tools/testing/selftests/hid/progs/hid.c
+++ b/tools/testing/selftests/hid/progs/hid.c
@@ -1,8 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2022 Red hat */
-#include "vmlinux.h"
-#include <bpf/bpf_helpers.h>
-#include <bpf/bpf_tracing.h>
 #include "hid_bpf_helpers.h"
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/hid/progs/hid_bpf_helpers.h b/tools/testing/selftests/hid/progs/hid_bpf_helpers.h
index 4fff31dbe0e74b..65e657ac11985d 100644
--- a/tools/testing/selftests/hid/progs/hid_bpf_helpers.h
+++ b/tools/testing/selftests/hid/progs/hid_bpf_helpers.h
@@ -5,6 +5,83 @@
 #ifndef __HID_BPF_HELPERS_H
 #define __HID_BPF_HELPERS_H
 
+/* "undefine" structs and enums in vmlinux.h, because we "override" them below */
+#define hid_bpf_ctx hid_bpf_ctx___not_used
+#define hid_report_type hid_report_type___not_used
+#define hid_class_request hid_class_request___not_used
+#define hid_bpf_attach_flags hid_bpf_attach_flags___not_used
+#define HID_INPUT_REPORT         HID_INPUT_REPORT___not_used
+#define HID_OUTPUT_REPORT        HID_OUTPUT_REPORT___not_used
+#define HID_FEATURE_REPORT       HID_FEATURE_REPORT___not_used
+#define HID_REPORT_TYPES         HID_REPORT_TYPES___not_used
+#define HID_REQ_GET_REPORT       HID_REQ_GET_REPORT___not_used
+#define HID_REQ_GET_IDLE         HID_REQ_GET_IDLE___not_used
+#define HID_REQ_GET_PROTOCOL     HID_REQ_GET_PROTOCOL___not_used
+#define HID_REQ_SET_REPORT       HID_REQ_SET_REPORT___not_used
+#define HID_REQ_SET_IDLE         HID_REQ_SET_IDLE___not_used
+#define HID_REQ_SET_PROTOCOL     HID_REQ_SET_PROTOCOL___not_used
+#define HID_BPF_FLAG_NONE        HID_BPF_FLAG_NONE___not_used
+#define HID_BPF_FLAG_INSERT_HEAD HID_BPF_FLAG_INSERT_HEAD___not_used
+#define HID_BPF_FLAG_MAX         HID_BPF_FLAG_MAX___not_used
+
+#include "vmlinux.h"
+
+#undef hid_bpf_ctx
+#undef hid_report_type
+#undef hid_class_request
+#undef hid_bpf_attach_flags
+#undef HID_INPUT_REPORT
+#undef HID_OUTPUT_REPORT
+#undef HID_FEATURE_REPORT
+#undef HID_REPORT_TYPES
+#undef HID_REQ_GET_REPORT
+#undef HID_REQ_GET_IDLE
+#undef HID_REQ_GET_PROTOCOL
+#undef HID_REQ_SET_REPORT
+#undef HID_REQ_SET_IDLE
+#undef HID_REQ_SET_PROTOCOL
+#undef HID_BPF_FLAG_NONE
+#undef HID_BPF_FLAG_INSERT_HEAD
+#undef HID_BPF_FLAG_MAX
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <linux/const.h>
+
+enum hid_report_type {
+	HID_INPUT_REPORT		= 0,
+	HID_OUTPUT_REPORT		= 1,
+	HID_FEATURE_REPORT		= 2,
+
+	HID_REPORT_TYPES,
+};
+
+struct hid_bpf_ctx {
+	__u32 index;
+	const struct hid_device *hid;
+	__u32 allocated_size;
+	enum hid_report_type report_type;
+	union {
+		__s32 retval;
+		__s32 size;
+	};
+} __attribute__((preserve_access_index));
+
+enum hid_class_request {
+	HID_REQ_GET_REPORT		= 0x01,
+	HID_REQ_GET_IDLE		= 0x02,
+	HID_REQ_GET_PROTOCOL		= 0x03,
+	HID_REQ_SET_REPORT		= 0x09,
+	HID_REQ_SET_IDLE		= 0x0A,
+	HID_REQ_SET_PROTOCOL		= 0x0B,
+};
+
+enum hid_bpf_attach_flags {
+	HID_BPF_FLAG_NONE = 0,
+	HID_BPF_FLAG_INSERT_HEAD = _BITUL(0),
+	HID_BPF_FLAG_MAX,
+};
+
 /* following are kfuncs exported by HID for HID-BPF */
 extern __u8 *hid_bpf_get_data(struct hid_bpf_ctx *ctx,
 			      unsigned int offset,
-- 
2.53.0



