Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1B4226CF0;
	Tue, 26 Aug 2025 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207556; cv=none; b=W0ywPztW92f5C41gOJq6S6wnaDcfBf5GTe8xBc5SDSpnNLDGryPMX5//GqgLl7zUoAR0eEFlRfxt6CgYPCn3M/TelHAgZUHThijqADJumj+8JtG6lV7tPbtJmtjkSTNA++u1LKMAgO1Nn4dkfNJxHJS9wWWHOuTnJr+3eCsFT/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207556; c=relaxed/simple;
	bh=KeKoTkGqbK7KhLB3pthzt/6H+03dl6RLanZdOMLJw+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THtwD9w2npzFMBwZrnmieL9opNcvltT2DyI7xCQ4a4hWAIxh5jF0vyBWPz74EHlS/oF2d0NhEDzphhrb5oFhkZyR6CelK4oci0rcnZSP7E+RhlJkUeSC5JPbkx3Zk/AmJggjRBT7i75Ce66KxlLfiVZ6NQ1YsQGcjT0eRvAJ3ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1C0gTbcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1C0gTbcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0615C4CEF4;
	Tue, 26 Aug 2025 11:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207556;
	bh=KeKoTkGqbK7KhLB3pthzt/6H+03dl6RLanZdOMLJw+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1C0gTbcvXmY9DolXx7luPPy4ABywu9fv276NLLwsYeivws3eHKPfbAKhaqeQT5Xlo
	 4PyeiHE52/n4ZWM0rfNsjcaULh7ckBU3yJIHviaPOOn46pDDJ0Ssg384PYeSdQPRMf
	 eM4qj+LYsTya+IryldMXFD6EQ2qBcg7O8/u5/uvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.16 228/457] erofs: Do not select tristate symbols from bool symbols
Date: Tue, 26 Aug 2025 13:08:32 +0200
Message-ID: <20250826110943.004251103@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 74da24f0ac9b8aabfb8d7feeba6c32ddff3065e0 upstream.

The EROFS filesystem has many configurable options, controlled through
boolean Kconfig symbols.  When enabled, these options may need to enable
additional library functionality elsewhere.  Currently this is done by
selecting the symbol for the additional functionality.  However, if
EROFS_FS itself is modular, and the target symbol is a tristate symbol,
the additional functionality is always forced built-in.

Selecting tristate symbols from a tristate symbol does keep modular
transitivity.  Hence fix this by moving selects of tristate symbols to
the main EROFS_FS symbol.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/da1b899e511145dd43fd2d398f64b2e03c6a39e7.1753879351.git.geert+renesas@glider.be
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/Kconfig |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -3,8 +3,18 @@
 config EROFS_FS
 	tristate "EROFS filesystem support"
 	depends on BLOCK
+	select CACHEFILES if EROFS_FS_ONDEMAND
 	select CRC32
+	select CRYPTO if EROFS_FS_ZIP_ACCEL
+	select CRYPTO_DEFLATE if EROFS_FS_ZIP_ACCEL
 	select FS_IOMAP
+	select LZ4_DECOMPRESS if EROFS_FS_ZIP
+	select NETFS_SUPPORT if EROFS_FS_ONDEMAND
+	select XXHASH if EROFS_FS_XATTR
+	select XZ_DEC if EROFS_FS_ZIP_LZMA
+	select XZ_DEC_MICROLZMA if EROFS_FS_ZIP_LZMA
+	select ZLIB_INFLATE if EROFS_FS_ZIP_DEFLATE
+	select ZSTD_DECOMPRESS if EROFS_FS_ZIP_ZSTD
 	help
 	  EROFS (Enhanced Read-Only File System) is a lightweight read-only
 	  file system with modern designs (e.g. no buffer heads, inline
@@ -38,7 +48,6 @@ config EROFS_FS_DEBUG
 config EROFS_FS_XATTR
 	bool "EROFS extended attributes"
 	depends on EROFS_FS
-	select XXHASH
 	default y
 	help
 	  Extended attributes are name:value pairs associated with inodes by
@@ -94,7 +103,6 @@ config EROFS_FS_BACKED_BY_FILE
 config EROFS_FS_ZIP
 	bool "EROFS Data Compression Support"
 	depends on EROFS_FS
-	select LZ4_DECOMPRESS
 	default y
 	help
 	  Enable transparent compression support for EROFS file systems.
@@ -104,8 +112,6 @@ config EROFS_FS_ZIP
 config EROFS_FS_ZIP_LZMA
 	bool "EROFS LZMA compressed data support"
 	depends on EROFS_FS_ZIP
-	select XZ_DEC
-	select XZ_DEC_MICROLZMA
 	help
 	  Saying Y here includes support for reading EROFS file systems
 	  containing LZMA compressed data, specifically called microLZMA. It
@@ -117,7 +123,6 @@ config EROFS_FS_ZIP_LZMA
 config EROFS_FS_ZIP_DEFLATE
 	bool "EROFS DEFLATE compressed data support"
 	depends on EROFS_FS_ZIP
-	select ZLIB_INFLATE
 	help
 	  Saying Y here includes support for reading EROFS file systems
 	  containing DEFLATE compressed data.  It gives better compression
@@ -132,7 +137,6 @@ config EROFS_FS_ZIP_DEFLATE
 config EROFS_FS_ZIP_ZSTD
 	bool "EROFS Zstandard compressed data support"
 	depends on EROFS_FS_ZIP
-	select ZSTD_DECOMPRESS
 	help
 	  Saying Y here includes support for reading EROFS file systems
 	  containing Zstandard compressed data.  It gives better compression
@@ -147,8 +151,6 @@ config EROFS_FS_ZIP_ZSTD
 config EROFS_FS_ZIP_ACCEL
 	bool "EROFS hardware decompression support"
 	depends on EROFS_FS_ZIP
-	select CRYPTO
-	select CRYPTO_DEFLATE
 	help
 	  Saying Y here includes hardware accelerator support for reading
 	  EROFS file systems containing compressed data.  It gives better
@@ -163,9 +165,7 @@ config EROFS_FS_ZIP_ACCEL
 config EROFS_FS_ONDEMAND
 	bool "EROFS fscache-based on-demand read support (deprecated)"
 	depends on EROFS_FS
-	select NETFS_SUPPORT
 	select FSCACHE
-	select CACHEFILES
 	select CACHEFILES_ONDEMAND
 	help
 	  This permits EROFS to use fscache-backed data blobs with on-demand


