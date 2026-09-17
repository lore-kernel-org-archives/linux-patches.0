Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B8A3B27DF;
	Thu, 17 Sep 2026 16:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663875; cv=none; b=QasEh3QZp/nxcjhwfO+urKI27ovTto8zUdz3rFwLPMI2pnCwr8HU9PYuezVwhtW1Pfk3SYY1mq/4wTGDltdLkXeitt9ybyGfeFqE1yjvF5/xM/ki9b+o/Ecn3PfuMDVmDM5aah3ttwRjipPrDR37HH0tQCcetoa0A6hSRJ/lO+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663875; c=relaxed/simple;
	bh=qr9b+RCZPu268CfwaPusqsDsjgvg+csHg8OBwPcKDgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMRyu/HRPICAZ02OkK2BTQG6ogMscUzn9o/BYnGxFD5Fp9sYEv/uZorxIvpO9ivm5NiBZSf7nm6gh+FklK09p6+nUVnic/O5VhSGOs7Dl7Rpukw49bUKPArUy0L5P9mu6qHRnxBiShDYHyesJAzdrdfFmWEDljQjhLxZjTresYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyX23m1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyX23m1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DD91F00893;
	Thu, 17 Sep 2026 16:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663874;
	bh=cg3CyIn/eOfrkod7/rrf4Z4pG7PeW2WdUDVI0lnbLCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyX23m1Z6u7dct7V0l7PgmGhaXhitP5Ctem1xjw0apk5A5nvtXrFxirEAgISlUnkt
	 IHvKlN1PdAirESsHMUmRjzJswrcy4noakYgSGH9sJWrve9HCIZFEhwaxtFc6CoPyO5
	 8LyMIRvDBrj0tYWx9PRDSHZeT1/a8cBYZaREu8+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Chatterjee <nikhilc1527@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0184/1250] HID: bpf: Add Huion Inspiroy Frego M button quirk
Date: Thu, 17 Sep 2026 15:59:39 +0100
Message-ID: <20260917151557.098127815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Nikhil Chatterjee <nikhilc1527@gmail.com>

[ Upstream commit 857e71cb0a538b1660743a4267a1e789575f7966 ]

The Huion Inspiroy Frego M pen report descriptor exposes the second
side button as Secondary Tip Switch instead of Secondary Barrel Switch.
This makes userspace see the control as the wrong pen button.

Add a HID-BPF report descriptor fixup for the Bluetooth 256c:8251
device and USB 256c:2012 L610 variant. The fixup matches the expected
pen descriptor and rewrites the offending usage from Secondary Tip
Switch to Secondary Barrel Switch.

Tested by building the HID-BPF object with:

  make -C drivers/hid/bpf/progs Huion__Inspiroy-Frego-M.bpf.o

Signed-off-by: Nikhil Chatterjee <nikhilc1527@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/Huion__Inspiroy-Frego-M.bpf.c   | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 drivers/hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c

diff --git a/drivers/hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c b/drivers/hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c
new file mode 100644
index 0000000000000..e6ba2295dc775
--- /dev/null
+++ b/drivers/hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "vmlinux.h"
+#include "hid_bpf.h"
+#include "hid_bpf_helpers.h"
+#include <bpf/bpf_tracing.h>
+
+/*
+ * Huion Inspiroy Frego M Pen Tablet
+ * Model L610
+ * 256c:8251 (Bluetooth)
+ * 256c:2012 (USB)
+ */
+#define VID_HUION			0x256C
+#define PID_INSPIROY_FREGO_M		0x8251
+#define PID_L610			0x2012
+
+#define PEN_RDESC_SIZE			125
+#define SECONDARY_SWITCH_OFFSET		17
+
+HID_BPF_CONFIG(
+	HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_GENERIC, VID_HUION, PID_INSPIROY_FREGO_M),
+	HID_DEVICE(BUS_USB, HID_GROUP_GENERIC, VID_HUION, PID_L610)
+);
+
+/*
+ * The pen descriptor reports the second side button as Secondary Tip Switch
+ * instead of Secondary Barrel Switch.
+ *
+ * Relevant part of the original pen report descriptor:
+ *
+ * 0x09, 0x42,       // Usage (Tip Switch)                  12
+ * 0x09, 0x44,       // Usage (Barrel Switch)               14
+ * 0x09, 0x43,       // Usage (Secondary Tip Switch)        16 <- change to 0x5a
+ * 0x09, 0x3c,       // Usage (Invert)                      18
+ * 0x09, 0x45,       // Usage (Eraser)                      20
+ * 0x15, 0x00,       // Logical Minimum (0)                 22
+ * 0x25, 0x01,       // Logical Maximum (1)                 24
+ */
+SEC(HID_BPF_RDESC_FIXUP)
+int BPF_PROG(fix_secondary_barrel_rdesc, struct hid_bpf_ctx *hctx)
+{
+	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, HID_MAX_DESCRIPTOR_SIZE /* size */);
+
+	if (!data)
+		return 0; /* EPERM check */
+
+	if (hctx->size != PEN_RDESC_SIZE)
+		return 0;
+
+	if (data[0] != 0x05 || data[1] != 0x0d || /* Usage Page (Digitizers) */
+	    data[2] != 0x09 || data[3] != 0x02 || /* Usage (Pen) */
+	    data[16] != 0x09 ||
+	    data[SECONDARY_SWITCH_OFFSET] != 0x43) /* Secondary Tip Switch */
+		return 0;
+
+	data[SECONDARY_SWITCH_OFFSET] = 0x5a;
+
+	return 0;
+}
+
+HID_BPF_OPS(fix_secondary_barrel) = {
+	.hid_rdesc_fixup = (void *)fix_secondary_barrel_rdesc,
+};
+
+SEC("syscall")
+int probe(struct hid_bpf_probe_args *ctx)
+{
+	ctx->retval = ctx->rdesc_size != PEN_RDESC_SIZE;
+	if (ctx->retval) {
+		ctx->retval = -EINVAL;
+		return 0;
+	}
+
+	if (ctx->rdesc[0] != 0x05 || ctx->rdesc[1] != 0x0d || /* Usage Page (Digitizers) */
+	    ctx->rdesc[2] != 0x09 || ctx->rdesc[3] != 0x02 || /* Usage (Pen) */
+	    ctx->rdesc[16] != 0x09 ||
+	    ctx->rdesc[SECONDARY_SWITCH_OFFSET] != 0x43) { /* Secondary Tip Switch */
+		ctx->retval = -EINVAL;
+		return 0;
+	}
+
+	ctx->retval = 0;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.53.0



