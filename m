Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF48C10A35;
	Mon,  4 Mar 2024 21:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588549; cv=none; b=PRPXawBxMtNu1KJuxhImi86rVGTII9auMtGCRuFmOonv4Dab7zMpI92GllmEYyqFl7J3jJI9jvHviBBjZjpFk+qVXbptWgN8mOuPxqxQccsgqAb+rtdj7YxnyaJ4Mj598bH6co70rm1HpiiTYKuCW6jY71akooxaWNHtZVqhC+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588549; c=relaxed/simple;
	bh=OfiJ6LzeHwU+UFDp4rjmYzFY/BU3KTOLNnnva3/bnOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyFHbT+Y2YyXjQcX9PDslDnpqYyD3z5DkHRCABRGpgS2jsF5kmm42Q8mGv6ChotfDYbIktKObD4sM0mqEbQ9zhwNiFLv3wIQO3z0lYL++DE7KE9E9qXNcnpvltJCY37RwA8QXhAY02ivdjtWyzqNgrJz6yZTvceQ6v0qAQ6f60k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqWgjqIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqWgjqIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54993C433C7;
	Mon,  4 Mar 2024 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588549;
	bh=OfiJ6LzeHwU+UFDp4rjmYzFY/BU3KTOLNnnva3/bnOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqWgjqIhihH5b3uY13z7PsyO6vdzDiHvfr2qBbqdg+ZSP1SqYP2+HtcWmMAYXm1Uc
	 naAWAGGa6l+R61f0rYopXvD9qA+/ekj1L95UD7wakpAIAPKgCzOEcHlIqxBTofGhVb
	 Ly7WVhrQdEFK+cBobiqqi2/ISY8L7XsQ487z7sQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.6 134/143] x86/entry_32: Add VERW just before userspace transition
Date: Mon,  4 Mar 2024 21:24:14 +0000
Message-ID: <20240304211554.187264518@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit a0e2dab44d22b913b4c228c8b52b2a104434b0b3 upstream.

As done for entry_64, add support for executing VERW late in exit to
user path for 32-bit mode.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-3-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -885,6 +885,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.
@@ -954,6 +955,7 @@ restore_all_switch_stack:
 
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
+	CLEAR_CPU_BUFFERS
 .Lirq_return:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
@@ -1146,6 +1148,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:


