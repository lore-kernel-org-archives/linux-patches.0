Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF8933C53A;
	Fri,  9 Jan 2026 12:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962078; cv=none; b=aJc9SQk/62kfv51NUmLG87K8g/33HZB5KNA01Ao04eefd/YwAurWqegFNa8V1ww2edkkNauurOQdPtBgvxACKwfJdR6OHq2bJcQex8O3vKxOj9LOJmGtHVC/WwIlT2XvxfZbo+S4xq73JxZetdPtmdpKXqWiZkjOQ9wB4CTc1lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962078; c=relaxed/simple;
	bh=f5S9Y43VNzMsGc1UIGqPhelc0pMjLQeYHhbT4Kc9Ir8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1SOiq2EsE5UdeQrJ7MnswFFu7WQK/XGNTS9cGCLMmkcF1hBwT8RgPP8YXqJix7VJoidJgu96fc6OeN8fM/J82Y4tP2xVphcVv3R/DN5H3f96ikpq9uwMk2dr+1pw9qzOQdLYM3b67yrQoL6v5+fwfolglmLjBRW5bCJLXTDduc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7Lrrg4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7Lrrg4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8AAC4CEF1;
	Fri,  9 Jan 2026 12:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962077;
	bh=f5S9Y43VNzMsGc1UIGqPhelc0pMjLQeYHhbT4Kc9Ir8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7Lrrg4lqRmjRCPmHo6fBmaTTDIBqfni466ZinN+7CG1oj7ZB7GDt+baRT4z/f+p5
	 c9FwI/SFDIRsTgXX22KQoEDRS2OlmePxZU/4VhGk5Yn+qVC0ALzrKQz+ORqzP4eEi7
	 GnNkOfXXx0CmW/eIQ8jHH00V41p/x48Hgmwv8EaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Malyshev <mike.malyshev@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/634] kbuild: Use objtree for module signing key path
Date: Fri,  9 Jan 2026 12:38:35 +0100
Message-ID: <20260109112126.462240308@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 10df89b9ef679..dc947e7872b9f 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -67,7 +67,7 @@ endif
 #
 ifeq ($(CONFIG_MODULE_SIG_ALL),y)
 ifeq ($(filter pkcs11:%, $(CONFIG_MODULE_SIG_KEY)),)
-sig-key := $(if $(wildcard $(CONFIG_MODULE_SIG_KEY)),,$(srctree)/)$(CONFIG_MODULE_SIG_KEY)
+sig-key := $(if $(wildcard $(CONFIG_MODULE_SIG_KEY)),,$(objtree)/)$(CONFIG_MODULE_SIG_KEY)
 else
 sig-key := $(CONFIG_MODULE_SIG_KEY)
 endif
-- 
2.51.0



