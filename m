Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0F12E2F17;
	Tue, 15 Jul 2025 13:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586129; cv=none; b=PGgFEpOczH2kfH3j5/j5YfnrgBZq/m6S+Ssd+ppDTKWqChOrERrMLHSxVehfvwdwkZ56jT7Fi9PkG3sYEARuewP05DQdinrOhIrAa2U0n8iEPss0bZzDDVyTXXO+lXTZCUKg/1WXWcBXzRKlLPveeSIyKwMUVg8bIeYphdO2n80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586129; c=relaxed/simple;
	bh=wacTsz3u7XFT99lYVhyp9NQ4CrPNC06OXucwJTpR4Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDG0G75fpoDxqq9TB8hooFUvW3cEkavTagZ9nDJvcM+X23dYFNjQD5HB6TVtK0imD7uf9OD/WPBfnbNsCJWF6aNsR/jihP5UymDnql3Ylw8Hj87GxjIA7uEJ53CT4j0RKdxUBLxHcTr5J7u89AqNSOcfEpC1zLC5rEKVf5LkLvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCK5+hp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCK5+hp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B79DC4CEF1;
	Tue, 15 Jul 2025 13:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586128;
	bh=wacTsz3u7XFT99lYVhyp9NQ4CrPNC06OXucwJTpR4Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCK5+hp3400Oa5pmhwXIhCQA47yoKXq6DB3sIo45c5kN9YoZwR635dJhvUTFmULXW
	 8A0TNj4b/1/V7ESU6Ky6XwJxxfAyRO+qpUOmexTKuNJkUlynG5k+xMOBaUp144H+g3
	 LrqcKxnrWQ9snv1epb6S9NeDvCSG9gsqLg164fvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 26/77] x86/mce/amd: Fix threshold limit reset
Date: Tue, 15 Jul 2025 15:13:25 +0200
Message-ID: <20250715130752.757392187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -310,7 +310,6 @@ static void smca_configure(unsigned int
 
 struct thresh_restart {
 	struct threshold_block	*b;
-	int			reset;
 	int			set_lvt_off;
 	int			lvt_off;
 	u16			old_limit;
@@ -405,13 +404,13 @@ static void threshold_restart_bank(void
 
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


