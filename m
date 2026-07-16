Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4399E30AD05;
	Thu, 16 Jul 2026 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211218; cv=none; b=RVmNi/tkLnmzCFe6pmgaREBGg2urHPD1J+PIXANWWgDdpOcvvDDtLlchaImQrROAwK40r4Zi3+uoOC5iA/n6QQ4cXCJcRCJ4ckuGIa8XQWq3d1JF0B2PXpY7Xgw2tMT4d07ZqQ+Y5RjFsG/WzDXt3Ol6ieNbiexy+K+AZJxL/pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211218; c=relaxed/simple;
	bh=G4/FNrtMqX23DP+Pbq20w2mCc/Z4BPgLDYVh/bJTAyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/6BLPXMd4GIrBLPL2Oa6EETNMrhAUsZn6HH10mLRcRseOr2QXl3KCxPkQE8gr7H6A6hBdsqotAFJTgRxt6tOYSzL+HsmbhWurU2E0X3h22jvMG3XeieztjN6/8C06X+O8YUpod3WHIAlfTG/ngY3QZo/KRhjO4t36pfaKQmpRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfQT+bRd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfQT+bRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F4C1F000E9;
	Thu, 16 Jul 2026 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211217;
	bh=UHUcNzSiNZRm8/T0KJlzWqQHIunR6rrUP+kpYcASV6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfQT+bRdzSVap4my0Y+OqOeR5k8huHLyppqRHMl+ObCn1Hk29sM3EyL7qgIZNEDf/
	 NHvJryce4YgJqc6GvH2EibAUfGX38e07IH91kgfSaJnuvZXdWGIATMa6pOswBxmQ7M
	 0EZlrJdLDR/wvpuo9HXRrPgNbcj/rAFNOARBPHxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Philippe De Muyter <phdm@macqel.be>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 344/480] partitions: aix: bound the pp_count scan to the ppe array
Date: Thu, 16 Jul 2026 15:31:31 +0200
Message-ID: <20260716133052.252757930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


