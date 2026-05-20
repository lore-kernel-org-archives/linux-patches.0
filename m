Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7FA3368B6;
	Wed, 20 May 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297226; cv=none; b=evcCc1sm2BjGo0WhoQtzw2+mTc2Kcggk50Bx/a3bxiIbfGJ5v/yYazP+tYWieHwPbOL4Y/IrGjtiz+DC2aV/6zx/wtIsvHLa2v2qQJ0fjN9LQ+TuoATGwKU168pKXzJyNfaTvmumyj7DXaLoD5Le0ijt8LNSlSV8ZnYdQXgLIMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297226; c=relaxed/simple;
	bh=mLDYAx88zaXtU9gKv5l3ZyEdHHBuLspyjTKPpgmBCBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeLJYw6eoJ5T7XzXDSYkROzRnfO3NW4xKrw+9K8bdi/4hSa05LksbFCcrScQRIkvMX7mhLbeb+AT78gc6WdG++w9MGGNuGb1td8+7Z8uo+s3O2b9hwUKunstrCsbKvQ8NoatIY0S7wdxHHyDLHlxm3796lmceI8Ap442zs9qqE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcP24yIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcP24yIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5B31F000E9;
	Wed, 20 May 2026 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297225;
	bh=v97Sl14cJzpgJeDVJO1fhfe+ysBZfPnaI1VcJ+SXjC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcP24yIUELMr1kuJmmBm2gU5Zi36rQI/RGBfn1HaNJ6z3972W+3ihDjvyvgk5Tt+D
	 xeuJlgB/ZsT+CCbi27wISluiv36QQdpQopSu3zbV6W+gcGsk7ScOxUfa7+M2JNs5Mc
	 wrjtfb4vZvL71cgezmdCcx1AAlm5Nl0IKV9wwlb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan Kakulawaram <rohanka@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 7.0 1099/1146] x86/kexec: Push kjump return address even for non-kjump kexec
Date: Wed, 20 May 2026 18:22:29 +0200
Message-ID: <20260520162213.113800215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit 786a45757dcdf8f2beb9d4a6db605db16c18b2b4 upstream.

The version of purgatory code shipped by kexec-tools attempts to look above
the top of its stack to find a return address for a kjump, even in a non-kjump
kexec.

After the commit in Fixes: the word above the stack might not be there,
leading to a fault (which is at least now caught by my exception-handling code
in kexec).

That commit fixed things for the actual kjump path, but no longer
"gratuitously" pushes the unused return address to the stack in the non-kjump
path. Put that *back* in the non-kjump path, to prevent purgatory from
crashing when trying to access it.

Fixes: 2cacf7f23a02 ("x86/kexec: Fix stack and handling of re-entry point for ::preserve_context")
Reported-by: Rohan Kakulawaram <rohanka@google.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Rohan Kakulawaram <rohanka@google.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/32d627134143ffd957891cb697138e839c623211.camel@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/relocate_kernel_64.S |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -136,6 +136,14 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_ma
 	 * %r13 original CR4 when relocate_kernel() was invoked
 	 */
 
+	/*
+	 * Set return address to 0 if not preserving context. The purgatory
+	 * shipped in kexec-tools will unconditionally look for the return
+	 * address on the stack and set a kexec_jump_back_entry= command
+	 * line option if it's non-zero. There's no other way that it can
+	 * tell a preserve-context (kjump) kexec from a normal one.
+	 */
+	pushq	$0
 	/* store the start address on the stack */
 	pushq   %rdx
 


