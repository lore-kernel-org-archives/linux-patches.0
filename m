Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E151A76B2;
	Tue, 30 Jul 2024 17:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360257; cv=none; b=J1n0ATy8BE4rMqubLSE7jaI1ux8WV8SlvSCCSSxEG7BKFoPHQMthopGjcDfLrK46LymNjNk9nof8dF6th68BQyQx3CrYBpf7KB9miycrfinA5Mp9IRPjVjJJs4mf1bHRlT1NL8ETEn8SgFocKCyTp50ngj+p22LT6SxpiwOJn8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360257; c=relaxed/simple;
	bh=GFcgtSEb8X4/CCLshYkJg91GBBexpHuW1G6GhiX5D28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvQAEjYymhT9+9GQuCa2yjjKMDuYOHPxZhsN/V+Zj8SbLtsTG3UANmtpn8bq3mtCavrx2rr9sOD3fzkdfR4fVYtTe02hpyn8UvXaZFj5z94dkU2Hlyoz4tf3rjj80SNMF1XM8SgTD7RBbjs4+axiMKNrEwsquRKVtCtKKNx8hPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2iNtzeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2iNtzeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93CAC4AF0C;
	Tue, 30 Jul 2024 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360257;
	bh=GFcgtSEb8X4/CCLshYkJg91GBBexpHuW1G6GhiX5D28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2iNtzeIBgbY5A4BZ4RieFL9Yr4CCSF6C1xk64wZ3f1BCoow4lyf5B83+RvJPMErE
	 tzrR4xof+F9bpYDjF/FApKVvvNWVWF2O1ksGkqNc+OinBf6F/9mIEJd8ilhvT28q0q
	 gLmuzoXtYJDyUES8K/qmP59Z5oWvqRscCeXblBIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tuhaowen <tuhaowen@uniontech.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.10 644/809] dev/parport: fix the array out-of-bounds risk
Date: Tue, 30 Jul 2024 17:48:40 +0200
Message-ID: <20240730151750.302333123@linuxfoundation.org>
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

From: tuhaowen <tuhaowen@uniontech.com>

commit ab11dac93d2d568d151b1918d7b84c2d02bacbd5 upstream.

Fixed array out-of-bounds issues caused by sprintf
by replacing it with snprintf for safer data copying,
ensuring the destination buffer is not overflowed.

Below is the stack trace I encountered during the actual issue:

[ 66.575408s] [pid:5118,cpu4,QThread,4]Kernel panic - not syncing: stack-protector:
Kernel stack is corrupted in: do_hardware_base_addr+0xcc/0xd0 [parport]
[ 66.575408s] [pid:5118,cpu4,QThread,5]CPU: 4 PID: 5118 Comm:
QThread Tainted: G S W O 5.10.97-arm64-desktop #7100.57021.2
[ 66.575439s] [pid:5118,cpu4,QThread,6]TGID: 5087 Comm: EFileApp
[ 66.575439s] [pid:5118,cpu4,QThread,7]Hardware name: HUAWEI HUAWEI QingYun
PGUX-W515x-B081/SP1PANGUXM, BIOS 1.00.07 04/29/2024
[ 66.575439s] [pid:5118,cpu4,QThread,8]Call trace:
[ 66.575469s] [pid:5118,cpu4,QThread,9] dump_backtrace+0x0/0x1c0
[ 66.575469s] [pid:5118,cpu4,QThread,0] show_stack+0x14/0x20
[ 66.575469s] [pid:5118,cpu4,QThread,1] dump_stack+0xd4/0x10c
[ 66.575500s] [pid:5118,cpu4,QThread,2] panic+0x1d8/0x3bc
[ 66.575500s] [pid:5118,cpu4,QThread,3] __stack_chk_fail+0x2c/0x38
[ 66.575500s] [pid:5118,cpu4,QThread,4] do_hardware_base_addr+0xcc/0xd0 [parport]

Signed-off-by: tuhaowen <tuhaowen@uniontech.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240708080430.8221-1-tuhaowen@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parport/procfs.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -51,12 +51,12 @@ static int do_active_device(struct ctl_t
 	
 	for (dev = port->devices; dev ; dev = dev->next) {
 		if(dev == port->cad) {
-			len += sprintf(buffer, "%s\n", dev->name);
+			len += snprintf(buffer, sizeof(buffer), "%s\n", dev->name);
 		}
 	}
 
 	if(!len) {
-		len += sprintf(buffer, "%s\n", "none");
+		len += snprintf(buffer, sizeof(buffer), "%s\n", "none");
 	}
 
 	if (len > *lenp)
@@ -87,19 +87,19 @@ static int do_autoprobe(struct ctl_table
 	}
 	
 	if ((str = info->class_name) != NULL)
-		len += sprintf (buffer + len, "CLASS:%s;\n", str);
+		len += snprintf (buffer + len, sizeof(buffer) - len, "CLASS:%s;\n", str);
 
 	if ((str = info->model) != NULL)
-		len += sprintf (buffer + len, "MODEL:%s;\n", str);
+		len += snprintf (buffer + len, sizeof(buffer) - len, "MODEL:%s;\n", str);
 
 	if ((str = info->mfr) != NULL)
-		len += sprintf (buffer + len, "MANUFACTURER:%s;\n", str);
+		len += snprintf (buffer + len, sizeof(buffer) - len, "MANUFACTURER:%s;\n", str);
 
 	if ((str = info->description) != NULL)
-		len += sprintf (buffer + len, "DESCRIPTION:%s;\n", str);
+		len += snprintf (buffer + len, sizeof(buffer) - len, "DESCRIPTION:%s;\n", str);
 
 	if ((str = info->cmdset) != NULL)
-		len += sprintf (buffer + len, "COMMAND SET:%s;\n", str);
+		len += snprintf (buffer + len, sizeof(buffer) - len, "COMMAND SET:%s;\n", str);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -117,7 +117,7 @@ static int do_hardware_base_addr(struct
 				 void *result, size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
-	char buffer[20];
+	char buffer[64];
 	int len = 0;
 
 	if (*ppos) {
@@ -128,7 +128,7 @@ static int do_hardware_base_addr(struct
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += sprintf (buffer, "%lu\t%lu\n", port->base, port->base_hi);
+	len += snprintf (buffer, sizeof(buffer), "%lu\t%lu\n", port->base, port->base_hi);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -155,7 +155,7 @@ static int do_hardware_irq(struct ctl_ta
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += sprintf (buffer, "%d\n", port->irq);
+	len += snprintf (buffer, sizeof(buffer), "%d\n", port->irq);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -182,7 +182,7 @@ static int do_hardware_dma(struct ctl_ta
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += sprintf (buffer, "%d\n", port->dma);
+	len += snprintf (buffer, sizeof(buffer), "%d\n", port->dma);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -213,7 +213,7 @@ static int do_hardware_modes(struct ctl_
 #define printmode(x)							\
 do {									\
 	if (port->modes & PARPORT_MODE_##x)				\
-		len += sprintf(buffer + len, "%s%s", f++ ? "," : "", #x); \
+		len += snprintf(buffer + len, sizeof(buffer) - len, "%s%s", f++ ? "," : "", #x); \
 } while (0)
 		int f = 0;
 		printmode(PCSPP);


