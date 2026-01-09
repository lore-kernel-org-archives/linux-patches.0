Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE9835E540;
	Fri,  9 Jan 2026 12:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962730; cv=none; b=mFuGx9wvXv6a3KjM/eRBAdJ/pIwRuEjimpy47NYasq4vTnNvQfvZnM7Rs1asYBHJt71IyaFk1wnSdUdfj5+Nt6NXhp+pQXJ3xpfwr8ut0JBYu3IRbz0ISXLaJhXaeX7qOA1pXCoXI+yndk08L8ynJmbVyTAlK+fERgACefg2b4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962730; c=relaxed/simple;
	bh=Wr5QeTMrKL2WEeyOC3rq9rK27I595On4OgMqnSCP1W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZmnvZivyS8WiFONMowU17/qI96X2s706e1eOLL0pZSypBnvLkO7C1AIJuq5RHasouaZTgEUlTpH/VO4Fps9Q8uOe7clgSS+Cv+0/HGFdBiBVi0Cmu0cbvPDfagOwYDyAD7cqbmpdTPlRwXUyojTpYTtBPxheB9VmhkLFm8PIsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnPobUcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnPobUcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85BCC4CEF1;
	Fri,  9 Jan 2026 12:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962730;
	bh=Wr5QeTMrKL2WEeyOC3rq9rK27I595On4OgMqnSCP1W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnPobUcUXlHh8k436ma0qEetQQXNO9G9s9R8LiaQ1u+K3QMg23rt8PQAptwuz7g/5
	 srReRDIPOvD9BfPGOP1fb9Rt4CaWz14Btas7AEvP4YfzD4X/9OvuhsK6SnWGw5wMCq
	 hBGafMuamV/moJSESkf+zyCCxVHGNETLcizKYTAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@stackframe.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 468/634] parisc: entry.S: fix space adjustment on interruption for 64-bit userspace
Date: Fri,  9 Jan 2026 12:42:26 +0100
Message-ID: <20260109112135.159589054@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1046,8 +1046,6 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r17, PT_IOR(%r29)
 
 #if defined(CONFIG_64BIT)
-	b,n		intr_save2
-
 skip_save_ior:
 	/* We have a itlb miss, and when executing code above 4 Gb on ILP64, we
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
@@ -1056,10 +1054,17 @@ skip_save_ior:
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


