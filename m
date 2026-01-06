Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254CD346A02;
	Tue,  6 Jan 2026 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719727; cv=none; b=TmQ2D3nqfFEhbodLucHY+sV8ZS7CDcl1TgwoaZZICYvqDoMzUoinwHQp8LsghKD4qvKNoIEBx07F/Ay6p0rQqxa4RGvWiY64zQ9LzrJex4l1E4G+lNyPQUtFci5kNNN+YYJQPKzXMK4KHgywX6EkdA7672bInys27KxZrv5fQzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719727; c=relaxed/simple;
	bh=JVha160GrdinOkGQm+QbY8eYql8v/7Z0x5IWFw4d/EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDuZe4Fil+EUD/gLGcSVTGf6WmB6Ln2QsmSSMbjZ/aK190/+T4z3LG7VqvAK+NNGw35+NLiC1B3KWYC3GYhjwMIIC4UCl2jyiDRH2yLGXuMOtTAMaar0QQNNbcGtUD6+WvWyKzxVje3zC7s6GZtw0OlJPipd5Y+6QN+BMCRooAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdYhNcRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdYhNcRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DD6C19424;
	Tue,  6 Jan 2026 17:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719727;
	bh=JVha160GrdinOkGQm+QbY8eYql8v/7Z0x5IWFw4d/EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdYhNcRqjOeVboSOociESKlDGThjtwPnpJs50ehRC+G97TyVuoctuXcfAw4dYv965
	 S5B/nFmzfp4YXKHoU1wnMVbrzwCVOuyDgEeAPxeWmA4XEgQmXb9qGVlZQHBV2FG24b
	 rBA+1jBfmR3jk+BwHgxDQFUzg071RZrE6b7l2fqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Malyshev <mike.malyshev@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/567] kbuild: Use objtree for module signing key path
Date: Tue,  6 Jan 2026 17:56:43 +0100
Message-ID: <20260106170452.128689037@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Malyshev <mike.malyshev@gmail.com>

[ Upstream commit af61da281f52aba0c5b090bafb3a31c5739850ff ]

When building out-of-tree modules with CONFIG_MODULE_SIG_FORCE=y,
module signing fails because the private key path uses $(srctree)
while the public key path uses $(objtree). Since signing keys are
generated in the build directory during kernel compilation, both
paths should use $(objtree) for consistency.

This causes SSL errors like:
  SSL error:02001002:system library:fopen:No such file or directory
  sign-file: /kernel-src/certs/signing_key.pem

The issue occurs because:
- sig-key uses: $(srctree)/certs/signing_key.pem (source tree)
- cmd_sign uses: $(objtree)/certs/signing_key.x509 (build tree)

But both keys are generated in $(objtree) during the build.

This complements commit 25ff08aa43e37 ("kbuild: Fix signing issue for
external modules") which fixed the scripts path and public key path,
but missed the private key path inconsistency.

Fixes out-of-tree module signing for configurations with separate
source and build directories (e.g., O=/kernel-out).

Signed-off-by: Mikhail Malyshev <mike.malyshev@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20251015163452.3754286-1-mike.malyshev@gmail.com
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.modinst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index d977209431898..5dd52788a042a 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -100,7 +100,7 @@ endif
 # Don't stop modules_install even if we can't sign external modules.
 #
 ifeq ($(filter pkcs11:%, $(CONFIG_MODULE_SIG_KEY)),)
-sig-key := $(if $(wildcard $(CONFIG_MODULE_SIG_KEY)),,$(srctree)/)$(CONFIG_MODULE_SIG_KEY)
+sig-key := $(if $(wildcard $(CONFIG_MODULE_SIG_KEY)),,$(objtree)/)$(CONFIG_MODULE_SIG_KEY)
 else
 sig-key := $(CONFIG_MODULE_SIG_KEY)
 endif
-- 
2.51.0



