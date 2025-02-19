Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450341B85D7;
	Wed, 19 Feb 2025 09:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956749; cv=none; b=CnrWXoMr9hfZsd9NfGkQzBPSA+T9h8I3IR1T7DH9dSOp+9sU6Gz+48Is/XGCtIdcVVHheHKG1lMdIY/xwaVUDKhWEAMO+QzfQJzHdad36mMRBvaVNSi1zE2Gkec9voUP5EkAOI28DCena6U9VXzPN38u3t2ipSwyL4hvofOMp8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956749; c=relaxed/simple;
	bh=ocx2acbUu+z47GDREWbTukJdsXWERv37FfU56RRvMok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlK4f2mi9MNpN80MtaF4YSxFnv/tzRCMifPqa+hKUKFVk/Qk6buB39tHMgz5o+iahRXyJV9v16iUvW1n4MFegl2uBZn43N3lEgzy3GMSGcsN0y2X4+H46yK3Sp/T4jQqioQ7Q6GMl2X1Z8L7iP0HSyjxc4gIy7CuVJEtR89Xahw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tUFQX/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tUFQX/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C65C4CED1;
	Wed, 19 Feb 2025 09:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956748;
	bh=ocx2acbUu+z47GDREWbTukJdsXWERv37FfU56RRvMok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tUFQX/XKPeqje19OxWO61oNkXa/qJG8oQX99KEQ7BHzp7sfGIL2JyaPVOBmj3QRP
	 19luEF1p0ikz/UywXAL2SQsjYhWmHDNvJhq/VdaGKKtM27hYQ/+PMaogKLxEGKKhgU
	 nhNNr/LTqaXRAr7UQCbaMoRopUQOoBQV7zCIAU0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.1 245/578] kbuild: switch from lz4c to lz4 for compression
Date: Wed, 19 Feb 2025 09:24:09 +0100
Message-ID: <20250219082702.670070819@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parth Pancholi <parth.pancholi@toradex.com>

commit e397a603e49cc7c7c113fad9f55a09637f290c34 upstream.

Replace lz4c with lz4 for kernel image compression.
Although lz4 and lz4c are functionally similar, lz4c has been deprecated
upstream since 2018. Since as early as Ubuntu 16.04 and Fedora 25, lz4
and lz4c have been packaged together, making it safe to update the
requirement from lz4c to lz4.

Consequently, some distributions and build systems, such as OpenEmbedded,
have fully transitioned to using lz4. OpenEmbedded core adopted this
change in commit fe167e082cbd ("bitbake.conf: require lz4 instead of
lz4c"), causing compatibility issues when building the mainline kernel
in the latest OpenEmbedded environment, as seen in the errors below.

This change also updates the LZ4 compression commands to make it backward
compatible by replacing stdin and stdout with the '-' option, due to some
unclear reason, the stdout keyword does not work for lz4 and '-' works for
both. In addition, this modifies the legacy '-c1' with '-9' which is also
compatible with both. This fixes the mainline kernel build failures with
the latest master OpenEmbedded builds associated with the mentioned
compatibility issues.

LZ4     arch/arm/boot/compressed/piggy_data
/bin/sh: 1: lz4c: not found
...
...
ERROR: oe_runmake failed

Link: https://github.com/lz4/lz4/pull/553
Suggested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Parth Pancholi <parth.pancholi@toradex.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile             |    2 +-
 scripts/Makefile.lib |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -528,7 +528,7 @@ KGZIP		= gzip
 KBZIP2		= bzip2
 KLZOP		= lzop
 LZMA		= lzma
-LZ4		= lz4c
+LZ4		= lz4
 XZ		= xz
 ZSTD		= zstd
 
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -459,10 +459,10 @@ quiet_cmd_lzo_with_size = LZO     $@
       cmd_lzo_with_size = { cat $(real-prereqs) | $(KLZOP) -9; $(size_append); } > $@
 
 quiet_cmd_lz4 = LZ4     $@
-      cmd_lz4 = cat $(real-prereqs) | $(LZ4) -l -c1 stdin stdout > $@
+      cmd_lz4 = cat $(real-prereqs) | $(LZ4) -l -9 - - > $@
 
 quiet_cmd_lz4_with_size = LZ4     $@
-      cmd_lz4_with_size = { cat $(real-prereqs) | $(LZ4) -l -c1 stdin stdout; \
+      cmd_lz4_with_size = { cat $(real-prereqs) | $(LZ4) -l -9 - -; \
                   $(size_append); } > $@
 
 # U-Boot mkimage


