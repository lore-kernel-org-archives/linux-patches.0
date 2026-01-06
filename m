Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F47335577;
	Tue,  6 Jan 2026 17:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721060; cv=none; b=X8JkHeLrU2F2I1QvpFHqUn78I0FEtezEldBOnu+EEgxQ9TrrdYsWEG9Z8gQaF/SGoLsE9cXkTZBLwWqpc+XGE9XCR2SF6fEyLYZZZy9AKuppY+C19Yi2DHFzRmjZ3dbu3glYAZgLwfXU2Log8wWcBtrYGeoQvXGeiUO7MSiG4YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721060; c=relaxed/simple;
	bh=rD9xJRs3vASbDRnKRO5/2HG3nX33Y+vgSo891XtfOPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/8G849if+Lnf3TLOzeZqug1xaNA3g1A2pbhnvrVdGarF0LO5MNIO5+jk+qgjasyDo8QfBnk21WMVheTYNLACu6HN0/2Txbjoct1cf0ZIdid4vNIosfJf0/q3Y8Ty4ZiUiUekF3EDYwi3BmDOCBRWc+79BsDxQqYn4l+gSCW8uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxExKrOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxExKrOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D679FC116C6;
	Tue,  6 Jan 2026 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721060;
	bh=rD9xJRs3vASbDRnKRO5/2HG3nX33Y+vgSo891XtfOPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxExKrOF0QQOxDkv81AYEs2G1TzVEJsppZ3ZAqmENymgyvhfUiEtptgwlu0SXvK8s
	 vvqwS2jBNfF8hUf7ZGrgKDLSzT51MD04lZCg4Z2987NI5l4LYckI450DVQm37AtfZX
	 sKxMTO1+VRwcjcqQLDUq93Gy6B5JRINc6L/k9BO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@stackframe.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 391/567] parisc: entry.S: fix space adjustment on interruption for 64-bit userspace
Date: Tue,  6 Jan 2026 18:02:53 +0100
Message-ID: <20260106170505.804331306@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1059,8 +1059,6 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r17, PT_IOR(%r29)
 
 #if defined(CONFIG_64BIT)
-	b,n		intr_save2
-
 skip_save_ior:
 	/* We have a itlb miss, and when executing code above 4 Gb on ILP64, we
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
@@ -1069,10 +1067,17 @@ skip_save_ior:
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


