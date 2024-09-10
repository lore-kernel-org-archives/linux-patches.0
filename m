Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E2F194145;
	Tue, 10 Sep 2024 10:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962913; cv=none; b=UFxZGzoSCGMsnpL/JSRAfDRFD8XktPc+WcfEiXVAL5Bu3/2I+rgAVsZ6MywXhRZkdt6d3FQRYgcHN8hnoHISme8bcKxSTbUB3z8Bvv4sRmwSSX8brM1Tm1UUy0P3wsVmnhLnXDi6N9J1rxIMKygpNaqRI7Wo8Jx/LuOmZ19oadk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962913; c=relaxed/simple;
	bh=GE0NdSROubGgU2k0XoCo4RJOumUVc6ZUbxceCBWlOOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eM/793lBuTL7G3kaXFLpA32dMv/dPdIgPJO410fgiL+VQIDRYKrjg872xjpgt0r3NKOtepNlw7xHuJTfaHDUExteJZsvD6C0Hi+cS4O2Eyaz8G70tJwRpTH6ajGQCSM5jH+Pe03TjKXWC2hOAFEJmmNmHxc07AN9GYGMGTDwkdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSF2NG8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSF2NG8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0030BC4CEC3;
	Tue, 10 Sep 2024 10:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962913;
	bh=GE0NdSROubGgU2k0XoCo4RJOumUVc6ZUbxceCBWlOOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSF2NG8isKtSgjv4jxOhYyQTupjOSnNtN3WYrzt385Wpcun2ag3PJXVYnKZIAUR3V
	 bSvwpk7o3tfWLgmOPBCRl2LMmJN+RLcEhrmaibvrfm0/WjboICEBqK9FnFxa+q09jF
	 TFwVg/0hSMECPbE4OIZOm4V4W59rcGNrAILgALGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/192] rust: kbuild: fix export of bss symbols
Date: Tue, 10 Sep 2024 11:31:36 +0200
Message-ID: <20240910092600.965317871@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
index 9321a4c83b71..28ba3b9ee18d 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -303,7 +303,7 @@ $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers.c FORCE
 quiet_cmd_exports = EXPORTS $@
       cmd_exports = \
 	$(NM) -p --defined-only $< \
-		| awk '/ (T|R|D) / {printf "EXPORT_SYMBOL_RUST_GPL(%s);\n",$$3}' > $@
+		| awk '/ (T|R|D|B) / {printf "EXPORT_SYMBOL_RUST_GPL(%s);\n",$$3}' > $@
 
 $(obj)/exports_core_generated.h: $(obj)/core.o FORCE
 	$(call if_changed,exports)
-- 
2.43.0



