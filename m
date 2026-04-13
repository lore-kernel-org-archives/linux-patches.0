Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD411D6DB5;
	Mon, 13 Apr 2026 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096259; cv=none; b=tVLyWyZE0BESv++oDt772YeLB4kkIHYqRSo0OJsR9nXYE5LauZCR52B+oUE3npzSQH241YcidUKPCds1Mr5YCPZrsp/Mscy6KGjBsEGYSmY53f6OynIOC7wEc2w2/nDzeG1k3CphXkARF8rcGhHLaO+vVeCNdrCCTwjt8rRHPMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096259; c=relaxed/simple;
	bh=yZ1sMwNtiHiB17mQ8KdIV9cBqUzIYc8DMmBOXctUICg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTxUtkPkGVFezAl0OopGzzLADyFWeyu7zjNNQhXCVjGuAVg/Uqdq0q1N2n0xAj4VXM4BISqffD+OhBzxR/VbpW4uZaQMmXwIQsG2oTAN9T62G8e3rh96LM9ECsBgNTDk1WFv4xnRpGRLckZbREuMlKYpUGiO4O9bIhg7Yhi24Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+Is9nCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+Is9nCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA83DC2BCAF;
	Mon, 13 Apr 2026 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096259;
	bh=yZ1sMwNtiHiB17mQ8KdIV9cBqUzIYc8DMmBOXctUICg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+Is9nCe12Qkkjj1KDQQQykqa21VGt6qA/r8gP99Uoa/WwL1KbSgOUA6u+Ki5XInV
	 iRT1u+zV14pzNoocv4rqKY0R08uQYWiaJU0d614IzFLF/DIpbTO/v3x3uA6Xmqk9zB
	 cLhnJuPGiJqoORP3nAXGxQbsoml+nuH78Jjb1icM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.19 28/86] x86/mce/amd: Filter bogus hardware errors on Zen3 clients
Date: Mon, 13 Apr 2026 17:59:35 +0200
Message-ID: <20260413155732.626381397@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 0422b07bc4c296b736e240d95d21fbfebbfaa2ca upstream.

Users have been observing multiple L3 cache deferred errors after recent
kernel rework of deferred error handling.¹ ⁴

The errors are bogus due to inconsistent status values. Also, user verified
that bogus MCA_DESTAT values are present on the system even with an older
kernel.²

The errors seem to be garbage values present in the MCA_DESTAT of some L3
cache banks. These were implicitly ignored before the recent kernel rework
because these do not generate a deferred error interrupt.

A later revision of the rework patch was merged for v6.19. This naturally
filtered out most of the bogus error logs. However, a few signatures still
remain.³

Minimize the scope of the filter to the reported CPU
family/model/stepping and only for errors which don't have the Enabled
bit in the MCi status MSR.

¹ https://lore.kernel.org/20250915010010.3547-1-spasswolf@web.de
² https://lore.kernel.org/6e1eda7dd55f6fa30405edf7b0f75695cf55b237.camel@web.de
³ https://lore.kernel.org/21ba47fa8893b33b94370c2a42e5084cf0d2e975.camel@web.de
⁴ https://lore.kernel.org/r/CAKFB093B2k3sKsGJ_QNX1jVQsaXVFyy=wNwpzCGLOXa_vSDwXw@mail.gmail.com

  [ bp: Generalize the condition according to which errors are bogus. ]

Fixes: 7cb735d7c0cb ("x86/mce: Unify AMD DFR handler with MCA Polling")
Closes: https://lore.kernel.org/20250915010010.3547-1-spasswolf@web.de
Reported-by: Bert Karwatzki <spasswolf@web.de>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-By: Bert Karwatzki <spasswolf@web.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250915010010.3547-1-spasswolf@web.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index a030ee4cecc2..28deaba08833 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -604,6 +604,14 @@ bool amd_filter_mce(struct mce *m)
 	enum smca_bank_types bank_type = smca_get_bank_type(m->extcpu, m->bank);
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
+	/* Bogus hw errors on Cezanne A0. */
+	if (c->x86 == 0x19 &&
+	    c->x86_model == 0x50 &&
+	    c->x86_stepping == 0x0) {
+		if (!(m->status & MCI_STATUS_EN))
+			return true;
+	}
+
 	/* See Family 17h Models 10h-2Fh Erratum #1114. */
 	if (c->x86 == 0x17 &&
 	    c->x86_model >= 0x10 && c->x86_model <= 0x2F &&
-- 
2.53.0



