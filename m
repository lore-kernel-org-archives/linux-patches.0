Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB6533470A;
	Mon, 18 Aug 2025 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526309; cv=none; b=Cqo5qHu4yASx1k/8JXAjBPY50V74N9Cp7xRqRyXIBSn7DI6IUVG+mRKWgdXyFvU8p+ODdLReCbGgd43v5xUTiSO2cb1XrENhwUmBiTISPgBAoctWAhgperBoDh74Byq9UxAwraMkBFtDi0nsBFNHqC6Fwzsh2ajJC0yQdt1iZKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526309; c=relaxed/simple;
	bh=FnC3SvXWNQZvmYHFNSc3XWiosumSOslWb9NScxTZfHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO/l9odmqG30Amc0KXG/TD9BzDDljrZxdM1zEdQpNQknVoEmT9FLa/n+v3zH1bqF9r9fTJhNyfku2oLFnibVTZMcHXnTW2Vd2crc1GQzsZbqbjAhto3KoJsDRAUO3mH3u5ADED3V5HHsWM1EdmKPgKM+C3xW+GyZBKDg7PKhzoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2PWZmeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2PWZmeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97F5C4CEEB;
	Mon, 18 Aug 2025 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526309;
	bh=FnC3SvXWNQZvmYHFNSc3XWiosumSOslWb9NScxTZfHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2PWZmeKOVae86Ln5B1GyD4Unox6LsRD5cmq2j8PNYAmIrOhq4UGvViswn1yEOxfs
	 OqJt2erRaBr/wletFJJGhj3a2txnb/P9siHjSvkzKH+JwQ5hAcCuH10k53UjwlaD5e
	 mqXLP7jdmnHngQUb4hv5KyKXicF28olyTxzHELFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Joerg Roedel <joerg.roedel@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.16 485/570] x86/sev: Ensure SVSM reserved fields in a page validation entry are initialized to zero
Date: Mon, 18 Aug 2025 14:47:52 +0200
Message-ID: <20250818124524.566335451@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 3ee9cebd0a5e7ea47eb35cec95eaa1a866af982d upstream.

In order to support future versions of the SVSM_CORE_PVALIDATE call, all
reserved fields within a PVALIDATE entry must be set to zero as an SVSM should
be ensuring all reserved fields are zero in order to support future usage of
reserved areas based on the protocol version.

Fixes: fcd042e86422 ("x86/sev: Perform PVALIDATE using the SVSM when not at VMPL0")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/7cde412f8b057ea13a646fb166b1ca023f6a5031.1755098819.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/startup/sev-shared.c |    1 +
 arch/x86/coco/sev/core.c           |    2 ++
 2 files changed, 3 insertions(+)

--- a/arch/x86/boot/startup/sev-shared.c
+++ b/arch/x86/boot/startup/sev-shared.c
@@ -785,6 +785,7 @@ static void __head svsm_pval_4k_page(uns
 	pc->entry[0].page_size = RMP_PG_SIZE_4K;
 	pc->entry[0].action    = validate;
 	pc->entry[0].ignore_cf = 0;
+	pc->entry[0].rsvd      = 0;
 	pc->entry[0].pfn       = paddr >> PAGE_SHIFT;
 
 	/* Protocol 0, Call ID 1 */
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -227,6 +227,7 @@ static u64 svsm_build_ca_from_pfn_range(
 		pe->page_size = RMP_PG_SIZE_4K;
 		pe->action    = action;
 		pe->ignore_cf = 0;
+		pe->rsvd      = 0;
 		pe->pfn       = pfn;
 
 		pe++;
@@ -257,6 +258,7 @@ static int svsm_build_ca_from_psc_desc(s
 		pe->page_size = e->pagesize ? RMP_PG_SIZE_2M : RMP_PG_SIZE_4K;
 		pe->action    = e->operation == SNP_PAGE_STATE_PRIVATE;
 		pe->ignore_cf = 0;
+		pe->rsvd      = 0;
 		pe->pfn       = e->gfn;
 
 		pe++;


