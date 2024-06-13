Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428CF13C8E1;
	Thu, 13 Jun 2024 12:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281113; cv=none; b=DghlISDGj76JB3IPdizq6Eqwfzbpr00W6w4h1Ldy1F2XBNf3RMUQ/nvOpLfCoxMPtBLpvdshWtJhUeye5VsuLwUemzm1jkOPizYrgBVs1D4Q4Oc3gdt2FpZjIK0p8fA2D+90ZLMhAT/YOMUV77KeS3hSzuasPm6QEYw68ewfhv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281113; c=relaxed/simple;
	bh=whlQs20yghcevcRrtKjU7rfdXgOi1Dt6T6eYZ4A8eew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAwmjXBlQsdPvSCkGHHGvYFwPCVxNBNleA1OOrg6Iz8K76MJGVyCshfvzw6LkMDuO2ElfcTUJsY5lLfT53khk66Kc6ZCp7vVCCTsJd4LMzM6edi0J3ASfS3f20thwDgCCvUX6lxDfIvpaJGNXq/f1i2q58qtKoS9VLISZmILJEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xR4WooLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xR4WooLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1D9C2BBFC;
	Thu, 13 Jun 2024 12:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281113;
	bh=whlQs20yghcevcRrtKjU7rfdXgOi1Dt6T6eYZ4A8eew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xR4WooLh5HyduM45jIvRHDwgQ8LnLqs8tgFE9k9+hO9J1KUvqBaPnWFVTokEHQE3H
	 nus+KvECEDl+G8sCL6u9cZae9HaX1ysXrXP4NTyZaQrpk3Q+g+gX1Ln/gf/eoZ9CgE
	 1CE5Z4J3amejpF6jABJ2I3XViPe6N/sOS2pcbvLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/317] serial: max3100: Lock port->lock when calling uart_handle_cts_change()
Date: Thu, 13 Jun 2024 13:32:43 +0200
Message-ID: <20240613113253.178121436@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 77ab53371a2066fdf9b895246505f5ef5a4b5d47 ]

uart_handle_cts_change() has to be called with port lock taken,
Since we run it in a separate work, the lock may not be taken at
the time of running. Make sure that it's taken by explicitly doing
that. Without it we got a splat:

  WARNING: CPU: 0 PID: 10 at drivers/tty/serial/serial_core.c:3491 uart_handle_cts_change+0xa6/0xb0
  ...
  Workqueue: max3100-0 max3100_work [max3100]
  RIP: 0010:uart_handle_cts_change+0xa6/0xb0
  ...
   max3100_handlerx+0xc5/0x110 [max3100]
   max3100_work+0x12a/0x340 [max3100]

Fixes: 7831d56b0a35 ("tty: MAX3100")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240402195306.269276-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max3100.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index 371569a0fd00a..915d7753eec2f 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -213,7 +213,7 @@ static int max3100_sr(struct max3100_port *s, u16 tx, u16 *rx)
 	return 0;
 }
 
-static int max3100_handlerx(struct max3100_port *s, u16 rx)
+static int max3100_handlerx_unlocked(struct max3100_port *s, u16 rx)
 {
 	unsigned int ch, flg, status = 0;
 	int ret = 0, cts;
@@ -253,6 +253,17 @@ static int max3100_handlerx(struct max3100_port *s, u16 rx)
 	return ret;
 }
 
+static int max3100_handlerx(struct max3100_port *s, u16 rx)
+{
+	unsigned long flags;
+	int ret;
+
+	uart_port_lock_irqsave(&s->port, &flags);
+	ret = max3100_handlerx_unlocked(s, rx);
+	uart_port_unlock_irqrestore(&s->port, flags);
+	return ret;
+}
+
 static void max3100_work(struct work_struct *w)
 {
 	struct max3100_port *s = container_of(w, struct max3100_port, work);
-- 
2.43.0



