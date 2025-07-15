Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFC62E7BC6;
	Tue, 15 Jul 2025 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585862; cv=none; b=MwbDWBzotxXa2m9ct65OlwfzOf6Gu3inh5ReCoRA97bxzbw7cXcaCaQxqFJ2DVHbjy3EUH3MHXuuhTuwLABscN97YT6rAJ68keAC2iJcVVSxN6vmRkHtokYVNgBSpF56ITaM/35QySc8cifC/P8/PzZrH3mhvkvAkdKBTnLNqtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585862; c=relaxed/simple;
	bh=wY/Y+70Tzj3AgT47YfGQQYHuf0vxFjmbPjePQlAKl0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1fAuMuF0sSNMV/aaEti4UhTQ2AMJREhA6RW4CkcybxoEmYeazB4bPqWua4YwwMdfg3MQaAp9BvpGBYeOm6uSeyfYvpVcHv2agaiD0Y3BqZKfd1FPOZ8Zr8EvwLiWknxbC83LLNx5wJZcm+tXQojOp2MrSw8qvvOXCISpWUFdII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZG5+BTnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZG5+BTnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE3BC4CEF1;
	Tue, 15 Jul 2025 13:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585862;
	bh=wY/Y+70Tzj3AgT47YfGQQYHuf0vxFjmbPjePQlAKl0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG5+BTnq/TwriH4CjZpP+LxHD9FShkpvCWyEe1lX+4FotHPwyMx5Ue4amgtOOkJLT
	 Oz+XV9iOpq64xEGE8/qshUCeXQboIVe7wq41U6TPITBgRRYZcJSb/4FUhkaUMqUUqT
	 WTyygeG1ky0D7Dkit/1Cex9jteKseEkEhhwnQUnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 034/109] x86/mce/amd: Fix threshold limit reset
Date: Tue, 15 Jul 2025 15:12:50 +0200
Message-ID: <20250715130800.249127893@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -335,7 +335,6 @@ static void smca_configure(unsigned int
 
 struct thresh_restart {
 	struct threshold_block	*b;
-	int			reset;
 	int			set_lvt_off;
 	int			lvt_off;
 	u16			old_limit;
@@ -430,13 +429,13 @@ static void threshold_restart_bank(void
 
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


