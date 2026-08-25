Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3186F25393E;
	Tue, 25 Aug 2026 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666075; cv=none; b=ZajjUesVlu56dcdHjahqGrFpnMfeujKQ7vxqnz3VKhGliFN+wP9AcTx7QtUwMDOYS1HU7DWYFGHdWCgN3IWV+kBLmP7GvZrBNdc8OBpa48WZP+L2T+I+Fp7YDoZs6pPri7mpJetkDDkRTx2V/982WuWfAmPkHxjUcFoAeO5M+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666075; c=relaxed/simple;
	bh=R0oUvCj0LGS+C1Tz/hBXVFThm6qTi/CnW6IDPgjnfsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoQznyEu64lBlE4pF7Pu6m/ARSd9BpbNkm1OOBXmX2ceaEsZNs2toEi3HeOvNJZqgc19rjJkm2AQgP0GKQhiEmJnyBEhpz3kL4G3mZ6ZtjdeWpeBcph/h7B4N4pg0qyDsVcsZoaO+ae4uKuNCswVT1boBfn7ubFpeELCQlYe0gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrHKYeL/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrHKYeL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3261F00A3A;
	Tue, 25 Aug 2026 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666074;
	bh=empxjPLj4z4mlh68zZ3LS9RDiMvzJTFQaB/4nPsC580=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BrHKYeL/97QDE/aZiNVmnXAZIfeKDTGU7bcHTSmQ4fWmnE54xut4pqaJBrZVjfpGo
	 g/7w9DzF8hcgxjdSDs0LQQbmwcuoXkFDACstAzzakG8LpONSRZRm2rsS8VQmXzYFSo
	 Xh1+BSXz24Synq/uB+6hssERuXcHlQ96oXFCHydA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 75/79] HID: nintendo: fix out-of-bounds read in joycon_ctlr_read_handler()
Date: Tue, 25 Aug 2026 15:26:55 +0200
Message-ID: <20260825132544.608876971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

commit 27b376b945c0aac46fcdfcc950b14a85b874b557 upstream.

joycon_ctlr_read_handler() casts an incoming HID input report to
struct joycon_input_report and parses it, guarding the cast only with a
12-byte length check:

	if (size >= 12) /* make sure it contains the input report */
		joycon_parse_report(ctlr, (struct joycon_input_report *)data);

struct joycon_input_report is 49 bytes: a 13-byte header followed by a
union whose IMU arm is 36 bytes. For an IMU report joycon_parse_report()
-> joycon_parse_imu_report() walks that union (struct offsets 13..48),
so a report of exactly 12 bytes with data[0] == JC_INPUT_IMU_DATA passes
the guard yet is read up to 37 bytes past its declared length. The
over-read bytes are decoded into accelerometer/gyroscope values and
forwarded to userspace through the "(IMU)" input device, leaking
driver-internal memory. data[0] and size are fully controlled by a
malicious or spoofed Joy-Con/Pro Controller.

Receive buffers are sized to the maximum report length, so this is an
over-read within the allocation rather than a slab OOB, but the decoded
bytes still reach userspace.

The sibling subcmd path in joycon_ctlr_handle_event() already bounds the
same cast correctly:

	if (size < sizeof(struct joycon_input_report) ||
	    data[0] != JC_INPUT_SUBCMD_REPLY)
		break;

Use the same sizeof(struct joycon_input_report) bound here.

Fixes: 2af16c1f846b ("HID: nintendo: add nintendo switch controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-nintendo.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -2140,7 +2140,12 @@ static int joycon_ctlr_read_handler(stru
 {
 	if (data[0] == JC_INPUT_SUBCMD_REPLY || data[0] == JC_INPUT_IMU_DATA ||
 	    data[0] == JC_INPUT_MCU_DATA) {
-		if (size >= 12) /* make sure it contains the input report */
+		/*
+		 * The whole struct is cast and parsed below, including the
+		 * IMU/subcmd union, not just the 12-byte partial header this
+		 * used to check for.
+		 */
+		if (size >= sizeof(struct joycon_input_report))
 			joycon_parse_report(ctlr,
 					    (struct joycon_input_report *)data);
 	}


