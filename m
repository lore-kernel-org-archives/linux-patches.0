Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E21432BCB;
	Thu, 16 Jul 2026 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212286; cv=none; b=tP5Cs7oxqJKCpwt4FGQQ6BRzaVolh6eI8/P+8dWOncp775nye5xk4nuxk9za2DnOUEsZV9vorydtlG8DeutkOXtrjLpOV1AJCaLxdrUV8cl0RQiRmfvhPL70tcvDOFhy0ZH6ULPTpDuW8fdCFwpG1S8UA57unvswfvHQxaT9zFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212286; c=relaxed/simple;
	bh=PXeN/Jx8b7xvtB/cGB0LV2ApfKrKW1EIRo20CqtrphQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0ln2g2aP5ZyDrtJCXDsUYLh4X0xKhGM+9LJWY2mDkb8khJwvkPB/5qY2KGFYDFimRZ+n7qdOZHw/cpGK3LM+DNJ7TEJ/L5nSjVa4KgO3C6SQonixqtbRvr1nsVlf3MfCs0WkhCKp+1W+MGBTYygfxAm6ojy2ruRWgTEeX80+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fF8Zxf65; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fF8Zxf65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D4A1F000E9;
	Thu, 16 Jul 2026 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212284;
	bh=aocKPDjaHoO+2rmHHOuIXUXMdjIzzfkGyZwA0bO+tzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fF8Zxf65u9Pp07fUPuUyzKeIyUZghzKK6tNpXCs9RRTjX6xtj3fRuK6xmKhUC9Eme
	 s+a8IAWZ/UyboZkdWNQgSWWM2xnlh9wook6Vl2xwiQSAe+ZnZr6Zgp4PXC/cYnPrlZ
	 qEN6TnfdrSL3vEXxqodEpxVvurBPKr9anAaQ1mz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Philippe De Muyter <phdm@macqel.be>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 268/349] partitions: aix: bound the pp_count scan to the ppe array
Date: Thu, 16 Jul 2026 15:33:22 +0200
Message-ID: <20260716133039.339346042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 2dc0bfd2fe355fb930de63c2f2eb8ced8570c579 upstream.

aix_partition() reads the physical volume descriptor into a fixed-size
struct pvd and then scans its physical-partition-extent array:

	int numpps = be16_to_cpu(pvd->pp_count);
	...
	for (i = 0; i < numpps; i += 1) {
		struct ppe *p = pvd->ppe + i;
		...
		lp_ix = be16_to_cpu(p->lp_ix);

pvd points at a single kmalloc()'d struct pvd whose ppe[] member holds a
fixed ARRAY_SIZE(pvd->ppe) (1016) entries, but the loop runs up to the
on-disk pp_count.  pp_count is an unvalidated __be16 read straight from
the descriptor, so a crafted AIX image with pp_count larger than 1016
drives the loop to read pvd->ppe[i] past the end of the allocation (up
to 65535 entries, ~2 MB out of bounds).

The partition scan runs without mounting anything, when a block device
with a crafted AIX/IBM partition table appears (an attacker-supplied
image attached with losetup -P, or a device auto-scanned by udev), via
msdos_partition() -> aix_partition().

Clamp the scan to the number of entries the ppe[] array can hold.

Fixes: 6ceea22bbbc8 ("partitions: add aix lvm partition support files")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Philippe De Muyter <phdm@macqel.be>
Link: https://patch.msgid.link/20260607064137.302574-1-hexlabsecurity@proton.me
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/partitions/aix.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/block/partitions/aix.c
+++ b/block/partitions/aix.c
@@ -228,6 +228,15 @@ int aix_partition(struct parsed_partitio
 		int next_lp_ix = 1;
 		int lp_ix;
 
+		/*
+		 * pvd was read into a fixed-size struct pvd whose ppe[] array
+		 * holds ARRAY_SIZE(pvd->ppe) entries.  pp_count is an
+		 * unvalidated on-disk __be16, so clamp the scan to the array
+		 * size to avoid walking past the allocation.
+		 */
+		if (numpps > ARRAY_SIZE(pvd->ppe))
+			numpps = ARRAY_SIZE(pvd->ppe);
+
 		for (i = 0; i < numpps; i += 1) {
 			struct ppe *p = pvd->ppe + i;
 			unsigned int lv_ix;


