Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD363D6479;
	Mon, 17 Aug 2026 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974512; cv=none; b=JJby5L72gb4CTSmqqsparT1OsmuP2VQLHmQiNxvvAallrz2hnBE5oZDRYhpGxwEwi4qkBdzAN2sElYfPR5XX67c4nS2amsK1e9bW4rbkhJLiHu67QE0QzaAL2QyRsfTr8ZuLgdzHPsxnOU57gHE2jr2BPmM8+Jf/as3kiKTIB9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974512; c=relaxed/simple;
	bh=5jBdPkp0Zj2Jvg8FQSXQhBeOrHmlL5/0ztXEJjssGtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP8Q9YVHovSbEI/65RT57c94Fo3qCkFy+yNwdhUq70wEy3YPVO75TIt7HOzdzI9TXCFJnEAkQBixnhM8VGF1s7XLt4a5kkqqoQuBiYKDAE64LjoVXELWTQY8G9VJyZUw/EXhe6iM/JjwYx/2kOPonLWSj+MBWVeRkaa5X2tfrmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OUxZCAj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OUxZCAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E111F000E9;
	Mon, 17 Aug 2026 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974506;
	bh=MoQNP3835Iq5VrEi9d4KZzTJ/qHa6mCYBbOqB/HfmZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OUxZCAjorfnONi58eI/xhrHF15HCQNYEVLivOnsiEgteCWUxMUS6ASsIHPCeSOkp
	 GMyuLO1A1LCS/ezJbvUgcFYMhE8ZWPtDYNpMLzIa2HHk/u3EODwwetM0H4gYe/X3Sy
	 uI5splrEjd1tkQwmcUJWoewBGDL6vaNiI0U8CoQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@surriel.com>,
	stable@kernel.org
Subject: [PATCH 7.1 229/271] x86/CPU: Add a tlbi= cmdline switch
Date: Mon, 17 Aug 2026 15:32:34 +0200
Message-ID: <20260817132546.187602445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit abe7c8b09bd72a9c726016257c6281f129b4c02d upstream.

With the recently found INVLPGB / TLBSYNC issue, there has been some
interest in disabling INVLPGB-based TLB flushing, in order to rule out
that CPU issue as a cause of userspace crashes.

Add a kernel command line option to control the TLB flushing behavior.

If the need arises, we will add a "tlbi=broadcast" for the case when TLB
invalidation broadcasts need to be explicitly selected, but this is not
needed now yet.

  [ bp: Rewrite commit message, move to cpu/common.c, add documentation. ]

Fixes: 767ae437a32d ("x86/mm: Add INVLPGB feature and Kconfig entry")
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260729204341.3eb0b5ea@fangorn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/cpu/common.c                    |   10 ++++++++++
 2 files changed, 14 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7573,6 +7573,10 @@ Kernel parameters
 			See Documentation/admin-guide/mm/transhuge.rst for more
 			details.
 
+	tlbi=		[X86-64]
+			Format: {ipi}
+			ipi: switch to IPI-based TLB flushing
+
 	topology=	[S390,EARLY]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2668,3 +2668,13 @@ void __init arch_cpu_finalize_init(void)
 	 */
 	mem_encrypt_init();
 }
+
+/* Control TLB flushing methods */
+static int __init tlbi_setup(char *str)
+{
+	if (!strcmp(str, "ipi"))
+		setup_clear_cpu_cap(X86_FEATURE_INVLPGB);
+
+	return 1;
+}
+__setup("tlbi=", tlbi_setup);


