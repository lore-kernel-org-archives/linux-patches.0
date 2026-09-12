Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7726F330647;
	Sat, 12 Sep 2026 14:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222303; cv=none; b=o2OAjjXv6Kq5yPUfXiu/1kahmcL6q5/Ws+Z0dZ1eUsD7Jie4KUXB//EnESY9QnCaI7wMoHqtELjyTHOHt1k7fUB1KyBqjWXOk/rnt5X43mc358NqL5xeGhlA/JWweonPcOKAHaQ9ymA5Ve67TMXwd8Y3giGVkYuuNE68/EwJ94Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222303; c=relaxed/simple;
	bh=VHAjLjAE6LuwAbVkuWVNnxSxtPAw9eTg0Q68W9EPKQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP9X2H+CRQJHQao7S1W4cwYh1P1qIs3xq11hn1CrMkLn2xTh3aWa5km3H7uZbn7xpshrHGCeuvDa+V9cOPCe4NG3vldza3NPlB/A+ciUs3VB2RWHXRZL9G+lUau5YFCw9v392rbrETPw1nc6PXbMeSx47wqSRcxfUfBPjxc9V9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndYzKKxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndYzKKxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805111F000FF;
	Sat, 12 Sep 2026 14:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222302;
	bh=n+96PSctEp7IfQ8QSd6s5AdonjiM8BZt4QTKmWf+uMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndYzKKxAUHCqUcC4kKiDqU76BLZDDsPCbJu8tRiRpEbXB4tefoJx8B3TeZuH2hMf9
	 /9kukpAK1yzEdW3TIOhV1TO1xoxBLUqBfe7WdxmtGCsKiCUfjR2/Ktcg6xslkbRHUx
	 F+GxRzUY5cB7SHQTt5EM2kLdsfBlF0J17BxyePTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Wei <huangwei@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0559/1424] usb: typec: ucsi: use UCSI_TIMEOUT_MS for sync command completion
Date: Sat, 12 Sep 2026 08:49:51 +0200
Message-ID: <20260912065619.822713170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Huang Wei <huangwei@kylinos.cn>

commit eb4573cf2fd860b20adfae050c3f6ec6ddc3abdb upstream.

The synchronous command completion path in ucsi_acpi_sync_write() hardcodes
a 5 second (5 * HZ) timeout when waiting for the PPM to signal command
completion via ACPI notification. This value matched UCSI_TIMEOUT_MS when it
was still 5000 ms, but it was not updated when that macro was later raised
to 10000 ms to fix PPM reset timeouts.

As a result, the two PPM communication paths are now inconsistent: the
polling path in ucsi_reset_ppm() respects the 10 second timeout, while the
event-driven completion path still uses 5 seconds. On machines where the
firmware is slow to respond during boot (e.g. some Lenovo ThinkPad models
such as the E14 Gen 7), commands sent after the PPM reset, such as
SET_NOTIFICATION_ENABLE and GET_CAPABILITY, can exceed 5 seconds and cause
UCSI initialization to fail with:

    ucsi_acpi USBC000:00: error -ETIMEDOUT: PPM init failed

Once UCSI init aborts, USB-C PD negotiation never completes, which in turn
blocks USB-C dock enumeration since the dock depends on a successful PD
contract.

Replace the hardcoded 5 * HZ with msecs_to_jiffies(UCSI_TIMEOUT_MS) so that
both communication paths share a single, consistent timeout value. Move the
UCSI_TIMEOUT_MS definition to ucsi.h so the ACPI backend can use it.

Fixes: bf4f9ae1cb08c ("usb: typec: ucsi: increase timeout for PPM reset operations")
Signed-off-by: Huang Wei <huangwei@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c      | 10 ----------
 drivers/usb/typec/ucsi/ucsi.h      |  3 +++
 drivers/usb/typec/ucsi/ucsi_acpi.c |  3 ++-
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index b0d5f071664fe..8cfde3cb85af0 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -17,16 +17,6 @@
 #include "ucsi.h"
 #include "trace.h"
 
-/*
- * UCSI_TIMEOUT_MS - PPM communication timeout
- *
- * Ideally we could use MIN_TIME_TO_RESPOND_WITH_BUSY (which is defined in UCSI
- * specification) here as reference, but unfortunately we can't. It is very
- * difficult to estimate the time it takes for the system to process the command
- * before it is actually passed to the PPM.
- */
-#define UCSI_TIMEOUT_MS		10000
-
 /*
  * UCSI_SWAP_TIMEOUT_MS - Timeout for role swap requests
  *
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 9ac5ad87f4015..f0cf52c6ddeba 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -26,6 +26,9 @@ struct dentry;
 #define UCSI_MESSAGE_OUT		32
 #define UCSIv2_MESSAGE_OUT		272
 
+/* PPM communication timeout in milliseconds */
+#define UCSI_TIMEOUT_MS		10000
+
 /* UCSI versions */
 #define UCSI_VERSION_1_2	0x0120
 #define UCSI_VERSION_2_0	0x0200
diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index e40f3bf650ad8..1054947497bb2 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -88,7 +88,8 @@ static int ucsi_acpi_sync_write(struct ucsi *ucsi, unsigned int offset,
 	if (ret)
 		goto out_clear_bit;
 
-	if (!wait_for_completion_timeout(&ua->complete, 5 * HZ))
+	if (!wait_for_completion_timeout(&ua->complete,
+					 msecs_to_jiffies(UCSI_TIMEOUT_MS)))
 		ret = -ETIMEDOUT;
 
 out_clear_bit:
-- 
2.53.0



