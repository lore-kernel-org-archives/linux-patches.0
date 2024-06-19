Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6445F13F428;
	Wed, 19 Jun 2024 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803956; cv=none; b=gYtp/+gCbO4zsfCb1eXc8PfdQgBauEYyZLIynPwclRuKJVzlOSX6dhOJDY9sd8mE1KEj+v69az2cNrlpqCEwKy+/NUOm/rVQtRoD8YjloHdxi4HWkz+wjgRoPB4ATs5N07HnpZEvyHJK1dwFKZ6s0wqXmf9G31fMJfY3C9SRUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803956; c=relaxed/simple;
	bh=DzI7hmbX7Km9ZviNFRDmJsA3/bZrmb4miG2w0wzTBEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+CAe2CM5De8ckhGJxv1pPlBhfs9Ztosph/g8+FCPEwbHL0bJgqgrnp3Qf080g1275nqS9IDdiKC14GA6DdnadzgdIj0wmMCqRfdGD4Lpr97d9+Mbt6Rkt9CaAW4g1IioNHOr9AUDDDSgnhs2hJ3C5hpwI7BDo5Q8JHNoqjrVUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUrIfqki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUrIfqki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED3EC2BBFC;
	Wed, 19 Jun 2024 13:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803956;
	bh=DzI7hmbX7Km9ZviNFRDmJsA3/bZrmb4miG2w0wzTBEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUrIfqki+04bA7IPwlV9YajJhlpHKoJxzMhuW0YL11iqJb7qJZvn0y4Uyls428K6+
	 H8cVWg+YQxRQUeKUKjmIKhP9cq5i+bwp6QfOMKLyRkjlE9ougEE13ylWmVa4WFGTP4
	 4aYUQWid9tg/UgLs9hzjgeAAxxcvzOc7MZUeGOu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Segall <bsegall@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 160/217] x86/boot: Dont add the EFI stub to targets, again
Date: Wed, 19 Jun 2024 14:56:43 +0200
Message-ID: <20240619125602.864935006@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
@@ -115,9 +115,9 @@ vmlinux-objs-$(CONFIG_INTEL_TDX_GUEST) +
 
 vmlinux-objs-$(CONFIG_EFI) += $(obj)/efi.o
 vmlinux-objs-$(CONFIG_EFI_MIXED) += $(obj)/efi_mixed.o
-vmlinux-objs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
+vmlinux-libs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
 
-$(obj)/vmlinux: $(vmlinux-objs-y) FORCE
+$(obj)/vmlinux: $(vmlinux-objs-y) $(vmlinux-libs-y) FORCE
 	$(call if_changed,ld)
 
 OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S


