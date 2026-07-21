Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B345367B63;
	Tue, 21 Jul 2026 22:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673345; cv=none; b=U/To7T4rsVDSe4Fok5VJJcdrHhTZoJ3v4czokwYom669dsleGX5ZC2Adnp+7El7ucOf4EJzwf5U5AaDI9E4tCGWMK7xYXgqsmQSkBo49Yd8SBpJATevso/ZZtfk/gN0OAJpHNNo686tUnMYp5DBIg4+pmD7i8LyZfSnIHxLp6MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673345; c=relaxed/simple;
	bh=2BOk4snoRah6042Tl65wimcjnNKvtS1QQwUB4a322Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nASiG8KKSAGadPVUByjaEEquzB5AI0q/RbJxeK8x0aHK0SK+r00fC2582bKzZAXA+M434pHpPfC0g0SSHFV8teMPosaz3ME+YuBO3eV9W08okReZi5lB+hTvMBlJTg1T3TiDaQsfzLJNLRXtHxyQ2vQE1TkrBiz1BIrwX8Bw71Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVOVXfrj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVOVXfrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811FC1F000E9;
	Tue, 21 Jul 2026 22:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673344;
	bh=796QNbkV3fh0s5ohb2/GYY/dlo0tUYM6qI64ICzAhKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVOVXfrjmkeowuTLyxzszztCPwerMaDJjImwYjsv98pfdEgjOjue4CirmYwOhqMCg
	 Qvoxq6icDGMAsgb+yGefBz3BC0hNdqauo3cTl/hkPLxC6lpQOfVFJyKEffqPorNEjQ
	 cIE6JG5rxjxoHpunVQn2jlMT+V8VWg8t5yqNuVUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Philippe De Muyter <phdm@macqel.be>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 125/699] partitions: aix: bound the pp_count scan to the ppe array
Date: Tue, 21 Jul 2026 17:18:04 +0200
Message-ID: <20260721152358.524370454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -244,6 +244,15 @@ int aix_partition(struct parsed_partitio
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


