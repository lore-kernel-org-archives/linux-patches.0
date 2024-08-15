Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C16C1714D0;
	Thu, 15 Aug 2024 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728880; cv=none; b=MnUKFQwmRBqdX2/PTSPCdkAXEQjk2RZ96EGsbSTm/E/aE2Zjol4DIusTRah+Iy8shfzrDKvu0fxFIRjBWNuvVBuETwqcPy6rJ7P5rKlOQLGbJ0RWAZko0i13uRYjd2RoLU7/0WXcrHGgg14gtKNBV9Y/Ew8/pG+It3Ycy3YT14M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728880; c=relaxed/simple;
	bh=/rUquG+zwFYO/JBs44gsnmUTfIl2hqis0iN5BJlw7zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rG0pxjbe9qKR7s+sOIU7GTyVcYG7mq4Zgw9ujCgBne/tnoNwsc8iOqSAC1dkFzN2BAt1e6YDDlMl7djZD14mzN/XyHfNBrWjJaZHtRhuOdIDoQeoORbVP+yF9HHfFXq6utm4pNSqP/wvEy72MrLSFSKGTB5cMV0MeIKRAWVqXWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4NmShaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4NmShaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AB1C32786;
	Thu, 15 Aug 2024 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728880;
	bh=/rUquG+zwFYO/JBs44gsnmUTfIl2hqis0iN5BJlw7zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4NmShaE6TeErjwAKm+mnx4SxYyWnPY5No5R2LDj4d7uhQVY3mP0bpLPFV80VnWWB
	 KUUgQBiCGu+86XA8zmNRUftzKhWhEem/D6Y6nqi/jfFx8g3JhCgWSkm3YO+LjCI7EX
	 07nVSubTbWAjcs/oIhS9tcTDbdSczmLE4bQWrQ5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tuhaowen <tuhaowen@uniontech.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/196] dev/parport: fix the array out-of-bounds risk
Date: Thu, 15 Aug 2024 15:23:49 +0200
Message-ID: <20240815131856.365351120@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: tuhaowen <tuhaowen@uniontech.com>

[ Upstream commit ab11dac93d2d568d151b1918d7b84c2d02bacbd5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/procfs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index e957beb94f142..595e23e6859b6 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -51,12 +51,12 @@ static int do_active_device(struct ctl_table *table, int write,
 	
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
@@ -87,19 +87,19 @@ static int do_autoprobe(struct ctl_table *table, int write,
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
@@ -117,7 +117,7 @@ static int do_hardware_base_addr(struct ctl_table *table, int write,
 				 size_t *lenp, loff_t *ppos)
 {
 	struct parport *port = (struct parport *)table->extra1;
-	char buffer[20];
+	char buffer[64];
 	int len = 0;
 
 	if (*ppos) {
@@ -128,7 +128,7 @@ static int do_hardware_base_addr(struct ctl_table *table, int write,
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += sprintf (buffer, "%lu\t%lu\n", port->base, port->base_hi);
+	len += snprintf (buffer, sizeof(buffer), "%lu\t%lu\n", port->base, port->base_hi);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -156,7 +156,7 @@ static int do_hardware_irq(struct ctl_table *table, int write,
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += sprintf (buffer, "%d\n", port->irq);
+	len += snprintf (buffer, sizeof(buffer), "%d\n", port->irq);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -184,7 +184,7 @@ static int do_hardware_dma(struct ctl_table *table, int write,
 	if (write) /* permissions prevent this anyway */
 		return -EACCES;
 
-	len += sprintf (buffer, "%d\n", port->dma);
+	len += snprintf (buffer, sizeof(buffer), "%d\n", port->dma);
 
 	if (len > *lenp)
 		len = *lenp;
@@ -216,7 +216,7 @@ static int do_hardware_modes(struct ctl_table *table, int write,
 #define printmode(x)							\
 do {									\
 	if (port->modes & PARPORT_MODE_##x)				\
-		len += sprintf(buffer + len, "%s%s", f++ ? "," : "", #x); \
+		len += snprintf(buffer + len, sizeof(buffer) - len, "%s%s", f++ ? "," : "", #x); \
 } while (0)
 		int f = 0;
 		printmode(PCSPP);
-- 
2.43.0



