Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017594;
	b=jSN284fJAdQsOo2lz22rDWT97GNiEkE183mDcjMHHCWNfBpRrVvUS2Ey42+zNbPsr+Vw
	 8jgTVtecbuLjDv0PAu78n54z13PFF+6gR4+VsDElbbGrdvdMAX8al8F2eMZIQ47Dxw4wA
	 zOxKpzuBdAtwfD02uEJgGyI6sVian6clKbUobba05wQRkLvSpxUqnJ+Ik38omwa51KQ0x
	 RizUVcSsWUZVUe3Suk9quhiDzzPik2HPp+oFYvPnUmsdXDMed5NRX6+Rzoe9X0USTfjHb
	 VYacXDfKiWPxALiMUITFJUgzwurYBPFgae3dk92enWf9ATsAIVbuOWUX3YWjtVEenGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NGeZxGKHKgopfBqSFpk3yn60jj5hG6wkEb7nopEsuxw=;
	b=4p8CZw0aXtPi3URRbpk8kaQOluMZGKX6iCyqIoNvMvtaCOb1V56kQ/Yd3Ych/fxu5u86
	 s9kyes/LhMr6KLtxQbxehbd69AH3vTbBueo0utr8XZ+pl1rRFf3CEwLVcqpynSJrRk4Xp
	 wN0ADlwe6KMqXt3PpsTzU5ykPpy2Q8asiq6cD7+LTvBO5Bfuk6gXlJBrJyTDIU6zQ05gw
	 /h6shSvFOVX9gkI2zWBEdAvNb9TefWYwZXdcExHneNAQT03bllr2hilPJcaY3i044eQs2
	 96gHe7gLXETTQMH7E3ZUnVTxW/SuzTc+HIaV93HtrROvdRZA0bm4iwpmKXawZT7Giaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfp5BE5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D567606A31C;
	Wed, 18 Nov 2026 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kfp5BE5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A3A1F000C5;
	Wed, 18 Nov 2026 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017594;
	bh=NGeZxGKHKgopfBqSFpk3yn60jj5hG6wkEb7nopEsuxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfp5BE5JQqG0o/T6V2tHDTwc3Mn5S5PUEhiyex0kRGLJfMXjtFOKEnQTIXFM+ZXC0
	 2g3HhXpyma96PnCYxkF0PT0ZElitdokB88GuJ3UtpHLPkFskeqK8uzJWveEd1XLSeB
	 Imdv/64SmWxkSHGinFY1ojPG4LfUJ67HuVT6WY5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 7.3 0913/2651] kbuild: keep .modinfo when vmlinux is linked with --gc-sections
Date: Wed, 18 Nov 2026 15:35:53 +0100
Message-ID: <20261118150320.759845635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit a98db7418797bc27bef53c861b97ac748f598414 ]

Builds with CONFIG_LD_DEAD_CODE_DATA_ELIMINATION=y, such as arm
allmodconfig, now fail while extracting modules.builtin.modinfo:

  arm-linux-gnueabihf-objcopy: vmlinux.unstripped: can't dump section
  '.modinfo' - it does not exist: file format not recognized
  /bin/sh: 1: cannot open modules.builtin.modinfo: No such file

or, with LLVM:

  llvm-objcopy: error: 'vmlinux.unstripped': section '.modinfo' not
  found

Nothing references the MODULE_INFO() strings, so --gc-sections
discards every .modinfo input section and vmlinux.unstripped ends up
with no .modinfo data. This is not new: ever since
modules.builtin.modinfo started being extracted from
vmlinux.unstripped, these builds have silently produced an empty
file, losing the modinfo of every built-in module. An arm
multi_v7_defconfig build with LD_DEAD_CODE_DATA_ELIMINATION on current
mainline yields a 0 byte modules.builtin.modinfo. The switch to
--dump-section only turned that into a build error.

Wrap the input section in KEEP() so that the linker retains it. The
output section is still (INFO), so nothing is allocated for it. With
the same arm config, modules.builtin.modinfo now has 14119 entries,
and on x86_64 defconfig, where nothing is garbage collected, it is
byte-identical before and after this change.

Found by KernelCI builds of the linus-next tree.

Fixes: 39cfd5b12160 ("kbuild: extract modules.builtin.modinfo from vmlinux.unstripped")
Fixes: 5fe4dd596641 ("kbuild: do not allocate .modinfo in vmlinux")
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20260927161227.1179863-1-sashal@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a6730d34e8c67..7a3e9f00d6283 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -855,7 +855,7 @@
 		KLP_SYMID
 
 #define MODINFO								\
-		.modinfo (INFO) : { *(.modinfo) }
+		.modinfo (INFO) : { KEEP(*(.modinfo)) }
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
-- 
2.53.0



