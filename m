Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27727172F;
	Mon,  8 Apr 2024 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582650; cv=none; b=i1NWHOSd8g14DFDsXHnhBGvhXQZL12AU/0S6ei5h28580djtHBdCapvuLtTc/u/GuYksOWR8sCZsWnklOBiupsGKrxQFjgP7/Te1YfXcyrj1lVpeBU+kozueZjmItr8p1/sZ5C5s5WDAwXwuzi5aZMensypstfOd3Ko7Gys5zlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582650; c=relaxed/simple;
	bh=/BrD77I+n/A7GtgnQQTC/8Cftzk8MRUUvKNA3NpeSoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdBpSSbOhkMyYS6pf7gNxdJxG46JkJbfiYoseABu0MX7EYWkKA44BQiiUDqtHL7cLuz03RCJR9Rxk7aG8K/eH3/sGpaM6yQ1kukyv82bXCn78y+fr0D1iZE5521tGTAHYav9OYTCIvd+0fjfN50G91KuddtoPOYMR7YA8NwYUWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N54SeiCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N54SeiCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72916C433F1;
	Mon,  8 Apr 2024 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582649;
	bh=/BrD77I+n/A7GtgnQQTC/8Cftzk8MRUUvKNA3NpeSoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N54SeiCcvaQYLCW8Nz4w6WT/l/X/BESuLu4Ciap3GiAb5zvlQrI3KwFCVE+Pax8kx
	 x+gzCq52sCPZZNkgL69VDWGvAGzsXBH2iAVd+o9DSnY0xf9D+Y/UXE0Byhoxn1NPIb
	 AG4FUp5iqZO/XqXkIgcMZ/XJ53u/BPbFiy+lta0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 162/690] x86/asm: Differentiate between code and function alignment
Date: Mon,  8 Apr 2024 14:50:28 +0200
Message-ID: <20240408125405.416389472@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 8eb5d34e77c63fde8af21c691bcf6e3cd87f7829 upstream.

Create SYM_F_ALIGN to differentiate alignment requirements between
SYM_CODE and SYM_FUNC.

This distinction is useful later when adding padding in front of
functions; IOW this allows following the compiler's
patchable-function-entry option.

[peterz: Changelog]

Change-Id: I4f9bc0507e5c3fdb3e0839806989efc305e0a758
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220915111143.824822743@infradead.org
[cascardo: adjust for missing commit c4691712b546 ("x86/linkage: Add ENDBR to SYM_FUNC_START*()")]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/linkage.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -11,11 +11,15 @@
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
 #endif /* CONFIG_X86_32 */
 
-#ifdef __ASSEMBLY__
-
 #define __ALIGN		.balign CONFIG_FUNCTION_ALIGNMENT, 0x90;
 #define __ALIGN_STR	__stringify(__ALIGN)
 
+#define ASM_FUNC_ALIGN		__ALIGN_STR
+#define __FUNC_ALIGN		__ALIGN
+#define SYM_F_ALIGN		__FUNC_ALIGN
+
+#ifdef __ASSEMBLY__
+
 #if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define RET	jmp __x86_return_thunk
 #else /* CONFIG_RETPOLINE */


