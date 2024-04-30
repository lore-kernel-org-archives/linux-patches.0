Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BEB12C487;
	Tue, 30 Apr 2024 10:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474379; cv=none; b=t3SeOH5Tw1PoHrcpi88gxgeXUnRsFsmJz2g9mEcL+qSuFhbU4EdF3UxlYOqP/3clnrtHMeEF0/fggQzp0/vCSvmYQO13Psk3RVjCtEOAykrPsZSqsgnjk62CufCqYEdJkJqfMgqFj3no9XzgSuHnlm6tnw/2fvyjQ5CDlcpBoT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474379; c=relaxed/simple;
	bh=Qbn3dgf3IbVCLGnfvEPncN8w10LfxyKkHOY2FQlrUno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRc7hX3gnalMop4EoAC2/FcV475BDpDgkNd2f3cCMXnJbVqnipnSatHmu8OmpRtoPsmEMmiD2RXEZbi26NWcL1yXZEq/w4mV7Iw/ItEs8k1nHIuc1vBfGr+AnJZq+3Wc8TCi8l3kN8KIni1dLWBqFlELPs164Ptvs+Y759LoGL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqF4E8zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqF4E8zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7701C4AF18;
	Tue, 30 Apr 2024 10:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474379;
	bh=Qbn3dgf3IbVCLGnfvEPncN8w10LfxyKkHOY2FQlrUno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqF4E8ztVaBhh7liNP1Yo9/U2cOeJGdgSZbHBdmhrVDs12ncg2lpznSUDeBEL1Vnc
	 CzCxP9ERf7pOBUpl5U2/wTxkv8mLEdxWcBcn4N0tASLFIMjSd1EuYdSpW8lWmZXay0
	 z4ywrwTKJb/JDw5S6Hue6MTbufWRlyF7ASqnddY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.8 138/228] rust: make mutually exclusive with CFI_CLANG
Date: Tue, 30 Apr 2024 12:38:36 +0200
Message-ID: <20240430103107.782803623@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 8933cf4651e02853ca679be7b2d978dfcdcc5e0c upstream.

On RISC-V and arm64, and presumably x86, if CFI_CLANG is enabled,
loading a rust module will trigger a kernel panic. Support for
sanitisers, including kcfi (CFI_CLANG), is in the works, but for now
they're nightly-only options in rustc. Make RUST depend on !CFI_CLANG
to prevent configuring a kernel without symmetrical support for kfi.

[ Matthew Maurer writes [1]:

    This patch is fine by me - the last patch needed for KCFI to be
    functional in Rust just landed upstream last night, so we should
    revisit this (in the form of enabling it) once we move to
    `rustc-1.79.0` or later.

  Ramon de C Valle also gave feedback [2] on the status of KCFI for
  Rust and created a tracking issue [3] in upstream Rust.   - Miguel ]

Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
Cc: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/rust-for-linux/CAGSQo024u1gHJgzsO38Xg3c4or+JupoPABQx_+0BLEpPg0cOEA@mail.gmail.com/ [1]
Link: https://lore.kernel.org/rust-for-linux/CAOcBZOS2kPyH0Dm7Fuh4GC3=v7nZhyzBj_-dKu3PfAnrHZvaxg@mail.gmail.com/ [2]
Link: https://github.com/rust-lang/rust/issues/123479 [3]
Link: https://lore.kernel.org/r/20240404-providing-emporium-e652e359c711@spud
[ Added feedback from the list, links, and used Cc for the tag. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1904,6 +1904,7 @@ config RUST
 	bool "Rust support"
 	depends on HAVE_RUST
 	depends on RUST_IS_AVAILABLE
+	depends on !CFI_CLANG
 	depends on !MODVERSIONS
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT


