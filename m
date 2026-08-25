Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862243C276D;
	Tue, 25 Aug 2026 13:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665561; cv=none; b=THvI4YXqkox5Yy5FGx9GC6Dc3b4HFpisiSZDh8aLLHkYzyW/JAqqPfXOAK0YWwxQ6uMS5ChSqFol7/SvofuTIuIk5G2VV/QopFwrPv/WhM9Nl1ZIzhxcQGOTk2SegWPJzxlFfmKTIdX+CD7bgMxn9Kkz5WKrErLfeUnjKQ5QQD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665561; c=relaxed/simple;
	bh=IgpzGHvSAm8wP8QljWH8hq9PsKuzoEU2ZrYdCgHg2oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+LxAa1MBVSoMXh53kxR3uY2fuNqjg/gpdPjGiOYDc4ZFkHDU3hlu5gGzF+XnGq2jmC+ygBWmvF0kjf5mMs7QzR02E89VJ9S7o1y7rU8dWzgpl5Poc1fPCuUxsQHobKCsdOWKf0ZKx1HsWGZ1wGVRZFdztIlzMqiYtV4bp8nMac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q87iYPXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q87iYPXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97F31F000E9;
	Tue, 25 Aug 2026 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665560;
	bh=MNJFpIRBtqGUcVHGW+9zVkm4HyNbYrp9V6wrvwfGVCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q87iYPXf9j1EjlcZtryUiJYX4tGgxOyIbn9NaVmcvAduNhKEId53PknfnNMTJP28f
	 cUPB/XjVt0oaThvk9cHPRm4EnU9Io7ZKwcNgIlq++vCcjxTTbXgUHvhZY9YGQQCwKj
	 Q7NivoVTs+nYgIgU6+LpcFj1Gn2+qudw/upwBPmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 68/77] HID: nintendo: fix out-of-bounds read in joycon_ctlr_read_handler()
Date: Tue, 25 Aug 2026 15:26:30 +0200
Message-ID: <20260825132544.192535725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2563,7 +2563,12 @@ static int joycon_ctlr_read_handler(stru
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


