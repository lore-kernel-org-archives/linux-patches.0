Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14242E2F0C;
	Tue, 15 Jul 2025 13:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586801; cv=none; b=F0GYJwxewm9EDvwfBIxBs1ET0sx/LmXHdAk5kJHPnUb3GCBAW7Imp1N3jKDt8XPAT7qgo/uVcC7GU6XjTMzZ0pjRy5KpaMHVTV/mcqjZSs2S2MEOaqfkhq0nwGpszDlnMHf/QqNCePl7xkEAnj6F07c+wHVQoNXXGfL0RApWS4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586801; c=relaxed/simple;
	bh=+P63tgq/ViANIC/cD3HAuazNaMF2FyIODW5EKbNDP8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYAAfFcctofOElKKqCw6ekP+l8Dlb1n+/wwmazU2YrpHpALirxQmt18OQkRjkkbh3X3O2bRwaG8OYAj6gvWSlDiHkAsB84qqd0x/+QPehmuI0sRF2aJiAPOTcnPmkJh5oRanehcEefQur56dHnsyrR3RWUjAxoIgzHrVaLYWlds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbWpq5i3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbWpq5i3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D46C4CEE3;
	Tue, 15 Jul 2025 13:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586801;
	bh=+P63tgq/ViANIC/cD3HAuazNaMF2FyIODW5EKbNDP8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbWpq5i3olXeYwf1VN+Lvjxku9fGzmknhP8evfPgHtOmc7SPeizjguHb8ZhjB8C0W
	 9fbJWtmoUFIRFQw059wXrL875UoN2B3etitxaLty1s3Gp4z0iQke7RHrJSVQEmgS9V
	 EnxVtuNoFilD1c326Q4GOyn+knyOn7Hgfb85JoRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.15 052/192] x86/mce/amd: Fix threshold limit reset
Date: Tue, 15 Jul 2025 15:12:27 +0200
Message-ID: <20250715130816.932363156@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -350,7 +350,6 @@ static void smca_configure(unsigned int
 
 struct thresh_restart {
 	struct threshold_block	*b;
-	int			reset;
 	int			set_lvt_off;
 	int			lvt_off;
 	u16			old_limit;
@@ -432,13 +431,13 @@ static void threshold_restart_bank(void
 
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


