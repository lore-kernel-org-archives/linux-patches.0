Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB5618EFD4;
	Wed,  5 Feb 2025 15:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768541; cv=none; b=FDxo69wWe8KrD//C/8nwSgzg2bhNdLSGMmdnZHOLMrD4uo4kMXCRrsJOPVfGIcuFqgabqAKQSwbP+Q/2yeDJCu2V7EjsnH8O0gWIx0VxxJOfEJ+Yoc9hUQhQT87QOTL4LqUbfGWbrQc0OkoFssiqr+zrflOs04ut9f+3rET1A+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768541; c=relaxed/simple;
	bh=KsLHYqHAfKo0XCUNxrwN+7EHRRTstaYVM4e7EHxpMcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo8w/eQPmXmQz4CbJ7W1O19e4vJXZ3OjgoVhtkQrlclBZ+Y+7d+llLIsMqWCq88wcjKsNZdgztlGcgzY2uMEb8jYy97osbyRB3JnNmir5A8G4XwYYJMwnXS2uPdsXWvQggPc88MC8O3pVm8JP2To7HN5TV+0QkD+ahV1LuOmHeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrQTvKyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrQTvKyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF355C4CED1;
	Wed,  5 Feb 2025 15:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768541;
	bh=KsLHYqHAfKo0XCUNxrwN+7EHRRTstaYVM4e7EHxpMcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrQTvKyzl5AYGIYpZR3wA96iYG27WC2n1hpV34h+erhRFPdFmczFLWo/51dETXDCB
	 UrcHUXI4L5Ow++JZGUMANxAt2Eoqmssgp0s8oy+QPhWmMlYU7axfP7GJkfDlx/mZAa
	 SLW6/2W6IYwyy/nO72hRQZ3qiTaBBcw7EyOQu3pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 556/623] kbuild: Fix signing issue for external modules
Date: Wed,  5 Feb 2025 14:44:58 +0100
Message-ID: <20250205134517.491545083@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Hilbrich <torsten.hilbrich@secunet.com>

[ Upstream commit 25ff08aa43e373a61c3e36fc7d7cae88ed0fc2d7 ]

When running the sign script the kernel is within the source directory
of external modules. This caused issues when the kernel uses relative
paths, like:

make[5]: Entering directory '/build/client/devel/kernel/work/linux-2.6'
make[6]: Entering directory '/build/client/devel/addmodules/vtx/work/vtx'
   INSTALL /build/client/devel/addmodules/vtx/_/lib/modules/6.13.0-devel+/extra/vtx.ko
   SIGN    /build/client/devel/addmodules/vtx/_/lib/modules/6.13.0-devel+/extra/vtx.ko
/bin/sh: 1: scripts/sign-file: not found
   DEPMOD  /build/client/devel/addmodules/vtx/_/lib/modules/6.13.0-devel+

Working around it by using absolute pathes here.

Fixes: 13b25489b6f8 ("kbuild: change working directory to external module directory with M=")
Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.modinst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index f97c9926ed31b..1628198f3e830 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -105,7 +105,7 @@ else
 sig-key := $(CONFIG_MODULE_SIG_KEY)
 endif
 quiet_cmd_sign = SIGN    $@
-      cmd_sign = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) "$(sig-key)" certs/signing_key.x509 $@ \
+      cmd_sign = $(objtree)/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) "$(sig-key)" $(objtree)/certs/signing_key.x509 $@ \
                  $(if $(KBUILD_EXTMOD),|| true)
 
 ifeq ($(sign-only),)
-- 
2.39.5



