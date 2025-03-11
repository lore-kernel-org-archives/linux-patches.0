Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC045260362;
	Tue, 11 Mar 2025 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707154; cv=none; b=s6Jt3FIRXurEc2OauvBQ1IoRrv+AAUflJHnY0ZT9V6owPfCtiYlZW8+Wk7YgOXtzzrFhZD2TuQrbkpJWnO3s+ymYjse0TjuZMfwrER6/J3fkLVsuSF9H5jDv3WsAFoykV3NPKB1PX82hSdIVI/ntBigGGJKVqtXRDjHIE8I0+Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707154; c=relaxed/simple;
	bh=UBh+2xZUzdl0Urrzv538cBXFBKPknOJYHoT3xL7EFAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/8+bZ71ZgIzNHvJZ1OiOBLCm2BDFVoYwFrkBUFHqVKYM+ZypIrjg+WSxRs27I+anUfOh85iTeQ7RNGCIvKqXytxrJTLt6HBRdPWkh7euUi0k/2uW8pX0RgTjIWGzlVAWmVYDSNC1+5TQ5ywcyN6MNjl68bRSi8v7w2KpGf6Zj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7I5q76x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7I5q76x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FCAC4CEE9;
	Tue, 11 Mar 2025 15:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707154;
	bh=UBh+2xZUzdl0Urrzv538cBXFBKPknOJYHoT3xL7EFAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7I5q76xaS2IsIC+nRKbbQPsjPLQUIdil/Um+jn5eYQxmfhmQouV0DwxaWdIKU3WD
	 LYU4xxNKW4/eJWBDvXVy7hT9L8gOq18FvMwbQjanqV/TCarJbJvh7rtfB+gkc3j6be
	 aw1lufgT5OTp2jxrlsTy8PMToUDDljl0Dtj5kOX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 293/462] x86/static-call: Remove early_boot_irqs_disabled check to fix Xen PVH dom0
Date: Tue, 11 Mar 2025 15:59:19 +0100
Message-ID: <20250311145809.941838507@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 5cc2db37124bb33914996d6fdbb2ddb3811f2945 upstream.

__static_call_update_early() has a check for early_boot_irqs_disabled, but
is used before early_boot_irqs_disabled is set up in start_kernel().

Xen PV has always special cased early_boot_irqs_disabled, but Xen PVH does
not and falls over the BUG when booting as dom0.

It is very suspect that early_boot_irqs_disabled starts as 0, becomes 1 for
a time, then becomes 0 again, but as this needs backporting to fix a
breakage in a security fix, dropping the BUG_ON() is the far safer option.

Fixes: 0ef8047b737d ("x86/static-call: provide a way to do very early static-call updates")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219620
Reported-by: Alex Zenla <alex@edera.dev>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Alex Zenla <alex@edera.dev>
Link: https://lore.kernel.org/r/20241221211046.6475-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/static_call.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -113,7 +113,6 @@ EXPORT_SYMBOL_GPL(arch_static_call_trans
 noinstr void __static_call_update_early(void *tramp, void *func)
 {
 	BUG_ON(system_state != SYSTEM_BOOTING);
-	BUG_ON(!early_boot_irqs_disabled);
 	BUG_ON(static_call_initialized);
 	__text_gen_insn(tramp, JMP32_INSN_OPCODE, tramp, func, JMP32_INSN_SIZE);
 	sync_core();


