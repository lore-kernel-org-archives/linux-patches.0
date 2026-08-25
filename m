Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EB33749F4;
	Tue, 25 Aug 2026 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664756; cv=none; b=f3lSKL9ZXOPAFvNdcqjftEY/Q/D9Hjlx9hIbr+C49tWRfZ2A9pNjV9POyBN6V152m5pytkg+XoqBW7aJ7+CgdUHpvPQK+/WMtArnlutKZlyRBUj6TISsuSFHdSIUFNT88pW++KU6Vsb4P4ARiMisuZLnA7ZwRuywBqvW2AZygHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664756; c=relaxed/simple;
	bh=bnAGM+58qE0b7WXnvA7pM1ex3NJhSP2oCLTTzG5xK7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUDafXd9EcpwjuJo1rCVbmfvBtGHjNkF7t9eyooxDkQjO9BP+pTN34p9Z76KFyZJf46D37E67vL2zsW0rnmCxlHiLM+bRrygwGCWo3oVzUUS7yjxYUiCKkAvTDiujN4B0wqGfuVAQl9u+bt8j3bB6GiargOUla411CENsrLGLKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MATPIO35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MATPIO35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373421F000E9;
	Tue, 25 Aug 2026 13:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664754;
	bh=n4fboCe44QBnoJF1AOmQaS8siKDO4B1mLY9Y+O/r5o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MATPIO35fbO21CCVrRNzgNdh9CkzEUsXmQSeRyQ+9gwgYRLqAEQrJQhW93htyE67E
	 HA/Qg0nDUi2HdJM66JwXed/6UQJnOdkgBHKSz+1ub5NQXRzIzSxL3g+8Y3/X7qoSiX
	 x8YMBkTdhHFuyrAsi9QY/iovuPF7lv6c1OICl6X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 7.2 75/82] drm/xe: Dont hand out the flat CCS storage as usable VRAM
Date: Tue, 25 Aug 2026 15:26:02 +0200
Message-ID: <20260825132544.431260693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 818bebeb63dd6bf5f4e07e145f6cdbace520a34c upstream.

get_flat_ccs_offset() reads the base of the flat CCS storage from the
hardware, scales it by the number of enabled L3 nodes, and rounds the
result up to 128K.  Everything below that offset is then handed to the
VRAM allocator as usable memory.

Rounding a limit that means "usable memory ends here" upwards publishes
whatever lies between the real base and the rounded one as free memory,
and that memory belongs to the compression hardware.  The scaled value
has no reason to be 128K aligned, and on a Battlemage G21 with 16 GiB it
is not:

	flat CCS base: raw 0x3fafff800, rounded 0x3fb000000

so the last 2 KiB of page 0x3fafff000 is CCS storage, in the allocator's
pool.  Whatever is allocated there gets that tail overwritten by the
compression hardware, which needs no page-table entry, no buffer object
and no GPU submission to do it, and does it before userspace exists.

On this machine a Mesa VM's level-3 page table landed on that page on
every cold boot.  It lost the entry covering the compositor's
batch-buffer heap, so the compositor's first submission faulted fetching
its batch and gdm restarted it forever: a black screen on an otherwise
working machine.  Restarting gdm cleared it because the next VM's page
tables were allocated somewhere else.

Round down instead, to the page size the allocator works in.  On this
machine that excludes exactly one page.

Reading the reserved page afterwards shows what had been writing it:

	[369] 0xcccc000000000000
	[371] 0xcc77000000000000
	[373] 0xcccc000000000000
	[375] 0xcc77000000000000

compression metadata, two bytes per sixteen, sitting where the driver
used to hand out memory.

The assertion that should have caught this compares the offset against
GSMBASE - ccs_size for equality.  That value is 128K aligned, so it
agrees with the rounded-up offset precisely when the base is not
aligned - the check cannot fail in the case it exists to catch, and is
compiled out unless CONFIG_DRM_XE_DEBUG is set.  Replace it with one
that can fail: CCS storage must not run into GSM.

[ And this was a debug session from hell, enormously helped by an AI
  doing much of the grunt-work.

  I'd like to call it my tireless helper, but the AI several times
  stated flat out that this was impossible and unsolvable and that we
  should just write a report about it.

  I suspect those things have been trained by people who may not be
  quite as stubborn as I am.

  But while the AI was ready to give up several times, it did keep
  adding debug code and analyzing it faithfully when I pushed. So credit
  where credit is due and I let the AI write the commit message above.

  This is basically a one-liner fixing a bogus "round_up()" to a
  "round_down()", but there were 24 patches adding more and more debug
  information to this, and 18 kernel boot to finally narrow it down to
  this.   - Linus ]

Fixes: 37173392741c ("drm/xe/vram: fix ccs offset calculation")
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vram.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vram.c
+++ b/drivers/gpu/drm/xe/xe_vram.c
@@ -89,12 +89,25 @@ static int get_flat_ccs_offset(struct xe
 		offset = offset_hi << 32; /* HW view bits 39:32 */
 		offset |= offset_lo << 6; /* HW view bits 31:6 */
 		offset *= num_enabled; /* convert to SW view */
-		offset = round_up(offset, SZ_128K); /* SW must round up to nearest 128K */
 
-		/* We don't expect any holes */
-		xe_assert_msg(xe, offset == (xe_mmio_read64_2x32(&gt_to_tile(gt)->mmio, GSMBASE) -
-					     ccs_size),
-			      "Hole between CCS and GSM.\n");
+		/*
+		 * Everything below this offset is handed to the VRAM
+		 * allocator, so it has to be the *first* address the
+		 * compression hardware owns, rounded down.  Rounding it up
+		 * publishes CCS storage as free memory.
+		 */
+		offset = round_down(offset, SZ_4K);
+
+		/*
+		 * CCS storage must not run into GSM.  The old check compared
+		 * the offset against GSMBASE - ccs_size for equality, which
+		 * could not fail: that value is 128K aligned, so it agreed
+		 * with the rounded-up offset even when the base was not 128K
+		 * aligned - exactly the case this fixes.
+		 */
+		xe_assert_msg(xe, offset + ccs_size <=
+			      xe_mmio_read64_2x32(&gt_to_tile(gt)->mmio, GSMBASE),
+			      "CCS overlaps GSM.\n");
 	} else {
 		reg = xe_gt_mcr_unicast_read_any(gt, XEHP_FLAT_CCS_BASE_ADDR);
 		offset = (u64)REG_FIELD_GET(XEHP_FLAT_CCS_PTR, reg) * SZ_64K;


