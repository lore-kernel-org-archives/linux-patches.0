Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207051;
	b=UHq8mz2Yi2eCU527nVSIqW6CzNIyVOEWLLA4mR5NFum+APT/BxxIFpgnVoeIWX1Yu9I3
	 3dY0AX+Dh35Q6nrOHu6WFh6rUopm7enkI2SNcFPNvFOy/ELvJeBNz4I5fIZ504qkPGg0X
	 DwEC1zzS38om6jguFjEn+MgOOPDPWIvp4WEBv8Nmq5rX67JQkmfdW2oayjzzhrIXiKPiQ
	 o9UIV+qtsKDV4Wyr17xIGj6llilYc86UsOaO/6pRrvrepJWznrPExkdqlI5/FfDgCUaLx
	 35odtYolDrb7dsd30brbidJudhfcpUPEL2bhG+K1Dbmx1uffvYaZupHC2fkhsaBuGjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p4NctfXu6KZM1lZaLq5pbRnbUa5suz8B2B29M2bNgEw=;
	b=dDTDwNs4NKs61TCyh7rYjFhe+ThHh53dlc1prGaHWCIE58pF8SrMNDUewNEsrDUVC8Wu
	 E9UHOS9jZWK+I4r8ES0zqgcTje5zRJPkg/5nHrgsZEfFzamvjx7Tg6kXjFaFG9AIvifUB
	 2mkk8/VSenmQHhSG1EyF0qqlbn3NeiHhdTwWdc305kV+XnjaFeWIpdNGSWV0iPyUFB3Fn
	 SVqSC69aXS9vbUrAER2PR/PrJeDT5cK3+RiJ6UpxE5boFe3eOVkxAsJNXM477eXXF8lGr
	 HD53r+dT7IBxXEVuaxNPBvxlVu57qD5sBe2J12oHDnl5NDka1QydrZHhKhTOyR3T/gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciUynwKh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF9B606A31A;
	Wed, 28 Oct 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciUynwKh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728401F01829;
	Wed, 28 Oct 2026 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207051;
	bh=p4NctfXu6KZM1lZaLq5pbRnbUa5suz8B2B29M2bNgEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciUynwKhzGhcbaU4G675c6N9VqGCtKjd0cMLtid6o2WtPFjWhurpjqkv+5IUwCOMP
	 QTyWgW8btnby4vxdwHKx1FLHdqJ0I9+qZJu0ubQanYszLLyr3B5D1dnifQaA3mSgXo
	 wUpiybbQng+r64oh6etWgR5Cp6yJPy61OueUwEiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haris Okanovic <harisokn@amazon.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Radu Rendec <radu@rendec.net>
Subject: [PATCH 7.3 01/38] genirq/proc: Fix missing CPU header in /proc/interrupts
Date: Wed, 28 Oct 2026 17:59:48 +0100
Message-ID: <20261028165940.436576652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haris Okanovic <harisokn@amazon.com>

commit e74798f2f8e1562f2bbd2fed8d81929eeef39ffc upstream.

irq_seq_show() must be idempotent since it may be called multiple times
to render the same record, e.g. when seq_file's buffer is exceeded. It
emits the CPU header behind the one-shot print_header flag, which the
first pass clears, so the header is lost with the discarded buffer.

This can be seen on large systems, such as 8g.48xl (192 CPUs) and
8i.96xl (384 CPUs) AWS instance types:

  $ head -1 /proc/interrupts
     9:          0          0 ...  0  GICv3  25 Level  vgic

Replace print_header with the position of the first record and include
the header whenever that record is emitted.

Fixes: 171cc0d9eed1 ("genirq/proc: Speed up /proc/interrupts iteration")
Signed-off-by: Haris Okanovic <harisokn@amazon.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260911-dev-harisokn-proc-interrupts-fix-b4-v1-1-f9ff208efcfa@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/proc.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -462,7 +462,7 @@ int __weak arch_show_interrupts(struct s
 static DEFINE_RAW_SPINLOCK(irq_proc_constraints_lock);
 
 static struct irq_proc_constraints {
-	bool		print_header;
+	loff_t		first_pos;
 	unsigned int	num_prec;
 	unsigned int	chip_width;
 } irq_proc_constraints __read_mostly = {
@@ -543,14 +543,13 @@ static int irq_seq_show(struct seq_file
 	struct irqaction *action;
 
 	/* Print header for the first interrupt? */
-	if (constr->print_header) {
+	if (p->index == constr->first_pos) {
 		unsigned int cpu;
 
 		seq_printf(p, "%*s", constr->num_prec + 8, "");
 		for_each_online_cpu(cpu)
 			seq_printf(p, "CPU%-8d", cpu);
 		seq_putc(p, '\n');
-		constr->print_header = false;
 	}
 
 	if (desc == ARCH_PROC_IRQDESC)
@@ -635,14 +634,25 @@ static void *irq_seq_next_desc(loff_t *p
 
 static void *irq_seq_start(struct seq_file *f, loff_t *pos)
 {
-	if (!*pos) {
-		struct irq_proc_constraints *constr = f->private;
+	struct irq_proc_constraints *constr = f->private;
+	bool first = !*pos;
+	void *ret;
 
+	if (first) {
 		constr->num_prec = READ_ONCE(irq_proc_constraints.num_prec);
 		constr->chip_width = READ_ONCE(irq_proc_constraints.chip_width);
-		constr->print_header = true;
 	}
-	return irq_seq_next_desc(pos);
+
+	ret = irq_seq_next_desc(pos);
+
+	/*
+	 * Record position of the first output record so that irq_seq_show()
+	 * knows where to write the header.
+	 */
+	if (first)
+		constr->first_pos = *pos;
+
+	return ret;
 }
 
 static void *irq_seq_next(struct seq_file *f, void *v, loff_t *pos)


