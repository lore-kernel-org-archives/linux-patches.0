Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A4231A20;
	Thu, 12 Dec 2024 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021038; cv=none; b=W9vCTNzATy569wtNUZjaF1yfp7oaAfpR23N9W6lz31aiBSPegz2liz92ACeI4uVzGzLKsdr8FeUfGqNE+KjUpr25UPcGc2Ul1pGPv1sk7EkC0skHXpMP7iIJmhXyd2gplbx7K9y7gn8pR8pvkrXW19c+GqRbBLNScHiaDFcrLSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021038; c=relaxed/simple;
	bh=fgkx9YW5fyNknQhRUbM+YFnSldT5ffAz4KlAf/vXhLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5JPkoGgw2o1KgqeXBOEMXeef2wDQVTFwyLHDMrwHZr2vnynfETF2XbjMMtHR+DWNxTSYMFsSOgFRC7hfGxHEvxuqCcpl2Fiw+Abpcs6QAD8tLyLTHrBM3CqcmkjGf5yr6w/aqpk5m0/TRXJsV52mz4cjL5o4OKOrlAuSlrWOxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNqqa9b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNqqa9b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E3AC4CECE;
	Thu, 12 Dec 2024 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021038;
	bh=fgkx9YW5fyNknQhRUbM+YFnSldT5ffAz4KlAf/vXhLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNqqa9b0qEoQNa21Hnb/2za6BIzysiTud+LtEopcSVx2jg95tuah5k8kaDEU9nRHR
	 fXOQII0uui2R8PrH8DbVqhWu0O38XkJLewXE0xSuyMNxnasxw37BjX1PQfTzbBregu
	 VsbrLvHZg/oXFKMzYG3vSi+vFKuYHYM3P8RzVhyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 629/772] modpost: Add .irqentry.text to OTHER_SECTIONS
Date: Thu, 12 Dec 2024 15:59:34 +0100
Message-ID: <20241212144415.926139401@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 7912405643a14b527cd4a4f33c1d4392da900888 upstream.

The compiler can fully inline the actual handler function of an interrupt
entry into the .irqentry.text entry point. If such a function contains an
access which has an exception table entry, modpost complains about a
section mismatch:

  WARNING: vmlinux.o(__ex_table+0x447c): Section mismatch in reference ...

  The relocation at __ex_table+0x447c references section ".irqentry.text"
  which is not in the list of authorized sections.

Add .irqentry.text to OTHER_SECTIONS to cure the issue.

Reported-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org # needed for linux-5.4-y
Link: https://lore.kernel.org/all/20241128111844.GE10431@google.com/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -829,7 +829,7 @@ static void check_section(const char *mo
 		".ltext", ".ltext.*"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", \
-		".coldtext", ".softirqentry.text"
+		".coldtext", ".softirqentry.text", ".irqentry.text"
 
 #define INIT_SECTIONS      ".init.*"
 #define MEM_INIT_SECTIONS  ".meminit.*"


