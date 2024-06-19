Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34F712FB31;
	Wed, 19 Jun 2024 13:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802512; cv=none; b=cVxmt7tsQUd+1S2T6pEvNldXdvxWiVQL1zcCNKLUXNDWHEx07MY26orWP5oUd1zA8TBsux/JjQz3/OMzjeLAXLEWnAK7L7+LN1xqzxQ8jAhXBpPV0k16B/K8gYKU3d7v9PPKHrtLOW7uKXZL8VId3yXunneUypS3k7U0p+B5l+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802512; c=relaxed/simple;
	bh=vhexItMjPauN3p9UbqX2rCa6QjezmjMfs2DmXbZgGOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWfwDhp5Nrx7ys4XkmIBe20aep0bVI2C6sNNZH7x7XK2yLYf6NBBhJLdJVpspQY4WAgpbKMEBywgg86qMQyVYnlVEut0rk64Qslpy9RvI1a3rc/riBHaf6FRussVfXbqRW4W/4g0f17pEpHCpQ7QbG1mAAzu75QcK1fGipnGhSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsTis+mV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsTis+mV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC6AC2BBFC;
	Wed, 19 Jun 2024 13:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802511;
	bh=vhexItMjPauN3p9UbqX2rCa6QjezmjMfs2DmXbZgGOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsTis+mVLcodL7fE8xUBKDCxBrfGWSu9Xv46NlLSCK7HowxL1+2FoSPdf8COF9Hur
	 vRR2gjATf/2+RgRJwC/TS4W7RQXlNdRjum/SetToVivpiNqGw2mwXolHAmUSgASX4u
	 JR3U3jH6u9L+0Wwi74MNKB2aaNMf9lYu0941wx8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.6 190/267] x86/kexec: Fix bug with call depth tracking
Date: Wed, 19 Jun 2024 14:55:41 +0200
Message-ID: <20240619125613.632274682@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Kaplan <david.kaplan@amd.com>

commit 93c1800b3799f17375989b0daf76497dd3e80922 upstream.

The call to cc_platform_has() triggers a fault and system crash if call depth
tracking is active because the GS segment has been reset by load_segments() and
GS_BASE is now 0 but call depth tracking uses per-CPU variables to operate.

Call cc_platform_has() earlier in the function when GS is still valid.

  [ bp: Massage. ]

Fixes: 5d8213864ade ("x86/retbleed: Add SKL return thunk")
Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20240603083036.637-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/machine_kexec_64.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -298,8 +298,15 @@ void machine_kexec_cleanup(struct kimage
 void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
-	void *control_page;
+	unsigned int host_mem_enc_active;
 	int save_ftrace_enabled;
+	void *control_page;
+
+	/*
+	 * This must be done before load_segments() since if call depth tracking
+	 * is used then GS must be valid to make any function calls.
+	 */
+	host_mem_enc_active = cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT);
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (image->preserve_context)
@@ -361,7 +368,7 @@ void machine_kexec(struct kimage *image)
 				       (unsigned long)page_list,
 				       image->start,
 				       image->preserve_context,
-				       cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT));
+				       host_mem_enc_active);
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (image->preserve_context)


