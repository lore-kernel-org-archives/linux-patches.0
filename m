Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2786C172BAE;
	Tue, 10 Sep 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964194; cv=none; b=shMgPqMDfOLo5a0Izee52cGPw8RbT3ZRJJ2aWXlASUpDiXv3M5U2Fd2qCD51obU5d4sv3/duT7SmzIvMkDGYTAa4+tINt31LjPtv0TQy7eKOAhNQCTjYemeK5ScSQrdHQ9Brfqsifcg57Tcljbr4rQ4m24a+mrUW9yYIC+EhUDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964194; c=relaxed/simple;
	bh=tJ1XTGY/YA0LjLtrF36eYia/cxbL4Fo8uWnu6XCRk6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EffHWK8JAgC0bxYRJ+qjk04OsdB6AyzwrPeMlsfD3WbEyZlDC6O5QH6aExChftPSHAKP8zj3K4PR9Ndr9wEz+sRy4xX4oAh3BuvDe4XNK44kjsz2RMOy11O1SWogmL9TpHSAu0oWM2VrrTzPBtsNDg/ZqYc6BaHu14A+dKN25Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ni7s58PG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ni7s58PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E81C4CEC3;
	Tue, 10 Sep 2024 10:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964193;
	bh=tJ1XTGY/YA0LjLtrF36eYia/cxbL4Fo8uWnu6XCRk6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ni7s58PG1OWsD+WvFC+/4uiLL6NoJdHFlLMuP5CkMKcx1fDxW7wVxbf7hsVXAOoeD
	 G6dMB92EVfSE06FRdpJglOttulKzdNO9twzCWNszjJms+0kvyohy3IpwwiSffEmM7w
	 zA9GbMG9757fkFAFNJVEjJR5FgYmsKiFZRUTGCNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/269] rust: kbuild: fix export of bss symbols
Date: Tue, 10 Sep 2024 11:31:27 +0200
Message-ID: <20240910092611.779620456@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Andreas Hindborg <a.hindborg@samsung.com>

[ Upstream commit b8673d56935c32a4e0a1a0b40951fdd313dbf340 ]

Symbols in the bss segment are not currently exported. This is a problem
for Rust modules that link against statics, that are resident in the kernel
image. Thus export symbols in the bss segment.

Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240815074519.2684107-2-nmi@metaspace.dk
[ Reworded slightly. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index 7e33ebe8a9f4..333b9a482473 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -363,7 +363,7 @@ $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers.c FORCE
 quiet_cmd_exports = EXPORTS $@
       cmd_exports = \
 	$(NM) -p --defined-only $< \
-		| awk '/ (T|R|D) / {printf "EXPORT_SYMBOL_RUST_GPL(%s);\n",$$3}' > $@
+		| awk '/ (T|R|D|B) / {printf "EXPORT_SYMBOL_RUST_GPL(%s);\n",$$3}' > $@
 
 $(obj)/exports_core_generated.h: $(obj)/core.o FORCE
 	$(call if_changed,exports)
-- 
2.43.0



