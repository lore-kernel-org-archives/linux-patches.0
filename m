Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945E812FB31;
	Wed, 19 Jun 2024 13:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802376; cv=none; b=f39YoZ5F/17jLbxd+2AMVpnb37xSn/m41OUFuJnGAlf/b1Pi06uA3a/tqiLh13o3bx789NMInVURpsThtHIi74DSdxwNs5bdojOymbHqeLLJxoGgXbwEk1u8iTE3peO/BFFsFjDkT1GN/UXppeV0IN2p4+IGyTpcmrqp0qOzA0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802376; c=relaxed/simple;
	bh=Nk++o5bXqlx/UweZpPGPh3AYxikfZsLL1HKX93wdybE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un5ORHR88NFPVlYAax4HjVaqCgVlA7lt/OcKZVjKkCBTWNigArYzWOlaOjTNu7aqT+zwlE41sMEczQZJZuFvfcGy79R0i0xLAdJGyIh2c9PuI/A2nWwTqlMFgpkFddAbUEvEZVyZIo10TegUNPbAS8whtS+Ol/zDbtT3ctlQ6TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9MNXMxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9MNXMxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E69C2BBFC;
	Wed, 19 Jun 2024 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802376;
	bh=Nk++o5bXqlx/UweZpPGPh3AYxikfZsLL1HKX93wdybE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9MNXMxNH2S1a647p9E1//52c1l0wABZoVOf1jBNMbBujWIxDEowsJR9be3fH/VdB
	 Bx/F0ngyjKl/gHua+7p0xUSwY/pIJwNsBo5v2oS8XGS1ht8PAtC2HPee5b60nH9r67
	 5qoLCQTX+LqK2rHIoK51PpdbSWcltKQO726JogkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Segall <bsegall@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 175/267] x86/boot: Dont add the EFI stub to targets, again
Date: Wed, 19 Jun 2024 14:55:26 +0200
Message-ID: <20240619125613.060390566@linuxfoundation.org>
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

From: Benjamin Segall <bsegall@google.com>

commit b2747f108b8034271fd5289bd8f3a7003e0775a3 upstream.

This is a re-commit of

  da05b143a308 ("x86/boot: Don't add the EFI stub to targets")

after the tagged patch incorrectly reverted it.

vmlinux-objs-y is added to targets, with an assumption that they are all
relative to $(obj); adding a $(objtree)/drivers/...  path causes the
build to incorrectly create a useless
arch/x86/boot/compressed/drivers/...  directory tree.

Fix this just by using a different make variable for the EFI stub.

Fixes: cb8bda8ad443 ("x86/boot/compressed: Rename efi_thunk_64.S to efi-mixed.S")
Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org # v6.1+
Link: https://lore.kernel.org/r/xm267ceukksz.fsf@bsegall.svl.corp.google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -116,9 +116,9 @@ vmlinux-objs-$(CONFIG_UNACCEPTED_MEMORY)
 
 vmlinux-objs-$(CONFIG_EFI) += $(obj)/efi.o
 vmlinux-objs-$(CONFIG_EFI_MIXED) += $(obj)/efi_mixed.o
-vmlinux-objs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
+vmlinux-libs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
 
-$(obj)/vmlinux: $(vmlinux-objs-y) FORCE
+$(obj)/vmlinux: $(vmlinux-objs-y) $(vmlinux-libs-y) FORCE
 	$(call if_changed,ld)
 
 OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S


