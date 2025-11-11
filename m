Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDA54C97;
	Tue, 11 Nov 2025 00:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822353; cv=none; b=GvjcVsVMPr3QFm3RVuzLSFzglVN4xegKy2kWp726h7IlR7Z+bSConVY9qzq1r3nQlLIr9l61lcUpxXeoUvUySIN4Wxoo2gO5FJSjsoR4eqdPtPZyTLfEPuIs3NooCKsV5LH4BvTxEBMP+SfBMbEnDkhgfhxAzI8xWe2qlfB5mOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822353; c=relaxed/simple;
	bh=bZMcs7QjRIxaGFrvGRHnPFk2AcreOr0JXVEnF/Bc7ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyQCOguQFhd6BfOD4lhGtk3B7RaP9pv4JRYNitIZksgyBuMQdihkpw/4XUHvABHZs/YwtsVFVPYSHwrHx6C9AxVn+++vH4gi3U9lGL9hagdZRiDk5EaRaPnJEZRjbxLgRsdNJ/mnZmJ+sjOdu6eUeTW87vGD0IRmDP1dCWl2X1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBm1yTYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBm1yTYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD8BC2BCB2;
	Tue, 11 Nov 2025 00:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822352;
	bh=bZMcs7QjRIxaGFrvGRHnPFk2AcreOr0JXVEnF/Bc7ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBm1yTYipKcaUagZVnE2uFXyYbCGCaql+PnjxxadlaUXfdk+nUvspEnUXIo1T+pCh
	 gs0+h2kk5MqK4De2vWbSwA7C1fJln7KhNQtCIdIvk9QopVRpw//j1O33RinzClIcUb
	 9lXZuMELthmYHJf+7vm1/IHQiXWRD9yT2npp+778=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri John Ledkov <dimitri.ledkov@surgut.co.uk>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.17 091/849] kbuild: align modinfo section for Secureboot Authenticode EDK2 compat
Date: Tue, 11 Nov 2025 09:34:21 +0900
Message-ID: <20251111004538.614315721@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri John Ledkov <dimitri.ledkov@surgut.co.uk>

commit d50f21091358b2b29dc06c2061106cdb0f030d03 upstream.

Previously linker scripts would always generate vmlinuz that has sections
aligned. And thus padded (correct Authenticode calculation) and unpadded
calculation would be same. As in https://github.com/rhboot/pesign userspace
tool would produce the same authenticode digest for both of the following
commands:

    pesign --padding --hash --in ./arch/x86_64/boot/bzImage
    pesign --nopadding --hash --in ./arch/x86_64/boot/bzImage

The commit 3e86e4d74c04 ("kbuild: keep .modinfo section in
vmlinux.unstripped") added .modinfo section of variable length. Depending
on kernel configuration it may or may not be aligned.

All userspace signing tooling correctly pads such section to calculation
spec compliant authenticode digest.

However, if bzImage is not further processed and is attempted to be loaded
directly by EDK2 firmware, it calculates unpadded Authenticode digest and
fails to correct accept/reject such kernel builds even when propoer
Authenticode values are enrolled in db/dbx. One can say EDK2 requires
aligned/padded kernels in Secureboot.

Thus add ALIGN(8) to the .modinfo section, to esure kernels irrespective of
modinfo contents can be loaded by all existing EDK2 firmware builds.

Fixes: 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
Cc: stable@vger.kernel.org
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@surgut.co.uk>
Link: https://patch.msgid.link/20251026202100.679989-1-dimitri.ledkov@surgut.co.uk
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8a9a2e732a65..e04d56a5332e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -832,7 +832,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 
 /* Required sections not related to debugging. */
 #define ELF_DETAILS							\
-		.modinfo : { *(.modinfo) }				\
+		.modinfo : { *(.modinfo) . = ALIGN(8); }		\
 		.comment 0 : { *(.comment) }				\
 		.symtab 0 : { *(.symtab) }				\
 		.strtab 0 : { *(.strtab) }				\
-- 
2.51.2



