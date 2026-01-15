Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA273C00B1;
	Thu, 15 Jan 2026 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499687; cv=none; b=R3GliXGJUa6M9WaMTu+HHUdf4EiO9vC77jTB/jzz2Mq7+SzqjJi2qMh8+V75G6rjGuBloNYWRaTDYuq533fheBgsZgJUyWStQkYHssQcG1K4uzKn+dsRfl4J9d7ys6mYzfqPcivH/RgfUriIMd8TeX3atNksy236shsP8ub7KyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499687; c=relaxed/simple;
	bh=DqActK6BgrzJCF3tlXwfCaNQGNXMRDTmLSTZhWOSD6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFjj3Ub33ztzrlKfjvxmMaiphxiMAgx6bClwBYMFdSc15clqAFghzCTsiOhvCDDLRQbwwMu5pU5U5nOc7wa8bgHjJG4n1M5zgJ8fYzpYHxtYId1XHCNgadN1yQs1lW8Hy2I6sL6EALM0ze3ExQDXZwylIIYC9SOntiW0AI7m0AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5bdqkBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5bdqkBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D774C116D0;
	Thu, 15 Jan 2026 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499686;
	bh=DqActK6BgrzJCF3tlXwfCaNQGNXMRDTmLSTZhWOSD6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5bdqkBgPgs+b2nHaO8QHXWCyJkNHe5B1mtI0JzdhML8FoQF9f7ibiyC/TNpHJs2X
	 ijS0nxIWk+MZ5ATqRE5Nto4LDu9vdN1zMzy+0WpE3s1ds/w6gKMGaGcIAP5O+lZpF9
	 vmyE+i3srHuQRmeqQSd17ePO0GW5g6SCrl6PhK34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@stackframe.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 315/451] parisc: entry.S: fix space adjustment on interruption for 64-bit userspace
Date: Thu, 15 Jan 2026 17:48:36 +0100
Message-ID: <20260115164242.295701073@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Sven Schnelle <svens@stackframe.org>

commit 1aa4524c0c1b54842c4c0a370171d11b12d0709b upstream.

In wide mode, the IASQ contain the upper part of the GVA
during interruption. This needs to be reversed before
the space is used - otherwise it contains parts of IAOQ.
See Page 2-13 "Processing Resources / Interruption Instruction
Address Queues" in the Parisc 2.0 Architecture Manual page 2-13
for an explanation.

The IAOQ/IASQ space_adjust was skipped for other interruptions
than itlb misses. However, the code in handle_interruption()
checks whether iasq[0] contains a valid space. Due to the not
masked out bits this match failed and the process was killed.

Also add space_adjust for IAOQ1/IASQ1 so ptregs contains sane values.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/entry.S |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1072,8 +1072,6 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r17, PT_IOR(%r29)
 
 #if defined(CONFIG_64BIT)
-	b,n		intr_save2
-
 skip_save_ior:
 	/* We have a itlb miss, and when executing code above 4 Gb on ILP64, we
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
@@ -1082,10 +1080,17 @@ skip_save_ior:
 	bb,COND(>=),n	%r8,PSW_W_BIT,intr_save2
 	LDREG		PT_IASQ0(%r29), %r16
 	LDREG		PT_IAOQ0(%r29), %r17
-	/* adjust iasq/iaoq */
+	/* adjust iasq0/iaoq0 */
 	space_adjust	%r16,%r17,%r1
 	STREG           %r16, PT_IASQ0(%r29)
 	STREG           %r17, PT_IAOQ0(%r29)
+
+	LDREG		PT_IASQ1(%r29), %r16
+	LDREG		PT_IAOQ1(%r29), %r17
+	/* adjust iasq1/iaoq1 */
+	space_adjust	%r16,%r17,%r1
+	STREG           %r16, PT_IASQ1(%r29)
+	STREG           %r17, PT_IAOQ1(%r29)
 #else
 skip_save_ior:
 #endif


