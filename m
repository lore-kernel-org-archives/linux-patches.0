Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE252E4980;
	Tue, 15 Jul 2025 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587232; cv=none; b=UENozcnjvgwvGUaxyW+EWEnG9QAxKR6uKSYUVaQJmdu2mmBHG0GPWO6LkBlHDkowqXrcYmxq5YI02ciG2DAS8SZhd8cI8RNjfBf/PEHUqjBv0KzcK3I6XyjrnsloBnMozN+Tplj5KRHKilnM43Nzp+4Thur3f9l5M0+VcQ7aJ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587232; c=relaxed/simple;
	bh=ePWh2TEsBTukSARBuGy/KsYw0/CBvI1IN9T0SCqrSTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkehiMxLvrCo8iN9K0w1o7yTAtUwwFbrRrE5xeLiRwsVJHT6oeF8HXzVKEwRlsaXU7FKudp0iHdDB5s6OTP2jwtboKkcxVtmgLUw9KXPvAWcGuJ0RDqm3AnUlF5BxhJS4RTHnJJuV0pDAE0nVYcsS4vMG7lnNxbGICGeBv3ZaY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRes3F0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRes3F0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF03C4CEE3;
	Tue, 15 Jul 2025 13:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587232;
	bh=ePWh2TEsBTukSARBuGy/KsYw0/CBvI1IN9T0SCqrSTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRes3F0rGTugzhOszG6L7c5l8RFGEgjVdJJD/SXss2J9WAKD1Uf20LBYFys9LkHmy
	 LYdNDMO0z/NMCq5ARv0I8GO9lGXbqvOfC5v5d/bBjKcbdlQgZzTJG8oG4CyUrtEriC
	 ssoJ/AGWnukzzXWI6uoKCzl628jHVkRKIwTbjctQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 23/88] x86/mce/amd: Fix threshold limit reset
Date: Tue, 15 Jul 2025 15:13:59 +0200
Message-ID: <20250715130755.445442540@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 5f6e3b720694ad771911f637a51930f511427ce1 upstream.

The MCA threshold limit must be reset after servicing the interrupt.

Currently, the restart function doesn't have an explicit check for this.  It
makes some assumptions based on the current limit and what's in the registers.
These assumptions don't always hold, so the limit won't be reset in some
cases.

Make the reset condition explicit. Either an interrupt/overflow has occurred
or the bank is being initialized.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250624-wip-mca-updates-v4-4-236dd74f645f@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -333,7 +333,6 @@ static void smca_configure(unsigned int
 
 struct thresh_restart {
 	struct threshold_block	*b;
-	int			reset;
 	int			set_lvt_off;
 	int			lvt_off;
 	u16			old_limit;
@@ -428,13 +427,13 @@ static void threshold_restart_bank(void
 
 	rdmsr(tr->b->address, lo, hi);
 
-	if (tr->b->threshold_limit < (hi & THRESHOLD_MAX))
-		tr->reset = 1;	/* limit cannot be lower than err count */
-
-	if (tr->reset) {		/* reset err count and overflow bit */
-		hi =
-		    (hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
-		    (THRESHOLD_MAX - tr->b->threshold_limit);
+	/*
+	 * Reset error count and overflow bit.
+	 * This is done during init or after handling an interrupt.
+	 */
+	if (hi & MASK_OVERFLOW_HI || tr->set_lvt_off) {
+		hi &= ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI);
+		hi |= THRESHOLD_MAX - tr->b->threshold_limit;
 	} else if (tr->old_limit) {	/* change limit w/o reset */
 		int new_count = (hi & THRESHOLD_MAX) +
 		    (tr->old_limit - tr->b->threshold_limit);


