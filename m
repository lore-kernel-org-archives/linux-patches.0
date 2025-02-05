Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BE521D5A7;
	Wed,  5 Feb 2025 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766520; cv=none; b=uOCGCypxpq07XsJ2BTVmmc8qzGzXWrx0znzmWM0mqBfoS0VzjLpnqTXG4w65HME4Somn+l6d0vhBC0JpilIoSH+GrpbZ34Oybi+aK71idvM9F7ivLYCLah6zAn5ETqN8Dg+H7WMxlm0ccvDZp6ta9yawKXf4YWmMF4J4bn98w9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766520; c=relaxed/simple;
	bh=OENSFks0YmhDmsKdJ5DNWfB7CzEh57z2nzlu+/KYNSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqbLVvc0Qupm7n3it4/tftyxuGdqCaoyVeCFcWihfG6y0xOgEWyev1RpgOznmYH2hut4MAf2yX7lPEp0Vpy7tTLvIG29e1D8Or6sc2thDAzjruN6XgC9xkOGb943jI6t1RhBNLU2L+ewoR5H8xP5ibYI4/KqdnXt/5i1/Pjp3E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2HYM2xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2HYM2xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB50C4CEE2;
	Wed,  5 Feb 2025 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766520;
	bh=OENSFks0YmhDmsKdJ5DNWfB7CzEh57z2nzlu+/KYNSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2HYM2xfRhxcAV+JvOflDDHlGDVpboyocUZaUferJd1HOfcRJOkDSfAKUaoiji1SJ
	 qpC0y0iVqDdEVjpIMINMr+jzvf/JOSR8LdIFjcxGAVEqQR6AqCo0oYYmg9M26gNLCp
	 WDWe1lBM/JPuc4fxg+ptvGWWfxWHIv14UcZ0RRpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.6 370/393] kbuild: switch from lz4c to lz4 for compression
Date: Wed,  5 Feb 2025 14:44:49 +0100
Message-ID: <20250205134434.454962396@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -518,7 +518,7 @@ KGZIP		= gzip
 KBZIP2		= bzip2
 KLZOP		= lzop
 LZMA		= lzma
-LZ4		= lz4c
+LZ4		= lz4
 XZ		= xz
 ZSTD		= zstd
 
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -472,10 +472,10 @@ quiet_cmd_lzo_with_size = LZO     $@
       cmd_lzo_with_size = { cat $(real-prereqs) | $(KLZOP) -9; $(size_append); } > $@
 
 quiet_cmd_lz4 = LZ4     $@
-      cmd_lz4 = cat $(real-prereqs) | $(LZ4) -l -c1 stdin stdout > $@
+      cmd_lz4 = cat $(real-prereqs) | $(LZ4) -l -9 - - > $@
 
 quiet_cmd_lz4_with_size = LZ4     $@
-      cmd_lz4_with_size = { cat $(real-prereqs) | $(LZ4) -l -c1 stdin stdout; \
+      cmd_lz4_with_size = { cat $(real-prereqs) | $(LZ4) -l -9 - -; \
                   $(size_append); } > $@
 
 # U-Boot mkimage


