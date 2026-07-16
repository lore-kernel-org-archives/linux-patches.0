Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804FB3BCD05;
	Thu, 16 Jul 2026 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210005; cv=none; b=WV/ySl5ZlN6wh5FNWe0Bv8YbphP6VcMG+8wiryz9H1OOk/MI01tQcKiXW96wmSnxpTBqwPU08/p8E2YHsXdAa3w2qqS+XN4X/8NoRBnjgNB1sVPPZLXw6zbgD3hUrFezTU0dvqNF3hdEusMu930nYACx03T9L9wW9Pn4PabCufI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210005; c=relaxed/simple;
	bh=IktqfzLAn7yZw73g57yBN8/+iilOsoaoBe2SElsCdYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZpYacKX3IKqBBV95MHM5QCPWgNBgsAQLBNPVmwRlWVfIEgJ3c4d18ze79nQq2s4FfSPBHz8xpLUVOfvq7Y6DGVvNa5JV/1VwpV3PoZNV67GMMvm9SvU058zuKbslxxnYgR3lF6hqSQF4sy7GEMVk/VmiVyKko7VoI9gty3pO/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b32ujQXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b32ujQXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B571F000E9;
	Thu, 16 Jul 2026 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210004;
	bh=p8TPahNm7d2IzSeEAiSAbzkIgmpWjJorP5hFuOIF1gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b32ujQXIALSS+uUT+KsgFtUM7J60W6mNbpKh9sGzpsMi2E+JJ7BJZ2g0Bar5psfYu
	 9BSJBiOjIVfp9YiME937aksN1/VyU4zXIPFJfqSUFgWh3xE+7M8wV2FkSqFXGRsrLn
	 yTPblfPHPoal2VtPuzriatvYsKygS4/yEcqdmcUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Philippe De Muyter <phdm@macqel.be>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 357/518] partitions: aix: bound the pp_count scan to the ppe array
Date: Thu, 16 Jul 2026 15:30:25 +0200
Message-ID: <20260716133055.640531354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -226,6 +226,15 @@ int aix_partition(struct parsed_partitio
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


